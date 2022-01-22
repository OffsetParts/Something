Players = game:GetService("Players")
local place = game.placeId

local http_request = http_request;
local c = identifyexecutor()
local http = game:GetService('HttpService')

if syn then
	http_request = syn.request
elseif c == "ScriptWare" then
	http_request = http:RequestAsync()
end	

if Settings.CH.on == true then
	local Embed = {
		['title'] = 'Beginning of Message logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(place).Name) .. " (" .. place .. ")".. " at "..tostring(os.date("%m/%d/%y"))
	}

	local a = http_request({
	   Url = wh,
	   Headers = {['Content-Type'] = 'application/json'},
	   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
	   Method = "POST"
	})

	function logMsg(webhook, Player, Message)
	   local MessageEmbed = {
		   ['description'] = Player..": ".. Message
	   }
	   local a = http_request({
		   Url = wh,
		   Headers = {['Content-Type'] = 'application/json'},
		   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {MessageEmbed}, ['content'] = ''}),
		   Method = "POST"
	   })
	end

	-- Post players already in servers
	for i,v in pairs(Players:GetPlayers()) do
		logMsg(wh, v.Name, " Is in the server")
	   v.Chatted:Connect(function(msg)
		   logMsg(wh, v.Name.." {" .. v.DisplayName .. "}", msg)
	   end)
	end

	-- On Player Join Message
	Players.PlayerAdded:Connect(function(plr)
	   logMsg(wh, plr.Name, "Player has joined")
	end)

	-- Adds log for new players
	Players.PlayerAdded:Connect(function(plr)
	   plr.Chatted:Connect(function(msg)
		   logMsg(wh, plr.Name.." {" .. plr.DisplayName .. "}", msg)
	   end)
	end)

	-- On Player leave Message
	Players.PlayerRemoving:Connect(function(plr)
	    logMsg(wh, plr.Name, "Player has Left")
	end)
else
	logs("Logger Disabled")
end
