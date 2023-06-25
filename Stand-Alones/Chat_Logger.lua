if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

local Settings
_senv.CL = _senv.CL or {
    Enable       	= true,
    url     	 = "", -- wh url,
	launched     = false,
	Perferences  = { -- Logs when: 
        Existed  = true, -- player is already in game
		Joins 	 = true, -- player joins
		Messages = true, -- player messages'
		Leaves   = true  -- player leave
	},
	Cache = {}
}

local Settings = _senv.CL local Enabled, wh, launched, Perferences, Cache = Settings.Enable, Settings.webhook, Settings.launched, Settings.Perferences, Settings.Cache

local function Notify(txt, debug)
	local time = os.clock()
	task.spawn(function()
		if Notifier and pcall(function() repeat task.wait() until Notifier and os.clock() - time > 1 end) then then
			Notifier("CL: " .. txt, debug)
		elseif debug then
			warn("CL: " .. txt)
		end
	end)
end

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Https             = game:GetService("HttpService")

local hp = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request

local format = Https:JSONDecode(game:HttpGetAsync("https://thumbnails.roblox.com/v1/assets?assetIds=".. game.PlaceId .. "&size=728x90&format=Png&isCircular=false")) -- turn into table

-- if you wanna fuck all with the format of the message, https://discord-api-types.dev/api/discord-api-types-v10/interface/APIMessage
if not launched then
    local Intro = {
		['thumbnail'] = {
			['height'] = 728,
			['width'] = 90,
			['url'] = format['data'][1]['imageUrl']
		},
		['url'] = "https://www.roblox.com/games/".. game.PlaceId .."/",
        ["title"] = "Message Logger V3 | ".. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "(" .. game.PlaceId .. ")",
        ["description"] = "taken at " .. os.date("%b %d, %Y %I:%M:%S %p - %Z")
    }

    hp({
        Url = wh,
        Headers = {["Content-Type"] = "application/json"},
        Body = Https:JSONEncode({
			["embeds"] = {Intro}
		}),
        Method = "POST"
    })
    launched = true
	Notify('launched', true)
else
	return
end


local function logMsg(Identifier, Message, Channel)
	if not Channel then Channel = '' end
	local playerTD = Https:JSONDecode(game:HttpGetAsync("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=".. Identifier.UserId .. "&size=50x50&format=Png&isCircular=false"))
    if Enabled then
        local Log = {
            -- ["title"] = 'Message Logger V3',
			['author'] = {
				['icon_url'] = playerTD['data'][1]['imageUrl'],
				['name'] = Identifier.DisplayName .. " (@" .. Identifier.Name .. ")"
			},
            ["description"] = Message,
			["footer"] = {
				["text"] = Channel .." > " .. os.date("%b %d, %Y %I:%M:%S %p")
			} 
        }
		task.spawn(function()
			hp({
				Url = wh,
				Headers = {["Content-Type"] = "application/json"},
				Body = Https:JSONEncode({
					["embeds"] = {Log}
				}),
				Method = "POST"
			})
		end)
    end
end

if ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") then
	ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data)
		if Perferences.Messages then
			local Player  = Players:FindFirstChild(Data.FromSpeaker)
			local Message = Data.Message
			local Channel = Data.OriginalChannel

			if Player then logMsg(Player, Message, Channel) end
		end
	end)
else
	Notify('Chat module missing, script ended', false)
	return
end


task.spawn(function()
    for _, Player in pairs(Players:GetPlayers()) do
        if Perferences.Existed then
            logMsg(Player, "Player already in game")
        end
    end
	Notify('connections to existing players', true)
end)

-- Adds connection to new players
Players.PlayerAdded:Connect(function(Player)
    if Perferences.Joins then
        logMsg(Player, "Player has joined the game")
    end
end)
Notify('connection to new players', true)

Players.PlayerRemoving:Connect(function(Player)
    if Perferences.Leaves then
        logMsg(Player, "Player has left the game")
    end
end)
Notify('connection to removing players', true)