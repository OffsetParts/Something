local Players = game:GetService("Players")
local Config = config.CH

local http_request = http_request;
local c = identifyexecutor()

if syn then
	http_request = syn.request
elseif c == "ScriptWare" then
	http_request = http.request
end	

local Embed = {
	['title'] = 'Beginning of Message logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(place).Name) .. " (" .. place .. ")".. " at "..tostring(os.date("%m/%d/%y"))
}

local a = http_request({
   Url = Config.wh,
   Headers = {['Content-Type'] = 'application/json'},
   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
   Method = "POST"
})

function logMsg(webhook, Player, Message)
   local MessageEmbed = {
	   ['description'] = Player..": ".. Message
   }
   local b = http_request({
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
