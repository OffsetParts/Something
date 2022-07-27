if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

-- Configure this shit wthin template
local Config = ER
local switch = Config.Enable
local mode   = Config.mode
local types  = Config.types
local wh 	 = Config.url

local Https = game:GetService("HttpService")
local hp = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or _senv.request or request or Https and Https.request

local launched = false
local function pr(txt)
    local text = tostring(txt)
    if switch and (syn or iskrnlclosure or identifyexecutor) then
        if not launched then -- Opening sequence | Console
            rconsoleprint("@@RED@@")
            rconsolewarn("Beginning of Output Logger for" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " (" .. game.PlaceId .. ") | on " ..  os.date("%x"))
            rconsoleprint("@@WHITE@@")
            rconsoleprint(" \n \n")
            launched = true
        end
        rconsoleprint(text .. " \n")
    else
        print('Your executor does not support this feature. Try KRNL(FREE), Synapse(PAID) or Script-Ware(PAID)')
    end
end

if not launched and switch and mode == "wh" then
    local Embed = {
        -- Opening sequence | Webhook
        ["title"] = "Beginning of Logs in " .. tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name) .. " (" .. game.PlaceId .. ") at " .. os.date("%x")
    }

    hp({
        Url = wh,
        Headers = {["Content-Type"] = "application/json"},
        Body = Https:JSONEncode({["embeds"] = {Embed}, ["content"] = ""}),
        Method = "POST"
    })
end

local oldprint = print
-- Prints
if switch and types["print"] then
    local oprint; oprint = hookfunction(print, newcclosure(function(...)
        local text = ...
        if checkcaller() then
            if mode == "wh" then
                hp({
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = Https:JSONEncode({content = tostring("Print > " .. text)})
                })
            elseif mode == "cli" then
                pr(tostring(text))
            end
        end
        oldprint(...)
        return oprint(...)
    end))
end

local oldwarn = warn
-- Warns
if switch and types["warn"] == true then
    local owarn; owarn = hookfunction(warn, newcclosure(function(...)
        local text = ...
        if checkcaller() then
            if mode == "wh" then
                hp({
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = Https:JSONEncode({content = tostring("Warn > " .. text)})
                })
            elseif mode == "cli" then
                pr(text)
            end
        end
        oldwarn(...)
        return owarn(...)
    end))
end


local olderror = error
-- Errors
if switch and types["error"] == true then
    local oerror; oerror = hookfunction(error, newcclosure(function(...)
        local text, lvl = ...
        if not lvl then lvl = 1 end
        if checkcaller() then
            if mode == "wh" then
                hp({
                    Url = wh,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = Https:JSONEncode({content = tostring("Error > " .. text .. ", Level: " .. lvl)})
                })
            elseif mode == "cli" then
                pr(tostring(text))
            end
        end
        olderror(...)
        return oerror(...)
    end))
end