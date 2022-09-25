local BlockedRemotes = {
    "StartFallDamage",
    "TakeFallDamage"
}

local Events = {
    Fire = true, 
    Invoke = true, 
    FireServer = true, 
    InvokeServer = true,
}

local gameMeta = getrawmetatable(game)
local psuedoEnv = {
    ["__index"] = gameMeta.__index,
    ["__namecall"] = gameMeta.__namecall;
}


local oldindex oldindex = hookmetamethod(game, '__index', newcclosure(function(Self, Index)
    if Events[Index] then
        for i,v in pairs(BlockedRemotes) do
            print(Self.Name, Index)
            if v == Self.Name and not checkcaller() then print'blocked' return nil end
        end
    end
    return oldindex(Self, Index)
end))

local oldNamecall oldNamecall = hookmetamethod(game, '__namecall', newcclosure(function(Self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if Events[method] then
        for i,v in pairs(BlockedRemotes) do
            print(Self.Name, method)
            if v == Self.Name and not checkcaller() then print'blocked' return nil end
        end
    end
    return oldNamecall(Self, ...)
end))