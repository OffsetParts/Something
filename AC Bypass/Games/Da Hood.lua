    -- // Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Vars
local tablefind = table.find
local MainEvent = ReplicatedStorage.MainEvent
local SpoofTable = {
    WalkSpeed = 16,
    JumpPower = 50
}

-- // Configuration
local Flags = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime"
}

-- // __namecall hook
local OldNameCall = nil

OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Self, Key = ...
    local method = getnamecallmethod()
    local caller = getcallingscript()

    -- // See if the game is trying to alert the server
    if (method == "FireServer" and Self == MainEvent and tablefind(Flags, Key) then
        return
    end

    -- // Anti Crash
    if (not checkcaller() and getfenv(2).crash) then
        -- // Hook the crash function to make it not work
        hookfunction(getfenv(2).crash, function()
            warn("Crash Attempt")
        end)
    end

    return OldNameCall(...)
end))

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(...)
    local self, prop = ...
    -- // Make sure it's trying to get our humanoid's ws/jp
    if (not checkcaller() and self:IsA("Humanoid") and (prop == "WalkSpeed" or prop == "JumpPower")) then
        -- // Return spoof values
        return SpoofTable[prop]
    end

    -- //
    return __index(...)
end))

local oldNewIndex
oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(...)
    local self, prop, value = ...
    -- // Make sure it's trying to set our humanoid's ws/jp
    if (not checkcaller() and self:IsA("Humanoid") and (prop == "WalkSpeed" or prop == "JumpPower")) then
        -- // Add values to spoof table
        SpoofTable[prop] = value

        -- // Disallow the set
        return
    end
    
    -- //
    return __newindex(...)
end))

