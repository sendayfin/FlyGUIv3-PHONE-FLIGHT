local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- UI МЕНЮ
-- ==========================================
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "DroneUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "FPV DRONE SYSTEM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

local startBtn = Instance.new("TextButton", mainFrame)
startBtn.Size = UDim2.new(1, -20, 0, 40)
startBtn.Position = UDim2.new(0, 10, 0, 40)
startBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
startBtn.Text = "🚁 ЗАПУСТИТЬ ДРОН"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 14
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel", mainFrame)
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 90)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.TextSize = 12

-- ==========================================
-- FPV ЭФФЕКТЫ (Помехи и Звук)
-- ==========================================
local fpvOverlay = Instance.new("ImageLabel", screenGui)
fpvOverlay.Size = UDim2.new(1, 0, 1, 0)
fpvOverlay.BackgroundTransparency = 1
fpvOverlay.Image = "rbxassetid://1316045217" -- Текстура помех
fpvOverlay.ImageTransparency = 1
fpvOverlay.ImageColor3 = Color3.fromRGB(255, 255, 255)
fpvOverlay.Visible = false

local droneSound = Instance.new("Sound", screenGui)
droneSound.SoundId = "rbxassetid://9046535924" -- Звук жужжания дрона
droneSound.Volume = 1
droneSound.Looped = true

-- ==========================================
-- ЛОГИКА ДРОНА
-- ==========================================
local isDroneActive = false
local droneModel = nil
local humanoidRoot = nil
local savedCFrame = nil
local moveVector = Vector3.zero
local savedCameraType = Camera.CameraType

-- Функция для получения направления от джойстика
local function getMoveDirection()
    local direction = Vector3.zero
    
    -- Управление для ПК (WASD)
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Vector3.new(1, 0, 0) end
    end
    
    -- Управление для телефона (стандартный джойстик)
    if UserInputService.TouchEnabled then
        -- Здесь мы эмулируем управление через Humanoid.MoveDirection
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            if humanoid.MoveDirection.Magnitude > 0 then
                -- Берем направление из камеры
                local camLook = Camera.CFrame.LookVector
                local camRight = Camera.CFrame.RightVector
                direction = (camLook * humanoid.MoveDirection.Z) + (camRight * humanoid.MoveDirection.X)
            end
        end
    end
    
    return direction.Unit
end

local function createDrone()
    local model = Instance.new("Model", workspace)
    model.Name = "FPV_Drone"
    
    -- Корпус (плоский ромб)
    local body = Instance.new("Part", model)
    body.Size = Vector3.new(1.5, 0.2, 1.5)
    body.Color = Color3.fromRGB(30, 30, 30)
    body.Material = Enum.Material.Metal
    body.CanCollide = false
    body.Anchored = true
    body.Name = "Body"
    
    -- Винты (крестиком)
    for i = 1, 4 do
        local prop = Instance.new("Part", model)
        prop.Size = Vector3.new(0.8, 0.05, 0.1)
        prop.Color = Color3.fromRGB(200, 200, 200)
        prop.Material = Enum.Material.SmoothPlastic
        prop.CanCollide = false
        prop.Anchored = true
        prop.Name = "Prop" .. i
    end
    
    -- Бомба (красная сфера снизу)
    local bomb = Instance.new("Part", model)
    bomb.Shape = Enum.PartType.Ball
    bomb.Size = Vector3.new(0.4, 0.4, 0.4)
    bomb.Color = Color3.fromRGB(255, 50, 50)
    bomb.Material = Enum.Material.Neon
    bomb.CanCollide = false
    bomb.Anchored = true
    bomb.Name = "Bomb"
    bomb.Position = Vector3.new(0, -0.5, 0)
    
    return model
end

local function updateDronePhysics()
    if not isDroneActive or not droneModel then return end
    
    -- Получаем направление от джойстика
    local moveDir = getMoveDirection()
    
    -- Скорость дрона
    local speed = 1.5 
    local newPos = droneModel.PrimaryPart.Position + (moveDir * speed)
    
    -- Плавное движение
    droneModel:PivotTo(CFrame.new(newPos, newPos + Camera.CFrame.LookVector))
    
    -- Вращение пропеллеров
    local angle = tick() * 50
    droneModel.Prop1.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(angle), 0)
    droneModel.Prop2.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop3.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop4.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(angle), 0)

    -- Проверка столкновения
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = player.Character.HumanoidRootPart
            local distance = (enemyRoot.Position - droneModel.PrimaryPart.Position).Magnitude
            if distance < 4 then
                -- ВЗРЫВ
                local explosion = Instance.new("Explosion", workspace)
                explosion.Position = droneModel.PrimaryPart.Position
                explosion.BlastRadius = 15
                explosion.BlastPressure = 0
                
                -- ФЛИНГ
                enemyRoot.AssemblyLinearVelocity = Vector3.new(0, 500, 0)
                enemyRoot.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
                
                endDrone()
                break
            end
        end
    end
end

function startDrone()
    if isDroneActive then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    isDroneActive = true
    humanoidRoot = char.HumanoidRootPart
    savedCFrame = humanoidRoot.CFrame
    savedCameraType = Camera.CameraType
    
    -- Скрываем персонажа
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Transparency = 1 end
    end
    humanoidRoot.Anchored = true
    
    -- Создаем дрон
    droneModel = createDrone()
    droneModel.PrimaryPart = droneModel.Body
    droneModel:PivotTo(savedCFrame * CFrame.new(0, 5, 0))
    
    -- Камера от первого лица дрона
    Camera.CameraType = Enum.CameraType.Scriptable
    Camera.CameraSubject = droneModel.Body
    
    -- Эффекты
    fpvOverlay.Visible = true
    TweenService:Create(fpvOverlay, TweenInfo.new(0.5), {ImageTransparency = 0.6}):Play()
    droneSound:Play()
    
    startBtn.Text = "🔴 ОТМЕНА (Вернуться)"
    status.Text = "Status: IN FLIGHT"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
end

function endDrone()
    if not isDroneActive then return end
    isDroneActive = false
    
    -- Удаляем дрон и эффекты
    if droneModel then droneModel:Destroy() end
    fpvOverlay.Visible = false
    droneSound:Stop()
    
    -- Возвращаем камеру и персонажа
    if humanoidRoot and savedCFrame then
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
        humanoidRoot.Anchored = false
        humanoidRoot.CFrame = savedCFrame
    end
    
    Camera.CameraType = savedCameraType
    Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    
    startBtn.Text = "🚁 ЗАПУСТИТЬ ДРОН"
    status.Text = "Status: Ready"
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
end

startBtn.MouseButton1Click:Connect(function()
    if isDroneActive then endDrone() else startDrone() end
end)

-- ==========================================
-- ОБНОВЛЕНИЕ КАДРОВ
-- ==========================================
RunService.RenderStepped:Connect(function()
    if isDroneActive then
        -- Привязываем камеру к дрону (вид от первого лица)
        Camera.CFrame = droneModel.Body.CFrame * CFrame.new(0, 1, 0) -- Смотрим с носа дрона
        
        -- Обновляем физику дрона
        updateDronePhysics()
    end
end)

-- Защита при смерти
LocalPlayer.CharacterAdded:Connect(function()
    endDrone()
end)
