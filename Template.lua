-- ver - 2.6 | still written like shit but better
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- [[ Variables ]] --
getgenv().Logs = true -- enable logs for benchmark and testing
getgenv().SName = "Nil" -- Obscure Name
getgenv().Debug = false -- Run debugs for some scripts | prints and enables additional functions for testing | Not finished
getgenv().place = game.placeId -- global just to have the placeId for covinence

-- [[ Libraries ]] --
if not Promise then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/stellar-4242/Source/main/Promise.lua"))()
    getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end
if not ProtectInstance and not UnProtectInstance then
    loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))()
end
if not IrisInit then
    loadstring(game:HttpGet("https://irishost.xyz/InfinityHosting/IrisInit.lua"))()
end
loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterConsole.lua"))()

getgenv().Notifier = function(str, debu) -- Debug print only functionality
    if Logs then
        if not debu then
            print(tostring(str))
        elseif debu and Debug then
            warn("[DEBUG] " .. tostring(str))
        end
    end
end

local ST = os.clock()

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"), true))()

getgenv().config = {
    ON = true, -- Obscure Names | Nametag remover and name local name changer
    ASS = false, -- Anti-stream Snipe | Interferes with ADN choose wisely
    ADN = true, -- Anti Display Names by mothra
    NC = true, -- Noclip tool
    -- Chat Logger
    CH = {
        on = true, -- on/off
        wh = "" -- web url
    },
    dmnX = {
        on = true,
        theme = true -- if premium
    },
    ER = {
        -- Error Reporter
        on = true,
        wh = "", -- webhook url
        mode = "wh", -- wh or cli | console only works with syn, krnl, and sw
        types = {
            -- enables the logging of each type
            Print = false, -- Not recommeded
            Error = true,
            Warn = true
        }
    },
    Customs = true, -- load custom scripts url onlys
    CGames = {
        --  [gameId]     = 'link'
        [6536671967] = "https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua",
        [8982709021] = "https://raw.githubusercontent.com/RegularVynixu/Scripts/main/YouTube%20Life/Auto%20Farm.lua"
    }
}

spawn(
    function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"), true))()
        Notifier("(1/2) Security/Settings Loaded", true)

        --- Obscure Names
        if config.ON then
            loadstring(
                game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"), true)
            )()
            loadstring(
                game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"), true)
            )()
            Notifier("(3a) NameGuard Deployed", true)
        end
        -----------------------------------------------------------------------------------------------------------------------
        --- Anti-Display-Names
        if config.ADN then
            loadstring(
                game:HttpGet(
                    ("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),
                    true
                )
            )()
            Notifier("(3b) Anti-DisplayName Deployed", true)
        end
        -----------------------------------------------------------------------------------------------------------------------
        --- Anti-Streamsnipe
        if config.ASS then
            loadstring(
                game:HttpGet(
                    ("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),
                    true
                )
            )()
            Notifier("(3c) Anti-Streamsnipe protection", true)
        end

        ---	Loggers
        -- Errors
        if config.ER.on then
            loadstring(
                game:HttpGet(
                    ("https://raw.githubusercontent.com/Input50/Something/master/Main/Error%20Reporter.lua"),
                    true
                )
            )()
            Notifier("(4a) Error Reporter loaded", true)
        end

        -- Chat
        if config.CH.on then
            loadstring(
                game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/ChatLogger.lua"), true)
            )()
            Notifier("(4b) Chat Logger Enabled", true)
        end
        -----------------------------------------------------------------------------------------------------------------------

        ---	Tools

        -- Noclip
        if config.NC then
            loadstring(
                game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua"), true)
            )()
            Notifier("(5a) Noclip Loaded", true)
        end
    end
)

-- DomainX
spawn(
    function()
        if config.dmnX.on then
            -- [[ DomainX Theme ]] --
            if config.dmnX.theme then
                ThemeEnabled = true
                Theme = {
                    Name = "Pornhub",
                    PrimaryColor = Color3.fromRGB(20, 20, 20),
                    SecondaryColor = Color3.fromRGB(234, 143, 28),
                    Font = ""
                }
            end

            loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexsoftworks/DomainX/main/source", true))()
        end
    end
)

--- Custom | Possibly more addons in the future
if config.Customs then
    for i, v in next, config.CGames do
        task.wait()
        if v == place then
            local link = config.CGames[v]
            spawn(
                function()
                    loadstring(game:HttpGet((link), true))()
                end
            )
            Notifier(place .. ": " .. link, true)
        end
    end
end

DT = os.clock() - ST
-- Benchmark execution speed
Notifier("Took " .. DT .. " seconds to load", true)
Notifier("Loaded", false)