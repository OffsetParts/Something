if not game:IsLoaded() then
    game.Loaded:Wait()
end

local _senv = getgenv() or _G

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Https             = game:GetService("HttpService")

_senv.CH = {
    -- Setup
    Enable  = true, -- on/off
    url     = "" -- webhook url
}

local Config = _senv.CH
local switch = Config.Enable
local wh     = Config.url

local hp     = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request


-- if you wanna fuck all with the format of the message, https://discord-api-types.dev/api/discord-api-types-v10/interface/APIMessage
local launched = false
if not launched then
    local Intro = {
        ["title"] = "Beginning of Chat logs in " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")",
        ["description"] = "taken at " .. os.date("%x")
    }

    hp({
        Url = wh,
        Headers = {["Content-Type"] = "application/json"},
        Body = Https:JSONEncode({["embeds"] = {Intro}, ["content"] = ""}),
        Method = "POST"
    })
    launched = true
end

local function logMsg(Identifier, Message, Channel)
    if switch then
        local Embed = {
            ["title"] = 'Message Logger v2',
			["author"] = Identifier
            ["description"] = Message .. " | " .. Channel
			["footer"] = {
				["text"] = os.date("%X"),
				["icon_url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=".. Identifier.UserId .."&width=350&height=350&format=png"
			}
        }
		if not Channel then
            Embed['description'] = Message
        end
        hp({
            Url = wh,
            Headers = {["Content-Type"] = "application/json"},
            Body = Https:JSONEncode({["embeds"] = {Embed}, ["content"] = ""}),
            Method = "POST"
        })
    end
end

local Connections = {}

-- Attach to already existing players
task.spawn(function()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer then
            logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player already in game") -- log that they are already in game
            local connection = ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data) -- now log their messages
				local plr = Players[Data.FromSpeaker]
				local Message = Data.Message
				local Channel = Data.OriginalChannel

				logMsg(plr.DisplayName .. " (@" .. plr.Name .. ")", Message, Channel)
			end)
            Connections[Player.Name] = connection
        end
    end
end)

-- Adds connection to new players
Players.PlayerAdded:Connect(function(Player)
    if Player ~= Players.LocalPlayer then
        logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player has joined at " .. tostring(os.date("%c"))) -- log they have joiend
        local connection = ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data) -- now log their messages
            local plr = Players[Data.FromSpeaker]
            local Message = Data.Message
            local Channel = Data.OriginalChannel

            logMsg(plr.DisplayName .. " (@" .. plr.Name .. ")", Message, Channel)
        end)
        Connections[Player.Name] = connection
    end
end)

Players.PlayerRemoving:Connect(function(Player)
    logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player has left at " .. tostring(os.date("%c"))) -- log they have left
    Connections[Player.Name]:Disconnect()
    Connections[Player.Name] = nil
end)