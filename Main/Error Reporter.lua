if not game:IsLoaded() then game.Loaded:Wait() end

local _genv = getgenv or _G

local Config = config.ER
local mode = Config.mode
local types = Config.types
local wh = Config.wh

-- Configure this shit with template

local hp;
local https = game:GetService('HttpService')

if syn then 
	hp = syn.request
elseif identifyexecutor() then
	hp = http.request
else
	hp = https.request
end

local launched = false;

local function pr(txt)
	if (syn or iskrnlclosure or identifyexecutor) then
		if launched == false then -- Opening sequence | Console
			rconsoleprint('@@RED@@')
			rconsolewarn('Beginning of Console: ' .. os.time() .. ' | gameId: ' .. place)
			rconsoleprint('@@WHITE@@')
			rconsoleprint('\n \n')
			launched = true
		end

		rconsoleprint(txt .. '\n')
	end
end

if Config.on and mode == 'wh' then
	local Embed = { -- Opening sequence | Webhook
		['title'] = 'Beginning of Logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(place).Name) .. " (" .. place .. ") ".. "at "..tostring(os.date("%m/%d/%y"))
	}

	local a = hp({
		Url = wh,
		Headers = {['Content-Type'] = 'application/json'},
		Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
		Method = "POST"
	})
end


-- Prints
if types.prints == true then
	getgenv().print = function(text) -- hooks to game env <type> signal
		if mode == 'wh' then
			local response = hp(
			   {
				   Url = wh,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Print > " .. text)})
			   }
			);
		elseif mode == 'cli' then
			pr(text)
		end
	end
end

-- Warns
if types.warns == true then
	getgenv().warn = function(text)
		if mode == 'wh' then
			local response = hp(
			   {
				   Url = wh,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Warn > "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." ( "..tostring(game.GameId).." ): "..text)})
			   }
			);
		elseif mode == 'cli' then
			pr(text)
		end
	end
end

-- Errors
if types.errors == true then
	getgenv().error = function(text)
		if mode == 'wh' then
			local response = hp(
				{
					Url = wh,
					Method = 'POST',
					Headers = {
						['Content-Type'] = 'application/json'
					},
					Body = game:GetService('HttpService'):JSONEncode({content = tostring("Error > "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." ( "..tostring(game.GameId).." ): "..text)})
				}
			);
		elseif mode == 'cli' then
			pr(text)
		end
	end
end