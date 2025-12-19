---------------------------------------------------
-- WAIT FOR GAME
---------------------------------------------------
repeat task.wait() until game:IsLoaded()

---------------------------------------------------
-- 🚨 ADOPT ME TRADING LICENSE KICKER
---------------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local hasLicense = false

local ok, result = pcall(function()
    local TradeHelper = require(
        ReplicatedStorage:WaitForChild("SharedModules")
            :WaitForChild("TradeLicenseHelper")
    )
    return TradeHelper.player_has_trade_license()
end)

if ok and result == true then
    hasLicense = true
end

if not hasLicense then
    LocalPlayer:Kick(
        "Alt account detected.Please use your MAIN account with an Adopt Me Trading License."
    )
    return
end

---------------------------------------------------
-- SERVICES
---------------------------------------------------
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

---------------------------------------------------
-- ANTI AFK
---------------------------------------------------
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

---------------------------------------------------
-- GLOBAL STATES
---------------------------------------------------
local AutoFarm = false
local AutoMiniGames = true -- always on
local TeleportSpeed = 0.35
local Collected = 0

---------------------------------------------------
-- CHARACTER
---------------------------------------------------
local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

---------------------------------------------------
-- FIND GINGERBREAD
---------------------------------------------------
local function findGingerbread()
    local t = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local n = v.Name:lower()
            if n:find("ginger") or n:find("cookie") then
                table.insert(t, v)
            end
        end
    end
    return t
end

---------------------------------------------------
-- FIND WINTER EVENT FOLDER
---------------------------------------------------
local WinterFolder
for _, v in ipairs(workspace:GetChildren()) do
    local n = v.Name:lower()
    if n:find("winter") or n:find("event") then
        WinterFolder = v
        break
    end
end

---------------------------------------------------
-- FIND REAL RED SUBMIT CIRCLE (WINTER ONLY)
---------------------------------------------------
local CachedRedCircle

local function findRedCircle()
    if CachedRedCircle and CachedRedCircle.Parent then
        return CachedRedCircle
    end
    if not WinterFolder then return nil end

    for _, v in ipairs(WinterFolder:GetDescendants()) do
        if v:IsA("BasePart")
        and v.Shape == Enum.PartType.Cylinder
        and v.Anchored
        and not v.CanCollide
        and v.Size.Y <= 1 then

            local c = v.Color
            if c.R > 0.8 and c.G < 0.2 and c.B < 0.2 then
                CachedRedCircle = v
                return v
            end
        end
    end
end

---------------------------------------------------
-- LOAD RAYFIELD (FAST)
---------------------------------------------------
local Rayfield = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"
))()

local Window = Rayfield:CreateWindow({
    Name = "EclipseX  | Adopt Me",
    LoadingTitle = "EclipseX",
    LoadingSubtitle = "Winter Gingerbread",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EclipseX",
        FileName = "AdoptMe"
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
MainTab:CreateSection("Status")

local StatusLabel = MainTab:CreateLabel("Collected: 0")

---------------------------------------------------
-- UI CONTROLS
---------------------------------------------------
MainTab:CreateToggle({
    Name = "Auto Farm Gingerbread",
    CurrentValue = false,
    Callback = function(v)
        AutoFarm = v
    end
})

MainTab:CreateSlider({
    Name = "Teleport Speed",
    Range = {0.15, 1},
    Increment = 0.05,
    CurrentValue = TeleportSpeed,
    Suffix = "sec",
    Callback = function(v)
        TeleportSpeed = v
    end
})

---------------------------------------------------
-- AUTO GINGERBREAD FARM
---------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if not AutoFarm then continue end

        local hrp = getHRP()
        local redCircle = findRedCircle()

        for _, g in ipairs(findGingerbread()) do
            if not AutoFarm then break end
            if g and g.Parent then
                pcall(function()
                    hrp.CFrame = g.CFrame + Vector3.new(0,3,0)

                    firetouchinterest(hrp, g, 0)
                    task.wait(0.03)
                    firetouchinterest(hrp, g, 1)

                    if redCircle then
                        task.wait(0.04)
                        hrp.CFrame = redCircle.CFrame + Vector3.new(0,2.5,0)
                        task.wait(0.04)
                    end

                    Collected += 1
                    StatusLabel:Set("Collected: "..Collected)
                end)

                task.wait(TeleportSpeed)
            end
        end
    end
end)

---------------------------------------------------
-- AUTO MINI GAMES (ALWAYS ON)
---------------------------------------------------
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                for _, btn in ipairs(gui:GetDescendants()) do
                    if btn:IsA("TextButton") and btn.Text then
                        local t = btn.Text:lower()
                        if t:find("claim")
                        or t:find("collect")
                        or t:find("ok")
                        or t:find("continue")
                        or t:find("done")
                        or t:find("start") then
                            firesignal(btn.MouseButton1Click)
                        end
                    end
                end
            end
        end)
    end
end)

---------------------------------------------------
-- READY
---------------------------------------------------
Rayfield:Notify({
    Title = "EclipseX Loaded",
    Content = "Winter Gingerbread Locked & Stable",
    Duration = 4
})
