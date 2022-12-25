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


if Anticheat then -- Client Anticheat how the server will send signal to punish the user <kick, ban, etc>
    local Punish = rawget(Anticheat, 'punish')
    if Punish then
        hookfunction(Punish, function(Player, Info, Callback) -- anti punish (kick, ban) | Client only, game only server check is TP and thats ez to bypass
            return
        end)
    end

    hookfunction(Anticheat['getIsBodyMoverCreatedByGame'], function(BodyMover)
        return true
    end)
end

if ClientAnticheat then -- when the server does the punishment itself, it will send a notification this is typically for tp detection(magnitude checks), nothing serious
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