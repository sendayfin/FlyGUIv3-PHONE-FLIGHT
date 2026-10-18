local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- UI МЕНЮ (как в дрифте)
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
fpvOverlay.Image = "rbxassetid://1316045217" -- Текстура помех (примерная)
fpvOverlay.ImageTransparency = 1
fpvOverlay.ImageColor3 = Color3.fromRGB(255, 255, 255)
fpvOverlay.Visible = false

local droneSound = Instance.new("Sound", screenGui)
droneSound.SoundId = "rbxassetid://9046535924" -- Звук жужжания дрона (примерный)
droneSound.Volume = 1
droneSound.Looped = true

-- ==========================================
-- ФУНКЦИИ ДРОНА
-- ==========================================
local isDroneActive = false
local droneModel = nil
local humanoidRoot = nil
local savedCFrame = nil
local moveInput = Vector2.new(0, 0) -- Для виртуального джойстика
local cameraRotation = Vector2.new(0, 0)

local function createDrone()
    local model = Instance.new("Model", workspace)
    model.Name = "FPV_Drone"
    
    -- Корпус
    local body = Instance.new("Part", model)
    body.Size = Vector3.new(1.5, 0.2, 1.5)
    body.Color = Color3.fromRGB(30, 30, 30)
    body.Material = Enum.Material.Metal
    body.CanCollide = false
    body.Anchored = true
    body.Name = "Body"
    
    -- Пропеллеры (крестиком)
    for i = 1, 4 do
        local prop = Instance.new("Part", model)
        prop.Size = Vector3.new(0.8, 0.05, 0.1)
        prop.Color = Color3.fromRGB(200, 200, 200)
        prop.Material = Enum.Material.SmoothPlastic
        prop.CanCollide = false
        prop.Anchored = true
        prop.Name = "Prop" .. i
    end
    
    -- Снаряд снизу
    local bomb = Instance.new("Part", model)
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
    
    -- Управление полетом (через CFrame)
    local camCFrame = Camera.CFrame
    local moveDir = camCFrame.LookVector * moveInput.Y + camCFrame.RightVector * moveInput.X
    
    -- Скорость дрона
    local speed = 1.5 
    local newPos = droneModel.PrimaryPart.Position + (moveDir * speed)
    
    -- Применяем позицию (плавно)
    droneModel:PivotTo(CFrame.new(newPos, newPos + camCFrame.LookVector))
    
    -- Вращение пропеллеров для визуала
    local angle = tick() * 50
    droneModel.Prop1.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(angle), 0)
    droneModel.Prop2.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop3.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop4.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(angle), 0)

    -- Проверка столкновения с игроками
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = player.Character.HumanoidRootPart
            local distance = (enemyRoot.Position - droneModel.PrimaryPart.Position).Magnitude
            if distance < 4 then
                -- БУМ!
                local explosion = Instance.new("Explosion", workspace)
                explosion.Position = droneModel.PrimaryPart.Position
                explosion.BlastRadius = 15
                explosion.BlastPressure = 0 -- Отключаем стандартный урон
                explosion.DestroyJointRadiusPercent = 0

                -- Флинг врага
                enemyRoot.AssemblyLinearVelocity = Vector3.new(0, 500, 0)
                enemyRoot.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
                
                -- Возврат
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
    
    -- Скрываем персонажа
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.Transparency = 1 end
    end
    humanoidRoot.Anchored = true
    
    -- Создаем дрон
    droneModel = createDrone()
    droneModel.PrimaryPart = droneModel.Body
    droneModel:PivotTo(savedCFrame * CFrame.new(0, 5, 0)) -- Спавн над головой
    
    -- Камера
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
    
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    
    startBtn.Text = "🚁 ЗАПУСТИТЬ ДРОН"
    status.Text = "Status: Ready"
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
end

startBtn.MouseButton1Click:Connect(function()
    if isDroneActive then endDrone() else startDrone() end
end)

-- ==========================================
-- УПРАВЛЕНИЕ (Свайпы и Джойстик)
-- ==========================================
-- Свайпы для камеры
local touchInput = nil
UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive then return end
    touchInput = input
end)

UserInputService.TouchMoved:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive or not touchInput then return end
    local delta = input.Position - touchInput.Position
    -- Вращаем камеру (свайп)
    Camera.CFrame = Camera.CFrame * CFrame.Angles(math.rad(-delta.Y * 0.2), math.rad(-delta.X * 0.2), 0)
    touchInput = input
end)

-- Искусственный джойстик (для движения вперед)
-- (Упрощенно: просто летим вперед, если нажата кнопка)
local flyBtn = Instance.new("TextButton", screenGui)
flyBtn.Size = UDim2.new(0, 80, 0, 80)
flyBtn.Position = UDim2.new(0.8, -100, 0.8, -100)
flyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyBtn.BackgroundTransparency = 0.5
flyBtn.Text = "ВПЕРЕД"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.Visible = false
Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(1, 0)

flyBtn.MouseButton1Down:Connect(function() if isDroneActive then moveInput = Vector2.new(0, 1) end end)
flyBtn.MouseButton1Up:Connect(function() moveInput = Vector2.new(0, 0) end)

-- Показываем кнопку только в полете
RunService.RenderStepped:Connect(function()
    flyBtn.Visible = isDroneActive
    if isDroneActive then updateDronePhysics() end
end)

-- Защита при смерти
LocalPlayer.CharacterAdded:Connect(function()
    endDrone()
end)
