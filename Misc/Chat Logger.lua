local Players = game:GetService("Players")
local Https = game:GetService('HttpService')

local _senv = getgenv() or _G
local Config = _senv.CH
local wh = Config.url

local hp = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or request or Https and Https.request

local launched = false
if not launched then
   local Embed = {
      ['title'] = 'Beginning of Chat logs in ' .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")",
      ['description'] = 'taken at '.. os.date("%x")
   }

   local a = hp({
      Url = wh,
      Headers = {['Content-Type'] = 'application/json'},
      Body = https:JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
      Method = "POST"
   })
   launched = true
end

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
task.spawn(function()
   for _, Player in pairs(Players:GetPlayers()) do
      task.wait(0.1)
      if Player ~= Players.LocalPlayer then
         logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Is in the server")
         Player.Chatted:Connect(function(Message)
            logMsg(Player.Name, Message)
         end) 
      end
   end
end)

-- Adds connection to new players
Players.PlayerAdded:Connect(function(Player)
   if Player ~= Players.LocalPlayer then
      logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", "Player has joined at " .. tostring(os.date("%c")))
      Player.Chatted:Connect(function(msg)
         logMsg(Player.DisplayName .. " (@" .. Player.Name .. ")", msg)
      end)
   end
end)