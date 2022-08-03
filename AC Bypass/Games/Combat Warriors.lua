local Nevermore = require(game.ReplicatedStorage.Framework.Nevermore)
local Lookup = rawget(Nevermore, '_lookupTable')
local function GetModule(Name)
   local Module = rawget(Lookup, Name)

   if Module then
       return require(Module)
   end
end


local Anticheat = GetModule('AntiCheatHandler')
local ClientAnticheat = GetModule('AntiCheatHandlerClient')
local NotificationHandler = GetModule('CoreGuiHandlerClient')

local SendNotification
if NotificationHandler then
   SendNotification = rawget(NotificationHandler, 'sendNotification')
end


if Anticheat then
   local Punish = rawget(Anticheat, 'punish')
   if Punish then
       if SendNotification then
           SendNotification({
               Title = '[BYPASS] Client anticheat hooked',
               Text = 'All non-server punishments will be subverted'
           })
       end

       hookfunction(Punish, function(Player, Info, Callback)
           print('Punishment attempted')

           if Info and type(Info) == 'table' then
               table.foreach(Info, warn)
           else
               warn('No extra info')
           end
       end)
   end
end

if ClientAnticheat then
   local CreateNotification = rawget(ClientAnticheat, 'createNotification')
   if CreateNotification then
       hookfunction(CreateNotification, function(MessageInfo)
           return SendNotification({
               Title = '[BYPASS] Server anticheat caught you',
               Text = 'Hooking cannot stop the server'
           })
       end)
   end
end