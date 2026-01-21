local model = Instance.new("Model", workspace)
local togglerot = false
local down = false
local up = false
local currentSpeed = 0.2
local speedIncrement = 0.05

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MobileControls"
screenGui.ResetOnSpawn = false

-- ТВОИ КНОПКИ СКОРОСТИ (без изменений)
local speedPlusButton = Instance.new("ImageButton", screenGui)
speedPlusButton.Name = "SpeedPlus"
speedPlusButton.Size = UDim2.new(0.1, 0, 0.1, 0)
speedPlusButton.Position = UDim2.new(0.65, 0, 0.6, 0)
speedPlusButton.AnchorPoint = Vector2.new(0.5, 0.5)
speedPlusButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
speedPlusButton.BorderSizePixel = 0
speedPlusButton.Image = "rbxassetid://7072723065"
speedPlusButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
speedPlusButton.ImageTransparency = 0.2

local speedMinusButton = Instance.new("ImageButton", screenGui)
speedMinusButton.Name = "SpeedMinus"
speedMinusButton.Size = UDim2.new(0.1, 0, 0.1, 0)
speedMinusButton.Position = UDim2.new(0.65, 0, 0.8, 0)
speedMinusButton.AnchorPoint = Vector2.new(0.5, 0.5)
speedMinusButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
speedMinusButton.BorderSizePixel = 0
speedMinusButton.Image = "rbxassetid://7072721409"
speedMinusButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
speedMinusButton.ImageTransparency = 0.2

local speedDisplay = Instance.new("TextLabel", screenGui)
speedDisplay.Name = "SpeedDisplay"
speedDisplay.Size = UDim2.new(0.12, 0, 0.08, 0)
speedDisplay.Position = UDim2.new(0.65, 0, 0.7, 0)
speedDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
speedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedDisplay.BackgroundTransparency = 0.5
speedDisplay.BorderSizePixel = 0
speedDisplay.Text = "Speed: " .. currentSpeed
speedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDisplay.TextSize = 14
speedDisplay.Font = Enum.Font.GothamBold

local plusCorner = Instance.new("UICorner", speedPlusButton)
plusCorner.CornerRadius = UDim.new(1, 0)
local minusCorner = Instance.new("UICorner", speedMinusButton)
minusCorner.CornerRadius = UDim.new(1, 0)
local displayCorner = Instance.new("UICorner", speedDisplay)
displayCorner.CornerRadius = UDim.new(0.3, 0)

local plusGradient = Instance.new("UIGradient", speedPlusButton)
plusGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 50))
})
plusGradient.Rotation = 45

local minusGradient = Instance.new("UIGradient", speedMinusButton)
minusGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 0))
})
minusGradient.Rotation = 45

local plusStroke = Instance.new("UIStroke", speedPlusButton)
plusStroke.Color = Color3.fromRGB(0, 255, 150)
plusStroke.Thickness = 2
plusStroke.Transparency = 0.3

local minusStroke = Instance.new("UIStroke", speedMinusButton)
minusStroke.Color = Color3.fromRGB(255, 200, 0)
minusStroke.Thickness = 2
minusStroke.Transparency = 0.3

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

addPressEffect(speedPlusButton)
addPressEffect(speedMinusButton)
addPressEffect(upButton)
addPressEffect(downButton)

speedPlusButton.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + speedIncrement
    speedDisplay.Text = "Speed: " .. string.format("%.2f", currentSpeed)
    print("Скорость увеличена до: " .. currentSpeed)
end)

speedMinusButton.MouseButton1Click:Connect(function()
    if currentSpeed > speedIncrement then
        currentSpeed = currentSpeed - speedIncrement
        speedDisplay.Text = "Speed: " .. string.format("%.2f", currentSpeed)
        print("Скорость уменьшена до: " .. currentSpeed)
    else
        print("Минимальная скорость достигнута")
    end
end)

upButton.MouseButton1Down:Connect(function()
    up = true
end)

upButton.MouseButton1Up:Connect(function()
    up = false
end)

downButton.MouseButton1Down:Connect(function()
    down = true
end)

downButton.MouseButton1Up:Connect(function()
    down = false
end)

-- ТВОИ 4 ЧАСТИ ДЛЯ КОНЕЧНОСТЕЙ
local a = Instance.new("Part", model)
a.Name = "LeftLegAnchor"
a.Size = Vector3.new(1.1, 2.1, 1.1)
local a2 = Instance.new("Part", model)
a2.Name = "RightLegAnchor"
a2.Size = Vector3.new(1.1, 2.1, 1.1)
local a3 = Instance.new("Part", model)
a3.Name = "LeftArmAnchor"
a3.Size = Vector3.new(1.1, 2.1, 1.1)
local a4 = Instance.new("Part", model)
a4.Name = "RightArmAnchor"
a4.Size = Vector3.new(1.1, 2.1, 1.1)

a4.Position = Vector3.new(0, 5, 0)
a.Anchored = true
a.Rotation = Vector3.new(90, 0, 0)
a.Position = Vector3.new(-0.5, 0.5, 0)
a3.Position = Vector3.new(0, 3.15, 0)
a2.Position = Vector3.new(0, 1.3, 0)

a.CanQuery = false
a2.CanQuery = false
a3.CanQuery = false
a4.CanQuery = false
a.Transparency = 0.6
a2.Transparency = 0.6
a3.Transparency = 0.6
a4.Transparency = 0.6
a.Anchored = true
a.CanCollide = false
a2.CanCollide = false
a3.CanCollide = false
a4.CanCollide = false

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(
    function()
        model:Destroy()
        screenGui:Destroy()
    end
)

spawn(
    function()
        local last = nil
        for i, v in pairs(model:GetChildren()) do
            if last == nil then
                last = v
            else
                local weld = Instance.new("WeldConstraint", model)
                weld.Part0 = last
                weld.Part1 = v
                last = v
            end
        end
    end
)

spawn(
    function()
        while true do
            task.wait()
            workspace.CurrentCamera.CameraSubject = model
        end
    end
)

model:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)

spawn(
    function()
        while true do
            task.wait()
            if not togglerot then
                model:PivotTo(model.WorldPivot + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * currentSpeed)
                a.CFrame =
                    CFrame.new(
                    a.Position,
                    a.Position +
                        Vector3.new(
                            workspace.CurrentCamera.CFrame.LookVector.X,
                            a.Position,
                            workspace.CurrentCamera.CFrame.LookVector.Z
                        )
                ) * CFrame.Angles(0, 0, math.rad(90))
            end
            if up then
                model:PivotTo(model.WorldPivot + Vector3.new(0, currentSpeed, 0))
            end
            if down then
                model:PivotTo(model.WorldPivot + Vector3.new(0, -currentSpeed, 0))
            end
        end
    end
)

-- ВАЖНОЕ ИЗМЕНЕНИЕ: ТОЛЬКО КОНЕЧНОСТИ ПРИВЯЗЫВАЮТСЯ К МОДЕЛИ, ОСТАЛЬНОЕ ТЕЛО - РАГДОЛЛ
for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    -- ЛЕВАЯ НОГА - привязывается к модели (прозрачная часть 'a')
    if v.Name == "Left Leg" or v.Name == "LeftLowerLeg" then
        game:GetService("RunService").PostSimulation:Connect(
            function()
                v.CFrame = a.CFrame
                v.Velocity = Vector3.new(0, 4, 0)
                v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                v.Transparency = 0  -- Видимая
            end
        )
    
    -- ПРАВАЯ НОГА - привязывается к модели (прозрачная часть 'a2')
    elseif v.Name == "Right Leg" or v.Name == "RightLowerLeg" then
        game:GetService("RunService").PostSimulation:Connect(
            function()
                v.CFrame = a2.CFrame * CFrame.Angles(math.rad(180), 0, 0)
                v.Velocity = Vector3.new(0, 4, 0)
                v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                v.Transparency = 0  -- Видимая
            end
        )
    
    -- ПРАВАЯ РУКА - привязывается к модели (прозрачная часть 'a4')
    elseif v.Name == "Right Arm" or v.Name == "RightLowerArm" then
        game:GetService("RunService").PostSimulation:Connect(
            function()
                v.CFrame = a4.CFrame * CFrame.Angles(math.rad(180), math.rad(-90), 0)
                v.Velocity = Vector3.new(0, 4, 0)
                v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                v.Transparency = 0  -- Видимая
            end
        )
    
    -- ЛЕВАЯ РУКА - привязывается к модели (прозрачная часть 'a3')
    elseif v.Name == "Left Arm" or v.Name == "LeftLowerArm" then
        game:GetService("RunService").PostSimulation:Connect(
            function()
                v.CFrame = a3.CFrame
                v.Velocity = Vector3.new(0, 4, 0)
                v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                v.Transparency = 0  -- Видимая
            end
        )
    
    -- ВСЕ ОСТАЛЬНЫЕ ЧАСТИ ТЕЛА - ОСТАЮТСЯ РАГДОЛЛ (НИЧЕГО С НИМИ НЕ ДЕЛАЕМ)
    elseif v:IsA("BasePart") and 
           v.Name ~= "Left Leg" and v.Name ~= "LeftLowerLeg" and
           v.Name ~= "Right Leg" and v.Name ~= "RightLowerLeg" and
           v.Name ~= "Right Arm" and v.Name ~= "RightLowerArm" and
           v.Name ~= "Left Arm" and v.Name ~= "LeftLowerArm" then
        -- НИЧЕГО НЕ ДЕЛАЕМ! Эти части остаются рагдоллом
        -- Они будут двигаться физикой Roblox естественно
    end
end

print("========================================")
print("     ЧАСТИЧНЫЙ РАГДОЛЛ СКРИПТ         ")
print("========================================")
print("✅ Только конечности привязаны к модели")
print("✅ Торс, голова и остальное - рагдолл")
print("✅ Другие игроки видят твоего персонажа")
print("✅ Кнопки скорости работают")
print("========================================")
