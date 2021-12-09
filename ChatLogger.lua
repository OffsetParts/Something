if CH then
local embed1 = {
	['title'] = 'Beginning of Message logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. "(" game.PlaceId .. ")".. " at "..tostring(os.date("%m/%d/%y"))
}

local a = syn.request({
   Url = wh,
   Headers = {['Content-Type'] = 'application/json'},
   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {embed1}, ['content'] = ''}),
   Method = "POST"
})

Players = game:GetService("Players")

function logMsg(webhook, Player, Message)
   local embed = {
       ['description'] = Player..": "..Message
   }
   local a = syn.request({
       Url = wh,
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
   logMsg(wh, plar.Name, "Player has joined")
end)

Players.PlayerAdded:Connect(function(plr)
   plr.Chatted:Connect(function(msg)
       logMsg(wh, plr.Name, msg)
   end)
end)
elseif CH and wh ~= true then
	logs("false alarm")
end
