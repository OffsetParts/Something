local Lookup = rawget(require(game.ReplicatedStorage.Framework.Nevermore), '_lookupTable')
local function GetModule(Name) 
    local Module = rawget(Lookup, Name) 
    if Module then return require(Module) end
end

local Anticheat = GetModule('AntiCheatHandler')
local ClientAnticheat = GetModule('AntiCheatHandlerClient')
local NotificationHandler = GetModule('CoreGuiHandlerClient')

local SendNotification
if NotificationHandler then
    SendNotification = rawget(NotificationHandler, 'sendNotification')
end

if Anticheat then -- Client Anticheat will send a signal<kick, ban, etc> to punish the user 
    local Punish = rawget(Anticheat, 'punish')
    if Punish then
        hookfunction(Punish, function(Player, Info, Callback)
            return
        end)
    end

    hookfunction(Anticheat['getIsBodyMoverCreatedByGame'], function(BodyMover)
        return true
    end)
end

if ClientAnticheat then -- when the server does a punishment, it will send a notification aswell this is typically for tp detection(magnitude/position checks) for hit and fall regs, nothing serious
    local CreateNotification = rawget(ClientAnticheat, 'createNotification')
    if CreateNotification then
        hookfunction(CreateNotification, function(MessageInfo)
            return SendNotification({
                Title = 'Server anticheat caught you',
                Text = 'Teleporting too far will cause this'
            })
        end)
    end
end