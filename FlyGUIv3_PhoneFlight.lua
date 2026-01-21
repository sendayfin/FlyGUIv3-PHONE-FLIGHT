local model = Instance.new("Model", workspace)
model.Name = "FlyingPlatform"

local togglerot = false
local up = false
local down = false

-- === СКОРОСТЬ ПОЛЕТА ===
local maxSpeed = 2.5
local minSpeed = 1.0
local speedStep = 0.5

-- === UI КНОПКИ ===
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MobileControls"
screenGui.ResetOnSpawn = false

-- === КНОПКА ВВЕРХ ===
local upButton = Instance.new("ImageButton", screenGui)
upButton.Size = UDim2.new(0.15, 0, 0.15, 0)
upButton.Position = UDim2.new(0.8, 0, 0.6, 0)
upButton.AnchorPoint = Vector2.new(0.5, 0.5)
upButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
upButton.BorderSizePixel = 0
upButton.Image = "rbxassetid://7072717236"
upButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
upButton.ImageTransparency = 0.2

local upGradient = Instance.new("UIGradient", upButton)
upGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 200))
})
upGradient.Rotation = 45

local upCorner = Instance.new("UICorner", upButton)
upCorner.CornerRadius = UDim.new(1, 0)

local upStroke = Instance.new("UIStroke", upButton)
upStroke.Color = Color3.fromRGB(0, 255, 255)
upStroke.Thickness = 2
upStroke.Transparency = 0.3

-- === КНОПКА ВНИЗ ===
local downButton = Instance.new("ImageButton", screenGui)
downButton.Size = UDim2.new(0.15, 0, 0.15, 0)
downButton.Position = UDim2.new(0.8, 0, 0.8, 0)
downButton.AnchorPoint = Vector2.new(0.5, 0.5)
downButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
downButton.BorderSizePixel = 0
downButton.Image = "rbxassetid://7072718631"
downButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
downButton.ImageTransparency = 0.2

local downGradient = Instance.new("UIGradient", downButton)
downGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 50))
})
downGradient.Rotation = 45

local downCorner = Instance.new("UICorner", downButton)
downCorner.CornerRadius = UDim.new(1, 0)

local downStroke = Instance.new("UIStroke", downButton)
downStroke.Color = Color3.fromRGB(255, 0, 100)
downStroke.Thickness = 2
downStroke.Transparency = 0.3

-- === КНОПКА УВЕЛИЧИТЬ СКОРОСТЬ (+) ===
local speedUpButton = Instance.new("ImageButton", screenGui)
speedUpButton.Size = UDim2.new(0.12, 0, 0.12, 0)
speedUpButton.Position = UDim2.new(0.2, 0, 0.6, 0)
speedUpButton.AnchorPoint = Vector2.new(0.5, 0.5)
speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
speedUpButton.BorderSizePixel = 0
speedUpButton.Image = "rbxassetid://10401555538" -- символ "+"
speedUpButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.ImageTransparency = 0.2

local speedUpGradient = Instance.new("UIGradient", speedUpButton)
speedUpGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 200, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 0))
})
speedUpGradient.Rotation = 45

local speedUpCorner = Instance.new("UICorner", speedUpButton)
speedUpCorner.CornerRadius = UDim.new(1, 0)

local speedUpStroke = Instance.new("UIStroke", speedUpButton)
speedUpStroke.Color = Color3.fromRGB(0, 255, 0)
speedUpStroke.Thickness = 2
speedUpStroke.Transparency = 0.3

-- === КНОПКА УМЕНЬШИТЬ СКОРОСТЬ (-) ===
local speedDownButton = Instance.new("ImageButton", screenGui)
speedDownButton.Size = UDim2.new(0.12, 0, 0.12, 0)
speedDownButton.Position = UDim2.new(0.2, 0, 0.8, 0)
speedDownButton.AnchorPoint = Vector2.new(0.5, 0.5)
speedDownButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedDownButton.BorderSizePixel = 0
speedDownButton.Image = "rbxassetid://10401555539" -- символ "-"
speedDownButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.ImageTransparency = 0.2

local speedDownGradient = Instance.new("UIGradient", speedDownButton)
speedDownGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
})
speedDownGradient.Rotation = 45

local speedDownCorner = Instance.new("UICorner", speedDownButton)
speedDownCorner.CornerRadius = UDim.new(1, 0)

local speedDownStroke = Instance.new("UIStroke", speedDownButton)
speedDownStroke.Color = Color3.fromRGB(255, 0, 0)
speedDownStroke.Thickness = 2
speedDownStroke.Transparency = 0.3

-- === ТЕКСТ ТЕКУЩЕЙ СКОРОСТИ ===
local speedText = Instance.new("TextLabel", screenGui)
speedText.Size = UDim2.new(0.2, 0, 0.08, 0)
speedText.Position = UDim2.new(0.2, 0, 0.5, 0)
speedText.AnchorPoint = Vector2.new(0.5, 0.5)
speedText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedText.BackgroundTransparency = 0.8
speedText.TextColor3 = Color3.fromRGB(255, 255, 255)
speedText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
speedText.TextStrokeTransparency = 0.5
speedText.Font = Enum.Font.SourceSansBold
speedText.TextScaled = true
speedText.Text = "Скорость: " .. string.format("%.1f", maxSpeed)

-- === ЭФФЕКТЫ НАЖАТИЯ ===
local function addPressEffect(button)
    local originalSize = button.Size
    local originalPosition = button.Position
    
    button.MouseButton1Down:Connect(function()
        button:TweenSize(UDim2.new(originalSize.X.Scale * 0.9, 0, originalSize.Y.Scale * 0.9, 0), "Out", "Quad", 0.1, true)
        button.ImageTransparency = 0
    end)
    
    button.MouseButton1Up:Connect(function()
        button:TweenSize(originalSize, "Out", "Elastic", 0.5, true)
        button.ImageTransparency = 0.2
    end)
end

addPressEffect(upButton)
addPressEffect(downButton)
addPressEffect(speedUpButton)
addPressEffect(speedDownButton)

-- === УПРАВЛЕНИЕ ===
upButton.MouseButton1Down:Connect(function() up = true end)
upButton.MouseButton1Up:Connect(function() up = false end)
downButton.MouseButton1Down:Connect(function() down = true end)
downButton.MouseButton1Up:Connect(function() down = false end)

-- === УПРАВЛЕНИЕ СКОРОСТЬЮ ===
speedUpButton.MouseButton1Down:Connect(function()
    if maxSpeed < 5.0 then
        maxSpeed = math.min(maxSpeed + speedStep, 5.0)
        speedText.Text = "Скорость: " .. string.format("%.1f", maxSpeed)
    end
end)

speedDownButton.MouseButton1Down:Connect(function()
    if maxSpeed > minSpeed then
        maxSpeed = math.max(maxSpeed - speedStep, minSpeed)
        speedText.Text = "Скорость: " .. string.format("%.1f", maxSpeed)
    end
end)

-- === ПОСТРОЕНИЕ МОДЕЛИ ===
local a = Instance.new("Part", model)
a.Size = Vector3.new(1.1, 0.3, 1.1)
a.Anchored = true
a.CanCollide = false
a.CanQuery = false
a.Transparency = 0.6
a.BrickColor = BrickColor.new("Bright blue")

local a2 = Instance.new("Part", model)
a2.Size = Vector3.new(1.1, 0.3, 1.1)
a2.Position = Vector3.new(0, 1.5, 0)
a2.Anchored = true
a2.CanCollide = false
a2.CanQuery = false
a2.Transparency = 0.6
a2.BrickColor = BrickColor.new("Bright blue")

local a3 = Instance.new("Part", model)
a3.Size = Vector3.new(1.1, 0.3, 1.1)
a3.Position = Vector3.new(0, 3.0, 0)
a3.Anchored = true
a3.CanCollide = false
a3.CanQuery = false
a3.Transparency = 0.6
a3.BrickColor = BrickColor.new("Bright blue")

local a4 = Instance.new("Part", model)
a4.Size = Vector3.new(1.1, 0.3, 1.1)
a4.Position = Vector3.new(0, 4.5, 0)
a4.Anchored = true
a4.CanCollide = false
a4.CanQuery = false
a4.Transparency = 0.6
a4.BrickColor = BrickColor.new("Bright blue")

-- Соединяем части
spawn(function()
    local parts = model:GetChildren()
    local last = nil
    for _, part in ipairs(parts) do
        if part:IsA("Part") then
            if last then
                local weld = Instance.new("WeldConstraint", model)
                weld.Part0 = last
                weld.Part1 = part
            end
            last = part
        end
    end
end)

-- === КАМЕРА ===
spawn(function()
    while true do
        task.wait()
        if model and model.Parent then
            workspace.CurrentCamera.CameraSubject = model
        end
    end
end)

-- === ПОЛЁТ С ИНЕРЦИЕЙ (С НОВОЙ СКОРОСТЬЮ) ===
local velocity = Vector3.new(0, 0, 0)
local acceleration = 0.8
local drag = 0.95

model:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)

spawn(function()
    while model and model.Parent do
        task.wait()

        -- Управление
        if up then
            velocity = velocity + Vector3.new(0, acceleration, 0)
        elseif down then
            velocity = velocity + Vector3.new(0, -acceleration, 0)
        end

        -- Ограничение скорости по новому maxSpeed
        velocity = velocity.Unit * math.min(velocity.Magnitude, maxSpeed)

        -- Применяем инерцию
        model:PivotTo(model.WorldPivot + velocity * 0.1)

        -- Аэродинамика
        velocity = velocity * drag

        -- Плавное поворачивание
        if velocity.Magnitude > 0.1 then
            local targetCFrame = CFrame.lookAt(model.Position, model.Position + velocity)
            model:PivotTo(targetCFrame)
        end
    end
end)

-- === ПРИВЯЗКА КОНЕЧНОСТЕЙ ===
game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
    if model then model:Destroy() end
    if screenGui then screenGui:Destroy() end
end)

spawn(function()
    while model and model.Parent and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") do
        task.wait()

        local char = game.Players.LocalPlayer.Character
        if not char then continue end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "Left Leg" then
                    part.CFrame = a.CFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                elseif part.Name == "Right Leg" then
                    part.CFrame = a2.CFrame * CFrame.Angles(math.rad(180), 0, 0)
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                elseif part.Name == "Left Arm" then
                    part.CFrame = a3.CFrame
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                elseif part.Name == "Right Arm" then
                    part.CFrame = a4.CFrame * CFrame.Angles(math.rad(180), math.rad(-90), 0)
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                else
                    part.CFrame = CFrame.new(model.Position + Vector3.new(0, 600, 0))
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
end)
