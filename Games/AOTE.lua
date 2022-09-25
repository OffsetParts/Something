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
local VirtualInputManager   = game:GetService('VirtualInputManager')
local TweenService          = game:GetService('TweenService')
local virtualUser           = game:GetService('VirtualUser')
local TeleportService       = game:GetService("TeleportService")

local LP                = Players.LocalPlayer
local Assets            = ReplicatedStorage:WaitForChild("Assets")

local GPIDs             = LP:WaitForChild("Gamepasses")
local Modules           = Assets:WaitForChild("Modules")
local Events            = Assets:WaitForChild("Remotes")

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

local HostM = nil

for i, v in pairs(getloadedmodules()) do
    if v.Name == 'Host' and require(v).Security then
        print'found'
        HostM = require(v)
        local values = HostM.New()

        --[[ local oldCheck; oldCheck = hookfunction(HostM.Check, function(...)
            return 
        end) ]]
        
        local oldGPs oldGPs = hookfunction(HostM.Owns_Gamepass, function(...) -- bloodline bag visual(don't store, will not work(detects now)) and skip roll for now.
            return true
        end)

        local oldSecurity oldSecurity = hookfunction(HostM.Security, function(...) -- stop remotes from changing their names
            wait(9e9)
            return
        end)
        
        for i = 2, 10, 1 do -- excluding Main
            if game.PlaceId == whitelist[i] then
                local oldOPS oldOPS = hookfunction(HostM.Owns_Perk, function(Self, Player, Perk) -- supposed to grant all perks
	                return true;
                end)

                local oldFamily oldFamily = hookfunction(HostM.Owns_Family, function(...) -- supposed to grant all family perks
                    return true
                end)
            end
        end

        for c = 5, 10, 1 do -- missions only
            if game.PlaceId == whitelist[c] then
                local oldGM oldGM = hookfunction(HostM.Gear_Multiplier, function(self, stat)
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

                local oldKick; oldKick = hookfunction(HostM.Kick, function(...)
                    warn'tried to kick'
                    return
                end)

                local oldGU oldGU = hookfunction(HostM.Get_Upgrades, function(...) -- supposed to grant all family perks
                    return 9
                end)

                local oldPhysics oldPhysics = hookfunction(HostM.Physics, function(p496, p497, p498, p499, p500, p501, p502, p503) -- supposed to grant all family perks
                    local v3539, v3540 = pcall(function()
                        local Data = p496.Data;
                        local Difficulty = p496.Difficulty;
                        local Services = p496.Services;
                        local Gear = p496.Gear;
                        local Cache = p496.Cache;
                        local Velocities = p496.Velocities;
                        local v3547 = 0.025;
                        local v3548 = Vector3.new(0, 0, 0);
                        local v3549 = Vector3.new(20000, 20000, 20000);
                        local v3550 = 1.05;
                        local Skill_Holding = p496.Skill_Holding;
                        if p497 ~= nil and p498 ~= nil and p499 ~= nil and p500 ~= nil and p501 ~= nil and p502 ~= nil and p503 ~= nil and Data ~= nil and Difficulty ~= nil and Services ~= nil and Gear ~= nil and Cache ~= nil and Velocities ~= nil and Enum.MouseBehavior.LockCenter ~= nil and Enum.HumanoidStateType.Freefall ~= nil and p496:Ignore_List() ~= nil then
                            local Mouse = p497:GetMouse();
                            local v3553 = p496:Morph(p497);
                            local Damaged = p500:GetAttribute("Damaged");
                            local Skill = p497:GetAttribute("Skill");
                            local Remove_Range = p501.Remove_Range;
                            local State = p502:GetState();
                            local MoveDirection = p502.MoveDirection;
                            local Avatar = Data.Avatar;
                            local Settings = Data.Settings;
                            local UIS = Services.UIS;
                            local W = Services.W;
                            local Equipped = Gear.Equipped;
                            local GSettings = Gear.Settings;
                            local Refill = Gear.Refill;
                            local Hooks = Gear.Hooks;
                            local Swerves = Gear.Swerves;
                            local Boosting = Gear.Boosting;
                            local Backflip = Gear.Backflip;
                            local Frontflip = Gear.Frontflip;
                            local Upflip = Gear.Upflip;
                            local Left_Side = Gear.Left_Side;
                            local Right_Side = Gear.Right_Side;
                            local Running = Gear.Running;
                            local Grab = Gear.Grab;
                            local Typing = Gear.Typing;
                            local Holds = Gear.Holds;
                            local Landing = Gear.Landing;
                            local Rolling = Gear.Rolling;
                            local Escaped = Gear.Escaped;
                            local Speed = Gear.Speed;
                            local Objects = Cache.Objects;
                            local Swerve = Velocities.Swerve;
                            local Target_Swerve = Velocities.Target_Swerve;
                            local Velocity = p503.Velocity;
                            if Mouse ~= nil and v3553 ~= nil and Remove_Range ~= nil and State ~= nil and MoveDirection ~= nil and Avatar ~= nil and Settings ~= nil and UIS ~= nil and W ~= nil and Equipped ~= nil and GSettings ~= nil and Refill ~= nil and Hooks ~= nil and Swerves ~= nil and Boosting ~= nil and Backflip ~= nil and Frontflip ~= nil and Upflip ~= nil and Left_Side ~= nil and Right_Side ~= nil and Running ~= nil and Grab ~= nil and Typing ~= nil and Holds ~= nil and Landing ~= nil and Rolling ~= nil and Escaped ~= nil and Speed ~= nil and Objects ~= nil and Swerve ~= nil and Target_Swerve ~= nil and Velocity ~= nil then
                                local Gas = v3553:FindFirstChild("Gas");
                                local Family = Avatar.Family;
                                local CurrentCamera = W.CurrentCamera;
                                local Gravity = math.floor(W.Gravity);
                                local Titans = W:FindFirstChild("Titans");
                                local EState = Equipped.State;
                                local GSpeed = GSettings.Speed;
                                local GRemove_Range = GSettings.Remove_Range;
                                local GDelay = GSettings.Delay;
                                local Cooldown = GSettings.Cooldown;
                                local Refilling = Refill.Refilling;
                                local Full_Refilling = Refill.Full_Refilling;
                                local Station = Refill.Station;
                                local LeftH = Hooks.Left;
                                local RightH = Hooks.Right;
                                local Midpoint = Hooks.Midpoint;
                                local Hooked = Hooks.Hooked;
                                local ChangeH = Hooks.Change;
                                local SLeft = Swerves.Left;
                                local SRight = Swerves.Right;
                                local SChange = Swerves.Change;
                                local BState = Backflip.State;
                                local FState = Frontflip.State;
                                local UState = Upflip.State;
                                local LSState = Left_Side.State;
                                local RSState = Right_Side.State;
                                local Grabbing = Grab.Grabbing;
                                local Pressed = Grab.Pressed;
                                local HLeft = Holds.Left;
                                local HRight = Holds.Right;
                                local Speed_CFrame = Speed.CFrame;
                                local Speed_Value = Speed.Value;
                                local Velocity_Magnitude = Velocity.Magnitude;
                                local CFrameN = CFrame.new;
                                local BG = Objects.BG;
                                local BV = Objects.BV;
                                local Player_Magnitude = (p503.Position - Midpoint).Magnitude;
                                local Other_Magnitude = (Midpoint - Vector3.new(p503.Position.X, Midpoint.Y, p503.Position.Z)).Magnitude;
                                if Gas ~= nil and Family ~= nil and Settings.Gameplay ~= nil and CurrentCamera ~= nil and Gravity ~= nil and Titans ~= nil and EState ~= nil and GSpeed ~= nil and GSettings.Range ~= nil and GRemove_Range ~= nil and GDelay ~= nil and GSettings.Gravity ~= nil and Cooldown ~= nil and Refilling ~= nil and Full_Refilling ~= nil and LeftH ~= nil and RightH ~= nil and SLeft ~= nil and SRight ~= nil and SChange ~= nil and BState ~= nil and FState ~= nil and UState ~= nil and LSState ~= nil and RSState ~= nil and Pressed ~= nil and HLeft ~= nil and HRight ~= nil and Midpoint ~= nil and ChangeH ~= nil and Speed_CFrame ~= nil and Speed_Value ~= nil and Velocity_Magnitude ~= nil and BG ~= nil and BV ~= nil and Player_Magnitude ~= nil and Other_Magnitude ~= nil then
                                    local NewSpeed = p496:Gear_Multiplier("Speed");
                                    local v3624 = tick() - ChangeH;
                                    if GSpeed > 500 then
                                        GSpeed = 500;
                                    end;
                                    if NewSpeed ~= nil then
                                        GSpeed = GSpeed * NewSpeed;
                                    end;
                                    local Teleporting = p496.Teleporting;
                                    if Damaged == nil and p502.Health > 0 and Teleporting ~= nil and Teleporting == false then
                                        BG.Parent = p503;
                                        BV.Parent = p503;
                                        if Skill ~= nil and Skill ~= "Rising Thrust" and Skill ~= "Drilling Thrust" and Skill ~= "Boost" and Skill ~= "Loose Capsules" and Skill ~= "Self Heal" and Skill ~= "Healing Aura" and Skill ~= "Infinite Chain" then
                                            BG.CFrame = p503.CFrame;
                                            BV.MaxForce = Vector3.new(0, 0, 0);
                                        end;
                                    elseif p496.Blown == nil then
                                        BG.Parent = nil;
                                        BV.Parent = nil;
                                    end;
                                    local l__Current__3626 = Gas:FindFirstChild("Current");
                                    local l__CFrame__3627 = p503.CFrame;
                                    local v3628 = CurrentCamera.CFrame * CFrameN(0, 1, 0);
                                    local v3629 = Speed_Value;
                                    if Boosting == true then
                                        local Propulsion = true;
                                        if Propulsion ~= nil and Propulsion == true then
                                            v3550 = v3550 * 1.15;
                                        end;
                                        v3629 = v3629 * v3550;
                                    end;
                                    local v3631 = CFrameN(GSpeed, 0, 0);
                                    local l__Part__3632 = LeftH.Part;
                                    local l__Part__3633 = RightH.Part;
                                    local l__Position__3634 = LeftH.Position;
                                    local l__Position__3635 = RightH.Position;
                                    local l__Hitbox__3636 = LeftH.Hitbox;
                                    local l__Hitbox__3637 = RightH.Hitbox;
                                    local l__Pressed__3638 = LeftH.Pressed;
                                    local l__Pressed__3639 = RightH.Pressed;
                                    local l__Ending__3640 = LeftH.Ending;
                                    local l__Ending__3641 = RightH.Ending;
                                    local l__State__3642 = SLeft.State;
                                    local l__State__3643 = SRight.State;
                                    local v3644 = tick() - SChange;
                                    local v3645 = tick() - Pressed;
                                    local u154 = Midpoint;
                                    local u155 = true;
                                    local function v3646(p504, p505, p506, p507)
                                        if p504 ~= nil and p505 ~= nil and p506 ~= nil then
                                            local v3647 = false;
                                            if p504 == true then
                                                v3647 = p496:Grab(p497, p498, p500, p503, u154, LeftH, RightH);
                                            end;
                                            if v3647 == false then
                                                if p507 ~= nil and p507 == true then
                                                    p505 = true;
                                                    p506 = true;
                                                end;
                                                if p505 == true then
                                                    p496:Hook(p497, p498, {
                                                        Hook = "Left", 
                                                        State = "Passive"
                                                    });
                                                end;
                                                if p506 == true then
                                                    p496:Hook(p497, p498, {
                                                        Hook = "Right", 
                                                        State = "Passive"
                                                    });
                                                end;
                                            end;
                                            if p505 == false and p506 == false then
                                                u155 = false;
                                            end;
                                        end;
                                    end;
                                    if (l__Part__3632 ~= nil or l__Part__3633 ~= nil) and (Damaged ~= nil or p502.Health <= 0 or Skill ~= nil) then
                                        v3646(false, true, true);
                                    end;
                                    local l__Hit__3648 = Mouse.Hit;
                                    local v3649 = p497:GetAttribute("Skill");
                                    if v3649 ~= nil and (v3649 == "Counter" or v3649 == "Loose_Capsules" or v3649 == "Self_Heal" or v3649 == "Healing_Aura" or v3649 == "Infinite_Chain") then
                                        v3649 = nil;
                                    end;
                                    if l__Current__3626 ~= nil and l__CFrame__3627 ~= nil and v3628 ~= nil and v3629 ~= nil and Speed_CFrame ~= nil and l__Pressed__3638 ~= nil and l__Pressed__3639 ~= nil and l__Ending__3640 ~= nil and l__Ending__3641 ~= nil and l__State__3642 ~= nil and l__State__3643 ~= nil and v3644 ~= nil and v3645 ~= nil then
                                        local l__Unit__3650 = l__CFrame__3627:VectorToObjectSpace(MoveDirection).Unit;
                                        local l__LookVector__3651 = v3628.LookVector;
                                        local v3652 = tick() - l__Pressed__3638;
                                        local v3653 = tick() - l__Pressed__3639;
                                        if l__Unit__3650 ~= nil and l__LookVector__3651 ~= nil and v3652 ~= nil and v3653 ~= nil then
                                            local v3654 = CFrameN(GSpeed, 0, 0);
                                            local l__X__3655 = l__Unit__3650.X;
                                            local l__Z__3656 = l__Unit__3650.Z;
                                            if l__X__3655 ~= nil and l__Z__3656 ~= nil then
                                                if l__Z__3656 > 0 then
                                                    local v3657 = true;
                                                    if not (math.abs(l__X__3655) <= math.abs(l__Z__3656)) then
                                                        if not (l__X__3655 >= 0) then
                                                            v3657 = false;
                                                            if l__X__3655 < 0 then
                                                                v3657 = math.abs(l__Z__3656) <= math.abs(l__X__3655);
                                                            end;
                                                        else
                                                            v3657 = math.abs(l__Z__3656) <= math.abs(l__X__3655);
                                                        end;
                                                    end;
                                                elseif not (l__X__3655 >= 0) then
                                                    v3657 = false;
                                                    if l__X__3655 < 0 then
                                                        v3657 = math.abs(l__Z__3656) <= math.abs(l__X__3655);
                                                    end;
                                                else
                                                    v3657 = math.abs(l__Z__3656) <= math.abs(l__X__3655);
                                                end;
                                                local v3658, v3659, v3660 = p496:Constants(0.75, Boosting, Swerve, Target_Swerve, BV, GSpeed, l__Position__3634, l__Position__3635, v3644);
                                                if v3657 ~= nil and GSpeed ~= nil and v3658 ~= nil and v3659 ~= nil and v3660 ~= nil then
                                                    p496:Updater(p499, Grabbing, { v3658, v3659, v3660 });
                                                    local v3661 = false;
                                                    local v3662 = "";
                                                    for v3663, v3664 in pairs(p501) do
                                                        local v3665 = GSettings[v3663];
                                                        if v3665 ~= nil then
                                                            local v3666 = p496:Gear_Multiplier("Range");
                                                            if v3663 == "Remove_Range" and Remove_Range * v3666 < v3665 * v3666 then
                                                                v3661 = true;
                                                                v3662 = v3663;
                                                                break;
                                                            end;
                                                            if v3663 ~= "Remove_Range" and v3664 ~= v3665 then
                                                                v3661 = true;
                                                                v3662 = v3663;
                                                                break;
                                                            end;
                                                        end;
                                                    end;
                                                    if l__Position__3634 ~= nil or l__Position__3635 ~= nil or v3652 <= 1.5 or v3653 <= 1.5 then
                                                        local v3667 = 95;
                                                    else
                                                        v3667 = 133;
                                                    end;
                                                    if Gravity ~= v3667 then
                                                        W.Gravity = v3667;
                                                    end;
                                                    if l__Position__3634 == nil and l__Position__3635 == nil or l__Ending__3640 == true and l__Ending__3641 == true then
                                                        local v3668 = nil;
                                                        local v3669 = nil;
                                                        local v3670 = GDelay * 3;
                                                        Speed.CFrame = CFrameN(0, 0, 0);
                                                        if Escaped == true then
                                                            v3668 = CFrameN(p503.Position).UpVector * 225;
                                                            v3669 = 1;
                                                        elseif BState == true then
                                                            local l__Velocity__3671 = p503.Velocity;
                                                            if l__Velocity__3671 ~= nil then
                                                                local v3672 = GSpeed / 4;
                                                                local v3673 = 0;
                                                                if l__Velocity__3671.Y < 0 and State == Enum.HumanoidStateType.Freefall then
                                                                    v3673 = l__Velocity__3671.Y;
                                                                    p503.Velocity = Vector3.new(l__Velocity__3671.X, -(v3673 / 3), l__Velocity__3671.Z);
                                                                end;
                                                                local v3674 = p496:Owns_Perk(p497, "Parkour Master");
                                                                if v3674 ~= nil and v3674 == true then
                                                                    v3672 = v3672 * 1.25;
                                                                end;
                                                                v3668 = l__CFrame__3627.LookVector * -(v3672 * 2.5) + l__CFrame__3627.UpVector * ((v3672 + v3673) * 1.5);
                                                                v3669 = 1;
                                                                if State ~= Enum.HumanoidStateType.Freefall then
                                                                    v3668 = l__CFrame__3627.LookVector * -(v3672 * 2.5) + l__CFrame__3627.UpVector * (v3672 * 0.65);
                                                                    BV.MaxForce = v3549;
                                                                end;
                                                            end;
                                                        elseif FState == true then
                                                            local l__Velocity__3675 = p503.Velocity;
                                                            if l__Velocity__3675 ~= nil then
                                                                local v3676 = GSpeed / 4;
                                                                local v3677 = 0;
                                                                if l__Velocity__3675.Y < 0 and State == Enum.HumanoidStateType.Freefall then
                                                                    v3677 = l__Velocity__3675.Y;
                                                                    p503.Velocity = Vector3.new(l__Velocity__3675.X, -(v3677 / 3), l__Velocity__3675.Z);
                                                                end;
                                                                local v3678 = p496:Owns_Perk(p497, "Parkour Master");
                                                                if v3678 ~= nil and v3678 == true then
                                                                    v3676 = v3676 * 1.25;
                                                                end;
                                                                v3668 = l__CFrame__3627.LookVector * (v3676 * 2.5) + l__CFrame__3627.UpVector * ((v3676 + v3677) * 1.5);
                                                                v3669 = 1;
                                                                if State ~= Enum.HumanoidStateType.Freefall then
                                                                    v3668 = l__CFrame__3627.LookVector * (v3676 * 2.5) + l__CFrame__3627.UpVector * (v3676 * 0.65);
                                                                    BV.MaxForce = v3549;
                                                                end;
                                                            end;
                                                        elseif UState == true then
                                                            local l__Velocity__3679 = p503.Velocity;
                                                            if l__Velocity__3679 ~= nil then
                                                                local v3680 = GSpeed / 4;
                                                                local v3681 = 0;
                                                                if l__Velocity__3679.Y < 0 and State == Enum.HumanoidStateType.Freefall then
                                                                    v3681 = l__Velocity__3679.Y;
                                                                end;
                                                                local v3682 = p496:Owns_Perk(p497, "Parkour Master");
                                                                if v3682 ~= nil and v3682 == true then
                                                                    v3680 = v3680 * 1.25;
                                                                end;
                                                                v3668 = l__CFrame__3627.UpVector * ((v3680 + v3681) * 2);
                                                                v3669 = 1;
                                                                if State ~= Enum.HumanoidStateType.Freefall then
                                                                    v3668 = l__CFrame__3627.UpVector * (v3680 * 1.25);
                                                                end;
                                                                BV.MaxForce = v3549;
                                                            end;
                                                        elseif LSState == true then
                                                            local l__Velocity__3683 = p503.Velocity;
                                                            if l__Velocity__3683 ~= nil then
                                                                local v3684 = GSpeed / 4;
                                                                local v3685 = 0;
                                                                if l__Velocity__3683.Y < 0 and State == Enum.HumanoidStateType.Freefall then
                                                                    v3685 = l__Velocity__3683.Y;
                                                                    p503.Velocity = Vector3.new(l__Velocity__3683.X, -(v3685 / 3), l__Velocity__3683.Z);
                                                                end;
                                                                local v3686 = p496:Owns_Perk(p497, "Parkour Master");
                                                                if v3686 ~= nil and v3686 == true then
                                                                    v3684 = v3684 * 1.25;
                                                                end;
                                                                v3668 = l__CFrame__3627.RightVector * -(v3684 * 2.5) + l__CFrame__3627.UpVector * ((v3684 + v3685) * 1.5);
                                                                v3669 = 1;
                                                                if State ~= Enum.HumanoidStateType.Freefall then
                                                                    v3668 = l__CFrame__3627.RightVector * -(v3684 * 2.5) + l__CFrame__3627.UpVector * (v3684 * 0.65);
                                                                    BV.MaxForce = v3549;
                                                                end;
                                                            end;
                                                        elseif RSState == true then
                                                            local l__Velocity__3687 = p503.Velocity;
                                                            if l__Velocity__3687 ~= nil then
                                                                local v3688 = GSpeed / 4;
                                                                local v3689 = 0;
                                                                if l__Velocity__3687.Y < 0 and State == Enum.HumanoidStateType.Freefall then
                                                                    v3689 = l__Velocity__3687.Y;
                                                                    p503.Velocity = Vector3.new(l__Velocity__3687.X, -(v3689 / 3), l__Velocity__3687.Z);
                                                                end;
                                                                local v3690 = p496:Owns_Perk(p497, "Parkour Master");
                                                                if v3690 ~= nil and v3690 == true then
                                                                    v3688 = v3688 * 1.25;
                                                                end;
                                                                v3668 = l__CFrame__3627.RightVector * (v3688 * 2.5) + l__CFrame__3627.UpVector * ((v3688 + v3689) * 1.5);
                                                                v3669 = 1;
                                                                if State ~= Enum.HumanoidStateType.Freefall then
                                                                    v3668 = l__CFrame__3627.RightVector * -(v3688 * 2.5) + l__CFrame__3627.UpVector * (v3688 * 0.65);
                                                                    BV.MaxForce = v3549;
                                                                end;
                                                            end;
                                                        elseif Boosting == true and v3652 >= 1.5 and v3653 >= 1.5 then
                                                            local v3691 = v3628 * CFrameN(0, 0, 1);
                                                            local v3692 = CFrameN(l__CFrame__3627.Position);
                                                            if l__CFrame__3627.Position == v3691.Position then
                                                                v3692 = CFrameN(l__CFrame__3627.Position);
                                                            elseif l__CFrame__3627.Position ~= v3691.Position then
                                                                v3692 = CFrameN(l__CFrame__3627.Position, v3691.Position);
                                                            end;
                                                            if v3692 ~= nil then
                                                                local v3693 = GSpeed / 4 * 1.4;
                                                                if v3693 ~= nil then
                                                                    v3668 = v3692.LookVector * -v3693 + v3691.UpVector * -5;
                                                                    v3669 = 1;
                                                                    u155 = false;
                                                                    p496:Gas_Usage(p498, l__Position__3634, l__Position__3635, Boosting, false);
                                                                end;
                                                            end;
                                                        elseif v3670 < v3645 then
                                                            local v3694 = math.clamp(Velocity_Magnitude, 1, 500);
                                                            if Rolling == false then
                                                                v3668 = l__CFrame__3627.LookVector * v3694;
                                                                v3669 = 60;
                                                            elseif Rolling == true then
                                                                local l__Held_Velocity__3695 = p496.Held_Velocity;
                                                                if l__Held_Velocity__3695 == nil then
                                                                    local v3696 = (math.abs(BV.Velocity.X) + math.abs(BV.Velocity.Z)) / 2;
                                                                    v3668 = l__CFrame__3627.LookVector * v3696;
                                                                    v3669 = 1;
                                                                    p496.Held_Velocity = v3696;
                                                                elseif l__Held_Velocity__3695 ~= nil then
                                                                    v3668 = l__CFrame__3627.LookVector * l__Held_Velocity__3695;
                                                                    v3669 = 1;
                                                                    p496:Shake(1);
                                                                end;
                                                            end;
                                                        end;
                                                        local l__Knockback__3697 = p496.Knockback;
                                                        local v3698 = false;
                                                        if l__Knockback__3697 ~= nil and l__Knockback__3697 == true then
                                                            local l__Current__3699 = Data.Current;
                                                            if l__Current__3699 ~= nil then
                                                                if l__Current__3699 == "APG" then
                                                                    v3698 = true;
                                                                elseif l__Current__3699 ~= "3DMG" and l__Current__3699 == "3DMG/TP" and p497:GetAttribute("Side") == "3DMG" then
                
                                                                end;
                                                            end;
                                                            v3669 = 1;
                                                        end;
                                                        p496:Ungrab(p497, p498);
                                                        if v3668 ~= nil and v3669 ~= nil and v3669 >= 1 and p496.Blown == nil then
                                                            if v3668 ~= v3668 then
                                                                print("NaN Velocity");
                                                            elseif v3668 == v3668 then
                                                                local l__Skill_BP__3700 = p503:FindFirstChild("Skill_BP");
                                                                if v3649 == nil and l__Skill_BP__3700 ~= nil then
                                                                    l__Skill_BP__3700:Destroy();
                                                                end;
                                                                if v3649 ~= nil and Skill_Holding == true then
                                                                    if l__Skill_BP__3700 == nil and v3649:find("Blade") == nil and v3649 ~= "Loose_Capsules" and v3649 ~= "Self_Heal" and v3649 ~= "Healing_Aura" and v3649 ~= "Infinite_Chain" then
                                                                        p503.CFrame = p503.CFrame;
                                                                        local v3701 = Instance.new("BodyPosition");
                                                                        v3701.Name = "Skill_BP";
                                                                        v3701.Position = p503.Position;
                                                                        v3701.P = 100;
                                                                        v3701.D = 100000;
                                                                        v3701.Parent = p503;
                                                                    end;
                                                                elseif Full_Refilling == false and ((p496.Coordinates.Lock == true or v3649 ~= nil or v3657 == true or UIS.MouseBehavior == Enum.MouseBehavior.LockCenter or v3652 <= v3670 or v3653 <= v3670 or MoveDirection ~= Vector3.new(0, 0, 0)) and l__Hit__3648 ~= nil) then
                                                                    local v3702 = p503.Position + Vector3.new(l__LookVector__3651.X, 0, l__LookVector__3651.Z);
                                                                    if p503.Position ~= v3702 and BG ~= nil then
                                                                        local l__Aiming__3703 = p496.Aiming;
                                                                        if l__Aiming__3703 ~= nil then
                                                                            BG.CFrame = l__Aiming__3703;
                                                                        elseif Rolling == false and (p496.Coordinates.Lock == true or p502.MoveDirection ~= Vector3.new(0, 0, 0)) then
                                                                            BG.CFrame = CFrameN(p503.Position, v3702);
                                                                        end;
                                                                    end;
                                                                elseif Full_Refilling == true and Station ~= nil then
                                                                    local l__Hitbox__3704 = Station:FindFirstChild("Hitbox");
                                                                    if l__Hitbox__3704 ~= nil then
                                                                        local v3705 = Vector3.new(l__Hitbox__3704.Position.X, p503.Position.Y, l__Hitbox__3704.Position.Z);
                                                                        if Rolling == false and p503.Position ~= v3705 and BG ~= nil and BG.Parent == p503 then
                                                                            BG.CFrame = CFrameN(p503.Position, v3705);
                                                                        end;
                                                                    end;
                                                                end;
                                                                local v3706 = 16;
                                                                local v3707 = 50;
                                                                if Difficulty == nil or Damaged ~= nil or Landing == true or Rolling == true or Full_Refilling == true then
                                                                    v3706 = 0;
                                                                    v3707 = 0;
                                                                end;
                                                                local v3708 = p496:Owns_Perk(p497, "Lightweight");
                                                                if v3708 ~= nil and v3708 == true then
                                                                    v3706 = v3706 * 1.2;
                                                                end;
                                                                local v3709 = p496:Owns_Family("Galliard");
                                                                if v3709 ~= nil and v3709 == true then
                                                                    v3706 = v3706 * 1.5;
                                                                end;
                                                                local v3710 = p496:Owns_Stackable_Family(p497, "Smith");
                                                                if v3710 ~= nil then
                                                                    v3706 = v3706 * v3710;
                                                                end;
                                                                local v3711 = p496:Owns_Perk(p497, "Willpower");
                                                                if v3711 ~= nil then
                                                                    local v3712 = p497:GetAttribute("Bloodlust");
                                                                    if (Family ~= "Ackerman" or v3712 == nil or v3712 ~= true) and v3711 ~= true and Family ~= "Galliard" then
                                                                        v3706 = v3706 * (p502.Health / p502.MaxHealth);
                                                                    end;
                                                                end;
                                                                if v3649 ~= nil or p502.Health <= 0 then
                                                                    v3706 = 0;
                                                                    v3707 = 0;
                                                                end;
                                                                if Running == false then
                                                                    local v3713 = v3706;
                                                                    if not v3713 then
                                                                        v3713 = false;
                                                                        if Running == true then
                                                                            v3713 = v3706 * 2.3;
                                                                        end;
                                                                    end;
                                                                else
                                                                    v3713 = false;
                                                                    if Running == true then
                                                                        v3713 = v3706 * 2.3;
                                                                    end;
                                                                end;
                                                                p502.WalkSpeed = v3713;
                                                                p502.JumpPower = v3707;
                                                                if BV ~= nil then
                                                                    if Damaged == nil then
                                                                        if v3649 ~= nil and Skill_Holding == false and (v3649 == "Drilling_Thrust" or v3649 == "Rising_Thrust" or v3649 == "Boost") then
                                                                            BV.MaxForce = v3549;
                                                                            local v3714 = p496:Get_Upgrades("3DMG Speed");
                                                                            if v3714 ~= nil then
                                                                                if v3649 == "Drilling_Thrust" then
                                                                                    local l__Aiming__3715 = p496.Aiming;
                                                                                    if l__Aiming__3715 == nil then
                                                                                        p496.Aiming = l__Hit__3648;
                                                                                    elseif l__Aiming__3715 ~= nil then
                                                                                        BV.MaxForce = v3549;
                                                                                        BV.Velocity = l__Aiming__3715.LookVector * (175 + v3714 * 15);
                                                                                    end;
                                                                                elseif v3649 == "Rising_Thrust" then
                                                                                    BV.MaxForce = v3549;
                                                                                    BV.Velocity = p503.CFrame.UpVector * (120 + v3714 * 5);
                                                                                elseif v3649 == "Boost" then
                                                                                    local l__Aiming__3716 = p496.Aiming;
                                                                                    if l__Aiming__3716 == nil then
                                                                                        p496.Aiming = l__Hit__3648;
                                                                                    elseif l__Aiming__3716 ~= nil then
                                                                                        BV.MaxForce = v3549;
                                                                                        BV.Velocity = l__Aiming__3716.LookVector * (500 + v3714 * 60);
                                                                                        p496.Boost_Delay = tick();
                                                                                        p496:Shake(5);
                                                                                    end;
                                                                                end;
                                                                            end;
                                                                        else
                                                                            local l__MaxForce__3717 = BV.MaxForce;
                                                                            local v3718 = v3549 / 5;
                                                                            local v3719 = true;
                                                                            if BState ~= true then
                                                                                v3719 = true;
                                                                                if FState ~= true then
                                                                                    v3719 = true;
                                                                                    if UState ~= true then
                                                                                        v3719 = true;
                                                                                        if LSState ~= true then
                                                                                            v3719 = true;
                                                                                            if RSState ~= true then
                                                                                                v3719 = true;
                                                                                                if Boosting ~= true then
                                                                                                    v3719 = true;
                                                                                                    if not (v3652 <= GDelay) then
                                                                                                        v3719 = v3653 <= GDelay;
                                                                                                    end;
                                                                                                end;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                end;
                                                                            end;
                                                                            if v3719 ~= nil then
                                                                                if Escaped == true then
                                                                                    local v3720 = v3549.X;
                                                                                    if not v3720 then
                                                                                        if v3719 == false then
                                                                                            v3720 = l__MaxForce__3717.X;
                                                                                            if not v3720 then
                                                                                                v3720 = false;
                                                                                                if v3719 == true then
                                                                                                    v3720 = v3718.X;
                                                                                                end;
                                                                                            end;
                                                                                        else
                                                                                            v3720 = false;
                                                                                            if v3719 == true then
                                                                                                v3720 = v3718.X;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                elseif v3719 == false then
                                                                                    v3720 = l__MaxForce__3717.X;
                                                                                    if not v3720 then
                                                                                        v3720 = false;
                                                                                        if v3719 == true then
                                                                                            v3720 = v3718.X;
                                                                                        end;
                                                                                    end;
                                                                                else
                                                                                    v3720 = false;
                                                                                    if v3719 == true then
                                                                                        v3720 = v3718.X;
                                                                                    end;
                                                                                end;
                                                                                if v3698 == false and Escaped == false then
                                                                                    local v3721 = l__MaxForce__3717.Y;
                                                                                    if not v3721 then
                                                                                        if v3698 ~= true then
                                                                                            v3721 = false;
                                                                                            if Escaped == true then
                                                                                                v3721 = v3549.Y;
                                                                                            end;
                                                                                        else
                                                                                            v3721 = v3549.Y;
                                                                                        end;
                                                                                    end;
                                                                                elseif v3698 ~= true then
                                                                                    v3721 = false;
                                                                                    if Escaped == true then
                                                                                        v3721 = v3549.Y;
                                                                                    end;
                                                                                else
                                                                                    v3721 = v3549.Y;
                                                                                end;
                                                                                if Escaped == true then
                                                                                    local v3722 = v3549.Z;
                                                                                    if not v3722 then
                                                                                        if v3719 == false then
                                                                                            v3722 = l__MaxForce__3717.Z;
                                                                                            if not v3722 then
                                                                                                v3722 = false;
                                                                                                if v3719 == true then
                                                                                                    v3722 = v3718.Z;
                                                                                                end;
                                                                                            end;
                                                                                        else
                                                                                            v3722 = false;
                                                                                            if v3719 == true then
                                                                                                v3722 = v3718.Z;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                elseif v3719 == false then
                                                                                    v3722 = l__MaxForce__3717.Z;
                                                                                    if not v3722 then
                                                                                        v3722 = false;
                                                                                        if v3719 == true then
                                                                                            v3722 = v3718.Z;
                                                                                        end;
                                                                                    end;
                                                                                else
                                                                                    v3722 = false;
                                                                                    if v3719 == true then
                                                                                        v3722 = v3718.Z;
                                                                                    end;
                                                                                end;
                                                                                BV.MaxForce = Vector3.new(v3720, v3721 / v3669, v3722);
                                                                                local v3723 = v3547 * 1.25;
                                                                                local v3724 = v3548;
                                                                                if p496.Blown == true then
                                                                                    v3724 = v3549;
                                                                                end;
                                                                                BV.MaxForce = BV.MaxForce:Lerp(v3724, v3723);
                                                                                local l__Magnitude__3725 = v3668.Magnitude;
                                                                                local l__Held_Velocity__3726 = p496.Held_Velocity;
                                                                                if l__Held_Velocity__3726 == nil and v3649 ~= nil and v3649 ~= "Counter" and v3649 ~= "Loose_Capsules" and v3649 ~= "Self_Heal" and v3649 ~= "Healing_Aura" and v3649 ~= "Infinite_Chain" and v3668 ~= nil then
                                                                                    p496.Held_Velocity = v3668;
                                                                                elseif Rolling == false and l__Held_Velocity__3726 ~= nil and (v3649 == nil or v3649 == "Counter" or v3649 == "Loose_Capsules" or v3649 == "Self_Heal" or v3649 == "Healing_Aura" or v3649 == "Infinite_Chain") then
                                                                                    v3668 = l__Held_Velocity__3726;
                                                                                    v3723 = 1;
                                                                                    BV.MaxForce = v3549;
                                                                                    p496.Held_Velocity = nil;
                                                                                    p496.Aiming = nil;
                                                                                end;
                                                                                if Rolling == true then
                                                                                    v3723 = 2 - (tick() - Gear.Last_Fall);
                                                                                    BV.MaxForce = Vector3.new(v3549.X * v3723, 0, v3549.Z * v3723);
                                                                                    p503.Anchored = false;
                                                                                end;
                                                                                if type(v3668) == "vector" then
                                                                                    BV.Velocity = BV.Velocity:Lerp(v3668, v3723);
                                                                                end;
                                                                            end;
                                                                        end;
                                                                    elseif Damaged ~= nil and p496.Blown == nil then
                                                                        BV.MaxForce = Vector3.new(0, 0, 0);
                                                                        BV.Velocity = Vector3.new(0, 0, 0);
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    elseif (l__Part__3632 ~= nil or l__Part__3633 ~= nil) and (l__Position__3634 ~= nil or l__Position__3635 ~= nil) and (l__Ending__3640 == false or l__Ending__3641 == false) then
                                                        if Boosting == false then
                                                            local v3727 = 1;
                                                        else
                                                            v3727 = false;
                                                            if Boosting == true then
                                                                v3727 = 2;
                                                            end;
                                                        end;
                                                        if v3727 ~= nil then
                                                            if l__Hitbox__3636 ~= nil and l__Hitbox__3637 ~= nil then
                                                                local v3728 = 0.2;
                                                            elseif l__Hitbox__3636 ~= nil or l__Hitbox__3637 ~= nil then
                                                                v3728 = 0.1;
                                                            else
                                                                v3728 = 0;
                                                            end;
                                                            if v3728 ~= nil and v3728 > 0 then
                                                                p496:Gas_Usage(p498, l__Position__3634, l__Position__3635, Boosting, false);
                                                                Speed.CFrame = Speed_CFrame:Lerp(v3654, v3728 * v3727);
                                                                local l__CFrame__3729 = Speed.CFrame;
                                                                if l__CFrame__3729 ~= nil then
                                                                    Speed.Value = l__CFrame__3729.X;
                                                                    local v3730 = false;
                                                                    if l__Part__3632 ~= nil and l__Part__3632:IsDescendantOf(Titans) == true or l__Part__3633 ~= nil and l__Part__3633:IsDescendantOf(Titans) == true then
                                                                        v3730 = true;
                                                                    end;
                                                                    if v3730 ~= nil then
                                                                        if v3730 == false then
                                                                            local v3731 = 1;
                                                                        else
                                                                            v3731 = false;
                                                                            if v3730 == true then
                                                                                v3731 = 2;
                                                                            end;
                                                                        end;
                                                                        if v3731 ~= nil then
                                                                            local v3732 = true;
                                                                            local v3733 = true;
                                                                            local v3734 = true;
                                                                            if (Data.Current == "TP" or Data.Current == "3DMG/TP" and p497:GetAttribute("Side") == "TP") and (Gear.Launch.Launching == true or Gear.Launch.Triggering == true) and (Gear.Launch.Combo == "Left" and Gear.Hooks.Left.Part ~= nil or Gear.Launch.Combo == "Right" and Gear.Hooks.Right.Part ~= nil) then
                                                                                v3732 = false;
                                                                                v3733 = Gear.Launch.Combo == "Left";
                                                                                v3734 = Gear.Launch.Combo == "Right";
                                                                            end;
                                                                            if not (p502.Health <= 0) and Damaged == nil and Landing ~= true and Rolling ~= true then
                                                                                if v3732 == false then
                                                                                    if v3733 == true or v3734 == true or EState == false or Refilling == true or l__Current__3626.Value <= 0 or GRemove_Range < Player_Magnitude then
                                                                                        v3646(false, v3733, v3734);
                                                                                    elseif Grabbing == true and Cooldown <= v3645 then
                                                                                        p496:Ungrab(p497, p498);
                                                                                    elseif Grabbing == false and Other_Magnitude <= 2.5 * v3731 then
                                                                                        local v3735 = false;
                                                                                        local v3736 = false;
                                                                                        if l__Position__3634 == nil or l__Position__3634 ~= nil and l__Part__3632 ~= nil then
                                                                                            v3735 = true;
                                                                                        end;
                                                                                        if l__Position__3635 == nil or l__Position__3635 ~= nil and l__Part__3633 ~= nil then
                                                                                            v3736 = true;
                                                                                        end;
                                                                                        if v3735 == true and v3736 == true then
                                                                                            v3646(true, false, false, true);
                                                                                        end;
                                                                                    elseif Typing == false and (HLeft == false or HRight == false) then
                                                                                        v3646(false, not HLeft, not HRight);
                                                                                    end;
                                                                                elseif EState == false or Refilling == true or l__Current__3626.Value <= 0 or GRemove_Range < Player_Magnitude then
                                                                                    v3646(false, v3733, v3734);
                                                                                elseif Grabbing == true and Cooldown <= v3645 then
                                                                                    p496:Ungrab(p497, p498);
                                                                                elseif Grabbing == false and Other_Magnitude <= 2.5 * v3731 then
                                                                                    v3735 = false;
                                                                                    v3736 = false;
                                                                                    if l__Position__3634 == nil or l__Position__3634 ~= nil and l__Part__3632 ~= nil then
                                                                                        v3735 = true;
                                                                                    end;
                                                                                    if l__Position__3635 == nil or l__Position__3635 ~= nil and l__Part__3633 ~= nil then
                                                                                        v3736 = true;
                                                                                    end;
                                                                                    if v3735 == true and v3736 == true then
                                                                                        v3646(true, false, false, true);
                                                                                    end;
                                                                                elseif Typing == false and (HLeft == false or HRight == false) then
                                                                                    v3646(false, not HLeft, not HRight);
                                                                                end;
                                                                            else
                                                                                v3646(false, v3733, v3734);
                                                                            end;
                                                                            if u155 == true then
                                                                                if p496.Devices.Computer == true or p496.Devices.Console == true then
                                                                                    p502.WalkSpeed = 0;
                                                                                    p502.JumpPower = 0;
                                                                                end;
                                                                                if Boosting == true then
                                                                                    v3547 = v3547 * 2.5;
                                                                                end;
                                                                                if v3644 <= 0.1875 then
                                                                                    v3547 = v3547 / 4;
                                                                                end;
                                                                                if BV ~= nil then
                                                                                    BV.MaxForce = BV.MaxForce:Lerp(v3549, v3547);
                                                                                end;
                                                                                if (p496.Gear.Hooks.Left.Hitbox ~= nil or p496.Gear.Hooks.Right.Hitbox ~= nil) and p496.Gear.Hooks.Left.Ending == false and p496.Gear.Hooks.Right.Ending == false and (p496.Gear.Hooks.Left.Position ~= nil or p496.Gear.Hooks.Right.Position ~= nil) then
                                                                                    local u156 = l__Hitbox__3636 ~= nil and l__Hitbox__3636.Position or nil;
                                                                                    local u157 = l__Hitbox__3637 ~= nil and l__Hitbox__3637.Position or nil;
                                                                                    local function v3737(p508, p509)
                                                                                        if p508 ~= nil and p509 ~= nil then
                                                                                            local l__Pointer__3738 = p509:FindFirstChild("Pointer");
                                                                                            if l__Pointer__3738 ~= nil then
                                                                                                local l__Value__3739 = l__Pointer__3738.Value;
                                                                                                if l__Value__3739 ~= nil then
                                                                                                    if p508 == "Left" then
                                                                                                        u156 = l__Value__3739.WorldPosition;
                                                                                                        return;
                                                                                                    end;
                                                                                                    if p508 == "Right" then
                                                                                                        u157 = l__Value__3739.WorldPosition;
                                                                                                    end;
                                                                                                end;
                                                                                            end;
                                                                                        end;
                                                                                    end;
                                                                                    v3737("Left", l__Hitbox__3636);
                                                                                    v3737("Right", l__Hitbox__3637);
                                                                                    if u156 == nil or u157 == nil then
                                                                                        if u156 ~= nil then
                                                                                            local v3740 = u156;
                                                                                            if not v3740 then
                                                                                                v3740 = false;
                                                                                                if u157 ~= nil then
                                                                                                    v3740 = u157;
                                                                                                end;
                                                                                            end;
                                                                                        else
                                                                                            v3740 = false;
                                                                                            if u157 ~= nil then
                                                                                                v3740 = u157;
                                                                                            end;
                                                                                        end;
                                                                                        u154 = v3740;
                                                                                    elseif u156 ~= nil and u157 ~= nil then
                                                                                        if u156 == u157 then
                                                                                            u154 = u156;
                                                                                        elseif u156 ~= u157 then
                                                                                            local v3741 = CFrameN(u156, u157);
                                                                                            u154 = (v3741 + v3741.LookVector * ((u156 - u157).Magnitude / 2)).Position;
                                                                                        end;
                                                                                    end;
                                                                                    Hooks.Midpoint = u154;
                                                                                end;
                                                                                local v3742 = CFrameN(0, 0, 0);
                                                                                local l__Magnitude__3743 = (u154 - p503.Position).Magnitude;
                                                                                local v3744 = u154 - p503.Position;
                                                                                local v3745 = u154 - p503.Position;
                                                                                if u154 == p503.Position then
                                                                                    v3744 = u154;
                                                                                end;
                                                                                if u154 == p503.Position then
                                                                                    v3745 = u154;
                                                                                end;
                                                                                local l__Unit__3746 = v3744.Unit;
                                                                                local l__Unit__3747 = v3745.Unit;
                                                                                local v3748 = l__Unit__3746:Cross(Vector3.new(0, 1, 0));
                                                                                local v3749 = l__Unit__3747:Cross(Vector3.new(0, 1, 0));
                                                                                local v3750 = v3748:Cross(l__Unit__3746);
                                                                                local v3751 = CFrame.fromMatrix(p503.Position, v3748, v3750);
                                                                                BV.MaxForce = BV.MaxForce:lerp(v3549, 0.4);
                                                                                BG.MaxTorque = Vector3.new(1000, 1000, 1000);
                                                                                BG.CFrame = CFrame.fromMatrix(p503.Position, v3749, (v3749:Cross(l__Unit__3747)));
                                                                                if l__State__3642 == true or LSState == true then
                                                                                    local v3752 = -1;
                                                                                elseif l__State__3643 == true or RSState == true then
                                                                                    v3752 = 1;
                                                                                else
                                                                                    v3752 = 0;
                                                                                end;
                                                                                if LSState == true or RSState == true then
                                                                                    local v3753 = CFrameN(p503.Position, (CFrameN(u154, (v3751 * CFrameN(v3752 * 50, 0, 0)).Position) * CFrameN(0, 0, -l__Magnitude__3743 + 10)).Position).LookVector * v3629;
                                                                                    if FState == true then
                                                                                        v3753 = v3753 * 1.35;
                                                                                    elseif BState == true then
                                                                                        v3753 = v3753 * -1.35;
                                                                                    elseif UState == true then
                                                                                        v3753 = v3753 + v3750 * v3629;
                                                                                    end;
                                                                                    BV.Velocity = BV.Velocity:lerp(v3753, v3547);
                                                                                elseif v3752 == 0 then
                                                                                    local v3754 = l__Unit__3746 * v3629;
                                                                                    if FState == true then
                                                                                        v3754 = v3754 * 1.35;
                                                                                    elseif BState == true then
                                                                                        v3754 = v3754 * -1.35;
                                                                                    elseif UState == true then
                                                                                        v3754 = v3754 + v3750 * v3629;
                                                                                    end;
                                                                                    BV.Velocity = BV.Velocity:lerp(v3754, v3547);
                                                                                elseif v3752 ~= 0 then
                                                                                    local v3755 = CFrameN(p503.Position, (CFrameN(u154, (v3751 * CFrameN(v3752, 0, 0)).Position) * CFrameN(0, 0, -l__Magnitude__3743 + 1)).Position).LookVector * v3629;
                                                                                    if FState == true then
                                                                                        v3755 = v3755 * 1.35;
                                                                                    elseif BState == true then
                                                                                        v3755 = v3755 * -1.35;
                                                                                    elseif UState == true then
                                                                                        v3755 = v3755 + v3750 * v3629;
                                                                                    end;
                                                                                    BV.Velocity = BV.Velocity:lerp(v3755, v3547);
                                                                                end;
                                                                            end;
                                                                        end;
                                                                    end;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end);
                    p496:Check(v3539, v3540);
                end)
            end
        end
    end
end


local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

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

for i = 5, 10, 1 do
    if game.PlaceId == whitelist[i] then -- any PvE area
        local Titans = Workspace:WaitForChild("Titans")

        local AN = Function:AddToggle({
            Name = "Always Nape",
            Default = true,
            Callback = function(bool) 
                -- OrionLib.Flags.AlwaysNape.Value = bool
                print(bool)
            end,
            Flag = "AlwaysNape",
            Save = true,
        })

        --[[ Function:AddToggle({
            Name = "Titan ESP",
            Default = true,
            Callback = function(bool)
                while OrionLib.Flags.TitanESP.Value do
                    for i2, v2 in pairs(Titans:GetChildren()) do
                        MHL(Color3.fromRGB(200, 90, 255), Color3.fromRGB(255, 119, 215), v2)
                    end
                    task.wait()
                end
            end,
            Flag = "TitanESP",
            Save = true
        }) ]]

        --[[ Keybinds:AddBind({
            Name = "Always Nape Keybind",
            Default = Enum.KeyCode.G,
            Hold = false,
            Callback = function() 
                OrionLib.Flags.AlwaysNape.Value = not OrionLib.Flags.AlwaysNape.Value
            end,
            Flag = "ANK",
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
                if method == "InvokeServer" and args[1] == "Slash" and OrionLib.Flags.AlwaysNape.Value then
                    args[3] = "Nape"
                    return OldNameCall(Self, unpack(args))
                end
            end
            return OldNameCall(Self, ...)
        end))

        task.spawn(function () -- anti-attack
            while task.wait() do
                local HRP = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if HRP:FindFirstChildOfClass("TouchTransmitter") then
                    HRP.TouchInterest:Destroy()
                end
            end
        end)
    end
end

Orion.Enabled = false

OrionLib:MakeNotification({
	Name = "Slient Mode",
	Content = "GUI is off by default, default keybind to toggle is RSHIFT",
	Image = "rbxassetid://4483345998",
	Time = 5
})

OrionLib:Init()
