if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - Auto-roll
-- Find detections to make excution more uhhh... smart

local whitelist = {
    7127407851,  -- Main/Lobby
    7229033818,  -- Hub
    10421123948, -- Pro Hub
    9668084201,  -- Trading Hub
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

local Players               = game:GetService("Players")
local Workspace             = game:GetService("Workspace")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local Char
local Humanoid, HRP

local GPIDs             = LP:WaitForChild("Gamepasses")
local Events            = Assets:WaitForChild("Remotes")

local POST              = Events:FindFirstChildOfClass("RemoteEvent") -- Join, Refill, Leave, etc.
local GET               = Events:FindFirstChildOfClass("RemoteFunction") -- Attack, etc.

-- Stats
getgenv().AOTE = AOTE or {
    Consecutive = false,
    AlwaysNape = false,
    TitanESP = false,
    PlayerESP = false,
    DeathTouch = false,
    KillAura =  false,
    JoinVIP = {
        Enabled = true,
        Code = "129PMiv" -- input vip code
    }
}

if AutoFarm then return end

local Settings = AOTE

local Weapons_Base_Damage = {
    [0] = 90;
    [1] = 150;
    [2] = 250;
    [3] = 475;
    [4] = 750;
    [5] = 1450;
    [6] = 2500;
    [7] = 4000;
    [8] = 6500
}

PlayerProxies = PlayerProxies or {};
MobProxies = MobProxies or {};

-- ESP lib
if not DendroESP then
    DendroESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/LordNahida/DendroESP/main/Source.lua"))();
end

-- Functions
local function AddChar(Char)
    Char:WaitForChild("HumanoidRootPart", 15);
    local Proxy = DendroESP:AddCharacter(Char, "Highlight");
    Proxy.TextEnabled = true;
    Proxy.Text = Char.Name .. "#" .. tostring(math.random(1000, 9999));

    table.insert(PlayerProxies, Proxy);
end;

local function AddTitan(Char)
    Char:WaitForChild("HumanoidRootPart", 30);
    local Proxy = DendroESP:AddCharacter(Char, "Highlight");
    Proxy.HealthEnabled = true;
    Proxy.CrosshairEnabled = false;
    Proxy.CrosshairOffset  = CFrame.new(0, 0, 0);

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

Host, HostM = Host ~= nil and Host or nil, HostM ~= nil and HostM or nil

if not HostM then
    for _, v in pairs(getloadedmodules()) do -- find client Host
        if (v.Name == 'Host' or v.Name == 'HostNugget') and not v.Parent then
            v.Name = 'HostNugget'

            Host, HostM = v, require(v) 
            warn 'Found You'
            break
        end
    end
    assert(Host and HostM, 'Weird... there is no host module.')
end

if HostM then
    local oldCheck -- checks successes and errors, logs
    local oldGPs -- verifies gamepasses
    local oldSecurity -- spoof remotes | that is so stupid
    local oldOPS -- verifies perks
    local oldFamily -- verifies family
    local oldGM -- Gear Multiplier
    local oldKick -- Kick plr | Client-Sided (speed, fling, spin, and fly checks)
    local oldGU -- Gear Upgrades | What gear lvl (Ex: speed lvl 4, durability lvl 5)
    local oldPhysics -- calculates physics, and movement anticheat 
    local oldCustomization -- customizes the player and its interface
    local oldSkills -- manages whether you own a skill or not
    local oldSFamilies -- if you own and have stackable families, add additional mulitpliers

    oldCheck = hookfunction(HostM.Check, function(self, Success, Error)
        return task.wait(9e9) -- This is client-sided and one-sidedly reports errors or "unusually occurances" to the server.
    end)

    oldGPs = hookfunction(HostM.Owns_Gamepass, function(self, Player, ID, Type, Prompt)
        return true
    end)

    oldSecurity = hookfunction(HostM.Security, function(self, ...)
        POST.Name = "POST" GET.Name = "GET"
    end)

    if game.PlaceId == whitelist[1] and Settings.JoinVIP.Enabled then task.wait(2) GET:InvokeServer("VIP", "Join", Settings.JoinVIP.Code) end
    
    for n = 2, 9 do -- excluding Main
        if game.PlaceId == whitelist[n] then

            Char = LP.Character or LP.CharacterAdded:Wait()
            Humanoid, HRP = Char:WaitForChild('Humanoid'), Char:WaitForChild('HumanoidRootPart')
            LP.CharacterAdded:Connect(function()
                DendroESP.BulletSource = LP.Character:WaitForChild("HumanoidRootPart")
                DendroESP.RaycastParams.FilterDescendantsInstances = {LP.Character}
            end);
            
            DendroESP.BulletSource = LP.Character:WaitForChild("HumanoidRootPart")
            DendroESP.RaycastParams.FilterDescendantsInstances = {LP.Character}
            
            for _, __ in pairs(Players:GetPlayers()) do
                if (not __.Character or __ == LP) then continue end
                AddPlayer(__)
            end;
            
            Players.PlayerAdded:Connect(function(Player)
                AddPlayer(Player)
            end);

            oldOPS = hookfunction(HostM.Owns_Perk, function(Player, Perk)
                return true
            end)

            oldFamily = hookfunction(HostM.Owns_Family, function(Family)
                return true
            end)
        end
    end

    for c = 5, 10 do -- missions only
        if game.PlaceId == whitelist[c] then
            oldGM = hookfunction(HostM.Gear_Multiplier, function(Stat)
                local Multiplier = 1.2
                if Stat == "Damage" then
                    Multiplier += 0.2 -- Family bonus
                    Multiplier += 0.5 -- bloodlust
                    Multiplier += (0.05 * 6) -- stacked perks
                    Multiplier += 0.15 -- Proficiency bonus
                    Multiplier += .15 -- Capsule bonus
                    Multiplier += .1 -- Solo bonus
                elseif Stat == "Speed" then
                    Multiplier += .25 -- Capsule bonus
                    Multiplier += .1 -- Solo bonus
                end
                return Multiplier;
            end)

            oldKick = hookfunction(HostM.Kick, function(self, Player, POST, Message)
                warn("AC: Client tried to kick, Reason:", Message)
                return
            end)

            oldSkills = hookfunction(HostM.Owns_Skill, function(self, Player, Family)
                return true
            end)

            oldSFamilies = hookfunction(HostM.Owns_Stackable_Family, function(self, Player, Family)
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
            end)

            oldGU = hookfunction(HostM.Get_Upgrades, function(self, Upgrade_Name)
                return 8
            end)
        end
    end
end

for i = 5, 10 do
    if game.PlaceId == whitelist[i] then -- any PvE/Mission areas -- add raids later
        local Titans = Workspace:WaitForChild("Titans")
        local ID     = Workspace:GetAttribute('Key')
        local BV     -- thing that make body go zoom

        -- LP:SetAttribute('Maximum_Refills', 9999)

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

        local Rayfield = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
        
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

        local Functions = Window:CreateTab("Functions", 4483362458)
        local Keybinds  = Window:CreateTab("Keybinds", 4483362458)

        repeat task.wait() until HRP BV = HRP:WaitForChild("BV", 10) local Velocity = BV.Velocity
        task.spawn(function () -- retarded
            if HRP:FindFirstChildOfClass("TouchTransmitter") then
                task.wait()
                HRP.TouchInterest:Destroy()
            end
        end)

        local AN = Functions:CreateToggle({
            Name = "Always Nape",
            CurrentValue = false,
            Flag = 'AN',
            Callback = function(bool) 
                Settings.AlwaysNape = bool
            end
        })

        local KA = Functions:CreateToggle({Name = "Kill Aura", Default = false, Flag = 'KAT', Callback = function(bool)
            Settings.KillAura = bool
            task.spawn(function() 
                while Settings.KillAura do
                    task.wait()
                    for _, t in pairs(Titans:GetChildren()) do task.wait()
                        local titanHumanoid = t:FindFirstChild("Humanoid")
                        if (titanHumanoid and titanHumanoid.Health > 0) and (HRP.Position - t:GetPivot().Position).magnitude < 150 then
                            local Template = {[1] = "Slash", [2] = t, [3] = "Nape", [7] = ID, [8] = Weapons_Base_Damage[8] * 4.5}
                            GET:InvokeServer(unpack(Template))
                        end
                    end
                end
            end)
        end})

        Functions:CreateToggle({Name = "Player ESP", Default = false, Flag = 'PESP', Callback = function(bool)
            for _, proxy in next, PlayerProxies do
                proxy.Enabled = bool
            end
        end})

        Functions:CreateToggle({Name = "Titan ESP", Default = false, Flag = 'MESP', Callback = function(bool)
            for _, proxy in next, MobProxies do
                proxy.Enabled = bool
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
            Name = "Kill Aura Keybind",
            CurrentKeybind = "H",
            HoldToInteract = false,
            Flag = 'KAK',
            Callback = function() 
                KA:Set(not Settings.KillAura)
            end
        })

        -- Although I have disabled the kick function I just wanted to get past the numerous checks just in case.
        for _, v in pairs(getconnections(HRP.ChildAdded)) do
            if isconnectionenabled(v) then setconnectionenabled(v, false) end
        end

        if Humanoid then
            for _, c in pairs(getconnections(Humanoid.HealthChanged)) do
                if isconnectionenabled(c) and not iswaitingconnection(c) then
                    local currHealth = Humanoid.Health
                    if getconnectionfunction(c) then
                        hookfunction(getconnectionfunction(c), function()
                            local Revives = LP:GetAttribute("Revives")
                            local Dead    = Char:GetAttribute("Dead")
                            LP:SetAttribute('Revives', 9999)

                            
                            if (Humanoid.Health < currHealth) then
                                HostM:Spark({ [1] = "Titan"; [2] = Char })
                                local Index = math.random(1, 4)
                                HostM:Sound({ [1] = tostring("Hit_" .. Index); [2] = Char; [3] = true; [4] = "Once" })
                            end
                            
                            currHealth = Humanoid.Health
                            
                            if (Humanoid.Health <= 0) then
                                task.delay(.3, function()
                                    if (Dead == nil) then
                                        POST:FireServer(false, "Dead")
                                    end
                                end)
                            end
                            
                            if (Revives == nil or (Revives ~= nil and Revives == 0)) then
                                
                                if (Humanoid.Health <= 0) then
                                    for _, Event in pairs(Events) do
                                        Event:Disconnect()
                                    end
                                    Humanoid:SetStateEnabled(Dead, false)
                                    POST:FireServer(false, "Dead")
                                    --Reset(true)
                                    --HostM:Death(LP, POST, Interface)
                                end
                                
                            elseif (Revives ~= nil and Revives > 0) then
                                Humanoid:SetStateEnabled(Dead, false)
                            end
                        end)
                    end
                end
            end
        end

        if Char:FindFirstChild('Kicker') then
            local Kicker = Char.Kicker -- If Kicker or the event is destroyed, the server BANS you | Do not attempt to destroy unless you want to lose your data
            local Event = Kicker:WaitForChild("Event")
            local Client = LP.PlayerScripts:WaitForChild('Client')
            
            if not Settings.Consecutive then
                if Client:GetPropertyChangedSignal("Disabled") then
                    hooksignal(Client:GetPropertyChangedSignal("Disabled"), function() return false end)
                end
                if Client:GetPropertyChangedSignal("Parent") then
                    hooksignal(Client:GetPropertyChangedSignal("Parent"), function() return false end)
                end
                if Event.Event then
                    hooksignal(Event.Event, function() return false end)
                end
                if Kicker:GetPropertyChangedSignal("Disabled") then
                    hooksignal(Kicker:GetPropertyChangedSignal("Disabled"), function() return false end)
                end

                LP.CharacterAdded:Connect(function(character)
                    task.spawn(function()
                        character.ChildAdded:Connect(function(child)
                            if child.Name == 'Kicker' then
                                if child:GetPropertyChangedSignal("Disabled") then
                                    hooksignal(child:GetPropertyChangedSignal("Disabled"), function() return false end)
                                end
                                if child:FindFirstChild('Event') and child.Event.Event then hooksignal(child.Event.Event, function() return false end) end
                            end
                        end)
                    end)
                end)
            end
        end


        if not Settings.Consecutive then
            local OldIndex; OldIndex = hookmetamethod(game, "__index", newcclosure(function(Self, Key)
                if Self == Humanoid then
                    if Key == 'HipHeight' then
                        return OldIndex(Self, 2)
                    end
                end
                return OldIndex(Self, Key)
            end))
            
            local OldNameCall; OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...) -- Always Nape
                local args = {...}
                local method = getnamecallmethod()
                if not checkcaller() then
                    if method == "InvokeServer" then
                        if Settings.AlwaysNape and (args[1] == "Slash" and args[7] == ID) then
                            args[3] = "Nape"
                            args[8] *= 4.5
                            return OldNameCall(Self, unpack(args))
                        end
                    end
                    if method == "FireServer" then
                        if args[2] == "Log" then
                            return
                        end
                    end
                end
                return OldNameCall(Self, ...)
            end))
            Settings.Consecutive = true
        end
        Rayfield:LoadConfiguration()
    end
end