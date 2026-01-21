local model = Instance.new("Model", workspace)
local togglerot = false
local down = false
local up = false
local currentSpeed = 0.2
local speedIncrement = 0.05

-- Определяем тип тела (R6 или R15)
local character = game.Players.LocalPlayer.Character
local humanoid = character:WaitForChild("Humanoid")
local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
print("📐 Тип тела: " .. (isR15 and "R15" or "R6"))

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MobileControls"
screenGui.ResetOnSpawn = false

-- Кнопки скорости
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

-- Кнопка видимости
local visibilityButton = Instance.new("TextButton", screenGui)
visibilityButton.Name = "VisibilityToggle"
visibilityButton.Size = UDim2.new(0.1, 0, 0.1, 0)
visibilityButton.Position = UDim2.new(0.8, 0, 0.4, 0)
visibilityButton.AnchorPoint = Vector2.new(0.5, 0.5)
visibilityButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
visibilityButton.Text = "👻\nСкрыт"
visibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
visibilityButton.TextSize = 12
visibilityButton.Visible = false

local plusCorner = Instance.new("UICorner", speedPlusButton)
plusCorner.CornerRadius = UDim.new(1, 0)
local minusCorner = Instance.new("UICorner", speedMinusButton)
minusCorner.CornerRadius = UDim.new(1, 0)
local displayCorner = Instance.new("UICorner", speedDisplay)
displayCorner.CornerRadius = UDim.new(0.3, 0)
local visibilityCorner = Instance.new("UICorner", visibilityButton)
visibilityCorner.CornerRadius = UDim.new(1, 0)

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

-- Переменные для видимости
local playerVisible = false
local ragdollButtonFound = false

-- Функция переключения видимости
local function toggleVisibility()
    playerVisible = not playerVisible
    
    if playerVisible then
        visibilityButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        visibilityButton.Text = "👤\nВиден"
        print("✅ Теперь видимый")
    else
        visibilityButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        visibilityButton.Text = "👻\nСкрыт"
        print("👻 Теперь невидимый")
    end
    
    -- Применяем видимость ко всем частям тела
    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = playerVisible and 0 or 1
        end
    end
end

visibilityButton.MouseButton1Click:Connect(toggleVisibility)

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

-- Создаем якоря для частей тела
local anchors = {}
if isR15 then
    -- R15: больше частей тела
    anchors = {
        LeftLowerLeg = Instance.new("Part", model),
        RightLowerLeg = Instance.new("Part", model),
        LeftLowerArm = Instance.new("Part", model),
        RightLowerArm = Instance.new("Part", model),
        LeftUpperLeg = Instance.new("Part", model),
        RightUpperLeg = Instance.new("Part", model),
        LeftUpperArm = Instance.new("Part", model),
        RightUpperArm = Instance.new("Part", model)
    }
else
    -- R6: стандартные части
    anchors = {
        LeftLeg = Instance.new("Part", model),
        RightLeg = Instance.new("Part", model),
        LeftArm = Instance.new("Part", model),
        RightArm = Instance.new("Part", model)
    }
end

-- Настраиваем якоря
for name, anchor in pairs(anchors) do
    anchor.Name = name .. "Anchor"
    anchor.Size = Vector3.new(1.1, 2.1, 1.1)
    anchor.CanQuery = false
    anchor.Transparency = 0.6
    anchor.Anchored = true
    anchor.CanCollide = false
end

-- Позиционируем якоря
if isR15 then
    anchors.LeftLowerLeg.Position = Vector3.new(-0.5, 0.5, 0)
    anchors.RightLowerLeg.Position = Vector3.new(0, 1.3, 0)
    anchors.LeftLowerArm.Position = Vector3.new(0, 3.15, 0)
    anchors.RightLowerArm.Position = Vector3.new(0, 5, 0)
    anchors.LeftUpperLeg.Position = Vector3.new(-0.5, -0.5, 0)
    anchors.RightUpperLeg.Position = Vector3.new(0, -1.3, 0)
    anchors.LeftUpperArm.Position = Vector3.new(0, 4.15, 0)
    anchors.RightUpperArm.Position = Vector3.new(0, 6, 0)
else
    anchors.LeftLeg.Position = Vector3.new(-0.5, 0.5, 0)
    anchors.RightLeg.Position = Vector3.new(0, 1.3, 0)
    anchors.LeftArm.Position = Vector3.new(0, 3.15, 0)
    anchors.RightArm.Position = Vector3.new(0, 5, 0)
end

anchors.LeftLowerLeg.Rotation = Vector3.new(90, 0, 0) if anchors.LeftLowerLeg then

game.Players.LocalPlayer.Character.Humanoid.Died:Connect(
    function()
        model:Destroy()
        screenGui:Destroy()
    end
)

-- Соединяем якоря
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

-- Камера следует за моделью
spawn(
    function()
        while true do
            task.wait()
            workspace.CurrentCamera.CameraSubject = model
        end
    end
)

model:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)

-- Движение модели
spawn(
    function()
        while true do
            task.wait()
            if not togglerot then
                model:PivotTo(model.WorldPivot + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * currentSpeed)
                
                -- Поворот для R6 левой ноги
                if anchors.LeftLeg then
                    anchors.LeftLeg.CFrame = CFrame.new(
                        anchors.LeftLeg.Position,
                        anchors.LeftLeg.Position +
                        Vector3.new(
                            workspace.CurrentCamera.CFrame.LookVector.X,
                            anchors.LeftLeg.Position.Y,
                            workspace.CurrentCamera.CFrame.LookVector.Z
                        )
                    ) * CFrame.Angles(0, 0, math.rad(90))
                elseif anchors.LeftLowerLeg then
                    anchors.LeftLowerLeg.CFrame = CFrame.new(
                        anchors.LeftLowerLeg.Position,
                        anchors.LeftLowerLeg.Position +
                        Vector3.new(
                            workspace.CurrentCamera.CFrame.LookVector.X,
                            anchors.LeftLowerLeg.Position.Y,
                            workspace.CurrentCamera.CFrame.LookVector.Z
                        )
                    ) * CFrame.Angles(0, 0, math.rad(90))
                end
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

-- Функция поиска кнопки Ragdoll в игре
local function findRagdollButton()
    local placesToSearch = {
        game:GetService("CoreGui"),
        game.Players.LocalPlayer.PlayerGui,
        game:GetService("StarterGui")
    }
    
    for _, location in pairs(placesToSearch) do
        for _, gui in pairs(location:GetDescendants()) do
            if (gui:IsA("TextButton") or gui:IsA("ImageButton")) then
                local text = string.lower(gui.Text or "")
                local name = string.lower(gui.Name or "")
                
                if string.find(text, "ragdoll") or 
                   string.find(name, "ragdoll") or
                   string.find(text, "рэгдол") or
                   string.find(text, "рагдал") then
                    print("🎮 Найдена кнопка Ragdoll: " .. gui.Name)
                    return gui
                end
            end
        end
    end
    
    return nil
end

-- Функция привязки частей тела для R15
local function attachR15Limbs()
    local limbConnections = {}
    
    local function connectLimb(limbName, anchor, rotation)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and string.find(string.lower(part.Name), string.lower(limbName)) then
                local connection = game:GetService("RunService").PostSimulation:Connect(function()
                    if anchor and anchor.Parent then
                        part.CFrame = anchor.CFrame * (rotation or CFrame.new())
                        part.Velocity = Vector3.new(0, 4, 0)
                        part.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                        part.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                        part.Transparency = playerVisible and 0 or 1
                    end
                end)
                table.insert(limbConnections, connection)
                print("✅ Привязано: " .. part.Name .. " → " .. limbName)
            end
        end
    end
    
    -- Привязываем R15 части
    if anchors.LeftLowerLeg then
        connectLimb("LeftLowerLeg", anchors.LeftLowerLeg)
        connectLimb("LeftUpperLeg", anchors.LeftUpperLeg)
        connectLimb("RightLowerLeg", anchors.RightLowerLeg, CFrame.Angles(math.rad(180), 0, 0))
        connectLimb("RightUpperLeg", anchors.RightUpperLeg, CFrame.Angles(math.rad(180), 0, 0))
        connectLimb("LeftLowerArm", anchors.LeftLowerArm)
        connectLimb("LeftUpperArm", anchors.LeftUpperArm)
        connectLimb("RightLowerArm", anchors.RightLowerArm, CFrame.Angles(math.rad(180), math.rad(-90), 0))
        connectLimb("RightUpperArm", anchors.RightUpperArm, CFrame.Angles(math.rad(180), math.rad(-90), 0))
    end
    
    -- Остальные части телепортируем
    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") and not string.find(string.lower(part.Name), "lower") 
           and not string.find(string.lower(part.Name), "upper")
           and not string.find(string.lower(part.Name), "hand")
           and not string.find(string.lower(part.Name), "foot") then
            
            if not (string.find(string.lower(part.Name), "leftleg") or
                    string.find(string.lower(part.Name), "rightleg") or
                    string.find(string.lower(part.Name), "leftarm") or
                    string.find(string.lower(part.Name), "rightarm")) then
                
                game:GetService("RunService").PostSimulation:Connect(function()
                    part.CFrame = CFrame.new(model.WorldPivot.Position + Vector3.new(0, 600, 0))
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    part.Transparency = playerVisible and 0 or 1
                end)
            end
        end
    end
    
    return limbConnections
end

-- Функция привязки частей тела для R6
local function attachR6Limbs()
    for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v.Name == "Left Leg" then
            game:GetService("RunService").PostSimulation:Connect(
                function()
                    v.CFrame = anchors.LeftLeg.CFrame
                    v.Velocity = Vector3.new(0, 4, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                    v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                    v.Transparency = playerVisible and 0 or 1
                end
            )
        elseif v.Name == "Right Leg" then
            game:GetService("RunService").PostSimulation:Connect(
                function()
                    v.CFrame = anchors.RightLeg.CFrame * CFrame.Angles(math.rad(180), 0, 0)
                    v.Velocity = Vector3.new(0, 4, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                    v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                    v.Transparency = playerVisible and 0 or 1
                end
            )
        elseif v.Name == "Right Arm" then
            game:GetService("RunService").PostSimulation:Connect(
                function()
                    v.CFrame = anchors.RightArm.CFrame * CFrame.Angles(math.rad(180), math.rad(-90), 0)
                    v.Velocity = Vector3.new(0, 4, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                    v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                    v.Transparency = playerVisible and 0 or 1
                end
            )
        elseif v.Name == "Left Arm" then
            game:GetService("RunService").PostSimulation:Connect(
                function()
                    v.CFrame = anchors.LeftArm.CFrame
                    v.Velocity = Vector3.new(0, 4, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 4, 0)
                    v.AssemblyAngularVelocity = Vector3.new(5, 0, 0)
                    v.Transparency = playerVisible and 0 or 1
                end
            )
        elseif v:IsA("BasePart") and 
               v.Name ~= "Left Leg" and 
               v.Name ~= "Right Leg" and
               v.Name ~= "Right Arm" and
               v.Name ~= "Left Arm" then
            game:GetService("RunService").PostSimulation:Connect(
                function()
                    v.CFrame = CFrame.new(model.WorldPivot.Position + Vector3.new(0, 600, 0))
                    v.Velocity = Vector3.new(0, 0, 0)
                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    v.Transparency = playerVisible and 0 or 1
                end
            )
        end
    end
end

-- Автоматическое обнаружение кнопки Ragdoll
spawn(function()
    wait(3) -- Ждем загрузки интерфейса игры
    
    local ragdollButton = findRagdollButton()
    
    if ragdollButton then
        print("✅ Кнопка Ragdoll найдена!")
        visibilityButton.Visible = true
        ragdollButtonFound = true
        
        -- Следим за нажатием кнопки в игре
        local function connectRagdollButton()
            ragdollButton.MouseButton1Click:Connect(function()
                print("🎯 Нажата кнопка Ragdoll в игре!")
                toggleVisibility()
            end)
        end
        
        -- Пробуем подключиться сразу
        pcall(connectRagdollButton)
        
        -- Если кнопка появится позже
        ragdollButton:GetPropertyChangedSignal("Parent"):Connect(function()
            pcall(connectRagdollButton)
        end)
        
    else
        print("⚠️ Кнопка Ragdoll не найдена")
        print("👆 Используй кнопку видимости в интерфейсе скрипта")
        visibilityButton.Visible = true
    end
end)

-- Запускаем привязку частей тела
if isR15 then
    print("🔧 Привязываем R15 конечности...")
    attachR15Limbs()
else
    print("🔧 Привязываем R6 конечности...")
    attachR6Limbs()
end

print("========================================")
print("     RAGDOLL GAME SCRIPT - R15/R6      ")
print("========================================")
print("📐 Тип тела: " .. (isR15 and "R15" or "R6"))
print("👻 Старт: невидимый")
print("🎮 Ищем кнопку Ragdoll в игре...")
print("➕➖ Кнопки скорости работают")
print("👆 Используй кнопку видимости если нужно")
print("========================================")
