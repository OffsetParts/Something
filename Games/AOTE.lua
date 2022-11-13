if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - GUI in Main and Hub | Auto-roll, Bloodbag actually working, chance and userdata manipulation, etc.

local whitelist = {
    7127407851,  -- Main
    7229033818,  -- Hub
    10421123948, -- Hub - Pro
    9668084201,  -- Hub - Trading
    7942446389,  -- Forest - PvE
    8061174649,  -- Shiganshina - PvE
    8061174873,  -- OutSkirts - PvE
    8365571520,  -- Training Grounds - PvE
    8892853383,  -- Utgard Castle - PvE
    -- 8452934184,  -- Hub - PvP
}

local wl
for _, c in next, whitelist do
    if c == game.PlaceId then wl = true end
end

if not wl then return end

local _senv = getgenv() or _G

local CoreGui               = game:GetService("CoreGui")
local Players               = game:GetService("Players")
local Workspace             = game:GetService("Workspace")
local RunService            = game:GetService("RunService")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")
local PathfindingService    = game:GetService("PathfindingService")
local VirtualInputManager   = game:GetService('VirtualInputManager')
local TweenService          = game:GetService('TweenService')
local virtualUser           = game:GetService('VirtualUser')
local TeleportService       = game:GetService("TeleportService")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local GPIDs             = LP:WaitForChild("Gamepasses")
local Char              = LP.Character or LP.CharacterAdded:Wait()
local Modules           = Assets:WaitForChild("Modules")
local Events            = Assets:WaitForChild("Remotes")

local HRP               = Char:WaitForChild("HumanoidRootPart")

local RE                = Events:FindFirstChildOfClass("RemoteEvent") -- Join, Refill, Leave, etc.
local RF                = Events:FindFirstChildOfClass("RemoteFunction") -- Attack, etc.

local Stuff = {}
-- Functions
function Stuff:Add (Index, obj, override: boolean)
    if not self[Index] then
        if obj then
            self[Index] = obj;
        else
            return;
        end
        return self[Index];
    elseif self[Index] and override then
        if obj then
            self[Index] = obj;
        else
            return;
        end
    else
        return self[Index];
    end
end

-- ESP 
local function create(Int: string, Nickname: string?, Parent: Instance?) -- <type>? can be <type> or nil
    local obj = Instance.new(Int)
    if Parent then
        obj.Parent = Parent
    end
    if Nickname then
        obj.Name = Nickname
    end
    return obj
end

local function MHL(FillC, OutLC, obj)
    if not obj:FindFirstChildOfClass('Highlight') then
        local Inst = create('Highlight', obj.Name, obj)

        Inst.Adornee = obj
        Inst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Inst.FillColor = FillC
        Inst.FillTransparency  = 0.65
        Inst.OutlineColor = OutLC
        Inst.OutlineTransparency = 0

        Inst.Adornee.Changed:Connect(function()
            if (not Inst.Adornee or not Inst.Adornee.Parent) then
                Inst:Destroy()
            end
        end)
    end
end

for x, w in next, GPIDs:GetChildren() do
    w.Value = true
end

for i, v in pairs(getloadedmodules()) do
    if v.Name == 'Host' and v.Parent == nil then
        print'found Module'
        v.Name = 'NiggerHost' -- more Identifiable
        HostM = require(v)
        
        local oldGPs -- verifies gamepasses
        local oldSecurity -- to spoof remotes
        local oldOPS -- verifies perks
        local oldFamily -- verifies family
        local oldGM -- Gear Multiplier
        local oldKick -- Kick plr | Client-Sided (speed, fling, spin, and fly checks) | remote tampering is serversided
        local oldGU -- Gear Upgrades | What gear lvl (Ex: speed lvl 4, durability lvl 5)
        local oldPhysics -- calculates physics, and movement anticheat | Need latest won for speed checks
        local oldCustomization -- customizes the player and its interface


        oldGPs = hookfunction(HostM.Owns_Gamepass, function(Player, ID, Type, Prompt)
            return true
        end)

        oldSecurity = hookfunction(HostM.Security, function(POST)
            return
        end)
        
        for n = 2, 9 do -- excluding Main
            if game.PlaceId == whitelist[n] then
                oldOPS = hookfunction(HostM.Owns_Perk, function(Player, Perk)
	                return true;
                end)

                oldFamily = hookfunction(HostM.Owns_Family, function(Family)
                    return true
                end)
            end
        end

        for c = 5, 10 do -- missions only
            if game.PlaceId == whitelist[c] then
                oldGM = hookfunction(HostM.Gear_Multiplier, function(stat)
                    --[[ local newValue = 1;
                    local v2853, v2854 = pcall(function()
                        local Data = self.Data;
                        local Player = LP;
                        local Services = self.Services;
                        local Difficulty = self.Difficulty;
                        if stat ~= nil and Data ~= nil and Player ~= nil and Services ~= nil and Difficulty ~= nil and Difficulty ~= "Nightmare" then
                            local Avatar = Data.Avatar;
                            local Players = Services.P;
                            if Avatar ~= nil and Players ~= nil then
                                local Family = Avatar.Family;
                                if Family ~= nil then
                                    if Family == "Ackerman" then
                                        local v2862 = Player:GetAttribute("Bloodlust");
                                        if stat == "Damage" then
                                            newValue = 1.2;
                                        end;
                                        if v2862 ~= nil and v2862 == true then
                                            newValue = newValue + 0.5;
                                        end;
                                    elseif Family == "Braus" and stat == "Range" then
                                        newValue = 1.1;
                                    end;
                                    local Growth = true
                                    local Proficiency = true
                                    if Growth ~= nil and Proficiency ~= nil then
                                        if Growth == true then
                                            local Stack = 6;
                                            if Stack ~= nil and Stack > 0 then
                                                newValue = newValue + Stack * 0.05;
                                            end;
                                        end;
                                        if Proficiency == true then
                                            newValue = newValue + 1;
                                        end;
                                    end;
                                    if (stat == "Speed" or stat == "Damage") then
                                        if stat == "Speed" then
                                            newValue = newValue + 1;
                                        elseif stat == "Damage" then
                                            newValue = newValue + 1;
                                        end;
                                    end;
                                    local Solo = true;
                                    if Solo ~= nil and Solo == true then
                                        local SoloB = 0;
                                        for index, value in pairs(Players:GetPlayers()) do
                                            local Character = value.Character;
                                            if Character ~= nil then
                                                local Humanoid = Character:FindFirstChild("Humanoid");
                                                if Humanoid ~= nil and Humanoid.Health > 0 then
                                                    SoloB = SoloB + 1;
                                                end;
                                            end;
                                        end;
                                        if SoloB then
                                            newValue = newValue + 0.1;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end); ]]
                    return 1.5;
                end)

                oldKick = hookfunction(HostM.Kick, function(Player, POST, Message)
                    warn'client tried to kick'
                    return
                end)

                HostM.Get_Upgrades = function(Upgrade_Name)
                    local Upgrades = 0

                    local Success, Error = pcall(function()
                        local Player_Data = HostM.Data
                        
                        if (Player_Data ~= nil) then
                            local Current, Player_Upgrades = Player_Data.Current, Player_Data.Upgrades
                            
                            if (Current ~= nil and Player_Upgrades ~= nil) then
                                if (Upgrade_Name:find("3DMG") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "3DMG", Current)
                                    
                                elseif (Upgrade_Name:find("APG") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "APG", Current)
                                    
                                elseif (Upgrade_Name:find("TP") ~= nil) then
                                    Upgrade_Name = string.gsub(Upgrade_Name, "TP", Current)
                                end

                                print('Upgrade_Name is', Upgrade_Name)
                                
                                for _, Upgrade_Data in pairs(Player_Upgrades) do
                                    local Name, Current = Upgrade_Data.Name, Upgrade_Data.Current
                                    
                                    if (Name ~= nil and Name == Upgrade_Name and Current ~= nil) then
                                        Upgrades = Current
                                        
                                        break
                                    end
                                end
                            end
                        end
                    end)
                    
                    HostM:Check(Success, Error)
                    
                    print('Upgrades is', Upgrades)
                    return 9
                end
            end
        end
    end
end


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Flags = Rayfield.Flags
local UI = CoreGui:FindFirstChild("Rayfield")

local Window = Rayfield:CreateWindow({
    Name = "AOTE",
    LoadingTitle = "I am Alive",
    LoadingSubtitle = "by scrumptious",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Scrumpy",
        FileName = "AOTE"
    },
    Discord = {
        Enabled = false,
        Invite = 'nigger',
        RememberJoins = true,
    },
    KeySystem = false,
    KeySettings = {
        Title = "AOTE Script",
        Subtitle = 'give the key bitch',
        Note = 'SUCK MY DICK, LONG DICK STYLE',
        FileName = 'AuthKey',
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = 'FuckTyrone'
    }
})

local Function = Window:CreateTab("Functions", 4483362458)
local Keybinds = Window:CreateTab("Keybinds", 4483362458)
local Funny    = Window:CreateTab("The funny", 4483362458)

local Settings = {
    AlwaysNape = false,
    Damage = 6000,
    TitanESP = false
}

for i = 5, 10 do
    if game.PlaceId == whitelist[i] then -- any PvE/Mission areas
        local Titans = Workspace:WaitForChild("Titans")

        task.spawn(function () -- anti-attack
            while HRP:FindFirstChildOfClass("TouchTransmitter") do
                task.wait()
                HRP.TouchInterest:Destroy()
            end
        end)

        local AN = Function:CreateToggle({
            Name = "Always Nape",
            CurrentValue = false,
            Flag = 'AN',
            Callback = function(bool) 
                Settings.AlwaysNape = bool
            end
        })

        Keybinds:CreateKeybind({
            Name = "Always Nape Keybind",
            CurrentKeybind = "G",
            HoldToInteract = false,
            Flag = 'ANK',
            Callback = function() 
                AN:Set(not Settings.AlwaysNape)
            end
        })

        Function:CreateToggle({
            Name = "Titan ESP",
            Default = false,
            Callback = function(bool)
                Settings.TitanESP = bool
                if Settings.TitanESP then
                    while Settings.TitanESP do
                        task.wait()
                        for i2, v2 in pairs(Titans:GetChildren()) do
                            MHL(Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 119, 215), v2)
                        end
                    end
                end
            end
        })

        local OldNameCall; OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if not checkcaller() then
                if method == "InvokeServer" and args[1] == "Slash" and Settings.AlwaysNape then
                    args[3] = "Nape"
                    args[8] = Settings.Damage
                    return OldNameCall(Self, unpack(args))
                end
            end
            return OldNameCall(Self, ...)
        end))
    end

    Rayfield:LoadConfiguration()
end