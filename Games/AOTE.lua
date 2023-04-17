if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - Auto-roll
-- Find detections to make excution more uhhh... smart

local whitelist = {
    7127407851,  -- Main/Lobby
    7229033818,  -- Hub
    10421123948, -- Hub - Pro
    9668084201,  -- Hub - Trading
    7942446389,  -- Forest - PvE
    8061174649,  -- Shiganshina - PvE
    8061174873,  -- OutSkirts - PvE
    8365571520,  -- Training Grounds - PvE
    8892853383,  -- Utgard Castle - PvE
    8452934184,  -- Hub - PvP
}

local wl
for _, c in next, whitelist do
    if c == game.PlaceId then wl = true end
end

if not wl then return end

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

local POST                = Events:FindFirstChildOfClass("RemoteEvent") -- Join, Refill, Leave, etc.
local GET                = Events:FindFirstChildOfClass("RemoteFunction") -- Attack, etc.


PlayerProxies = PlayerProxies or {};
MobProxies = MobProxies or {};

-- ESP lib
local DendroESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/LordNahida/DendroESP/main/Source.lua"))();

-- Functions
local function AddChar(Char)
    Char:WaitForChild("HumanoidRootPart");
    local Proxy = DendroESP:AddCharacter(Char, "Highlight");
    Proxy.TextEnabled = true;
    Proxy.Text = Char.Name .. "#" .. tostring(math.random(1000, 9999));

    table.insert(PlayerProxies, Proxy);
end;

local function AddTitan(Char)
    Char:WaitForChild("HumanoidRootPart");
    local Proxy = DendroESP:AddCharacter(Char, "Highlight");
    Proxy.HealthEnabled = true;
    Proxy.CrosshairEnabled = true;
    Proxy.CrosshairOffset  = CFrame.new(0, 0, 0);
    Proxy.Enabled = false;

    table.insert(MobProxies, Proxy);
end

local function AddPlayer(Player)
    if (Player.Character) then
        AddChar(Player.Character);
    end;
    Player.CharacterAdded:Connect(function()
        AddChar(Player.Character);
    end);
end;

for x, w in next, GPIDs:GetChildren() do -- Enable some gamepasses
    w.Value = true
end

HostM = HostM or nil
local HostD

for i, v in pairs(getloadedmodules()) do -- find client Host module
    task.wait()
    if (v.Name == 'Host' or v.Name == 'HostNugget') and v.Parent == nil then
        v.Name = 'HostNugget' -- more Identifiable

        HostM = require(v) warn 'Found You'
        HostD = HostM.New()
        break
    end
end

if HostM then
    local oldCheck -- checks successes and errors
    local oldGPs -- verifies gamepasses
    local oldSecurity -- spoof remotes
    local oldOPS -- verifies perks
    local oldFamily -- verifies family
    local oldGM -- Gear Multiplier
    local oldKick -- Kick plr | Client-Sided (speed, fling, spin, and fly checks) | remote tampering is serversided
    local oldGU -- Gear Upgrades | What gear lvl (Ex: speed lvl 4, durability lvl 5)
    local oldPhysics -- calculates physics, and movement anticheat | Need latest won for speed checks
    local oldCustomization -- customizes the player and its interface
    local oldSkills -- manages where you own a skill or not
    local oldSFamilies -- if you own a stackable family, add additional mulitpliers

    oldCheck = hookfunction(HostM.Check, function(Success, Error)
        return
    end)

    oldGPs = hookfunction(HostM.Owns_Gamepass, function(Player, ID, Type, Prompt)
        return true
    end)

    oldSecurity = hookfunction(HostM.Security, function(POST)
        return
    end)
    
    for n = 2, 9 do -- excluding Main
        LP.CharacterAdded:Connect(function()
            DendroESP.BulletSource = LP.Character:WaitForChild("HumanoidRootPart");
            DendroESP.RaycastParams.FilterDescendantsInstances = {LP.Character;};
        end);
        
        DendroESP.BulletSource = LP.Character:WaitForChild("HumanoidRootPart");
        DendroESP.RaycastParams.FilterDescendantsInstances = {LP.Character;};
        
        for _, __ in pairs(Players:GetPlayers()) do
            if (not __.Character or __ == LP) then continue; end;
            AddPlayer(__);
        end;
        
        Players.PlayerAdded:Connect(function(Player)
            AddPlayer(Player);
        end);

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
            oldGM = hookfunction(HostM.Gear_Multiplier, function(Stat)
                local Multiplier = 1
                if Stat == "Damage" then
                    Multiplier + 0.2 -- Family bonus
                    Multiplier += 0.5 -- bloodlust
                    Multiplier = (Multiplier + (0.05 * 6)) -- stacked perks
                    Multiplier += 0.15 -- Proficiency bonus
                    Multiplier += .15 -- Capsule bonus
                    Multiplier += .1 -- Solo bonus
                elseif Stat == "Speed" then
                    Multiplier += .25 -- Capsule bonus
                    Multiplier += .1 -- Solo bonus
                end
                return Multiplier;
            end)

            oldKick = hookfunction(HostM.Kick, function(Player, POST, Message)
                warn'client tried to kick'
                return
            end)

            oldSkills = hookfunction(HostM.Owns_Skill, function(Player, Family)
                return true
            end)

            HostM.Owns_Stackable_Family = function(Player, Family)
                local Multiplier = 1
                for _, __Player in pairs(Players:GetPlayers()) do
					local Character = __Player.Character
					
					if (Character ~= nil) then
						local Lore = Character:FindFirstChild("Lore")
						
						if (Lore ~= nil) then
							local __Family = Lore:FindFirstChild("Family")
							
							if (__Family ~= nil and __Family.Value == Family) then
								if (Player == __Player) then
									Multiplier = (Multiplier + .1)
									
								elseif (Player ~= __Player) then
									Multiplier = (Multiplier + .1)
								end
								
								break
							end
						end
					end
				end
                return Multiplier
            end

            oldGU = hookfunction(HostM.Get_Upgrades, function(Upgrade_Name)
                return 8
            end)
        end
    end
end

local Settings = {
    AlwaysNape = false,
    TitanESP = false,
    PlayerESP = false,
    DeathTouch = false,
}

local Weapons_Base_Damage = {
    ["3DMG"] = {
        [0] = 90;
        [1] = 150;
        [2] = 250;
        [3] = 475;
        [4] = 750;
        [5] = 1450;
        [6] = 2500;
        [7] = 4000;
        [8] = 6500
    };
    
    ["APG"] = {
        [0] = 40;
        [1] = 90;
        [2] = 150;
        [3] = 275;
        [4] = 450;
        [5] = 700;
        [6] = 925;
        [7] = 1450;
        [8] = 2000
    };
    
    ["TP"] = {
        [0] = 400;
        [1] = 900;
        [2] = 1500;
        [3] = 2200;
        [4] = 3000;
        [5] = 3900;
        [6] = 4900;
        [7] = 6000;
        [8] = 7200
    }
}

for i = 5, 10 do
    if game.PlaceId == whitelist[i] then -- any PvE/Mission areas -- add waves and raids later
        local Titans = Workspace:WaitForChild("Titans")

        for _, Titan in pairs(Titans:GetChildren()) do
            if Titan:IsA 'Model' then
                AddTitan(Titan)
            end
        end

        Titans.ChildAdded:Connect(function(Titan)
            if Titan:IsA 'Model' then
                AddTitan(Titan)
            end
        end)

        local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
        local Flags = Rayfield.Flags
        local UI = CoreGui:FindFirstChild("Rayfield")
        
        local Window = Rayfield:CreateWindow({
            Name = "Attack On Titan: Evo",
            LoadingTitle = "I am Alive",
            LoadingSubtitle = "by scrumptious",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "Scrumpy",
                FileName = "AOTE"
            },
            Discord = {
                Enabled = false,
                Invite = '',
                RememberJoins = true,
            },
            KeySystem = false,
            KeySettings = {
                Title = "AOTE Script",
                Subtitle = 'give the key bitch',
                Note = 'LONG DICK STYLE',
                FileName = 'AuthKey',
                SaveKey = true,
                GrabKeyFromSite = false,
                Key = 'FuckTyrone'
            }
        })

        repeat task.wait() until Char:WaitForChild('HumanoidRootPart')
        task.spawn(function () -- anti-attack
            if HRP:FindFirstChildOfClass("TouchTransmitter") then
                task.wait()
                HRP.TouchInterest:Destroy()
            end
        end)

        local Functions = Window:CreateTab("Functions", 4483362458)

        local AN = Functions:CreateToggle({
            Name = "Always Nape",
            CurrentValue = false,
            Flag = 'AN',
            Callback = function(bool) 
                Settings.AlwaysNape = bool
            end
        })

        local DT = Functions:CreateToggle({
            Name = 'Death\'s Touch',
            CurrentValue = false,
            Flag = 'DT',
            Callback = function(bool)
                Settings.DeathTouch = bool
            end
        })

        Functions:CreateToggle({Name = "Player ESP", Default = false, Flag = 'PESP', Callback = function(bool)
            Settings.PlayerESP = bool
            if Settings.PlayerESP then
                for _, proxy in next, PlayerProxies do
                    proxy.Enabled = bool
                end
            end
        end})

        Functions:CreateToggle({Name = "Titan ESP", Default = false, Flag = 'MESP', Callback = function(bool)
            Settings.TitanESP = bool
            if Settings.TitanESP then
                for _, proxy in next, MobProxies do
                    proxy.Enabled = bool
                end
            end
        end})

        Functions:CreateButton({Name = 'Refresh ESP', Callback = function()
            for i, proxy in next, PlayerProxies do
                proxy:Destroy()
            end
            for i, proxy in next, MobProxies do
                proxy:Destroy()
            end
            for _, Titan in pairs(Titans:GetChildren()) do
                if Titan:IsA 'Model' then
                    AddTitan(Titan)
                end
            end
            for _, __ in pairs(Players:GetPlayers()) do
                if (not __.Character or __ == LP) then continue; end;
                AddPlayer(__);
            end;
        end})
        
        local Keybinds = Window:CreateTab("Keybinds", 4483362458)

        Keybinds:CreateKeybind({
            Name = "Always Nape Keybind",
            CurrentKeybind = "G",
            HoldToInteract = false,
            Flag = 'ANK',
            Callback = function() 
                AN:Set(not Settings.AlwaysNape)
            end
        })

        Keybinds:CreateKeybind({
            Name = 'Death\'s Touch Keybind',
            CurrentKeybind = "H",
            HoldToInteract = false,
            Flag = 'DTK',
            Callback = function()
                DT:Set(not Settings.DeathTouch)
            end
        })

        local ID
        Rayfield:LoadConfiguration()
        local OldNameCall; OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...) -- Always Nape
            local args = {...}
            local method = getnamecallmethod()
            if not checkcaller() then
                if Settings.AlwaysNape and method == "InvokeServer" and args[1] == "Slash" then
                    args[3] = "Nape"
                    args[8] *= 4.5
                    ID = args[7]
                    return OldNameCall(Self, unpack(args))
                end
            end
            return OldNameCall(Self, ...)
        end))

        repeat task.wait() until ID

        if GET and ID then
            for t, titan in pairs(Titans:GetChildren()) do
                local Hitboxes = titan:WaitForChild("Hitboxes")
                local plrHitboxes = Hitboxes:WaitForChild("Player")

                local Template = {
                    [1] = "Slash",
                    [2] = titan,
                    [3] = "Nape",
                    [7] = ID,
                    [8] = Weapons_Base_Damage["3DMG"][8] * 4.5
                }

                for n, hitbox in pairs(plrHitboxes:GetChildren()) do
                    hitbox.Touched:Connect(function()
                        if Settings.DeathTouch and hitbox then
                            local Crit, Damage = unpack(GET:InvokeServer(unpack(Template)))
                        end
                    end)
                end
            end

            Functions:CreateButton({Name = 'Kill All', Callback = function()
                for t, titan in pairs(Titans:GetChildren()) do
                    task.wait(1)
                    local Hitboxes = titan:WaitForChild("Hitboxes")
                    local plrHitboxes = Hitboxes:WaitForChild("Player")

                    local Template = {
                        [1] = "Slash",
                        [2] = titan,
                        [3] = "Nape",
                        [7] = ID,
                        [8] = Base_Damage_Values["3DMG"][8]
                    }

                    repeat
                        local Crit, Damage = unpack(GET:InvokeServer(unpack(Template)))
                    until titan.Humanoid.Health <= 0 or not titan
                end
            end})
        end
    end
end