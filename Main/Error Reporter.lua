if not game:IsLoaded() then game.Loaded:Wait() end

local Config = Settings.ER
local mode = Config.mode
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
	if launched == false then -- Opening sequence | Console
		rconsoleprint('@@RED@@')
		rconsoleprint('Beginning of Console reporter: ' .. os.time() .. ' | gameId: ' .. place .. '\n')
		rconsoleprint('@@WHITE@@')
		rconsoleprint('\n')
		rconsoleprint('\n')
		launched = true
	end

	if (syn or iskrnlclosure or identifyexecutor) then
		rconsoleprint(txt .. ' \n')
	end
end

if Config.on and Config.mode == 'wh' then
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
if Config.types.prints == true then
	getgenv().print = function(text) -- hooks to game env <type> signal
		if mode == 'wh' then
			local response = hp(
			   {
				   Url = wh,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Print > "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." ( "..tostring(game.GameId).." ): "..text)})
			   }
			);
		elseif mode == 'cli' then
			pr(text)
		elseif Debug == true then
			logs('Invaild mode | ' .. mode)
		end
	end
end

-- Warns
if Config.types.warns == true then
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
		elseif Debug == true then
			logs('Invaild mode | ' .. mode)
		end
	end
end

-- Errors
if Config.types.errors == true then
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
		elseif Debug == true then
			logs('Invaild mode | ' .. mode)
		end
	end
end