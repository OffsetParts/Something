if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or getrenv() or _G

local function Notify(txt, debug) -- Template support
    if _senv.Notifier then
        _senv.Notifier("CH: " .. txt, debug) -- add CH tag
    end
end

_senv.ER = {
	Enable = false,
	url = '', -- webhook url
	mode = 'wh', -- wh or cli | console only works with syn, krnl, and sw
	types = { -- enables the logging of each type | Warning: this will override the default behavior and redirect the enabled to your mode of choosing and will not replicate
		["print"] = false, -- Not recommeded
		["error"] = true,
		["warn"]  = true,
	},
    launched = false
}

local Settings  = _senv.ER
local Enabled   = Settings.Enable
local leche     = Settings.launched
local mode      = Settings.mode
local types     = Settings.types
local wh 	    = Settings.url

local Https     = game:GetService("HttpService")
local MS        = game:GetService("MarketplaceService")
local hp        = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or Https and Https.request

local gameData  = game:HttpGetAsync("https://thumbnails.roblox.com/v1/assets?assetIds=".. game.PlaceId .. "&size=728x90&format=Png&isCircular=false")
local formatted = Https:JSONDecode(gameData) -- turn into table

-- if you wanna fuck all with the format of the message, https://discord-api-types.dev/api/discord-api-types-v10/interface/APIMessage
if not leche then
    if mode == 'wh' then
        local Intro = {
            ['thumbnail'] = {
                ['height'] = 728,
                ['width'] = 90,
                ['url'] = formatted['data'][1]['imageUrl']
            },
            ['url'] = "https://www.roblox.com/games/".. game.PlaceId .."/",
            ["title"] = "Output Reporter V3 | ".. MS:GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ")",
            ["description"] = "Started at " .. os.date("%b %d, %Y %I:%M:%S %p - %Z")
        }
        hp({
            Url = wh,
            Headers = {["Content-Type"] = "application/json"},
            Body = Https:JSONEncode({
                ["embeds"] = {Intro}
            }),
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
        print('Invalid mode. Please use "wh" or "cli"')
    end
    leche = true
else
	print'Restart the client to re-execute'
	return
end
Notify('launched', true)

local function pr(...)
    local text = tostring(...)
    if Enabled and text and (syn or iskrnlclosure or identifyexecutor) then
        rconsoleprint(text .. " \n")
    else
        print('Your executor does not support this feature. Try KRNL(FREE), Synapse(PAID) or Script-Ware(PAID)')
		return
    end
end

-- Prints
local oprint; oprint = hookfunction(print, newcclosure(function(...)
    if checkcaller() and Enabled and types["print"] then
		local text = {...}
        if mode == "wh" then
            local Embed = {
                ['Title'] = "Output Logger V3",
                ["description"] = unpack(text),
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
            pr("Print:".. text)
        end
    end
    return oprint(...)
end))

-- Warns
local owarn; owarn = hookfunction(warn, newcclosure(function(...)
    if checkcaller() and Enabled and types["warn"] then
	    local text = {...}
        local str = ""
        for i, v in pairs(text) do
            str = str .. tostring(v)7
        end
        if mode == "wh" then
            local Embed = {
                ['Title'] = "Output Logger V3",
                ["description"] = str,
                ["footer"] = {
                    ["text"] = "Warn > " .. os.date("%b %d, %Y %I:%M:%S %p")
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
    return owarn(...)
end))

-- Errors
local oerror; oerror = hookfunction(error, newcclosure(function(...)
    if checkcaller() and Enabled and types["error"] then
		local err, level = ...
		if not level then level = 1 end
        if mode == "wh" then
            local Embed = {
                ['Title'] = "Output Logger V3",
                ["description"] = err,
                ["footer"] = {
                    ["text"] = "Error, Level: ".. level .." > " .. os.date("%b %d, %Y %I:%M:%S %p")
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
            pr("Error: " .. err)    
        end
    end
    return oerror(...)
end))