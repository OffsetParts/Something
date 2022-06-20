-- One of my first actually selfmade scripts, this is buggy and still a WIP but still decent
-- game = https://www.roblox.com/games/9508087919/Apeirophobia-The-End-UPDATE

if not game:IsLoaded() then game.Loaded:Wait() end

getgenv()["Apeirophobia"] = {
    Enabled   = false,
    Players   = false,
    Exits     = false,
    Mobs      = false,
    Interacts = false,
    Cores     = false
}

local Settings     = getgenv()["Apeirophobia"]

local RS           = game:GetService('ReplicatedStorage')
local RunService   = game:GetService('RunService')
local GSettings    = RS.GameSettings
local currentLevel = GSettings.currentLevel

local Players      = game:GetService('Players')
local LP           = Players.LocalPlayer
local Hum          = LP.Character:FindFirstChild("HumanoidRootPart")

local CoreGui      = game:GetService("CoreGui")
local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

local MainWindow   = OrionLib:MakeWindow({Name = "Apeirophobia GUI", HidePremium = true, SaveConfig = true, ConfigFolder = "./Scrumpy/Aperiophobia"})

local Disclaimer   = MainWindow:MakeTab({Name = ' Disclaimer', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Functions    = MainWindow:MakeTab({Name = ' ESP ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Misc         = MainWindow:MakeTab({Name = ' Miscellanous ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Config       = MainWindow:MakeTab({Name = ' Settings ', Icon = "rbxassetid://4483345998", premiumOnly = false})

local Workspace    = game:GetService("Workspace")
local Buildings    = Workspace:FindFirstChild("Buildings")
local Characters   = Workspace:FindFirstChild("Characters")
local Beings       = Workspace:FindFirstChild("Entities")
local Ignored      = Workspace:FindFirstChild("Ignored")

local Interacts    = Ignored:FindFirstChild("Interacts")
local Trophies     = Ignored:FindFirstChild("Trophies")

local function create(Int: string, Nickname: string, Parent: Instance)
    local obj = Instance.new(Int, Parent)
    obj.Name = Nickname
    return obj
end

-- ESP bit | Skidded from zntly on github, modified by me

local Holder = CoreGui:FindFirstChild("ESPHolder") or create('Folder', 'ESPHolder', CoreGui);

local ESP = {
    ["Players"]    = Holder:FindFirstChild("Players")   or create('Folder', 'Players',      Holder),
    ["Exits"]      = Holder:FindFirstChild("Exits")     or create('Folder', 'Exits',        Holder),
    ["Mobs"]       = Holder:FindFirstChild("Mobs")      or create('Folder', 'Mobs',         Holder),
    ["Interacts"]  = Holder:FindFirstChild("Interacts") or create('Folder', 'Interacts',    Holder),
    ["Trophies"]   = Holder:FindFirstChild("Trophies")  or create('Folder', 'Trophies',     Holder)
}

function ESP:createHL(Ins: Instance, Depth, Fill, type: string) -- return Instance(<model, part>) that has parts as children
    
    local place = ESP[type]
    
    local Name  = Ins.Name
    local ID    = Ins:GetDebugId()

    local HL = Instance.new("Highlight", place)
    HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    HL.FillColor = Fill
    HL.OutlineTransparency = 1

    if place and Ins then
        HL.Adornee = Ins
        if not Players:GetPlayerFromCharacter(Ins) then -- If not player model then
            if Ins:IsA("Model") then
                if (Name == "valve" or Name == "key" or Name == "button" or Name == "padlock") and not place:FindFirstChild(ID) then -- Interact
                    HL.Name = ID
                elseif (Name == "Hounds" or Name == "Cloners" or Name == "Howler" or Name == "Starfish" or Name == "Cameraman" or Name == "Skinstealer") and not place:FindFirstChild(Name) then -- Mobs
                    HL.Name = Name
                elseif Ins.Parent == Trophies and Name == "Simulation Core" and not place:FindFirstChild(ID) then -- Trophies
                    HL.Name = ID
                end
            elseif Ins:IsA("Part") then
                if Name == "Part" and (Ins:FindFirstAncestor("Exits") or Ins:FindFirstAncestor("Exit") or Ins:FindFirstAncestor("Level2Entrance") or Ins:FindFirstAncestor("Level4Entrance")) and Ins:FindFirstChildOfClass("TouchTransmitter") and not place:FindFirstChild(ID) then -- Exits
                    HL.Name = ID
                else
                    HL:Destroy()
                end
            end
        elseif Players:GetPlayerFromCharacter(Ins) then
            if not ESP.Players:FindFirstChild(Name) and Ins ~= LP.Character then
                HL.Name = Name
                HL.Adornee = Ins
            else
                HL:Destroy()
            end
        else
            HL:Destroy()
        end
    else
        HL:Destroy()
    end
end


function ESP:removeHL(Ins: Instance, type: string)
    local name;
    if Ins.Parent ~= Characters then -- if for player get player name else get their debug name
        name = Ins:GetDebugId()
    elseif Ins.Parent == Characters then
        name = Ins.Name
    end

    if type then
        for i,v in pairs(ESP[type]:GetDescendants()) do -- find Obj of that name or Id and delete them
            if v.Name == name then
                v:Destroy()
            end
        end
    end
end

local function UpdateHLs()
    task.wait(0.1)
    if Settings.Enabled then
    for i, v in pairs(Holder:GetDescendants()) do
        if v:IsA("Highlight") then
            if v.Adornee == nil then v:Destroy() end 
        end
    end
    end
end

RunService:BindToRenderStep("Refresh", 3, UpdateHLs)

Disclaimer:AddParagraph("Bad news","This game has an advance chunk loading and it will unload anything not near so you gotta to get close for now on. This includes stuff for interacts, cores, and exits. So for stuff such as 'TP to exits' \nYou actually gotta be near where the exit part is to use it, so as you can its a major hinderance. But, I may try to find a way to get around this, but it will of be laggy, no guarantee. \nFor now if you want to cheese it, this game has no AC yet so you can just noclip and fly near. Make sure to ")

Functions:AddToggle({
	Name = "Global ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Enabled = bool
        spawn(function()
            ESP.Players.Parent = Holder;
            if Holder.Name == "ESPHolder" then
                for i, v in next, Holder:GetChildren() do
                    if Settings.Enabled == false then
                        task.wait(0.1) -- slight freeze
                        v:ClearAllChildren() -- clear all
                    end
                end
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
                        ESP:createHL(v, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(255, 255, 255), "Exits")
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
                    if Settings.Players then
                        ESP:createHL(chr, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(86, 255, 74), "Players")
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
                    if (v.Character or Characters:FindFirstChild(v.Name) or v.CharacterAdded:Wait()) then
                        ESP:createHL(v.Character, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(86, 255, 74), "Players")
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
                    if v:IsA("Model") or v:IsA("Part") and Settings.Mobs then
                        ESP:createHL(v, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(255, 0, 0), "Mobs")
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
                        ESP:createHL(v, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(0, 191, 255), "Interacts")
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
                    if (v.Name == "Simulation Core" and v:FindFirstChild("core")) then
                        ESP:createHL(v, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(255, 240, 35), "Cores")
                    end
                end
            end
        end)
    end
})

Misc:AddParagraph("Note", "'TP to exit' only mapped till lvl 4, too complicated to make automatic, and im to lazy to map the rest rn")


Misc:AddButton({
    Name = "Get all Trophies",
    Callback = function()
        local oldPos = Hum.CFrame -- save old player position
        print(tostring(oldPos))
        for i, v in next, Trophies:GetChildren() do
            if v.Name == "Simulation Core" and v:IsA("Model") and v:FindFirstChild("core") and v:FindFirstChild("core"):FindFirstChildOfClass("TouchTransmitter") then
                task.wait()
                Hum.CFrame = v.core.CFrame
            end
        end
        Hum.CFrame = oldPos
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
    Name = "Disable Camera shake",
    Callback = function(bool: boolean)
        while bool == true do
            task.wait()
            for i, v in pairs(Beings:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                    local hostile = v:FindFirstChild("gVars").isHostile
                    hostile.Value = false
                end
            end
        end
    end
})

Misc:AddButton({
    Name = "Fullbright",
    Callback = function() loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Utilites/Fullbright.lua'), true))() end
})

Misc:AddButton({
    Name = "No Fog",
    Callback = function ()
        game:GetService("Lighting").FogEnd = 786543
        for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
            if v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end
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