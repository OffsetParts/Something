if not game:IsLoaded() then game.Loaded:Wait() end

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

-- prints
if Settings.ER.types.prints == true then
	getgenv().print = function(text)
		if Settings.ER.mode == 'webhook' or 'wh' then
			local response = http_request(
			   {
				   Url = webby,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Error reported in game "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." (gameid "..tostring(game.GameId).."): "..text)})
			   }
			);
		elseif Settings.ER.mode == 'console' or 'cli' then
			pr(text)
		else
			if DebugMode then
				logs('invaild Mode')
				logs('Phrased ' .. mode)
			end
		end
	end
end

-- Warns
if Settings.ER.types.warns == true then
	getgenv().warn = function(text)
		if Settings.ER.mode == 'webhook' or 'wh' then
			local response = http_request(
			   {
				   Url = webby,
				   Method = 'POST',
				   Headers = {
					   ['Content-Type'] = 'application/json'
				   },
				   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Error reported in game "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." (gameid "..tostring(game.GameId).."): "..text)})
			   }
			);
		elseif Settings.ER.mode == 'console' or 'cli' then
			pr(text)
		else
			if DebugMode then
				logs('invaild Mode')
				logs('Phrased ' .. mode)
			end
		end
	end
end

-- Errors
if Settings.ER.types.errors == true then
getgenv().error = function(text)
	if Settings.ER.mode == 'webhook' or 'wh' then
		local response = http_request(
		   {
			   Url = webby,
			   Method = 'POST',
			   Headers = {
				   ['Content-Type'] = 'application/json'
			   },
			   Body = game:GetService('HttpService'):JSONEncode({content = tostring("Error reported in game "..tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name).." (gameid "..tostring(game.GameId).."): "..text)})
		   }
		);
	end
	elseif Settings.ER.mode == 'console' or 'cli' then
		pr(text)
	else
		if DebugMode then
			logs('invaild Mode')
			logs('Phrased ' .. mode)
		end
	end
end