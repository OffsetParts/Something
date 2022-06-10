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
local GSettings    = RS.GameSettings
local currentLevel = GSettings.currentLevel

local Players      = game:GetService('Players')
local LP           = Players.LocalPlayer
local Hum          = LP.Character:FindFirstChild("HumanoidRootPart")

local CoreGui      = game:GetService("CoreGui")
local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

local MainWindow   = OrionLib:MakeWindow({Name = "Apeirophobia GUI", HidePremium = true, SaveConfig = true, ConfigFolder = "./Scrumpy/Aperiophobia"})

local Functions    = MainWindow:MakeTab({Name = ' Functions ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Misc         = MainWindow:MakeTab({Name = ' Miscellanous ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Config       = MainWindow:MakeTab({Name = ' Settings ', Icon = "rbxassetid://4483345998", premiumOnly = false})

local Workspace    = game:GetService("Workspace")
local Buildings    = Workspace:WaitForChild("Buildings")
local Characters   = Workspace:WaitForChild("Characters")
local Beings       = Workspace:WaitForChild("Entities")
local Ignored      = Workspace:WaitForChild("Ignored")

local Interacts    = Ignored:FindFirstChild("Interacts")
local Trophies     = Ignored:FindFirstChild("Trophies")

-- ESP bit | Skidded from zntly on github, modified by me

local Holder = CoreGui:FindFirstChild("ESPHolder") or Instance.new('Folder', CoreGui);

Holder.Name = "ESPHolder";

local ESP = {
    ["Players"]    = Holder:FindFirstChild("Players")   or Instance.new('Folder', Holder),
    ["Exits"]      = Holder:FindFirstChild("Exits")     or Instance.new('Folder', Holder),
    ["Mobs"]       = Holder:FindFirstChild("Mobs")      or Instance.new('Folder', Holder),
    ["Interacts"]  = Holder:FindFirstChild("Interacts") or Instance.new('Folder', Holder),
    ["Trophies"]   = Holder:FindFirstChild("Cores")     or Instance.new('Folder', Holder)
}

ESP.Players.Name = "Players" ESP.Exits.Name = "Exits" ESP.Mobs.Name = "Mobs" ESP.Interacts.Name = "Interacts" ESP.Trophies.Name = "Cores"

function ESP:createHL(Ins, Depth, Fill, type: string) -- return Instance(<model, part>) that has parts as children
    
    local place = Holder[type]
    
    local Name  = Ins.Name
    local ID    = Ins:GetDebugId()

    local HL = Instance.new("Highlight", place)
    HL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    HL.FillColor = Fill
    HL.OutlineTransparency = 1

    if place then
        if Ins.Parent ~= Characters then -- If not player model then

            HL.Adornee = Ins

            if Ins:IsA("Model") and (Name == "valve" or Name == "key" or Name == "button") and not place:FindFirstChild(ID) then -- Interact
                HL.Name = ID
            elseif Ins:IsA("Model") and (Name == "Hounds" or Name == "Cloners" or Name == "Howler" or Name == "Starfish" or Name == "Cameraman") and not place:FindFirstChild(Name) then -- Mobs
                HL.Name = Name
                HL.Changed:Connect(function(prop)
                    if prop == "Adornee" then
                        task.wait()
                        HL.Adornee = Beings:FindFirstChild(Name)
                    end
                end)
            elseif Ins.Parent == Trophies and Name == "Simulation Core"  and not place:FindFirstChild(ID) then -- Trophies
                HL.Name = ID
            elseif (v.Parent.Name == "Exits" or v.Parent.Name == "Exit" or v.Parent.Name == "Level2Entrance" or v.Parent.Name == "Level4Entrance") and Name == "Part" and Ins:FindFirstChildOfClass("TouchTransmitter") and not place:FindFirstChild(ID) then -- Exits
                HL.Name = ID
            else
                HL:Destroy()
            end

        elseif typ == "Players" then
            if not ESP.Players:FindFirstChild(Name) and Ins ~= LP.Character then
                HL.Name = Name
                HL.Adornee = Ins
                HL.Changed:Connect(function(prop)
                    if prop == "Adornee" then
                        task.wait()
                        HL.Adornee = Characters:FindFirstChild(Name)
                    end
                end)
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

function ESP:removeHL(Ins, type: string)
    local name;
    if Ins.Parent ~= Characters then -- if for player get player name else get their debug name
        name = Ins:GetDebugId()
    elseif Ins.Parent == Characters then
        name = Ins.Name
    end

    if type then
        for i,v in pairs(Holder[type]:GetDescendants()) do -- find Obj of that name or Id and delete them
            if v.Name == name then
                v:Destroy()
            end
        end
    end
end


Functions:AddToggle({
	Name = "Global ESP",
    default = false,
	Callback = function(bool: boolean)
        Settings.Enabled = bool
        spawn(function()
            if Holder.Name == "ESPHolder" then
                for i, v in next, Holder:GetChildren() do
                    if Settings.Enabled == false then
                        wait(0.1) -- slight freeze
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
                    if v:IsA("Part") and v.Name == "Part" and (v.Parent.Name == "Exits" or v.Parent.Name == "Exit" or v.Parent.Name == "Level2Entrance" or v.Parent.Name == "Level4Entrance") and v:FindFirstChildOfClass("TouchTransmitter") then
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
                    task.wait()
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
                        ESP:createHL(v, Enum.HighlightDepthMode.AlwaysOnTop, Color3.fromRGB(136, 136, 136), "Cores")
                    end
                end
            end
        end)
    end
})

Misc:AddLabel("Only gets the ones currently loaded on the lvl")
Misc:AddLabel("Even though it all looks loaded by the ESP it not")

Misc:AddButton({
    Name = "Get all Trophies",
    Callback = function()
        local oldPos = Hum.CFrame -- save old player position
        print(tostring(oldPos))
        for i, v in next, Trophies:GetChildren() do
            if v.Name == "Simulation Core" and v:IsA("Model") and v:FindFirstChild("core") and v.core:FindFirstChildOfClass("TouchTransmitter") then
                task.wait()
                Hum.CFrame = v.core.CFrame
            end
        end
        Hum.CFrame = oldPos
    end
})

Misc:AddLabel("------------------------------------------------------------------------")
Misc:AddLabel("'TP to exit' only mapped till lvl 4, too complicated to make automatic, and im to lazy to map the rest rn")

Misc:AddButton({
    Name = "TP to Exit",
    Callback = function()
        local lvl = currentLevel.Value
        local floor = Buildings[lvl]

        if lvl == 0 then
            local Exit = floor["Exits"] or floor["Exit"]
            if Exit.Part  and Exit.Part.TouchInterest then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 1 then
            local Exit = Buildings.Rendered.Level2Entrance
            for _, v in pairs(Exit:GetChildren()) do
                if v:IsA("Part") and v:FindFirstChild("TouchInterest") then Hum.CFrame = v.CFrame end
            end
        elseif lvl == 2 then
            local Exit = floor["Exits"] or floor["Exit"]
            if Exit.Part and Exit.Part.TouchInterest then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 3 then 
            Hum.CFrame = CFrame.new(605, 9, -108, 0, 0, 1, 0, 1, 0, 1, 0, 0)
        elseif lvl == 4 then
            local Exit = floor["Exits"] or floor["Exit"]
            if Exit.Part and Exit.Part.TouchInterest then Hum.CFrame = Exit.Part.CFrame end
        elseif lvl == 5 then
            local Exit = floor["Exits"] or floor["Exit"]
            if Exit.Part and Exit.Part.TouchInterest then Hum.CFrame = Exit.Part.CFrame end
        end
    end
})

Misc:AddLabel("------------------------------------------------------------------------")

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