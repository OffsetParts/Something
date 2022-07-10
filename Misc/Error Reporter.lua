if not game:IsLoaded() then
    game.Loaded:Wait()
end

local _genv = getgenv() or _G

-- Configure this shit wthin template
local Config = config.ER
local switch = Config.Enable
local mode   = Config.mode
local types  = Config.types
local wh 	 = Config.url

local oprint = print
local owarn  = warn
local oerror = error

local https = game:GetService("HttpService")
local hp = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or request or https and https.request

local launched = false
local function pr(txt)
    if switch and (syn or iskrnlclosure or identifyexecutor) then
        if not launched then -- Opening sequence | Console
            rconsoleprint("@@RED@@")
            rconsolewarn("Beginning of Console: " .. os.time() .. " | gameId: " .. game.PlaceId)
            rconsoleprint("@@WHITE@@")
            rconsoleprint("\n \n")
            launched = true
        end
        rconsoleprint(txt .. "\n")
    end
end

if switch and mode == "wh" then
    local Embed = {
        -- Opening sequence | Webhook
        ["title"] = "Beginning of Logs in " .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. " (" .. game.PlaceId .. ") at " .. tostring(os.date("%m/%d/%y"))
    }

    local a =
        hp(
        {
            Url = wh,
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode({["embeds"] = {Embed}, ["content"] = ""}),
            Method = "POST"
        }
    )
end

-- Prints
if types["print"] == true then
    _genv.print = function(text) -- hooks to game env <type> signal
		if mode == "wh" then
            local response =
                hp(
                {
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({content = tostring("Print > " .. text)})
                }
            )
        elseif mode == "cli" then
            pr(text)
        end
        oprint(text)
    end
end

-- Warns
if types["warn"] == true then
    _genv.warn = function(text)
        if mode == "wh" then
            local response =
                hp(
                {
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({content = tostring("Warn > " .. text)})
                }
            )
        elseif mode == "cli" then
            pr(text)
        end
        owarn(text)
    end
end

-- Errors
if types["error"] == true then
    _genv.error = function(...)
        local text, lvl = ... 
        if mode == "wh" then
            local response =
                hp({
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = game:GetService("HttpService"):JSONEncode({content = tostring("Error > " .. text)})
                })
        elseif mode == "cli" then
            pr(text)
        end
        oerror(text)
    end
end