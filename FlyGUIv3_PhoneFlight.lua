-- === [GUI] === (Оставляем как есть — не трогаем)
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "FLY GUI V3"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer
local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "FLY GUI V3";
	Text = "BY XNEO";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true
Frame.Draggable = true

-- === [НОВЫЙ КОД: НЕВИДИМОСТЬ + ТЕНЬ] ===
local shadow = nil
local isGhostMode = false

local function createShadow()
	if shadow then shadow:Destroy() end
	shadow = Instance.new("Part")
	shadow.Name = "GhostShadow"
	shadow.Size = Vector3.new(1.5, 0.1, 1.5)
	shadow.Shape = Enum.PartType.Ball
	shadow.Material = Enum.Material.Neon
	shadow.Color = Color3.fromRGB(0, 0, 0)
	shadow.Transparency = 0.7
	shadow.CanCollide = false
	shadow.Anchored = true
	shadow.CanQuery = false
	shadow.CastShadow = true
	shadow.BrickColor = BrickColor.Black()
	shadow.Parent = speaker.Character
end

local function makeGhost()
	if not speaker.Character or not speaker.Character:FindFirstChild("HumanoidRootPart") then return end
	createShadow()
	
	-- Скрываем ВСЕ части тела
	for _, part in ipairs(speaker.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
			part.CastShadow = true -- тень всё равно видна!
		end
	end
	
	-- Отключаем анимации
	speaker.Character.Animate.Disabled = true
	
	-- Отключаем физику, чтобы не мешала
	speaker.Character.Humanoid.PlatformStand = true
	
	-- Включаем режим призрака
	isGhostMode = true
end

local function unmakeGhost()
	if shadow then shadow:Destroy() end
	isGhostMode = false
	
	-- Восстанавливаем видимость
	for _, part in ipairs(speaker.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 0
			part.CanCollide = true
		end
	end
	
	-- Включаем анимации
	speaker.Character.Animate.Disabled = false
	speaker.Character.Humanoid.PlatformStand = false
end

-- === [ПОЛЁТ] === (ОБНОВЛЁННЫЙ ПОД ПРИЗРАКА)
onof.MouseButton1Down:connect(function()
	if nowe == true then
		-- ВЫКЛЮЧАЕМ ПОЛЁТ
		nowe = false
		unmakeGhost() -- Убираем призрака
		
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		-- ВКЛЮЧАЕМ ПОЛЁТ + ПРИЗРАКА
		nowe = true
		makeGhost() -- Сразу делаем призраком!
		
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	-- РЕЖИМ ПОЛЁТА (R6 и R15)
	if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

		while nowe == true and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Torso") do
			game:GetService("RunService").RenderStepped:Wait()

			-- Обновляем управление (WASD)
			ctrl.f = (game.UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
			ctrl.b = (game.UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
			ctrl.l = (game.UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
			ctrl.r = (game.UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0)

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed + 0.5 + (speed / maxspeed)
				if speed > maxspeed then speed = maxspeed end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed - 1
				if speed < 0 then speed = 0 end
			end

			local cam = game.Workspace.CurrentCamera
			local look = cam.CoordinateFrame.lookVector
			local right = cam.CoordinateFrame.rightVector
			local up = cam.CoordinateFrame.upVector

			local move = (look * (ctrl.f - ctrl.b)) + (right * (ctrl.r - ctrl.l)) + (up * (game.UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - up * (game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0))

			if move.Magnitude > 0 then
				bv.velocity = move * speed
				bg.cframe = cam.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f - ctrl.b) * 50 * speed / maxspeed), 0, 0)
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			-- Обновляем тень в реальном времени
			if shadow and shadow.Parent then
				shadow.CFrame = CFrame.new(torso.Position + Vector3.new(0, -0.8, 0))
				shadow.Transparency = 0.7 + math.sin(os.clock() * 2) * 0.2 -- пульсация
			end
		end

		bg:Destroy()
		bv:Destroy()
		speaker.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false

	else
		-- R15
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

		while nowe == true and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("UpperTorso") do
			wait()

			-- Обновляем управление (WASD)
			ctrl.f = (game.UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
			ctrl.b = (game.UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
			ctrl.l = (game.UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
			ctrl.r = (game.UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0)

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed + 0.5 + (speed / maxspeed)
				if speed > maxspeed then speed = maxspeed end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed - 1
				if speed < 0 then speed = 0 end
			end

			local cam = game.Workspace.CurrentCamera
			local look = cam.CoordinateFrame.lookVector
			local right = cam.CoordinateFrame.rightVector
			local up = cam.CoordinateFrame.upVector

			local move = (look * (ctrl.f - ctrl.b)) + (right * (ctrl.r - ctrl.l)) + (up * (game.UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - up * (game.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 1 or 0))

			if move.Magnitude > 0 then
				bv.velocity = move * speed
				bg.cframe = cam.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f - ctrl.b) * 50 * speed / maxspeed), 0, 0)
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			-- Обновляем тень
			if shadow and shadow.Parent then
				shadow.CFrame = CFrame.new(UpperTorso.Position + Vector3.new(0, -0.8, 0))
				shadow.Transparency = 0.7 + math.sin(os.clock() * 2) * 0.2
			end
		end

		bg:Destroy()
		bv:Destroy()
		speaker.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
	end
end)

-- === [UP/DOWN] === (Оставляем как есть — теперь они работают с тенью)
local tis
up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			if speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") then
				speaker.Character.HumanoidRootPart.CFrame = speaker.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
			end
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then tis:Disconnect() tis = nil end
end)

local dis
down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			if speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") then
				speaker.Character.HumanoidRootPart.CFrame = speaker.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
			end
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then dis:Disconnect() dis = nil end
end)

-- === [SPEED] === (Оставляем как есть)
plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then
		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat	
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	end
end)

mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					local hb = game:GetService("RunService").Heartbeat	
					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)

-- === [GUI] === (Оставляем как есть)
closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)

-- === [РЕАКЦИЯ НА СМЕРТЬ И ПЕРЕРОЖДЕНИЕ] ===
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	if nowe then
		makeGhost() -- Восстанавливаем призрака
	else
		unmakeGhost() -- Убираем призрака
	end
end)
