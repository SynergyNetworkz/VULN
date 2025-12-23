shared.LoaderTitle = "Subscribe To SynergyNetworks"

shared.LoaderKeyFrames = {
    [1] = {1, 10},
    [2] = {2, 30},
    [3] = {3, 60},
    [4] = {2, 100}
}

local v2 = {
    LoaderData = {
        Name = shared.LoaderTitle,
        Colors = shared.LoaderColors or {
            Main = Color3.fromRGB(0, 0, 0),
            Topic = Color3.fromRGB(200, 200, 200),
            Title = Color3.fromRGB(255, 255, 255),
            LoaderBackground = Color3.fromRGB(40, 40, 40),
            LoaderSplash = Color3.fromRGB(0, 102, 255)
        }
    },
    Keyframes = shared.LoaderKeyFrames
}

local v3 = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = ""
}

function TweenObject(a,b,c)
    game.TweenService:Create(a, TweenInfo.new(b, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), c):Play()
end

function CreateObject(a,b)
    local c = Instance.new(a)
    local d
    for k,v in pairs(b) do
        if k ~= "Parent" then
            c[k] = v
        else
            d = v
        end
    end
    c.Parent = d
    return c
end

local function v4(a,b)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,a)
    c.Parent = b
end

local v5 = CreateObject("ScreenGui", {
    Name = "Core",
    Parent = game.CoreGui
})

local v6 = CreateObject("Frame", {
    Name = "Main",
    Parent = v5,
    BackgroundColor3 = v2.LoaderData.Colors.Main,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5,0,0.5,0),
    AnchorPoint = Vector2.new(0.5,0.5),
    Size = UDim2.new(0,0,0,0)
})

v4(12,v6)

local v7 = CreateObject("TextLabel", {
    Name = "LogoText",
    Parent = v6,
    BackgroundTransparency = 1,
    Text = "SN",
    Position = UDim2.new(0,15,0,10),
    Size = UDim2.new(0,50,0,50),
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center
})

v4(25,v7)

local v8 = CreateObject("TextLabel", {
    Name = "UserName",
    Parent = v6,
    BackgroundTransparency = 1,
    Text = "SynergyNetworks",
    Position = UDim2.new(0,75,0,10),
    Size = UDim2.new(0,200,0,50),
    Font = Enum.Font.GothamBold,
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local v9 = CreateObject("TextLabel", {
    Name = "Top",
    TextTransparency = 1,
    Parent = v6,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,30,0,70),
    Size = UDim2.new(0,301,0,20),
    Font = Enum.Font.Gotham,
    Text = "Loader",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
})

local v10 = CreateObject("TextLabel", {
    Name = "Title",
    Parent = v6,
    TextTransparency = 1,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,30,0,90),
    Size = UDim2.new(0,301,0,46),
    Font = Enum.Font.Gotham,
    RichText = true,
    Text = "<b>"..v2.LoaderData.Name.."</b>",
    TextColor3 = v2.LoaderData.Colors.Title,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local v11 = CreateObject("Frame", {
    Name = "BG",
    Parent = v6,
    AnchorPoint = Vector2.new(0.5,0),
    BackgroundTransparency = 1,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderBackground,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5,0,0,70),
    Size = UDim2.new(0.85,0,0,24)
})

v4(8,v11)

local v12 = CreateObject("Frame", {
    Name = "Progress",
    Parent = v11,
    BackgroundColor3 = v2.LoaderData.Colors.LoaderSplash,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0,0,0,24)
})

v4(8,v12)

local v13 = CreateObject("TextLabel", {
    Name = "StepLabel",
    Parent = v6,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5,0,1,-25),
    Size = UDim2.new(1,-20,0,20),
    Font = Enum.Font.Gotham,
    Text = "",
    TextColor3 = v2.LoaderData.Colors.Topic,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    AnchorPoint = Vector2.new(0.5,0.5)
})

function UpdateStepText(a)
    v13.Text = v3[a] or ""
end

function UpdatePercentage(a,b)
    TweenObject(v12,0.5,{Size=UDim2.new(a/100,0,0,24)})
    UpdateStepText(b)
end

TweenObject(v6,0.25,{Size=UDim2.new(0,346,0,121)})
wait()
TweenObject(v9,0.5,{TextTransparency=0})
TweenObject(v10,0.5,{TextTransparency=0})
TweenObject(v11,0.5,{BackgroundTransparency=0})
TweenObject(v12,0.5,{BackgroundTransparency=0})

for i,frame in pairs(v2.Keyframes) do
    wait(frame[1])
    UpdatePercentage(frame[2],i)
end

UpdatePercentage(100,4)
TweenObject(v9,0.5,{TextTransparency=1})
TweenObject(v10,0.5,{TextTransparency=1})
TweenObject(v11,0.5,{BackgroundTransparency=1})
TweenObject(v12,0.5,{BackgroundTransparency=1})
wait(0.5)
TweenObject(v6,0.25,{Size=UDim2.new(0,0,0,0)})
wait(0.25)
v5:Destroy()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

-- Toggle Button with minimalist design
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SynergyNetworksToggle"
screenGui.Parent = playerGui

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -70, 0, 20)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toggleButton.BackgroundTransparency = 0.2
toggleButton.Text = "SN"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.AutoButtonColor = false

-- Add subtle border
local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(60, 60, 70)
border.Thickness = 1.5
border.Parent = toggleButton

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = toggleButton

-- Add hover effect
local hoverFrame = Instance.new("Frame")
hoverFrame.Size = UDim2.new(1, 0, 1, 0)
hoverFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hoverFrame.BackgroundTransparency = 0.9
hoverFrame.BorderSizePixel = 0
hoverFrame.ZIndex = 2
hoverFrame.Parent = toggleButton
hoverFrame.Visible = false

Instance.new("UICorner", hoverFrame).CornerRadius = UDim.new(0.2, 0)

toggleButton.Parent = screenGui

-- Hover effects
toggleButton.MouseEnter:Connect(function()
    hoverFrame.Visible = true
    TweenService:Create(toggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(1, -69, 0, 19)
    }):Play()
    TweenService:Create(border, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = Color3.fromRGB(80, 80, 90)
    }):Play()
end)

toggleButton.MouseLeave:Connect(function()
    hoverFrame.Visible = false
    TweenService:Create(toggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(1, -70, 0, 20)
    }):Play()
    TweenService:Create(border, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = Color3.fromRGB(60, 60, 70)
    }):Play()
end)

-- Function to create the main GUI
local function makeGui()
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "synergy_networks_"..tostring(math.random(1000,9999))
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Enabled = false
    Gui.Parent = playerGui
    
    local Main = Instance.new("Frame")  
    Main.Size = UDim2.new(0,300,0,190)  
    Main.Position = UDim2.new(0.5,-150,0.5,-95)  
    Main.BackgroundColor3 = Color3.fromRGB(10,25,45)  
    Main.BackgroundTransparency = 0.15  
    Main.BorderSizePixel = 0  
    Main.Active = true  
    Main.Parent = Gui  
    
    -- Add border to main frame
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Color3.fromRGB(30, 40, 60)
    mainBorder.Thickness = 2
    mainBorder.Parent = Main
    
    Instance.new("UICorner",Main).CornerRadius = UDim.new(0,16)  
    
    local Title = Instance.new("TextLabel")  
    Title.Size = UDim2.new(1,-20,0,40)  
    Title.Position = UDim2.new(0,10,0,5)  
    Title.BackgroundTransparency = 1  
    Title.Text = "SynergyNetworks Auto Moreira V3"  
    Title.TextColor3 = Color3.fromRGB(200,220,255)  
    Title.TextSize = 15  
    Title.Font = Enum.Font.GothamBold  
    Title.Parent = Main  
    
    local StartBtn = Instance.new("TextButton")  
    StartBtn.Size = UDim2.new(1,-30,0,32)  
    StartBtn.Position = UDim2.new(0,15,0,50)  
    StartBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)  
    StartBtn.BackgroundTransparency = 0.2
    StartBtn.Text = "Start Auto Moreira"  
    StartBtn.TextColor3 = Color3.fromRGB(220, 220, 220)  
    StartBtn.TextSize = 12  
    StartBtn.Font = Enum.Font.GothamBold  
    StartBtn.Parent = Main  
    
    -- Add border to start button
    local startBtnBorder = Instance.new("UIStroke")
    startBtnBorder.Color = Color3.fromRGB(50, 60, 80)
    startBtnBorder.Thickness = 1.5
    startBtnBorder.Parent = StartBtn
    
    Instance.new("UICorner",StartBtn).CornerRadius = UDim.new(0,10)  
    
    local LoadBg = Instance.new("Frame")  
    LoadBg.Size = UDim2.new(1,-30,0,5)  
    LoadBg.Position = UDim2.new(0,15,0,90)  
    LoadBg.BackgroundColor3 = Color3.fromRGB(20, 25, 35)  
    LoadBg.BackgroundTransparency = 0.3  
    LoadBg.Parent = Main  
    Instance.new("UICorner",LoadBg).CornerRadius = UDim.new(1,0)  
    
    local LoadBar = Instance.new("Frame")  
    LoadBar.Size = UDim2.new(0,0,1,0)  
    LoadBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)  
    LoadBar.BackgroundTransparency = 0.2  
    LoadBar.Parent = LoadBg  
    Instance.new("UICorner",LoadBar).CornerRadius = UDim.new(1,0)  
    
    local Status = Instance.new("TextLabel")  
    Status.Size = UDim2.new(1,-30,0,18)  
    Status.Position = UDim2.new(0,15,0,100)  
    Status.BackgroundTransparency = 1  
    Status.Text = "Ready to start..."  
    Status.TextColor3 = Color3.fromRGB(180,180,200)  
    Status.TextSize = 10  
    Status.Font = Enum.Font.Gotham  
    Status.Parent = Main  
    
    local AutoBlock = Instance.new("TextButton")  
    AutoBlock.Size = UDim2.new(1,-30,0,20)  
    AutoBlock.Position = UDim2.new(0,15,1,-50)  
    AutoBlock.BackgroundTransparency = 1  
    AutoBlock.Text = "Auto Block: ON"  
    AutoBlock.TextColor3 = Color3.fromRGB(76,175,80)  
    AutoBlock.TextSize = 10  
    AutoBlock.Font = Enum.Font.GothamBold  
    AutoBlock.TextXAlignment = Enum.TextXAlignment.Left  
    AutoBlock.Parent = Main  
    
    local AntiCooldown = Instance.new("TextButton")  
    AntiCooldown.Size = UDim2.new(1,-30,0,20)  
    AntiCooldown.Position = UDim2.new(0,15,1,-28)  
    AntiCooldown.BackgroundTransparency = 1  
    AntiCooldown.Text = "Anti Cooldown: Coming Soon"  
    AntiCooldown.TextColor3 = Color3.fromRGB(244, 67, 54)  
    AntiCooldown.TextSize = 10  
    AntiCooldown.Font = Enum.Font.GothamBold  
    AntiCooldown.TextXAlignment = Enum.TextXAlignment.Left  
    AntiCooldown.Parent = Main  
    
    -- Button logic  
    local blockOn = true  
    local cooldownOn = false  
    local running = false  
    local playerListener  
    
    StartBtn.MouseButton1Click:Connect(function()  
        if running then return end  
        running = true  
        StartBtn.Text = "Starting..."  
        StartBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 45)  
        TweenService:Create(startBtnBorder, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255,170,40)
        }):Play()
        
        task.spawn(function()  
            local s = tick()  
            local d = 5  
            while tick()-s < d do  
                LoadBar.Size = UDim2.new((tick()-s)/d,0,1,0)  
                task.wait(0.03)  
            end  
            LoadBar.Size = UDim2.new(1,0,1,0)  
            StartBtn.Text = "Waiting for bot..."  
            StartBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)  
            TweenService:Create(startBtnBorder, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(33,150,243)
            }):Play()
            Status.Text = "Waiting for bot to join..."  
            playerListener = Players.PlayerAdded:Connect(function()  
                StartBtn.Text = "Bot Joined.."  
                StartBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)  
                TweenService:Create(startBtnBorder, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(76,175,80)
                }):Play()
                Status.Text = "Bot Joined!"  
                task.wait(5)  
                LoadBar.Size = UDim2.new(0,0,1,0)  
                StartBtn.Text = "Start Auto Moreira"  
                StartBtn.BackgroundColor3 = Color3.fromRGB(20, 25, 35)  
                TweenService:Create(startBtnBorder, TweenInfo.new(0.2), {
                    Color = Color3.fromRGB(50, 60, 80)
                }):Play()
                Status.Text = "Ready to start..."  
                running = false  
                if playerListener then  
                    playerListener:Disconnect()  
                end  
            end)  
        end)  
    end)  
    
    AutoBlock.MouseButton1Click:Connect(function()  
        blockOn = not blockOn  
        AutoBlock.Text = blockOn and "Auto Block: ON" or "Auto Block: OFF"  
        AutoBlock.TextColor3 = blockOn and Color3.fromRGB(76,175,80) or Color3.fromRGB(244,67,54)  
    end)  
    
    AntiCooldown.MouseButton1Click:Connect(function()  
        -- Coming soon - no functionality
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SynergyNetworks",
            Text = "Anti Cooldown feature coming soon!",
            Duration = 3
        })
    end)  
    
    -- Smooth draggable  
    local dragging = false  
    local dragStart, startPos  
    
    local function onInputBegan(input)  
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
            dragging = true  
            dragStart = input.Position  
            startPos = Main.Position  
        end  
    end  
    
    local function onInputChanged(input)  
        if dragging then  
            local delta = input.Position - dragStart  
            local targetPos = UDim2.new(  
                startPos.X.Scale,  
                startPos.X.Offset + delta.X,  
                startPos.Y.Scale,  
                startPos.Y.Offset + delta.Y  
            )  
            TweenService:Create(Main, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()  
        end  
    end  
    
    local function onInputEnded(input)  
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then  
            dragging = false  
        end  
    end  
    
    Main.InputBegan:Connect(onInputBegan)  
    Main.InputChanged:Connect(function(input)  
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then  
            onInputChanged(input)  
        end  
    end)  
    Main.InputEnded:Connect(onInputEnded)  
    
    return Gui
end

local AutoGui = makeGui()
local guiOpen = false

toggleButton.MouseButton1Click:Connect(function()
    guiOpen = not guiOpen
    AutoGui.Enabled = guiOpen
    
    -- Animate button click
    TweenService:Create(toggleButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 45, 0, 45),
        Position = UDim2.new(1, -67.5, 0, 22.5)
    }):Play()
    
    task.wait(0.1)
    
    TweenService:Create(toggleButton, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(1, -70, 0, 20)
    }):Play()
end)
