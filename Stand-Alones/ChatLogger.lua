if not game:IsLoaded() then game.Loaded:Wait() end
local _senv  = getgenv() or _G

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Https = game:GetService('HttpService')

_senv.CH = { -- Setup
   Enable = true, -- on/off
	url = '' -- webhook url
}

local Config = _senv.CH
local switch = Config.Enable
local wh     = Config.url

local hp     = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request

local launched = false
if not launched then
   local Embed = {
      ['title'] = 'Beginning of Chat logs in ' .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")",
      ['description'] = 'taken at '.. os.date("%x")
   }

   hp({
      Url = wh,
      Headers = {['Content-Type'] = 'application/json'},
      Body = Https:JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
      Method = "POST"
   })
   launched = true
end

local function logMsg(Identifier, Message, Channel)
   if switch then
      print'logged'
      if not Channel then Channel = "" end
      local Embed = {
         ['title'] = Identifier, ['description'] = Message .. " | " .. Channel
      }
      hp({
         Url = wh,
         Headers = {['Content-Type'] = 'application/json'},
         Body = Https:JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
         Method = "POST"
      })
   end
end

-- Attach to already existing players
task.spawn(function()
   for _, Player in pairs(Players:GetPlayers()) do
      task.wait(0.1)
      if Player ~= Players.LocalPlayer then
         logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player already in game") -- log that they are already in game
         ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data) -- now log their messages
            local Player  = Players[Data.FromSpeaker]
            local Message = Data.Message
            local Channel = Data.OriginalChannel

            logMsg(Player, Message, Channel)
         end) 
      end
   end
end)

-- Adds connection to new players
Players.PlayerAdded:Connect(function(Player) -- connect new players
   if Player ~= Players.LocalPlayer then
      logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player has joined at " .. tostring(os.date("%c"))) -- log they have joiend
      ReplicatedStorage.DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(Data) -- now log their messages
         local Player = Players[Data.FromSpeaker]
         local Message = Data.Message
         local Channel = Data.OriginalChannel
         
         logMsg(Player, Message, Channel)
      end)
   end
end)