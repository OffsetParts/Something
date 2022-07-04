local Players = game:GetService("Players")
local Config = config.CH
local wh = Config.url

local https = game:GetService('HttpService')
local hp = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or request or https and https.request

local Embed = {
	['title'] = 'Beginning of Message logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. " (" .. game.PlaceId .. ")",
   ['description'] = 'taken at '.. tostring(os.date("%m/%d/%y")
}

local a = hp({
   Url = wh,
   Headers = {['Content-Type'] = 'application/json'},
   Body = https:JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
   Method = "POST"
})

function logMsg(Identifier, Message)
   local MessageEmbed = {
	   ['title'] = Identifier, ['description'] = Message
   }
   local b = hp({
	   Url = wh,
	   Headers = {['Content-Type'] = 'application/json'},
	   Body = https:JSONEncode({['embeds'] = {MessageEmbed}, ['content'] = ''}),
	   Method = "POST"
   })
end

-- Attach to already existing players
for i, plr in pairs(Players:GetPlayers()) do
	logMsg(plr.Name, " Is in the server")
   plr.Chatted:Connect(function(msg)
	   logMsg(plr.Name.." {" .. plr.DisplayName .. "}", msg)
   end)
end

-- On Player Join Message
Players.PlayerAdded:Connect(function(plr)
   logMsg(plr.Name.." {" .. plr.DisplayName .. "}", "Player has joined at " .. tostring(os.date("%m/%d/%y"))
end)

-- Adds connection to new players
Players.PlayerAdded:Connect(function(plr)
   plr.Chatted:Connect(function(msg)
	   logMsg(plr.Name.." {" .. plr.DisplayName .. "}", msg)
   end)
end)
