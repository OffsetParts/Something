if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Https             = game:GetService("HttpService")

-- Setup
_senv.CH = {
    Enable      = true, -- on/off
	Perferences = {
        Existed  = true,
		Joins 	 = false,
		Messages = true,
		Leaves   = false
	},
    webhook     = "", -- webhook url,
	launched    = false,
}

local function Notify(txt, debug) -- Template support
    if Notifier then
        Notifier("CH: " .. txt, debug) -- add CH tag
	else
		warn("CH: " .. txt)
    end
end

local Settings 		= _senv.CH
local Enabled 		= Settings.Enable
local wh     		= Settings.webhook
local leche  		= Settings.launched
local Perferences	= Settings.Perferences

local hp        = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request

local gameData  = game:HttpGetAsync("https://thumbnails.roblox.com/v1/assets?assetIds=".. game.PlaceId .. "&size=728x90&format=Png&isCircular=false")
local formatted = Https:JSONDecode(gameData) -- turn into table

-- if you wanna fuck all with the format of the message, https://discord-api-types.dev/api/discord-api-types-v10/interface/APIMessage
if not leche then
    local Intro = {
		['thumbnail'] = {
			['height'] = 728,
			['width'] = 90,
			['url'] = formatted['data'][1]['imageUrl']
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
    leche = true
end
Notify('launched', true)

local function logMsg(Identifier, Message, Channel)
	if not Channel then Channel = '' end
	local playerData = game:HttpGetAsync("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=".. Identifier.UserId .. "&size=50x50&format=Png&isCircular=false")
	local array = Https:JSONDecode(playerData)
    if Enabled then
        local Log = {
            -- ["title"] = 'Message Logger V3',
			['author'] = {
				['icon_url'] = array['data'][1]['imageUrl'],
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
	Notifiy(' CH: Chat module missing, script ended', false)
end


task.spawn(function()
    for _, Player in pairs(Players:GetPlayers()) do
        if Perferences.Existed then
            logMsg(Player, "Player already in game")
        end
    end
end)
Notify('connections to existing players', true)

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