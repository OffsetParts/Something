if not game:IsLoaded() then game.Loaded:Wait() end

-- TODO: Features - GUI in Main and Hub | Auto-roll, Bloodbag actually working, chance and userdata manipulation, etc.

local whitelist = {
    7127407851,  -- Main
    7229033818,  -- Hub/Lobby
    10421123948, -- Hub/Lobby - Pro
    9668084201,  -- Hub/Lobby - Trading
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

local _senv = getgenv() or _G

local CoreGui               = game:GetService("CoreGui")
local Players               = game:GetService("Players")
local Workspace             = game:GetService("Workspace")
local RunService            = game:GetService("RunService")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")
local PathfindingService    = game:GetService("PathfindingService")
local VirtualInputManager = game:GetService('VirtualInputManager')
local TweenService = game:GetService('TweenService')
local virtualUser = game:GetService('VirtualUser')
local TeleportService = game:GetService("TeleportService")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local GPIDs             = LP:WaitForChild("Gamepasses")
local Modules           = Assets:WaitForChild("Modules")
local Events            = Assets:WaitForChild("Remotes")

local RE                = Events:FindFirstChildOfClass("RemoteEvent") -- Join, Refill, Leave, etc.
local RF                = Events:FindFirstChildOfClass("RemoteFunction") -- Attack, etc.

_senv['AOTE'] = {
    currTitan = nil,
    Speed = nil,
    titan = nil,
    titanparrt = nil,
    refilling = nil,
    iflobby = false,
    time = 0,
}

_senv.Settings = { -- import this to GUI later
    Map = "PLAINS", -- map must be in all caps
    Difficulty = "Easy", -- proper case, Easy, Medium, Hard, Extreme, Abnormal
    Speed = 550, -- tween speed to use to get to nearest titan
    Speed2 = 400 -- tween speed to use if <50 studs within titan (prevents kicking at times)
 }
 

local config = _senv['AOTE']
local Settings = _senv['Settings']

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

--[[ if game.PlaceId == whitelist[1] then
    -- for main menu storing W.I.P.
end

for i = 2, 3, 1 do
    if game.PlaceId == whitelist[i] then
        -- for hub storing
    end
end ]]

local HostM = nil

for i, v in pairs(getloadedmodules()) do
    if v.Name == 'Host' and require(v).New() then
        HostM = require(v)
        local values = modu.New()

        for x, w in next, GPIDs:GetChildren() do
            w.Value = true
        end

        local oldCheck; oldCheck = hookfunction(HostM.Check, function(...)
            return 
        end)
        
        local oldGPs oldGPs = hookfunction(HostM.Owns_Gamepass, function(...) -- bloodline bag visual(don't store, will not work(detects now)) and skip roll for now.
            return true
        end)

        local oldSecurity oldSecurity = hookfunction(HostM.Security, function(...) -- stop remotes from changing their names
            return
        end)
        
        for i = 2, 10, 1 do -- excluding Main
            if game.PlaceId == whitelist[i] then
                local oldOPS oldOPS = hookfunction(HostM.Owns_Perk, function(...) -- supposed to grant all perks
                    return true
                end)

                local oldFamily oldFamily = hookfunction(HostM.Owns_Family, function(...) -- supposed to grant all family perks
                    return true
                end)
            end
        end

        for c = 5, 10, 1 do -- missions only
            if game.PlaceId == whitelist[c] then
                local oldGM oldGM = hookfunction(HostM.Gear_Multiplier, function(...)
                    return 2
                end)

                local oldKick; oldKick = hookfunction(HostM.Kick, function(...)
                    return
                end)
            end
        end
    end
end


local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")
local Flags        = OrionLib.Flags

local MainWindow   = OrionLib:MakeWindow({Name = "Attack On Titan: Evo", HidePremium = false, SaveConfig = true, ConfigFolder = "./Scrumpy/Attack on Titan - Evo"})

local Main         = MainWindow:MakeTab({Name = ' Main ', Icon = "rbxassetid://4483345998", premiumOnly = false})

local Function     = Main:AddSection({Name = ' Functions '})
local Keybinds     = Main:AddSection({Name = ' Keybinds '})
local Funny        = Main:AddSection({Name = ' Funny '})

Keybinds:AddBind({
    Name = "Control Gui",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function() 
        Orion.Enabled = not Orion.Enabled 
    end,
    Flag = "GUI",
    Save = true,
})

Function:AddToggle({
    Name = "Slient Mode",
    Description = "To not show orion GUI on launch, use control GUI keybind to open",
    Default = false,
    Callback = function(bool) end,
    Flag = "SlientMode",
    Save = true
})

for i = 5, 10, 1 do
    if game.PlaceId == whitelist[i] then -- any PvE area
        local Titans       = Workspace:WaitForChild("Titans")

        -- Player Stuff
        local Character = LP.Character or LP.CharacterAdded:Wait()
        local Head      = Character:WaitForChild("Head", 999)
        local Humanoid  = Character:WaitForChild("Humanoid", 999)
        local HRP       = Character:WaitForChild("HumanoidRootPart", 999)

        local AN = Function:AddToggle({
            Name = "Always Nape",
            Description = "Always Nape",
            Default = false,
            Callback = function(bool) end,
            Flag = "AlwaysNape",
            Save = true,
        })

    --[[     local FG = Function:AddToggle({
            Name = "Full Gas",
            Description = "significantly decrease gas intake",
            Default = false,
            Callback = function(bool)
                Flags.FullGas = bool
            end,
            Flag = "FullGas",
            Save = true
        }) ]]

        Function:AddToggle({
            Name = "Titan ESP",
            Default = false,
            Callback = function(bool)
                while Flags.TitanESP do
                    for i2, v2 in pairs(Titans:GetChildren()) do
                        MHL(Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 119, 215), v2)
                    end
                    task.wait()
                end
            end,
            Flag = "TitanESP",
            Save = true
        })

        Keybinds:AddBind({
            Name = "Always Nape Keybind",
            Default = Enum.KeyCode.G,
            Hold = false,
            Callback = function() 
                AN:Set(not Flags.AlwaysNape) 
            end,
            Flag = "ANK",
            Save = true,
        })

    --[[     Keybinds:AddBind({
            Name = "Full Gas Keybind",
            Default = Enum.KeyCode.Y,
            Hold = false,
            Callback = function() 
                FG:Set(not Flags.FullGas) 
            end,
            Flag = "FGK",
            Save = true,
        }) ]]

        Funny:AddButton({
            Name = "Break titan animations",
            Callback = function()
                for i, v in pairs(Titans:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        v:WaitForChild("HumanoidRootPart"):WaitForChild("Animator"):Destroy()
                    end
                    task.wait()
                end
            end,
        })

        Funny:AddParagraph("Side Note", "It Makes them seem frozen, and flop around. A titan body's is actually serverside(making the game seem laggy), so this is not recommended.")

        local OldNameCall; OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if not checkcaller() then
                if method == "InvokeServer" and args[1] == "Slash" and Flags.AlwaysNape then
                    args[3] = "Nape"
                    return OldNameCall(Self, unpack(args))
                end
    --[[             if method == "FireServer" and args[2] == "Gas" and Flags.FullGas then
                    args[3] = 2
                    return OldNameCall(Self, unpack(args))
                end ]]
            end
            return OldNameCall(Self, ...)
        end))

        task.spawn(function () -- anti-attack
            while task.wait() do
                if HRP:FindFirstChildOfClass("TouchTransmitter") then
                    HRP.TouchInterest:Destroy()
                end
            end
        end)

        function getClosestTitan()
            local nearestPlayer, nearestDistance
            pcall(function()
                for _, titan in pairs(Workspace.Titans:GetChildren()) do
                    local hit = titan.Hitboxes.Player.Nape
                    if hit then
                        local nroot = titan:FindFirstChild('Main')
                        local tag = titan.Head:FindFirstChild('Party')
                        if nroot and tag then
                            local distance = LP:DistanceFromCharacter(nroot.Position)
                            if (nearestDistance and distance >= nearestDistance) then continue end
                            nearestDistance = distance
                            nearestPlayer = hit
                            config.currTitan = titan
                        end
                    end
                end
            end)
            return nearestPlayer, config.currTitan
        end
        
        function getClosestRefill()
            local nearestPlayer, nearestDistance
                for _, player in pairs(Workspace.Map.Props.Refills:GetChildren()) do
                    local character = player.Hitbox
                    if character then
                        local distance = LP:DistanceFromCharacter(character.Position)
                        if (nearestDistance and distance >= nearestDistance) then continue end
                        nearestDistance = distance
                        nearestPlayer = character
                    end
                end
            return nearestPlayer
        end

        function useSkill(key, bool)
            VirtualInputManager:SendKeyEvent(bool, key, false, game)
        end
        
        function lookAt(chr,target) -- found this func somewhere
            if chr.PrimaryPart then 
                local chrPos = chr.PrimaryPart.Position 
                local tPos = target.Position 
                local newCF = CFrame.new(chrPos,tPos) 
                chr:SetPrimaryPartCFrame(newCF)
            end
        end
        
        function bladesFull()
            local Status = 0
            pcall(function()
                for _,v in pairs(HRP.Board.Display.Blade.Segments:GetDescendants()) do
                    if v.Name == "Inner" then
                        if v.ImageTransparency == 1 then
                            Status = Status + 1
                        end
                    end
                end
            end)
        
            if Status == 7 then
                return true
            end
            return false
        end
        
        function refillBlades()
            wait(1)
            local args = {
                [1] = true,
                [2] = "Effect",
                [3] = "Refill"
            }
            
            RE:FireServer(unpack(args))
        
            wait(1.5)
            if bladesFull() then
                local refill = getClosestRefill()
                local Time = (refill.Position - HRP.Position).Magnitude / 400
                local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
                local Tween =
                    TweenService:Create(
                    HRP,
                    Info,
                    {CFrame = CFrame.new(refill.Position) + Vector3.new(0, 4, 0)}
                )
                Tween:Play()
                Tween.Completed:Wait()
                config.refilling = true
                wait(1)
                useSkill('R', true)
                wait(7)
                local Time = (refill.Position + Vector3.new(30, 4, 30) - HRP.Position).Magnitude / 400
                local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
                local Tween =
                    TweenService:Create(
                    HRP,
                    Info,
                    {CFrame = CFrame.new(refill.Position) + Vector3.new(15, 4, 15)}
                )
                Tween:Play()
                Tween.Completed:Wait()
                config.refilling = false
                wait(1)
            end
        end
        
        function okTitan()
            while task.wait() do
                if not config.titan then return end
                pcall(function()
                    lookAt(Character, config.titan)
                end)
            end
        end
--[[ 
        virtualUser:CaptureController()
        config['skilln'] = 0 ]]

        function killClosestTitan()
            wait(0.3)
            if bladesFull() == true then
                useSkill('E', false)
                refillBlades()
                return
            end
            config.titan, config.titanparrt = getClosestTitan()
            if not config.titan then return end
            if LP:DistanceFromCharacter(config.titan.Position) <= 50 then
                _senv.Speed = _senv.Settings.Speed2
            else
                _senv.Speed = _senv.Settings.Speed
            end
        
            local Time = (config.titan.CFrame.p + Vector3.new(0, 7,4) - HRP.Position).Magnitude / _senv.Speed
            local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
            local Tween =
                TweenService:Create(
                HRP,
                Info,
                {CFrame = CFrame.new(config.titan.CFrame.p) + Vector3.new(0, 7,4)}
            )
            Tween:Play()
            Tween.Completed:Wait()
            wait()
            local Time = (config.titan.CFrame.p + Vector3.new(0, 3, 1) - HRP.Position).Magnitude / _senv.Speed
            local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
            local Tween =
                TweenService:Create(
                HRP,
                Info,
                {CFrame = CFrame.new(config.titan.CFrame.p) + Vector3.new(0, 7,4)}
            )
            Tween:Play()
            repeat wait() until Tween.Completed or LP:DistanceFromCharacter(config.titan.Position) <= 20
            if not config.titan then return end
            repeat task.wait()
                if bladesFull() == false then
                    HRP.CFrame = CFrame.new(config.titan.CFrame.p) + Vector3.new(0, 1,1)
                    lookAt(Character, config.titan)
                    mousemoveabs(600,800)
                    useSkill('E', true)
                    mouse1click()
                else
                    break
                end
        
            until not config.titanparrt.Head:FindFirstChild('Party') or bladesFull() == true
        end
        
        
--[[         function getName()
            return ReplicatedStorage.Assets.Remotes:GetChildren()[1].Name
        end ]]
        
        function selectMap(map, difficulty)
            for _,v in pairs(LP.PlayerGui.Interface.PvE.Main:GetChildren()) do
                if v:IsA('ImageButton') then
                    if v.Title.Text == "???" then repeat wait() until v.Title.Text ~= "???" end
                    if v.Title.Text == map then
                        local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
                        for i,a in pairs(Signals) do
                            firesignal(v[a])
                        end
                    end
                end
            end
            for _,v in pairs(LP.PlayerGui.Interface.PvE.Difficulties:GetChildren()) do
                if v:IsA('TextButton') then
                    if v.Lock.Visible == false then
                        if v.Name == "???" then repeat wait() until v.Name ~= "???" end
                        if v.Name == difficulty then
                            local Signals = {'MouseButton1Down', 'MouseButton1Click', 'Activated'}
                            for i,a in pairs(Signals) do
                                firesignal(v[a])
                            end
                        end
                    end
                end
            end
        end
        
        pcall(function()
            config.iflobby = Workspace.Map.Props.Missions.Pad.Main
        end)
        
        if config.iflobby ~= nil then
            wait(1)
            HRP.CFrame = CFrame.new(config.iflobby.Position)
            repeat wait() until LP.PlayerGui.Interface.PvE.Main['1'].Visible == true
            wait()
            selectMap(_senv.Settings.Map, _senv.Settings.Difficulty)
            return
        end
        
--[[         task.spawn(function()
            wait(_senv.Settings.LeaveTimer)
            TeleportService:Teleport(7229033818, LP)
        end) ]]
        
        _senv.rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
                TeleportService:Teleport(7229033818)
            end
        end)
        config.time = 0
        
--[[         pcall(function() game.StarterGui:SetCore("SendNotification", {
            Title = "IF U GET NO REWARDS";
            Text = "working on a fix, will come out soon";
            Icon = "rbxassetid://57254792";
            Duration = 1337;
        }) end)
        
        pcall(function() game.StarterGui:SetCore("SendNotification", {
            Title = "IF U DONT INSTAKILL";
            Text = "upgrade the damage on ur odm, there is no instakill";
            Icon = "rbxassetid://57254792";
            Duration = 1337;
        }) end)
        
        pcall(function() game.StarterGui:SetCore("SendNotification", {
            Title = "made by jsn#0499";
            Text = "made by jsn#0499, if u have bugs or questions dm me";
            Icon = "rbxassetid://57254792";
            Duration = 1337;
        }) end) ]]
        
--[[         local Time = (HRP.Position + Vector3.new(200, 0, 200) - HRP.Position).Magnitude / 100
        local Info = TweenInfo.new(Time, Enum.EasingStyle.Linear)
        local Tweena =
            TweenService:Create(
            HRP,
            Info,
            {CFrame = CFrame.new(HRP.Position) + Vector3.new(200, 0, 200)}
        )
        Tweena:Play()
        Tweena.Completed:Wait()
        
        while task.wait() and not config.refilling do
            killClosestTitan()
        end ]]
    end
end

if Flags.SlientMode == true then Orion.Enabled = false end
OrionLib:Init()