-- Auto Farm GUI Script
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HalloweenAutoFarm"
gui.ResetOnSpawn = false

if gethui then
    gui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(gui)
    gui.Parent = player:WaitForChild("PlayerGui")
else
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- Background Circle Bubbles
local function createBubble()
    local bubble = Instance.new("Frame")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.new(0, math.random(20, 60), 0, math.random(20, 60))
    bubble.Position = UDim2.new(0, math.random(-50, 400), 0, math.random(-50, 250))
    bubble.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Halloween Orange
    bubble.BackgroundTransparency = 0.8
    bubble.BorderSizePixel = 0
    bubble.Parent = gui
    
    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(1, 0)
    bubbleCorner.Parent = bubble
    
    -- Bubble animation
    local breatheTween = TweenService:Create(
        bubble,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.9}
    )
    breatheTween:Play()
    
    -- Floating animation
    local floatTween = TweenService:Create(
        bubble,
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Position = bubble.Position + UDim2.new(0, math.random(-10, 10), 0, math.random(-5, 5))}
    )
    floatTween:Play()
    
    return bubble
end

-- Create multiple bubbles
for i = 1, 8 do
    createBubble()
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = gui

-- Halloween Orange Border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(255, 140, 0) -- Halloween Orange
border.Thickness = 4
border.Parent = mainFrame

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "HALLOWEEN AUTO FARM"
titleLabel.TextColor3 = Color3.fromRGB(255, 140, 0) -- Halloween Orange
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextStrokeTransparency = 0
titleLabel.TextStrokeColor3 = Color3.fromRGB(139, 0, 0) -- Dark Red
titleLabel.Parent = mainFrame

-- Title Stroke
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(139, 0, 0)
titleStroke.Thickness = 2
titleStroke.Parent = titleLabel

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -40, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0, 110)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Halloween Orange
toggleButton.Text = "START FARM"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.Parent = mainFrame

-- Button Corner
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = toggleButton

-- Button Stroke
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(139, 0, 0)
buttonStroke.Thickness = 2
buttonStroke.Parent = toggleButton

-- Loading Animation
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, -40, 0, 6)
loadingFrame.Position = UDim2.new(0, 20, 0, 160)
loadingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
loadingFrame.BorderSizePixel = 0
loadingFrame.Visible = false
loadingFrame.Parent = mainFrame

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(1, 0)
loadingCorner.Parent = loadingFrame

local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.Position = UDim2.new(0, 0, 0, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Halloween Orange
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(1, 0)
loadingBarCorner.Parent = loadingBar

-- Loading Bar Effects
local loadingPulse = Instance.new("UIStroke")
loadingPulse.Color = Color3.fromRGB(255, 255, 255)
loadingPulse.Thickness = 2
loadingPulse.Transparency = 1
loadingPulse.Parent = loadingBar

-- Animated Particles
local function createParticle(parent)
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, 4, 0, 4)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BorderSizePixel = 0
    particle.AnchorPoint = Vector2.new(0.5, 0.5)
    particle.Parent = parent
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    return particle
end

-- Auto Farm Variables
local isFarming = false
local connection
local startTime = 0
local farmDuration = 60 -- 60 seconds
local particles = {}

-- Function to simulate auto farming
local function autoFarm()
    statusLabel.Text = "Status: Loading..."
    
    -- Show loading animation
    loadingFrame.Visible = true
    
    -- Start loading bar pulse animation
    local pulseTween = TweenService:Create(
        loadingPulse,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1),
        {Transparency = 0}
    )
    pulseTween:Play()
    
    -- Create particles along the loading bar
    for i = 1, 5 do
        local particle = createParticle(loadingBar)
        particle.Position = UDim2.new(math.random() * 0.8 + 0.1, 0, 0.5, 0)
        
        -- Particle animation
        local particleTween = TweenService:Create(
            particle,
            TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1),
            {
                Position = UDim2.new(math.random() * 0.8 + 0.1, 0, 0.5, 0),
                BackgroundTransparency = 1
            }
        )
        particleTween:Play()
        table.insert(particles, {particle = particle, tween = particleTween})
    end
    
    startTime = tick()
    
    connection = RunService.Heartbeat:Connect(function()
        if isFarming then
            local currentTime = tick()
            local elapsed = currentTime - startTime
            local progress = elapsed / farmDuration
            
            -- Update loading bar with bounce effect
            loadingBar.Size = UDim2.new(progress, 0, 1, 0)
            
            -- Add subtle scale animation to loading bar
            if elapsed % 0.5 < 0.25 then
                loadingBar.Size = UDim2.new(progress, 0, 1.2, 0)
            else
                loadingBar.Size = UDim2.new(progress, 0, 0.8, 0)
            end
            
            -- Keep status as "Loading..." throughout
            statusLabel.Text = "Status: Loading..."
            
            -- Check if farming duration is complete
            if elapsed >= farmDuration then
                statusLabel.Text = "Status: Completed!"
                isFarming = false
                toggleButton.Text = "START FARM"
                toggleButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
                loadingFrame.Visible = false
                
                -- Stop animations
                pulseTween:Cancel()
                for _, p in pairs(particles) do
                    p.tween:Cancel()
                    p.particle:Destroy()
                end
                particles = {}
                
                if connection then
                    connection:Disconnect()
                end
            end
        end
    end)
end

-- Toggle Button Function
toggleButton.MouseButton1Click:Connect(function()
    isFarming = not isFarming
    
    if isFarming then
        toggleButton.Text = "PROCESSING..."
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60) -- Crimson Red
        statusLabel.Text = "Status: Starting..."
        
        -- Add a spooky effect
        local originalSize = mainFrame.Size
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize + UDim2.new(0, 10, 0, 10)})
        tween:Play()
        
        tween.Completed:Connect(function()
            local tweenBack = TweenService:Create(mainFrame, tweenInfo, {Size = originalSize})
            tweenBack:Play()
        end)
        
        -- Start farming after a short delay
        wait(0.5)
        autoFarm()
        
    else
        toggleButton.Text = "START FARM"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Halloween Orange
        statusLabel.Text = "Status: Stopped"
        loadingFrame.Visible = false
        
        -- Stop all animations
        for _, p in pairs(particles) do
            if p.tween then
                p.tween:Cancel()
            end
            if p.particle then
                p.particle:Destroy()
            end
        end
        particles = {}
        
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Add hover effects
toggleButton.MouseEnter:Connect(function()
    if isFarming then
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if isFarming then
        toggleButton.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    end
end)

-- Enhanced Draggable Functionality
local dragging = false
local dragInput, dragStart, startPos

-- Function to make any frame draggable
local function makeDraggable(frame)
    local dragToggle = nil
    local dragSpeed = 1
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X * dragSpeed,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y * dragSpeed)
        frame.Position = position
    end
    
    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
end

-- Make the main frame draggable
makeDraggable(mainFrame)

-- Also make the title bar draggable for better UX
titleLabel.Active = true
titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

print("Halloween Auto Farm GUI Loaded!")
