-- 🚀 СКРИПТ ДЛЯ ЧИТА: Превращение в летающую платформу + камера + кнопки
-- РАБОТАЕТ ВНЕШНЕ через Synapse X, Krnl, JJSploit и т.д.

local player = game.Players.LocalPlayer
local character = player:WaitForChild("Character")

-- Создаём платформу
local model = Instance.new("Model")
model.Name = "FlyingPlatform"

-- Создаём части платформы (4 куба)
local function createPart(name, size, position, color)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.Color = color
    part.Material = "Neon"
    part.Position = position
    part.Parent = model
    return part
end

local leftLeg = createPart("Left Leg", Vector3.new(2, 0.5, 2), Vector3.new(-2, -1, 0), Color3.fromRGB(0, 200, 255))
local rightLeg = createPart("Right Leg", Vector3.new(2, 0.5, 2), Vector3.new(2, -1, 0), Color3.fromRGB(0, 200, 255))
local frontLeg = createPart("Front Leg", Vector3.new(2, 0.5, 2), Vector3.new(0, -1, 2), Color3.fromRGB(0, 200, 255))
local backLeg = createPart("Back Leg", Vector3.new(2, 0.5, 2), Vector3.new(0, -1, -2), Color3.fromRGB(0, 200, 255))

-- Создаём центральный куб (тело платформы)
local body = Instance.new("Part")
body.Name = "Body"
body.Size = Vector3.new(4, 1, 4)
body.Anchored = true
body.CanCollide = false
body.Transparency = 0.2
body.Color = Color3.fromRGB(100, 100, 255)
body.Material = "Neon"
body.Position = Vector3.new(0, -1, 0)
body.Parent = model

-- Привязываем персонажа к платформе
local hrp = character:WaitForChild("HumanoidRootPart")
local root = hrp

-- Привязываем персонажа к центру платформы
local attachment = Instance.new("Attachment", body)
attachment.Position = Vector3.new(0, 0, 0)

local constraint = Instance.new("BallSocketConstraint")
constraint.Attachment0 = attachment
constraint.Attachment1 = Instance.new("Attachment", root)
constraint.Attachment1.Position = Vector3.new(0, 0, 0)
constraint.Parent = body

-- Привязываем платформу к миру
model.Parent = workspace

-- Камера
spawn(function()
    while not model or not model.Parent do task.wait() end
    while true do
        task.wait()
        if workspace.CurrentCamera and model and model.Parent then
            workspace.CurrentCamera.CameraSubject = model
        end
    end
end)

-- UI: Кнопки и текст
local function createButton(name, text, position, size, color, callback)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = UDim2.new(0, size.X, 0, size.Y)
    frame.Position = UDim2.new(0, position.X, 0, position.Y)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.Parent = player.PlayerGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = frame

    frame.MouseButton1Click:Connect(callback)
    return frame
end

-- Создаём GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyingGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local speed = 2.5
local speedText = Instance.new("TextLabel")
speedText.Name = "SpeedText"
speedText.Text = "Скорость: " .. speed
speedText.Size = UDim2.new(0, 150, 0, 30)
speedText.Position = UDim2.new(0, 10, 0, 10)
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedText.BackgroundTransparency = 0.7
speedText.TextScaled = true
speedText.Parent = gui

-- Кнопки
createButton("UpButton", "↑", Vector2.new(10, 50), Vector2.new(50, 50), Color3.fromRGB(0, 200, 100), function()
    up = true
    task.wait(0.1)
    up = false
end)

createButton("DownButton", "↓", Vector2.new(10, 110), Vector2.new(50, 50), Color3.fromRGB(200, 100, 0), function()
    down = true
    task.wait(0.1)
    down = false
end)

createButton("SpeedUp", "+", Vector2.new(70, 50), Vector2.new(50, 50), Color3.fromRGB(100, 100, 255), function()
    speed = math.min(speed + 0.5, 5.0)
    speedText.Text = "Скорость: " .. speed
end)

createButton("SpeedDown", "-", Vector2.new(70, 110), Vector2.new(50, 50), Color3.fromRGB(100, 100, 255), function()
    speed = math.max(speed - 0.5, 0.5)
    speedText.Text = "Скорость: " .. speed
end)

-- Летающий движение
spawn(function()
    while true do
        task.wait()
        if model and model.Parent then
            local vel = Vector3.new(0, 0, 0)
            if up then vel = vel + Vector3.new(0, speed, 0) end
            if down then vel = vel + Vector3.new(0, -speed, 0) end

            -- Применяем скорость к платформе
            for _, part in pairs(model:GetChildren()) do
                if part:IsA("Part") then
                    part.Velocity = vel
                end
            end
        end
    end
end)

