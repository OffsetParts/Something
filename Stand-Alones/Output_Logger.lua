if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or getrenv() or _G

local Settings
_senv.ER = {
	Enable = true,
	url = '', -- webhook url
	mode = 'wh', -- wh or cli | console only works with syn, krnl, and sw
	types = { -- enables the logging of each type | Warning: this will override the default behavior and redirect the enabled to your mode of choosing and will not replicate
		["print"] = false, -- Not recommeded
		["error"] = true,
		["warn"]  = true,
	},
    launched = false
}

local Settings = _senv.ER local Enabled, wh, leche, mode, types = Settings.Enable, Settings.url, Settings.launched, Settings.mode, Settings.types

local function Notify(txt, debug) -- Template support
	local time = os.clock()
	task.spawn(function()
		if pcall(function() repeat task.wait() until Notifier or os.clock() - time > 3 end) then
			Notifier("OL: " .. txt, debug) -- add CH tag
		else
			warn("OL: " .. txt)
		end
	end)
end

local Https     = game:GetService("HttpService")
local MS        = game:GetService("MarketplaceService")
local hp        = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request

local gameTD = Https:JSONDecode(game:HttpGetAsync("https://thumbnails.roblox.com/v1/assets?assetIds=".. game.PlaceId .. "&size=728x90&format=Png&isCircular=false")) -- turn into table

-- if you wanna fuck all with the format of the message, https://discord-api-types.dev/api/discord-api-types-v10/interface/APIMessage
if not leche then
    if mode == 'wh' then
        local Intro = {
            ['thumbnail'] = {
                ['height'] = 728,
                ['width'] = 90,
                ['url'] = gameTD['data'][1]['imageUrl']
            },
            ['url'] = "https://www.roblox.com/games/".. game.PlaceId .."/",
            ["title"] = "Output Reporter | ".. MS:GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")",
            ["description"] = "Started at " .. os.date("%b %d, %Y %I:%M:%S %p - %Z")
        }
        
        hp({Url = Settings.url, Headers = {["Content-Type"] = "application/json"},
            Body = Https:JSONEncode({["embeds"] = {Intro}}),
            Method = "POST"
        })
    elseif mode == 'cli' then
        if (syn or iskrnlclosure or identifyexecutor) then
            rconsoleprint("@@RED@@")
            rconsolewarn("Beginning of Output Logger for " .. MS:GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ") | on " ..  os.date("%x"))
            rconsoleprint("@@WHITE@@")
            rconsoleprint(" \n \n")
        else
            print('Your executor does not support this feature. Try KRNL(FREE), Synapse(PAID) or Script-Ware(PAID)')
        end
    else
        warn('Invalid mode. Please use "wh" or "cli"')
    end
    leche = true
	Notify('launched', true)
else
	return
end

local function pr(...)
    local text = tostring(...)
    if Enabled and text and (syn or iskrnlclosure or identifyexecutor) then
        rconsoleprint(text .. " \n")
    else
        warn('Your executor does not support this feature. Try KRNL(FREE), Synapse(PAID) or Script-Ware(PAID)')
    end
end

-- Prints
local oprint; oprint = hookfunction(print, newcclosure(function(...)
	local text = {...}
	task.spawn(function ()
		if checkcaller() and Enabled and types["print"] then
			local str = ""
			for i, v in pairs(text) do
				str ..= tostring(v) .. " "
			end
			if mode == "wh" then
				local Embed = {
					['Title'] = "Output Logger V3",
					["description"] = str,
					["footer"] = {
						["text"] = " Print > " .. os.date("%b %d, %Y %I:%M:%S %p")
					}
				}

				hp({
					Url = wh,
					Headers = {["Content-Type"] = "application/json"},
					Body = Https:JSONEncode({
						["embeds"] = {Embed}
					}),
					Method = "POST"
				})
			elseif mode == "cli" then
				pr("Print:".. str)
			end
		end
	end)
    return oprint(...)
end))

-- Warns
local owarn; owarn = hookfunction(warn, newcclosure(function(...)
	local text = {...}
	task.spawn(function ()
		if checkcaller() and Enabled and types["warn"] then
			local str = ""
			for i, v in pairs(text) do
				str ..= tostring(v) .. " "
			end
			if mode == "wh" then
				local Embed = {
					['Title'] = "Output Logger V3",
					["description"] = str,
					["footer"] = {
						["text"] = " Warn > " .. os.date("%b %d, %Y %I:%M:%S %p")
					}
				}

				hp({
					Url = wh,
					Headers = {["Content-Type"] = "application/json"},
					Body = Https:JSONEncode({
						["embeds"] = {Embed}
					}),
					Method = "POST"
				})
			elseif mode == "cli" then
				pr("Warn: ".. str)
			end
		end
	end)
    return owarn(...)
end))

-- Errors
local oerror; oerror = hookfunction(error, newcclosure(function(err, level)
	task.spawn(function ()
		if checkcaller() and Enabled and types['error'] then
			if mode == "wh" then
				local Embed = {
					['Title'] = "Output Logger V3",
					["description"] = err,
					["footer"] = {
						["text"] = " Error, Level: " .. level .. " > " .. os.date("%b %d, %Y %I:%M:%S %p")
					}
				}

				hp({
					Url = wh,
					Headers = {["Content-Type"] = "application/json"},
					Body = Https:JSONEncode({
						["embeds"] = {Embed}
					}),
					Method = "POST"
				})
			elseif mode == "cli" then
				pr("Error: " .. str)    
			end
		end
	end)
    return oerror(err, level)
end))