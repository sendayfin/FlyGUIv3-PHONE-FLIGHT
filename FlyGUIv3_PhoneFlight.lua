-- FPV Kamikaze Drone (Remake)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- НАСТРОЙКИ
-- ==========================================
local DRONE_SPEED = 100
local BASE_LIFT = 10
local GRAVITY = Vector3.new(0, -50, 0)
local DRAG = 0.95
local FLING_POWER = 800 -- Сила, с которой улетает враг

-- ==========================================
-- UI МЕНЮ (Красивое)
-- ==========================================
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "DroneUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 130)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Thickness = 2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "FPV KAMIKAZE SYSTEM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Active = true

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
status.Position = UDim2.new(0, 0, 0, 95)
status.BackgroundTransparency = 1
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.TextSize = 12

-- Эффект помех (FPV)
local fpvOverlay = Instance.new("ImageLabel", screenGui)
fpvOverlay.Size = UDim2.new(1, 0, 1, 0)
fpvOverlay.BackgroundTransparency = 1
fpvOverlay.Image = "rbxassetid://1316045217"
fpvOverlay.ImageTransparency = 0.7
fpvOverlay.ImageColor3 = Color3.fromRGB(200, 200, 200)
fpvOverlay.Visible = false

local droneSound = Instance.new("Sound", screenGui)
droneSound.SoundId = "rbxassetid://114037851906101" -- Из твоего скрипта
droneSound.Volume = 1
droneSound.Looped = true

-- ==========================================
-- ЛОГИКА
-- ==========================================
local isDroneActive = false
local dronePart = nil
local humanoidRoot = nil
local savedCFrame = nil
local savedCameraType = Camera.CameraType
local cameraRotation = Vector2.new(0, 0)
local velocity = Vector3.zero
local dronePosition = Vector3.new(0, 0, 0)

local function createDroneModel()
    local drone = Instance.new("Part")
    drone.Name = "FPVDrone"
    drone.Size = Vector3.new(1.4, 0.4, 1.4)
    drone.Anchored = true
    drone.CanCollide = false
    drone.Material = Enum.Material.Metal
    drone.Color = Color3.fromRGB(30, 30, 30)
    drone.Transparency = 1 -- Невидимый (чтобы не видеть его изнутри)
    drone.Parent = workspace
    return drone
end

local function getMoveDirection()
    local direction = Vector3.zero
    if UserInputService.KeyboardEnabled then
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction += Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction += Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += Vector3.new(1, 0, 0) end
    end
    
    if UserInputService.TouchEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local md = char.Humanoid.MoveDirection
            if md.Magnitude > 0 then
                local camLook = Camera.CFrame.LookVector
                local camRight = Camera.CFrame.RightVector
                direction = (Vector3.new(camLook.X, 0, camLook.Z) * md.Z) + (Vector3.new(camRight.X, 0, camRight.Z) * md.X)
            end
        end
    end
    
    return direction.Unit
end

local function updateDrone()
    if not isDroneActive or not dronePart then return end
    
    -- Тяга (Джойстик)
    local moveDir = getMoveDirection()
    local thrust = moveDir * DRONE_SPEED
    velocity = (velocity + thrust + GRAVITY * 0.016) * DRAG
    
    if velocity.Magnitude > DRONE_SPEED then
        velocity = velocity.Unit * DRONE_SPEED
    end
    
    dronePosition = dronePosition + velocity * 0.016
    
    -- Вращение (Свайпы)
    local camCFrame = CFrame.Angles(math.rad(cameraRotation.Y), math.rad(cameraRotation.X), 0)
    dronePart.CFrame = CFrame.new(dronePosition) * camCFrame
    
    -- Проверка на столкновение с игроком (Флинг)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = player.Character.HumanoidRootPart
            local distance = (enemyRoot.Position - dronePosition).Magnitude
            if distance < 6 then
                -- ВЗРЫВ
                local explosion = Instance.new("Explosion", workspace)
                explosion.Position = dronePosition
                explosion.BlastRadius = 15
                explosion.BlastPressure = 0
                
                -- ФЛИНГ (Улетает в космос)
                enemyRoot.AssemblyLinearVelocity = Vector3.new(math.random(-100, 100), FLING_POWER, math.random(-100, 100))
                enemyRoot.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                
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
    velocity = Vector3.zero
    dronePosition = savedCFrame.Position + Vector3.new(0, 5, 0)
    
    -- Скрываем персонажа
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 1
        end
    end
    humanoidRoot.Anchored = true
    
    dronePart = createDroneModel()
    dronePart.CFrame = CFrame.new(dronePosition)
    
    Camera.CameraType = Enum.CameraType.Scriptable
    cameraRotation = Vector2.new(0, 0)
    
    fpvOverlay.Visible = true
    droneSound:Play()
    
    startBtn.Text = "🔴 ОТМЕНА (Вернуться)"
    status.Text = "Status: IN FLIGHT"
    status.TextColor3 = Color3.fromRGB(255, 100, 100)
end

function endDrone()
    if not isDroneActive then return end
    isDroneActive = false
    
    if dronePart then dronePart:Destroy() end
    fpvOverlay.Visible = false
    droneSound:Stop()
    
    if humanoidRoot and savedCFrame then
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
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
-- СВАЙПЫ ДЛЯ КАМЕРЫ
-- ==========================================
local lastTouch = nil
UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive then return end
    lastTouch = input.Position
end)

UserInputService.TouchMoved:Connect(function(input, gameProcessed)
    if gameProcessed or not isDroneActive or not lastTouch then return end
    local delta = input.Position - lastTouch
    cameraRotation = cameraRotation + Vector2.new(-delta.X * 0.5, -delta.Y * 0.5)
    lastTouch = input.Position
end)

UserInputService.TouchEnded:Connect(function(input, gameProcessed)
    if not isDroneActive then return end
    lastTouch = nil
end)

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
    if isDroneActive and dronePart then
        updateDrone()
        -- Камера от первого лица (с носа дрона)
        local camCFrame = CFrame.Angles(math.rad(cameraRotation.Y), math.rad(cameraRotation.X), 0)
        Camera.CFrame = CFrame.new(dronePosition) * camCFrame * CFrame.new(0, 0.2, 0.5)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    endDrone()
end)
