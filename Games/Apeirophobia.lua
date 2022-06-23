-- One of my first actually selfmade scripts, this is buggy and still a WIP but still decent
-- game = https://www.roblox.com/games/9508087919/Apeirophobia-The-End-UPDATE

if not game:IsLoaded() then game.Loaded:Wait() end

getgenv()["Apeirophobia"] = {
    Enabled   = false,
    Players   = false,
    Exits     = false,
    Mobs      = false,
    Interacts = false,
    Cores     = false,
    DisableCS = false,
}

local Settings     = getgenv()["Apeirophobia"]

local Players           = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService('RunService')
local CoreGui           = game:GetService("CoreGui")

local GSettings    = ReplicatedStorage.GameSettings
local currentLevel = GSettings.currentLevel

local LP           = Players.LocalPlayer
local Hum          = LP.Character:FindFirstChild("HumanoidRootPart")

local Buildings    = Workspace:FindFirstChild("Buildings")
local Characters   = Workspace:FindFirstChild("Characters")
local Beings       = Workspace:FindFirstChild("Entities")
local Ignored      = Workspace:FindFirstChild("Ignored")
local Interacts    = Ignored:FindFirstChild("Interacts")
local Trophies     = Ignored:FindFirstChild("Trophies")
local cam          = Workspace.CurrentCamera

local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

local MainWindow   = OrionLib:MakeWindow({Name = "Apeirophobia GUI", HidePremium = true, SaveConfig = true, ConfigFolder = "./Scrumpy/Aperiophobia"})

local Disclaimer   = MainWindow:MakeTab({Name = ' Disclaimer', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Functions    = MainWindow:MakeTab({Name = ' ESP ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Misc         = MainWindow:MakeTab({Name = ' Miscellanous ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Config       = MainWindow:MakeTab({Name = ' Settings ', Icon = "rbxassetid://4483345998", premiumOnly = false})


local function create(Int: string, Nickname: string?, Parent: Instance?) -- can be <type> or nil
    local obj = Instance.new(Int)
    if Parent then
        obj.Parent = Parent
    end
    if Nickname then
        obj.Name = Nickname
    end
    return obj
end

-- ESP bit | Skidded from zntly on github, modified by me

local Holder = CoreGui:FindFirstChild("ESPHolder") or create('Folder', 'ESPHolder', CoreGui);

if ProtectInstance then ProtectInstance(Holder) 
    Holder.ChildAdded:Connect(function(child)
        ProtectInstance(child)
    end)
end;

local ESP = {
    ["Players"]    = Holder:FindFirstChild("Players")   or create('Folder', 'Players',      Holder),
    ["Exits"]      = Holder:FindFirstChild("Exits")     or create('Folder', 'Exits',        Holder),
    ["Mobs"]       = Holder:FindFirstChild("Mobs")      or create('Folder', 'Mobs',         Holder),
    ["Interacts"]  = Holder:FindFirstChild("Interacts") or create('Folder', 'Interacts',    Holder),
    ["Trophies"]   = Holder:FindFirstChild("Trophies")  or create('Folder', 'Trophies',     Holder)
}

local function MHL(Depth, FillT, FillC, OutLT, OutLC)
    local Inst = create('Highlight', nil, nil)
    Inst.DepthMode = Depth
    Inst.FillColor = FillC
    Inst.FillTransparency  = FillT
    Inst.OutlineColor = OutLC
    Inst.OutlineTransparency = OutLT

    return Inst
end

function ESP:sortHLs(Ins: Instance, Depth, FillT, FillC, OutLT, OutLC, type: string)
    
    local place = ESP[type]
    
    local Name  = Ins.Name
    local ID    = Ins:GetDebugId()
    local HL    = MHL(Depth, FillT, FillC, OutLT, OutLC)
    HL.Adornee = Ins
    HL.Parent = place
    warn(ID)

    if place and Settings.Enabled then
        for i, v in next, place:GetChildren() do
            warn(i, v.Name)
            if Ins.Parent ~= Characters and (not place:FindFirstChild(ID) or not place:FindFirstChild(Name)) then
                warn('cunt')
                HL.Name     = ID
            else
                warn('player')
                HL.Name = Ins.Name
            end
        end
    else 
        HL:Destroy()
    end
end

function ESP:removeHLs(type: string, Ins: Instance)
    local name;
    if Ins then name = Ins.Name end

    if type and Ins then
        for i, v in pairs(ESP[type]:GetChildren()) do
            if v.Name == name then
                v:Destroy()
                task.wait()
            end
        end
    elseif type and not Ins then
        for i, v in pairs(ESP[type]:GetChildren()) do
            v:Destroy()
            task.wait()
        end
    elseif type == nil and not Ins then
        for i, v in next, Holder:GetDescendants() do
            if v:IsA('Highlight') then 
                v:Destroy()
                task.wait() 
            end 
        end
    end
end

local function UpdateHLs()
    task.wait(0.25)
    if Settings.Enabled then
        for i, v in pairs(Holder:GetDescendants()) do
            if v:IsA("Highlight") then
                if v.Adornee == nil or v.Adornee == "nil" then v:Destroy() end 
            end
        end
    end
end

RunService:BindToRenderStep("Refresh", 2, UpdateHLs)

Disclaimer:AddParagraph("Bad news","This game has an advance chunk loading and it will unload anything not near you so must get near them to work. This interferes with stuff such as interacts, cores, exits, and mobs (ESP, TPs, and Disables). For example for the 'TP to exit' function \nYou actually must be near where the exit part is so it can load to use it, so its a major hinderance. But, I may try to find a way to get around this, but it will most likely be laggy, no guarantee. \nFor now if you want to cheese the game, it has no AC yet so you can just noclip and fly around with IY .")

Functions:AddToggle({
	Name = "Global ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Enabled = bool
        spawn(function()
            if not Settings.Enabled then
                ESP:removeHLs(nil)
            end
        end)
    end
})

Functions:AddToggle({
	Name = "Exits ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Exits = bool
        spawn(function()
            while Settings.Enabled and Settings.Exits do
                task.wait()
                for i, v in pairs(Buildings:GetDescendants()) do
                    if (v:FindFirstAncestor("Exits") or v:FindFirstAncestor("Exit") or v:FindFirstAncestor("Level2Entrance") or v:FindFirstAncestor("Level4Entrance")) and v:IsA("Part") and v:FindFirstChildOfClass("TouchTransmitter") then
                        task.wait()
                        ESP:sortHLs(v, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(255, 255, 255), 1, Color3.fromRGB(0, 0, 0), "Exits")
                    end
                end
            end
        end)
    end
})



Functions:AddToggle({
	Name = "Players ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Players = bool
        spawn(function()

            Players.PlayerAdded:Connect(function(plr)
                local chr = plr.Character or plr.CharacterAdded:Wait()
                plr.CharacterAdded:Connect(function()
                    task.wait(1)
                    if Settings.Enabled and Settings.Players then
                        ESP:sortHLs(chr, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(116, 255, 129), 0.5, Color3.fromRGB(255, 255, 255), "Players")
                    end
                end)
            end)
        
            Players.PlayerRemoving:Connect(function(plr)
                if ESP.Players and ESP.Players:FindFirstChild(plr.Name) then
                    local HL = ESP.Players:FindFirstChild(plr.Name)
                    HL:Destroy()
                end
            end)

            while Settings.Enabled and Settings.Players do
                task.wait()
                for i, v in pairs(Players:GetPlayers()) do
                    if (v.Character or v.CharacterAdded:Wait()) then
                        ESP:sortHLs(v.Character, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(116, 255, 129), 0.5, Color3.fromRGB(255, 255, 255), "Players")
                    end
                end
            end
        end)
    end
})

Functions:AddToggle({
	Name = "Mobs ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Mobs = bool
        spawn(function()
            while Settings.Enabled and Settings.Mobs do
                task.wait()
                for i, v in pairs(Beings:GetChildren()) do
                    if v:IsA("Model") and (v.Name == "Starfish") then
                        ESP:sortHLs(v, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(255, 0, 0), 0, Color3.fromRGB(255, 255, 255), "Mobs")
                    end
                end
            end
        end)
    end
})

Functions:AddToggle({
	Name = "Interacts ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Interacts = bool
        spawn(function()
            while Settings.Enabled and Settings.Interacts do
                task.wait()
                for i, v in pairs(Interacts:GetDescendants()) do
                    if (v.Name == "button" or v.Name == "key" or v.Name == "valve") and Settings.Interacts then
                        ESP:sortHLs(v, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(0, 191, 255), 0.5, Color3.fromRGB(255, 255, 255), "Interacts")
                    end
                end
            end
        end)
    end
})

Functions:AddToggle({
	Name = "Trophies/Cores ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Cores = bool
        spawn(function()
            while Settings.Enabled and Settings.Cores do
                task.wait()
                for i, v in pairs(Trophies:GetChildren()) do
                    if (v:FindFirstChild("core") and v:FindFirstChild("core"):FindFirstChildOfClass("TouchTransmitter")) then
                        ESP:sortHLs(v, Enum.HighlightDepthMode.AlwaysOnTop, 0, Color3.fromRGB(255, 238, 0), 0.5, Color3.fromRGB(0, 0, 0), "Trophies")
                    end
                end
            end
        end)
    end
})

Misc:AddParagraph("Note", "for the 'TP to exit' function is only mapped till lvl 4(5), too complicated to make automatic, and im to lazy to map the rest rn. \n Also Get Trophies is not needed for level 6 and above. ")


Misc:AddButton({
    Name = "Get all Trophies",
    Callback = function()
        spawn(function()
            local oldPos = Hum.CFrame -- save old player position
            print(tostring(oldPos))
            for i, v in pairs(Trophies:GetChildren()) do
                if (v:FindFirstChild("core") and v:FindFirstChild("core"):FindFirstChildOfClass("TouchTransmitter")) then
                    task.wait()
                    Hum.CFrame = v.core.CFrame
                end
            end
            Hum.CFrame = oldPos
        end)
    end
})

Misc:AddButton({
    Name = "TP to Exit",
    Callback = function()
        local lvl = currentLevel.Value
        local floor = Buildings[lvl]
        if lvl == 0 then
            local Exit = floor:FindFirstChild("Exits") or floor:FindFirstChild("Exit")
            if Exit:FindFirstChild("Part"):FindFirstChildOfClass("TouchTransmitter") then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 1 then
            local Exit = Buildings.Rendered.Level2Entrance
            for _, v in pairs(Exit:GetChildren()) do
                if v:IsA("Part") and v:FindFirstChild("TouchInterest") then Hum.CFrame = v.CFrame end
            end
        elseif lvl == 2 then
            local Exit = floor:FindFirstChild("Exits") or floor:FindFirstChild("Exit")
            if Exit:FindFirstChild("Part"):FindFirstChildOfClass("TouchTransmitter") then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 3 then 
            Hum.CFrame = CFrame.new(605, 9, -108, 0, 0, 1, 0, 1, 0, 1, 0, 0)
        elseif lvl == 4 then
            local Exit = floor:FindFirstChild("Exits") or floor:FindFirstChild("Exit")
            if Exit:FindFirstChild("Part"):FindFirstChildOfClass("TouchTransmitter") then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 5 then
            local Exit = floor:FindFirstChild("Exits") or floor:FindFirstChild("Exit")
            if Exit:FindFirstChild("Part"):FindFirstChildOfClass("TouchTransmitter") then Hum.CFrame = Exit.Part.CFrame end
        end
    end
})

Misc:AddToggle({
    Name = "Remove camera tool filter",
    Default = false,
    Callback = function(bool: boolean)
        cam.ChildAdded:Connect(function(child)
            if not child:IsA('Model') or not child:IsA("Part") then 
                child:Destroy() 
            end
        end)
    end,
    Flag = "CF",
    Save = true
})

Misc:AddToggle({
    Name = "Disable Screen Filter",
    Default = false,
    Callback = function(bool: boolean)
        Settings.DisableCS = bool
        spawn(function()
            while true do
                task.wait(0.1)
                for i, v in pairs(Beings:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("gVars") and Settings.DisableCS == true then
                        v.gVars.isHostile.Value = false
                    elseif v:IsA("Model") and v:FindFirstChild("gVars") then
                        v.gVars.isHostile.Value = true
                    end
                end
            end
        end)
    end,
    Flag = "CS",
    Save = true
})

Misc:AddBind({
    Name = "Fullbright",
    Default = "Enum.KeyCode.F",
    Hold = false,
    Callback = function() loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Utilites/Fullbright.lua'), true))() end
    Flag = "FB",
    Save = true
})

Misc:AddBind({
    Name = "No Fog",
    Default = "Enum.KeyCode.C",
    Callback = function ()
        game:GetService("Lighting").FogEnd = 786543
        for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
            if v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end
    Flag = "NF",
    Save = true
})

Config:AddBind({
    Name = "GUI Keybind",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function() Orion.Enabled = not Orion.Enabled end,
    Flag = "GUI_Keybind",
    Save = true,
})



OrionLib:MakeNotification({
	Name = "GUI loaded",
	Content = "Made by Scrumptious, this is skidded",
	Image = "rbxassetid://4483345998",
	Time = 3
})

OrionLib:Init()