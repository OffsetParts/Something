local ReplicatedStorage = game:GetService('ReplicatedStorage')

local REs = {}
local Nevermore = require(ReplicatedStorage.Framework:WaitForChild("Nevermore"))

local Lookup = rawget(Nevermore, '_lookupTable')
local function GetModule(Name)
   local Module = rawget(Lookup, Name)

    if Module then
        if Module.Name ~= Name then
            Module.Name = Name
        end
        return require(Module)
    end
end

for _,c in pairs(Lookup) do -- name modules
    if c then GetModule(_) end
end

for i,v in pairs(getgc(true)) do -- name remotes
    if typeof(v) == 'table' then
        if rawget(v, 'Remote') then
            if v.Remote then
                -- v.Remote.Name = v.Name
                REs[v.Name] = v.Remote
            end 
        end
    end
end