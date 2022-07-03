local Players = game:GetService("Players")
local Config = config.CH

local hp;
local https = game:GetService('HttpService')

if syn then 
	hp = syn.request
elseif identifyexecutor() then
	hp = http.request
else
	hp = https.request
end

local Embed = {
	['title'] = 'Beginning of Message logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. " (" .. game.PlaceId .. ")".. " at "..tostring(os.date("%m/%d/%y"))
}

local a = hp({
   Url = Config.wh,
   Headers = {['Content-Type'] = 'application/json'},
   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
   Method = "POST"
})

function logMsg(webhook, Player, Message)
   local MessageEmbed = {
	   ['description'] = Player..": ".. Message
   }
   local b = hp({
	   Url = Config.wh,
	   Headers = {['Content-Type'] = 'application/json'},
	   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {MessageEmbed}, ['content'] = ''}),
	   Method = "POST"
   })
end

-- Attach to already existing players
for i,v in pairs(Players:GetPlayers()) do
	logMsg(Config.wh, v.Name, " Is in the server")
   v.Chatted:Connect(function(msg)
	   logMsg(Config.wh, v.Name.." {" .. v.DisplayName .. "}", msg)
   end)
end

-- On Player Join Message
Players.PlayerAdded:Connect(function(plr)
   logMsg(Config.wh, plr.Name.." {" .. plr.DisplayName .. "}", "Player has joined")
end)

-- Adds log for new players
Players.PlayerAdded:Connect(function(plr)
   plr.Chatted:Connect(function(msg)
	   logMsg(Config.wh, plr.Name.." {" .. plr.DisplayName .. "}", msg)
   end)
end)
