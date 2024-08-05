local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GamerGBG/Script/main/SwordLib.lua",true))()

local Main = library:Window("Sword")

-- Slider to adjust the walking speed
Main:Slider("Speed Slider", 16, 500, 16, function(value)
    humanoid.WalkSpeed = value
end)

-- Slider to adjust the jump power
Main:Slider("Jump Slider", 50, 350, 50, function(value)
    humanoid.JumpPower = value
end)

Main:Slider("FOV Slider", 70, 120, 70, function(value)
	camera.FieldOfView = value
end)

Main:Button("Inf Jump", function()
	game:GetService('UserInputService').InputBegan:Connect(function(UserInput) local Player = game:GetService('Players').LocalPlayer; _G.JumpHeight = humanoid.JumpPower; local UIS = game:GetService('UserInputService'); local function Action(Object, Function) if Object ~= nil then Function(Object) end end; if UserInput.UserInputType == Enum.UserInputType.Keyboard and UserInput.KeyCode == Enum.KeyCode.Space then Action(Player.Character.Humanoid, function(self) if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then Action(self.Parent.HumanoidRootPart, function(rootPart) rootPart.Velocity = Vector3.new(0, _G.JumpHeight, 0) end) end end) end end)
end)

-- Flight button
Main:Toggle("Fly", false, function()
	ToggleAction()
end)

local Settings = {
	
	Speed = 1,
	SprintSpeed = 35,
	ToggleKey = Enum.KeyCode,
	SprintKey = Enum.KeyCode.LeftControl,
	
	ForwardKey = Enum.KeyCode.W,
	LeftKey = Enum.KeyCode.A,
	BackwardKey = Enum.KeyCode.S,
	RightKey = Enum.KeyCode.D,
	UpKey = Enum.KeyCode.Space,
	DownKey = Enum.KeyCode,
	
}

local Screen = Instance.new("ScreenGui",game.CoreGui)
local Distance = Instance.new("TextLabel",Screen)
Distance.BackgroundTransparency = 1
Distance.Size = UDim2.new(0,10,0,10)
Distance.ZIndex = 2
Distance.Text = "0"
Distance.TextStrokeTransparency = .5
Distance.TextSize = 20
Distance.TextStrokeColor3 = Color3.fromRGB(33, 33, 33)
Distance.Font = Enum.Font.Gotham
Distance.TextColor3 = Color3.new(1,1,1)
Distance.TextXAlignment = Enum.TextXAlignment.Left
Distance.TextYAlignment = Enum.TextYAlignment.Top


local Mouse = game.Players.LocalPlayer:GetMouse()
local Direction = Vector3.new(0,0,0)
local InterpolatedDir = Direction
local Tilt = 0
local InterpolatedTilt = Tilt
local RunService = game:GetService("RunService")
local Toggled = false
local Sprinting = false
local CameraPos = game.Workspace.CurrentCamera.CFrame.Position

pcall(function()
	game.Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam	
end)

function Lerp(a, b, t)
    return a + (b - a) * t
end

local LastPos = nil

function ToggleAction()
    Toggled = not Toggled
    if Toggled then
        LastPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        --game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
    else
        LastPos = nil
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        --game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end


function KeyHandler(actionName, userInputState)
	if true and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		if actionName == "Toggle" and userInputState == Enum.UserInputState.Begin then
			ToggleAction()
		elseif actionName == "Forward" then
			Tilt = userInputState == Enum.UserInputState.Begin and -20 or 0
			Direction = Vector3.new(Direction.x,Direction.y,userInputState == Enum.UserInputState.Begin and -1 or 0)
		elseif actionName == "Left" then
			Direction = Vector3.new(userInputState == Enum.UserInputState.Begin and -1 or 0,Direction.y,Direction.z)
		elseif actionName == "Backward" then
			Tilt = userInputState == Enum.UserInputState.Begin and 20 or 0
			Direction = Vector3.new(Direction.x,Direction.y,userInputState == Enum.UserInputState.Begin and 1 or 0)
		elseif actionName == "Right" then
			Direction = Vector3.new(userInputState == Enum.UserInputState.Begin and 1 or 0,Direction.y,Direction.z)
		elseif actionName == "Up" then
			Direction = Vector3.new(Direction.x,userInputState == Enum.UserInputState.Begin and 1 or 0,Direction.z)
		elseif actionName == "Down" then
			Direction = Vector3.new(Direction.x,userInputState == Enum.UserInputState.Begin and -1 or 0,Direction.z)
		elseif actionName == "Sprint" then
			Sprinting = userInputState == Enum.UserInputState.Begin
		end
	end
end



game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameProcessedEvent)
	
	if inputObject.KeyCode == Settings.ToggleKey then
		KeyHandler("Toggle", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.ForwardKey then
		KeyHandler("Forward", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.LeftKey then
		KeyHandler("Left", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.BackwardKey then
		KeyHandler("Backward", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.RightKey then
		KeyHandler("Right", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.UpKey then	
		KeyHandler("Up", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.DownKey then
		KeyHandler("Down", Enum.UserInputState.Begin, inputObject)
	elseif inputObject.KeyCode == Settings.SprintKey then
		KeyHandler("Sprint", Enum.UserInputState.Begin, inputObject)
	end
	
	
end)


game:GetService("UserInputService").InputEnded:connect(function(inputObject, gameProcessedEvent)
	
	if inputObject.KeyCode == Settings.ToggleKey then
		KeyHandler("Toggle", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.ForwardKey then
		KeyHandler("Forward", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.LeftKey then
		KeyHandler("Left", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.BackwardKey then
		KeyHandler("Backward", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.RightKey then
		KeyHandler("Right", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.UpKey then	
		KeyHandler("Up", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.DownKey then
		KeyHandler("Down", Enum.UserInputState.End, inputObject)
	elseif inputObject.KeyCode == Settings.SprintKey then
		KeyHandler("Sprint", Enum.UserInputState.End, inputObject)
	end
	
	
end)


RunService.RenderStepped:Connect(function()
	if Toggled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  then
		for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Velocity = Vector3.new(0,0,0)
			end
		end
		local RootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
		if LastPos then
			Distance.Text = math.floor((LastPos-RootPart.Position).Magnitude+.5)
			if (LastPos-RootPart.Position).Magnitude >= 350 then
				Distance.TextColor3 = Color3.new(1,0,0)
			else
				Distance.TextColor3 = Color3.new(1,1,1)	
			end
		else
			Distance.TextColor3 = Color3.new(1,1,1)
			Distance.Text = 0
		end
		InterpolatedDir = InterpolatedDir:Lerp((Direction * (Sprinting and Settings.SprintSpeed or Settings.Speed)),.2)
		InterpolatedTilt = Lerp(InterpolatedTilt ,Tilt* (Sprinting and 2 or 1),Tilt == 0 and .2 or .1)
		RootPart.CFrame = RootPart.CFrame:Lerp(CFrame.new(RootPart.Position,RootPart.Position + Mouse.UnitRay.Direction) * CFrame.Angles(0,math.rad(00),0) * CFrame.new(InterpolatedDir)  * CFrame.Angles(math.rad(InterpolatedTilt),0,0),.2)
	else
		Distance.TextColor3 = Color3.new(1,1,1)
		Distance.Text = 0
	end	
end)

local SettingsSword = library:Window("Settings")

SettingsSword:Label("Made By GamerGBG")
SettingsSword:Label("Press X To Hide")
SettingsSword:Button("Destroy Gui", function()
    library:Destroy()
end)

SettingsSword:Button("Join our Discord", function()
	-- Create a ScreenGui and TextBox in the Player's PlayerGui
	local player = game.Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "DiscordGui"
	screenGui.Parent = player.PlayerGui

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(0.7, 0, 0.1, 0)
	text.Position = UDim2.new(0.1, 0, 0.4, -135)
	text.Text = "Please Open the URL"
	text.TextColor3 = Color3.fromRGB(255, 255, 255)
	text.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Red color for visibility
	text.TextScaled = true
	text.Parent = screenGui

	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0.7, 0, 0.1, 0)
	textBox.Position = UDim2.new(0.1, 0, 0.4, 0)
	textBox.Text = "https://discord.gg/xP3Z4rSfxv"
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textBox.TextScaled = true
	textBox.TextWrapped = true
	textBox.TextEditable = false  -- Prevent editing
	textBox.ClearTextOnFocus = false  -- Prevent clearing text when focused
	textBox.Parent = screenGui

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0.2, 0, 0.2, 0)
	closeButton.Position = UDim2.new(0.8, 0, 0.3, 0)
	closeButton.Text = "Close"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.BackgroundColor3 = Color3.fromRGB(1, 0, 0)  -- Red color for visibility
	closeButton.TextScaled = true
	closeButton.Parent = screenGui

	-- Function to remove the ScreenGui
	local function onCloseButtonClicked()
		screenGui:Destroy()  -- This will remove the GUI from the player's screen
	end

	-- Connect the function to the button's click event
	closeButton.MouseButton1Click:Connect(onCloseButtonClicked)
end)

library:Keybind("X")
