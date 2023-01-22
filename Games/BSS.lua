-- Stuff to look into: Mondo Chick and Backpack Module
if not game:IsLoaded() then
    game.Loaded:Wait()
    if game.PlaceId ~= 1537690962 then return end
end 

local GSettings
if getgenv() then
    if not getgenv()['BSS'] then getgenv()['BSS'] = {} warn'Session env enabled' end
    GSettings = getgenv()['BSS']
    local Template = {
        ['Anti-Flag'] = false,
    }

    for i,v in next, Template do
        if not GSettings[i] then
            GSettings[i] = v
        end
    end
end

local Players   = Services.Players
local Marketing = Services.MarketplaceService
local Storage   = Services.ReplicatedStorage
local Workspace = Services.Workspace

local Player = Players.LocalPlayer

syn.set_thread_identity(2)
-- Server
local StatTools         = require(Storage:FindFirstChild'StatTools')
local GamePasses        = require(Storage:FindFirstChild'GamePasses')

-- Client
local Collectors        = require(Storage:FindFirstChild'Collectors')
local LocalCollect      = require(Storage:FindFirstChild'Collectors':FindFirstChild'LocalCollect')
local ClientStatTools   = require(Storage:FindFirstChild'ClientStatTools')
local ClientStatCache   = require(Storage:FindFirstChild'ClientStatCache')
local Parachutes        = require(Storage:FindFirstChild'Parachutes')
local BlenderRecipes    = require(Storage:FindFirstChild'BlenderRecipes')
syn.set_thread_identity(7) 

local ServerType = Workspace:FindFirstChild'ServerType'

-- I could get all these values in GC but that just too messy

if Collectors then
    local CollectorsTable
    for i,v in pairs(Collectors) do
        local uv = getupvalues(v)
        for i2,v2 in next, uv[1] do
            for i3,v3 in next, v2 do
                if i3 == 'Cooldown' then v3 = 0.1 end
                if i3 == 'Power' and typeof(i3) == 'number' then v3 = 2 end
                -- if i3 == 'Stamp' then v3 = "Line8" end
                warn(i3,v3)
            end
        end
    end
end

if LocalCollect then
    LocalCollect.HasCapacity = function()
        return true
    end
end

if BlenderRecipes then -- modify blender recipes
    local Recipes
    for i,v in pairs(BlenderRecipes) do
        local uv = getupvalues(v)
        if rawget(uv[1], 'Oil') then
            Recipes = uv[1]
            break
        end
    end
    for i2, v2 in next, Recipes do
        -- warn('Recipes', i2)
        for i3, v3 in next, v2 do
            if i3 == 'Time' then v3 = 1 end
            if i3 == 'AutoCompletePerTicket' then v3 = 0 end
            if i3 == 'Requirements' then v3 = {} end
            if i3 == 'Ingredients' then 
                for i4, v4 in next, v3 do
                    for i5, v5 in next, v4 do
                        -- warn(i5, v5, typeof(v5))
                        if i5 == 'Amount' then v5 = 1 end
                    end
                end
            end
        end
    end
end

if ClientStatTools then -- Modify how stats are handled
    ClientStatTools.HasItem = function() return true end
    ClientStatTools.HasBadge = function() return true end
end

if Parachutes then -- Modify Parachutes Stats
    task.spawn(function()
        local ParaTable
        for i, v in pairs(Parachutes) do
            local uv = getupvalues(v)
            if rawget(uv[1], 'Glider') then
                ParaTable = uv[1]
                break
            end
        end
        if ParaTable then
            for i,v in pairs(ParaTable) do
                -- warn(i,v)
                if v['Speed'] then
                    v.Speed = 100
                    v.Float = 30
                    v.Cost  = 0
                end
            end
        end
    end)
end

if ClientStatCache then
    local Flags = ClientStatCache:Get()['Flags']

    if not GSettings['Anti-Flag'] then
        task.spawn(function()
            while task.wait(2) do -- loops through and deletes any flags
                if Flags['ServerSide'] then
                    for i,v in pairs(Flags['ServerSide']) do
                        print("Flags:", i,v,typeof(v))
                        v:Set(v,nil)
                        v:Set({"Eggs","CheaterFlag"},nil)
                    end
                end
            end
        end)
        GSettings['Anti-Flag'] = true
    end
end

if GamePasses then -- pretty sure this is server-sided but still tryna see if it works
    local notRelease
    local GIDS = {}

    for i,v in pairs(require(Storage:FindFirstChild'RobuxDeals')) do
        if v.PassID ~= nil then
            --[[ print(i,v,typeof(v))
            warn'---------------------------------' ]]
            GIDS[i] = v
            --[[ for i2,v2 in pairs(v) do
                print(i2,v2,typeof(v2))
            end
            warn'---------------------------------' ]]
        end
    end

    GamePasses.ValidateGamePasses = function(plr, p2)
        if not p2.RobuxPurchases then
            p2.RobuxPurchases = {}
        end
        if ServerType ~= 'Release' then
            notRelease = game.PlaceId ~= 1537690962 -- true
        else
            notRelease = false
        end
        for i2, v2 in pairs(GIDS) do
            local ifHas
            local succ, err = pcall(function() 
                ifHas = true --Marketing:UserOwnsGamePassAsync(plr.UserId, v2.PassID) 
            end)
            if notRelease or succ and ifHas then
                p2.RobuxPurchases[i2] = 1;
                GamePasses.ApplyEffect(plr, i2, p2)
            else
                p2.RobuxPurchases[i2] = nil;
            end
        end
    end
end

warn'success'