local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- UI МЕНЮ (с перетаскиванием)
-- ==========================================
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "DroneUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- ВОТ ЭТО ДОБАВИЛИ
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
title.Active = true -- Чтобы можно было тащить за заголовок

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
-- FPV ЭФФЕКТЫ
-- ==========================================
local fpvOverlay = Instance.new("ImageLabel", screenGui)
fpvOverlay.Size = UDim2.new(1, 0, 1, 0)
fpvOverlay.BackgroundTransparency = 1
fpvOverlay.Image = "rbxassetid://1316045217"
fpvOverlay.ImageTransparency = 1
fpvOverlay.ImageColor3 = Color3.fromRGB(255, 255, 255)
fpvOverlay.Visible = false

local droneSound = Instance.new("Sound", screenGui)
droneSound.SoundId = "rbxassetid://9046535924"
droneSound.Volume = 1
droneSound.Looped = true

-- ==========================================
-- ЛОГИКА
-- ==========================================
local isDroneActive = false
local droneModel = nil
local humanoidRoot = nil
local savedCFrame = nil
local savedCameraType = Camera.CameraType
local cameraRotation = Vector2.new(0, 0) -- Для свайпов

local function createDrone()
    local model = Instance.new("Model", workspace)
    model.Name = "FPV_Drone"
    
    local body = Instance.new("Part", model)
    body.Size = Vector3.new(1.5, 0.2, 1.5)
    body.Color = Color3.fromRGB(30, 30, 30)
    body.Material = Enum.Material.Metal
    body.CanCollide = false
    body.Anchored = true
    body.Name = "Body"
    
    for i = 1, 4 do
        local prop = Instance.new("Part", model)
        prop.Size = Vector3.new(0.8, 0.05, 0.1)
        prop.Color = Color3.fromRGB(200, 200, 200)
        prop.Material = Enum.Material.SmoothPlastic
        prop.CanCollide = false
        prop.Anchored = true
        prop.Name = "Prop" .. i
    end
    
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

local function getMoveDirection()
    local direction = Vector3.zero
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Vector3.new(1, 0, 0) end
    end
    
    -- Для телефона: берем направление из Humanoid.MoveDirection
    if UserInputService.TouchEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local md = char.Humanoid.MoveDirection
            if md.Magnitude > 0 then
                local camLook = Camera.CFrame.LookVector
                local camRight = Camera.CFrame.RightVector
                -- Игнорируем Y, чтобы дрон не летел в пол
                direction = (Vector3.new(camLook.X, 0, camLook.Z) * md.Z) + (Vector3.new(camRight.X, 0, camRight.Z) * md.X)
            end
        end
    end
    
    return direction.Unit
end

local function updateDronePhysics()
    if not isDroneActive or not droneModel then return end
    
    local moveDir = getMoveDirection()
    local speed = 1.5 
    local newPos = droneModel.PrimaryPart.Position + (moveDir * speed)
    
    -- Плавное вращение камеры (свайпы)
    local camCFrame = CFrame.Angles(math.rad(cameraRotation.Y), math.rad(cameraRotation.X), 0)
    local targetCFrame = CFrame.new(newPos) * camCFrame
    
    droneModel:PivotTo(targetCFrame)
    
    local angle = tick() * 50
    droneModel.Prop1.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(angle), 0)
    droneModel.Prop2.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, 0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop3.CFrame = droneModel.Body.CFrame * CFrame.new(0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(-angle), 0)
    droneModel.Prop4.CFrame = droneModel.Body.CFrame * CFrame.new(-0.6, 0.1, -0.6) * CFrame.Angles(0, math.rad(angle), 0)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = player.Character.HumanoidRootPart
            local distance = (enemyRoot.Position - droneModel.PrimaryPart.Position).Magnitude
            if distance < 4 then
                local explosion = Instance.new("Explosion", workspace)
                explosion.Position = droneModel.PrimaryPart.Position
                explosion.BlastRadius = 15
                explosion.BlastPressure = 0
                
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
    
    droneModel = createDrone()
    droneModel.PrimaryPart = droneModel.Body
    -- СПАВН: строго над персонажем
    droneModel:PivotTo(savedCFrame * CFrame.new(0, 3, 0))
    
    -- Отключаем управление камерой (чтобы не дергалась)
    Camera.CameraType = Enum.CameraType.Scriptable
    cameraRotation = Vector2.new(0, 0) -- Сбрасываем поворот
    
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
    
    if droneModel then droneModel:Destroy() end
    fpvOverlay.Visible = false
    droneSound:Stop()
    
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
-- СВАЙПЫ (Управление камерой)
-- ==========================================
local lastTouch = nil
UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive then return end
    lastTouch = input.Position
end)

UserInputService.TouchMoved:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive or not lastTouch then return end
    local delta = input.Position - lastTouch
    cameraRotation = cameraRotation + Vector2.new(-delta.X * 0.5, -delta.Y * 0.5) -- Накапливаем поворот
    lastTouch = input.Position
end)

UserInputService.TouchEnded:Connect(function(input, gameProcessed)
    if not isDroneActive then return end
    lastTouch = nil
end)

-- Для ПК (мышь)
UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        cameraRotation = cameraRotation + Vector2.new(-input.Delta.X * 0.2, -input.Delta.Y * 0.2)
    end
end)

-- ==========================================
-- ОБНОВЛЕНИЕ КАДРОВ
-- ==========================================
RunService.RenderStepped:Connect(function()
    if isDroneActive and droneModel then
        updateDronePhysics()
        -- Камера смотрит с носа дрона с учетом поворота
        local camCFrame = CFrame.Angles(math.rad(cameraRotation.Y), math.rad(cameraRotation.X), 0)
        Camera.CFrame = CFrame.new(droneModel.Body.Position) * camCFrame
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    endDrone()
end)
