local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local G2L = {}
local SelectedUserId = nil

-- [[ ROOT SETUP ]]
G2L.Root = Instance.new("ScreenGui")
G2L.Root.Name = "StealABrainrotUI"
G2L.Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G2L.Root.ResetOnSpawn = false
G2L.Root.IgnoreGuiInset = true
G2L.Root.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- [[ MAIN FRAME ]]
G2L.Main = Instance.new("Frame")
G2L.Main.Name = "Main"
G2L.Main.Size = UDim2.new(0, 360, 0, 430) 
G2L.Main.Position = UDim2.new(0.5, -180, 0.5, -215)
G2L.Main.BackgroundColor3 = Color3.fromRGB(22, 23, 27) 
G2L.Main.BorderSizePixel = 0
G2L.Main.ClipsDescendants = true -- ADDED: Hides content when minimizing
G2L.Main.Parent = G2L.Root
Instance.new("UICorner", G2L.Main).CornerRadius = UDim.new(0, 14)
Instance.new("UIStroke", G2L.Main).Color = Color3.fromRGB(45, 45, 50)

-- [[ MOBILE SCALING SYSTEM ]]
G2L.UIScale = Instance.new("UIScale", G2L.Main)

local function AdjustScaleForMobile()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    -- If the screen is smaller than the UI's required height, scale it down proportionally
    if viewportSize.Y < 480 then
        G2L.UIScale.Scale = viewportSize.Y / 500
    else
        G2L.UIScale.Scale = 1
    end
end
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(AdjustScaleForMobile)
AdjustScaleForMobile()

-- [[ HEADER ]]
G2L.Header = Instance.new("Frame", G2L.Main)
G2L.Header.Size = UDim2.new(1, 0, 0, 50)
G2L.Header.BackgroundTransparency = 1

G2L.Title = Instance.new("TextLabel", G2L.Header)
G2L.Title.Size = UDim2.new(1, -90, 1, 0)
G2L.Title.Position = UDim2.new(0, 20, 0, 0)
G2L.Title.BackgroundTransparency = 1
G2L.Title.Font = Enum.Font.GothamBold
G2L.Title.Text = "Synergy Networkz"
G2L.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
G2L.Title.TextSize = 18
G2L.Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ WINDOW CONTROLS ]]
-- Close Button
G2L.CloseBtn = Instance.new("ImageButton", G2L.Header)
G2L.CloseBtn.Size = UDim2.new(0, 20, 0, 20)
G2L.CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
G2L.CloseBtn.BackgroundTransparency = 1
G2L.CloseBtn.Image = "rbxassetid://110786993356448"
G2L.CloseBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)
G2L.CloseBtn.MouseButton1Click:Connect(function()
    G2L.Root:Destroy()
end)

-- Minimize Button (New!)
G2L.MinimizeBtn = Instance.new("ImageButton", G2L.Header)
G2L.MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
G2L.MinimizeBtn.Position = UDim2.new(1, -65, 0.5, -10) -- Positioned next to close button
G2L.MinimizeBtn.BackgroundTransparency = 1
G2L.MinimizeBtn.Image = "rbxassetid://97427877691946"
G2L.MinimizeBtn.ImageColor3 = Color3.fromRGB(150, 150, 150)

local isMinimized = false
G2L.MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Shrink window
        TweenService:Create(G2L.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 360, 0, 50) -- Height of the header only
        }):Play()
        -- Rotate icon
        TweenService:Create(G2L.MinimizeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 180
        }):Play()
    else
        -- Expand window
        TweenService:Create(G2L.Main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 360, 0, 430) -- Full original height
        }):Play()
        -- Rotate icon back
        TweenService:Create(G2L.MinimizeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 0
        }):Play()
    end
end)

G2L.Divider = Instance.new("Frame", G2L.Main)
G2L.Divider.Size = UDim2.new(1, 0, 0, 1)
G2L.Divider.Position = UDim2.new(0, 0, 0, 50)
G2L.Divider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
G2L.Divider.BorderSizePixel = 0

-- [[ SEARCH BAR ]]
G2L.SearchBar = Instance.new("Frame", G2L.Main)
G2L.SearchBar.Size = UDim2.new(1, -40, 0, 40)
G2L.SearchBar.Position = UDim2.new(0, 20, 0, 65)
G2L.SearchBar.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
Instance.new("UICorner", G2L.SearchBar).CornerRadius = UDim.new(0, 😎
Instance.new("UIStroke", G2L.SearchBar).Color = Color3.fromRGB(50, 52, 58)

local searchIcon = Instance.new("ImageLabel", G2L.SearchBar)
searchIcon.Size = UDim2.new(0, 20, 0, 20)
searchIcon.Position = UDim2.new(0, 10, 0.5, -10)
searchIcon.BackgroundTransparency = 1
searchIcon.Image = "rbxassetid://103908993553772"
searchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

G2L.SearchInput = Instance.new("TextBox", G2L.SearchBar)
G2L.SearchInput.Size = UDim2.new(1, -40, 1, 0)
G2L.SearchInput.Position = UDim2.new(0, 40, 0, 0)
G2L.SearchInput.BackgroundTransparency = 1
G2L.SearchInput.Font = Enum.Font.Gotham
G2L.SearchInput.Text = ""
G2L.SearchInput.PlaceholderText = "Search player here.."
G2L.SearchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
G2L.SearchInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
G2L.SearchInput.TextSize = 13
G2L.SearchInput.TextXAlignment = Enum.TextXAlignment.Left

-- [[ PLAYER PROFILE CARD ]]
G2L.ProfileCard = Instance.new("Frame", G2L.Main)
G2L.ProfileCard.Size = UDim2.new(1, -40, 0, 80)
G2L.ProfileCard.Position = UDim2.new(0, 20, 0, 115)
G2L.ProfileCard.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
Instance.new("UICorner", G2L.ProfileCard).CornerRadius = UDim.new(0, 10)
G2L.ProfileStroke = Instance.new("UIStroke", G2L.ProfileCard)
G2L.ProfileStroke.Color = Color3.fromRGB(50, 52, 58) 
G2L.ProfileStroke.Thickness = 1.5

G2L.Avatar = Instance.new("ImageLabel", G2L.ProfileCard)
G2L.Avatar.Size = UDim2.new(0, 56, 0, 56)
G2L.Avatar.Position = UDim2.new(0, 12, 0.5, -28)
G2L.Avatar.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
G2L.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150" 
Instance.new("UICorner", G2L.Avatar).CornerRadius = UDim.new(1, 0)

G2L.TargetName = Instance.new("TextLabel", G2L.ProfileCard)
G2L.TargetName.Size = UDim2.new(1, -120, 0, 20)
G2L.TargetName.Position = UDim2.new(0, 80, 0.5, -10)
G2L.TargetName.BackgroundTransparency = 1
G2L.TargetName.Font = Enum.Font.GothamBold
G2L.TargetName.Text = "Awaiting Target..."
G2L.TargetName.TextColor3 = Color3.fromRGB(150, 150, 150)
G2L.TargetName.TextSize = 16
G2L.TargetName.TextXAlignment = Enum.TextXAlignment.Left

G2L.Checkmark = Instance.new("ImageLabel", G2L.ProfileCard)
G2L.Checkmark.Size = UDim2.new(0, 20, 0, 20)
G2L.Checkmark.Position = UDim2.new(1, -35, 0.5, -10)
G2L.Checkmark.BackgroundTransparency = 1
G2L.Checkmark.Image = "rbxassetid://139101312710134"
G2L.Checkmark.ImageColor3 = Color3.fromRGB(40, 200, 90)
G2L.Checkmark.Visible = false

-- [[ GLOBAL SEARCH LOGIC ]]
G2L.SearchInput.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    
    local txt = G2L.SearchInput.Text
    if txt == "" then return end

    G2L.TargetName.Text = "Searching..."
    G2L.TargetName.TextColor3 = Color3.fromRGB(200, 200, 200)
    G2L.ProfileStroke.Color = Color3.fromRGB(50, 52, 58)
    G2L.Checkmark.Visible = false

    task.spawn(function()
        local userId
        local success, _ = pcall(function()
            userId = Players:GetUserIdFromNameAsync(txt)
        end)

        if success and userId then
            local realName = txt
            pcall(function() realName = Players:GetNameFromUserIdAsync(userId) end)

            G2L.TargetName.Text = "@" .. realName
            G2L.TargetName.TextColor3 = Color3.fromRGB(40, 200, 90)
            G2L.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
            SelectedUserId = userId
            G2L.Checkmark.Visible = true

            TweenService:Create(G2L.ProfileStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 200, 90)}):Play()
        else
            G2L.TargetName.Text = "Player not found!"
            G2L.TargetName.TextColor3 = Color3.fromRGB(220, 40, 60)
            G2L.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=150&h=150"
            SelectedUserId = nil
            G2L.Checkmark.Visible = false

            TweenService:Create(G2L.ProfileStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(220, 40, 60)}):Play()
        end
    end)
end)

-- [[ THE 3 TOGGLE BUTTONS ]]
local btnDefs = {
    {name = "ForceAccept", label = "FORCE ACCEPT", sub = "bypass trade confirmation", posY = 205},
    {name = "FreezeVictim", label = "FREEZE VICTIM", sub = "freeze your victim", posY = 275},
    {name = "ForceGive", label = "FORCE GIVE BRAINROT", sub = "push all items instantly", posY = 345},
}

local colorDisabled = Color3.fromRGB(45, 45, 50)
local colorEnabled = Color3.fromRGB(40, 200, 90)
local colorError = Color3.fromRGB(220, 40, 60)

for _, def in ipairs(btnDefs) do
    local isEnabled = false

    local btnFrame = Instance.new("TextButton", G2L.Main)
    btnFrame.Name = def.name
    btnFrame.Size = UDim2.new(1, -40, 0, 60)
    btnFrame.Position = UDim2.new(0, 20, 0, def.posY)
    btnFrame.BackgroundColor3 = colorDisabled
    btnFrame.AutoButtonColor = false
    btnFrame.Text = ""
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", btnFrame)
    title.Size = UDim2.new(1, -30, 0, 20)
    title.Position = UDim2.new(0, 15, 0.5, -16)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = def.label
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", btnFrame)
    sub.Size = UDim2.new(1, -30, 0, 15)
    sub.Position = UDim2.new(0, 15, 0.5, 4)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.Text = def.sub
    sub.TextColor3 = Color3.fromRGB(200, 200, 200)
    sub.TextSize = 12
    sub.TextXAlignment = Enum.TextXAlignment.Left

    btnFrame.MouseButton1Click:Connect(function()
        if SelectedUserId == nil then
            local errorSound = Instance.new("Sound")
            errorSound.SoundId = "rbxassetid://126210834885859"
            errorSound.Volume = 1
            errorSound.Parent = G2L.Main
            errorSound:Play()
            Debris:AddItem(errorSound, 2)

            TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = colorError}):Play()
            
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -44, 0, 56), Position = UDim2.new(0, 22, 0, def.posY + 2)}):Play()
            task.wait(0.15)
            TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -40, 0, 60), Position = UDim2.new(0, 20, 0, def.posY)}):Play()
            
            local currentColor = isEnabled and colorEnabled or colorDisabled
            TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = currentColor}):Play()
            
            return 
        end
        
        isEnabled = not isEnabled 
        
        local toggleSound = Instance.new("Sound")
        if isEnabled then
            toggleSound.SoundId = "rbxassetid://75311202481026"
        else
            toggleSound.SoundId = "rbxassetid://17208361335"
        end
        toggleSound.Volume = 1
        toggleSound.Parent = G2L.Main
        toggleSound:Play()
        Debris:AddItem(toggleSound, 2)

        local targetColor = isEnabled and colorEnabled or colorDisabled

        TweenService:Create(btnFrame, TweenInfo.new(0.25), {BackgroundColor3 = targetColor}):Play()

        TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -44, 0, 56), Position = UDim2.new(0, 22, 0, def.posY + 2)}):Play()
        task.wait(0.1)
        TweenService:Create(btnFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -40, 0, 60), Position = UDim2.new(0, 20, 0, def.posY)}):Play()
    end)
end

-- [[ DRAGGABLE WINDOW LOGIC ]]
local dragging, dragInput, dragStart, startPos
G2L.Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = G2L.Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
G2L.Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        local scale = G2L.UIScale.Scale
        G2L.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (delta.X / scale), startPos.Y.Scale, startPos.Y.Offset + (delta.Y / scale))
    end
end)

-- [[ OPEN ANIMATION ]]
G2L.Main.Size = UDim2.new(0, 360, 0, 0)
G2L.Main.BackgroundTransparency = 1
TweenService:Create(G2L.Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 360, 0, 430),
    BackgroundTransparency = 0
}):Play()

return G2L.Root
