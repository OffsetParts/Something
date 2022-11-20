-- Gonna start leaving Update logs

-- 11/13/2022 - Updated and extensified the bypass
local removeMaxSpeed = true -- remove the max speed limit | Viechles

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local PlayerModels = Workspace:FindFirstChild("PlayerModels") -- All player stuff | cars, items, etc

-- Version Check
local Anticheat_Env = getsenv(LP.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript)
local Anticheat_Version = "5dc9a659a92f93012e2ee532ea8d785e192aff0b1fd2d85306a831057d00292d8f500959aed33c5378b5c94c52ec9914"

-- for i,v in pairs(Anticheat_Env) do
--     print("[ENV]", i,v, typeof(v))
-- end

if getscripthash(LP.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript) ~= Anticheat_Version then
    print("Anticheat Updated")
    -- return | Anticheat doesn't really change much
end

-- BypassCounter
local Bypass_Count = 0
local BanAverted

if ReplicatedStorage.Interaction:FindFirstChild("Ban") then -- Disable connection to when we are to change its ancestry or delete it.
    task.spawn(function()
        for _, v in next, getconnections(ReplicatedStorage.Interaction.Ban.AncestryChanged) do
            if pcall(function()
                v:Disable(v)
            end) then
                Bypass_Count += 1
                BanAverted = true
                ReplicatedStorage.Interaction.Ban:Destroy()
                print("Ban Remote Disabled")
            end
        end
    end)
end

if PlayerModels then -- changing the connection doesn't fire anything but i just wanna make sure
    task.spawn(function()
        for _, c in next, getconnections(PlayerModels.ChildAdded) do -- disable for new items
            if pcall(function()
                c:Disable(c)
            end) then
                Bypass_Count += 1
            end
        end
        for i, v in pairs(PlayerModels:GetChildren()) do
            if v:FindFirstChild("Configuration") and v.Configuration:FindFirstChild("MaxSpeed") then
                for _2, c2 in next, getconnections(v.Configuration.MaxSpeed.Changed) do -- disable for already loaded items
                    if pcall(function()
                        c2:Disable(c2)
                    end) then
                        Bypass_Count += 1
                        print("Raised max speed limit")
                    end
                end
                v.Configuration.MaxSpeed.Value = 2.5
            end
        end
    end)
end

if LP:FindFirstChildOfClass("Backpack") then -- tries to detect if we add HopperBins to our backpack
    task.spawn(function()
        for _, v in next, getconnections(LP.Backpack.ChildAdded) do
            if pcall(function()
                v:Disable(v)
            end) then
                Bypass_Count += 1
                print("Disabled inventory check")
            end
        end
    end)
end

if Workspace:FindFirstChild("Water") then -- He has it here but it does nothing will keep commented for now
    task.spawn(function()
        for i, v in next, Workspace.Water:GetChildren() do
            if v:IsA'Part' then
                for _, c in next, getconnections(v.Changed) do
                    if pcall(function()
                        c:Disable(c)
                    end) then
                        Bypass_Count += 1
                        -- print("Disabled water parts check")
                    end
                end
            end
        end
    end)
end


if Workspace:FindFirstChild("Region_MazeCave") then
    task.spawn(function()
        for i, v in next, Workspace.Region_MazeCave:GetChildren() do
            if v:IsA'Part' and v.Locked and BanAverted then
                -- print("[LOCKED]", v.Name)
                for _, c in next, getconnections(v.Changed) do
                    print(Bypass_Count)
                    if pcall(function()
                        c:Disable(c)
                    end) then
                        v.Locked = false
                        Bypass_Count += 1
                        print("Disabled maze unlock check")
                    end
                end
            end
        end
    end)
end



-- Hook Ban Function
hookfunction(Anticheat_Env.ban, function(...)
    -- print'client tried to ban'
    return
end)

hookfunction(Anticheat_Env.backpackClean, function(...) -- this for some reason deletes other players backups | Possible can grab other players items
    -- print'Backpack clear called'
    return
end)

print("Hooked Functions")

-- AntiKick / AntiLog / AntiDamage
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(...)
    local Self, Key = ...
    local method = getnamecallmethod()
    local callingscript = getcallingscript()

    if not checkcaller() then
        if Self.Name == 'AddLog' then
            -- print('logs fired')
            return
        end
        if Self.Name == 'Ban' then
            return
        end
        if Self.Name == 'DamageHumanoid' then
            return
        end
        if getnamecallmethod() == 'Kick' then
            return
        end
    end
    return OldNameCall(...)
end)

print("Namecall Hooked")

-- Finished
warn('Successfully Bypassed Anticheat', Bypass_Count)