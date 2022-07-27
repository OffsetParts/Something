-- ver - 3.5 | Its getting there I think
setfflag("AbuseReportScreenshotPercentage", 0) -- nullifies it chances
setfflag("DFFlagAbuseReportScreenshot", "False") -- Disable Abuse Report Screenshot
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "") -- remove the url it will upload crash report to prevent logging
setfflag("DFIntCrashUploadToBacktracePercentage", "0") -- nullifies the chances of it happening
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "") -- remove fingerprinting token
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "") -- remove fingerprinting token

-- loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"), true))()
if not game:IsLoaded() then game.Loaded:Wait() end
_senv = getgenv() or _G

local ST = os.clock()
-- [ Settings ] -- At the top for quicker access
_senv.config = {
	ACBs = false,   -- Community gathered Anticheat bypasses | Only contributor me :(
    NR   = false,   -- Name replacer | Replaces your name in-game every clientsided
	NTR  = false,  -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
	NC   = false,   -- Noclip tool
	ASS  = false,  -- Anti-Stream Snipe | Function Denaming players to make it harder to track your games. Tip: Interferes with ADN so choose wisely
    ADN  = {       -- Anti Display Names by mothra#4150
		Enable = false,
		Preferences = {
			RetroNaming = false,
			ShowOriginalName   = true,
			ApplyToLeaderboard = true,
			IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
			IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
			IdentifyPremium    = {Toggle = true, Identifier = '[Premium]'},
			IdentifyDeveloper  = {Toggle = true, Identifier = '[Developer]'},
			SpoofLocalPlayer   = {Toggle = false, UseRandomName = false, NewName = 'Random Name Lol'},
			Orientation 	   = 'Vertical'
		}
	},

	Customs = true, -- loads custom scripts url only
	Games = {
	--  [gameId]     = 'link'
		[6536671967] = 'https://raw.githubusercontent.com/XTheMasterX/Scripts/Main/SlayersUnleashedAdmin', -- by septex great by
		[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Scripts/main/YouTube%20Life/Auto%20Farm.lua', -- useless spergs
	},
}

-- [[ Variables ]] --
_senv["Scrumpy"] = {-- Yes I named it that, so its to make it harder for other scripts global to interfere
	Alias = 'Nil',
	Logs  = true, -- Enable logs
	Debug = true
}

_senv.Notifier = function(str, debug) -- global quick print function
    if  getgenv()["Scrumpy"].Logs then
        if not debug then
            print(tostring(str))
        elseif  getgenv()["Scrumpy"].Debug then
            warn("[DEBUG] " .. tostring(str))
        end
    end
end

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"), true))()
Notifier("(1) Settings Loaded", true)

task.spawn(function ()
	if config.ACBs then
		loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"), true))()
		Notifier("(2) ACBs Installed", true)
	end
	task.delay(7, function () 
        Notifier("Loading...", true)
		if config.NR then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"), true))()
			Notifier("(3) Obscurer Planted", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NTR then -- lol
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"), true))()
			Notifier("(4) Nametag Remover Working", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ADN then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
			Notifier("(5) Anti-Display Name Deployed", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.ASS then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
			Notifier("(6) Anti-Stream Snipe established", true)
		end
		-----------------------------------------------------------------------------------------------------------------------
		if config.NC then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua"), true))()
			Notifier("(7) Noclip Launched", true)
		end
		
		DT = os.clock() - ST
		Notifier("Took " .. DT .. " seconds to load", true)
	end)
end)

--- Custom | Possibly more addons in the future
if config.Customs then
    for i, v in next, config.Games do
		task.wait(1)
        if v == game.PlaceId then
            local link = config.Games[v]
            spawn(function()
				loadstring(game:HttpGet((link), true))()
            end)
            Notifier('Script founded for ' .. game.PlaceId, true)
        end
    end
end