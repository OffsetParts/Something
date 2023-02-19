-- Stuff to look into: Mondo Chick and Backpack Module
if not game:IsLoaded() then
    game.Loaded:Wait()
    if game.PlaceId ~= 1537690962 then return end
end 

local GSettings
if getgenv() and not getgenv()['BSS'] then
    getgenv()['BSS'] = {}               
    warn'Session env enabled'
    GSettings = getgenv()['BSS']
    local Template = {
        ['Anti-Flag'] = false,
        ['Webhook'] = '' -- put url here
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
local LocalCollect      = require(Storage:FindFirstChild'Collectors':WaitForChild'LocalCollect')
local ClientStatTools   = require(Storage:FindFirstChild'ClientStatTools')
local ClientStatCache   = require(Storage:FindFirstChild'ClientStatCache')
local Parachutes        = require(Storage:FindFirstChild'Parachutes')
local BlenderRecipes    = require(Storage:FindFirstChild'BlenderRecipes')
syn.set_thread_identity(7) 

local Flags = ClientStatCache:Get()['AntiCheat']
local ServerType = Workspace:FindFirstChild'ServerType'

local notRelease

--< Functions >-- 
function Webhook()
    local WebhookStuff = {
        ["embeds"] = {{
            ["title"] = "Flag Checker",
            ["description"] = "Successfully grabbed flags!",
            ["color"] = tonumber(0xAF0000),
            ["fields"] = {
                {
                    ["name"] = "`Username: " .. Player.Name .. "`",
                    ["value"] = "```CollectibleSusActions: " .. Flags["CollectibleSusActions"] .. "```",
                    ["value"] = "```6D05m: " .. Flags["6D05m"] .. "```",
                    ["value"] = "```f9*Kj: " .. Flags["f9*Kj"] .. "```",
                    ["value"] = "```uo#B2: " .. Flags["uo#B2"] .. "```",
                    ["value"] = "```z3$9k: " .. Flags["z3$9k"] .. "```",
                    ["value"] = "```CollectibleKicks: " .. Flags["CollectibleKicks"] .. "```",
                    ["value"] = "```w5lJ@i: " .. Flags["w5lJ@i"] .. "```",
                    ["value"] = "```FalseQuestActivations: " .. Flags["FalseQuestActivations"] .. "```"
                }
            }
        }}
    }

    local Request = (syn and syn.request) or (KRNL_LOADED and (http_request or request))
    
    pcall(function()
        Request({
            Url = GSettings['Webhook'],
            Method = 'POST',
            Headers = {
                ['content-type'] = 'application/json',
            },
            Body = game:GetService('HttpService'):JSONEncode(WebhookStuff)
        })
    end)
end

-- I could get all these values in GC but that just too messy

if Collectors then
    local CollectorsTable
    local uv 
    for i,v in pairs(Collectors) do
        if not uv then
            uv = getupvalues(v)
        else break end
    end
    for i2, v2 in next, uv[1] do
        if v2['Cooldown'] then
            v2['Cooldown'] = 0
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
    if not GSettings['Anti-Flag'] then
        task.spawn(function()
            while Flags == nil do
                task.wait(0.1)
                ClientStatCache:Update('AntiCheat')
            end

            while task.wait(1) do -- loops through and deletes any flags
                if Flags then
                    for i,v in pairs(Flags) do
                        Webhook()
                        ClientStatCache:Set(v,nil)
                        ClientStatCache:Set({"CollectibleSusActions", "6D05m", "f9*Kj", "uo#B2", "z3$9k", "w5lJ@i", "CollectibleKicks", "FalseQuestActivations"},nil)
                    end
                end
            end
        end)
        GSettings['Anti-Flag'] = true
    end
end

if GamePasses then -- pretty sure this is server-sided but still tryna see if it works
    local GIDS = {}
    local notRelease
    for i,v in pairs(require(Storage:FindFirstChild'RobuxDeals')) do
        if v.PassID ~= nil then
            GIDS[i] = v
        end
    end

    hookfunction(GamePasses.ValidateGamePasses, function(plr, p2)
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
    end)
end