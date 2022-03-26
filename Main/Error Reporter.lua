if not game:IsLoaded() then game.Loaded:Wait() end

local Config = Settings.ER
local mode = Config.mode
local wh = Config.wh

local http_request = http_request;
local c = identifyexecutor()
local http = game:GetService('HttpService')

-- Configure this shit with template

if syn then
	http_request = syn.request
elseif c == "ScriptWare" then
	http_request = http:RequestAsync()
end

local function pr(txt)
	if syn or iskrnlclosure then
		rconsoleprint(txt)
	end
end

	local Embed = {
		['title'] = 'Beginning of Logs in ' .. tostring(game:GetService("MarketplaceService"):GetProductInfo(place).Name) .. " (" .. place .. ")".. " at "..tostring(os.date("%m/%d/%y"))
	}

	local a = http_request({
	   Url = wh,
	   Headers = {['Content-Type'] = 'application/json'},
	   Body = game:GetService("HttpService"):JSONEncode({['embeds'] = {Embed}, ['content'] = ''}),
	   Method = "POST"
	})


-- Prints
if Config.types.prints == true then
	getgenv().print = function(text)
		if mode == 'webhook' or 'wh' then
			local response = http_request(
			   {
				   Url = wh,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Print > ( "..tostring(game.GameId).." ): "..text)})
			   }
			);
		elseif mode == 'console' or 'cli' then
			pr(text)
		else
			if Debug then
				logs('invaild Mode')
				logs('Phrased ' .. mode)
			end
		end
	end
end

-- Warns
if Config.types.warns == true then
	getgenv().warn = function(text)
		if mode == 'webhook' or 'wh' then
			local response = http_request(
			   {
				   Url = wh,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Warn > "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." ( "..tostring(game.GameId).." ): "..text)})
			   }
			);
		elseif mode == 'console' or 'cli' then
			pr(text)
		else
			if Debug then
				logs('invaild Mode')
				logs('Phrased ' .. mode)
			end
		end
	end
end

-- Errors
if Config.types.errors == true then
	getgenv().error = function(text)
		if mode == 'webhook' or 'wh' then
			local response = http_request(
			{
				Url = wh,
				Method = 'POST',
				Headers = {
					['Content-Type'] = 'application/json'
				},
				Body = game:GetService('HttpService'):JSONEncode({content = tostring("Error > "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." ( "..tostring(game.GameId).." ): "..text)})
			}
			);
		elseif mode == 'console' or 'cli' then
			pr(text)
		else
			if Debug then
				logs('invaild Mode')
				logs('Phrased ' .. mode)
			end
		end
	end
end