-- ver - 3.2 | Its getting there I think
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
-- ^my dumbass forgot they supposed to load before the game loads completely

if not game:IsLoaded() then game.Loaded:Wait() end

local ST = os.clock()
-- [ Settings ] -- At the top for quicker access
getgenv().config = {
	ACBs = false,   -- Community gathered Anticheat bypasses | Only contributor me :(
    NR   = false,   -- Name replacer | Replaces your name in-game every clientsided
	NTR  = false,   -- NameTag Remover | An function to find any client side nametags to remove (caution: raises suspicion)
	NC   = false,  -- Noclip tool
	ASS  = false,  -- Anti-Stream Snipe | Function Denaming players to make it harder to track your games. Tip: Interferes with ADN so choose wisely
    ADN  = {       -- Anti Display Names by mothra#4150
		Enable = false,
		Preferences = {
			RetroNaming = false,
			ShowOriginalName   = true,
			ApplyToLeaderboard = true,
			IdentifyFriends    = {Toggle = true, Identifier = '[Cuz]'},
			IdentifyBlocked    = {Toggle = true, Identifier = '[Cunt]'},
			IdentifyPremium    = {Toggle = false, Identifier = '[Premium]'},
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
if not Scrumpy then getgenv()["Scrumpy"] = {} end -- Yes I named it that, its to make it harder for other scripts global to interfere
local Settings = getgenv()["Scrumpy"]

Settings = {
	Alias = 'Nil'
	Logs  = true, -- Enable logs
	Debug = true, -- Unlocks more intensive features for debugging | WIP
}

getgenv().Notifier = function(str, debug) -- global quick print function
    if Settings.Logs then
        if not debug then
            print(tostring(str))
        elseif Settings.Debug then
            warn("[DEBUG] " .. tostring(str))
        end
    end
end

-- [[ Libraries ]] -- | <3 iris zaddy

if not IrisInit or not Iris then
    loadstring(game:HttpGet("https://irishost.xyz/InfinityHosting/IrisInit.lua"))()
	loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterConsole.lua"))() 
	loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterCompat.lua"))()
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
		--- Obscure Names
		if config.NR then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"), true))()
			Notifier("(3) Obscurer Planted", true)
		end
		
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
		-- Noclip
		if config.NC then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua"), true))()
			Notifier("(7) Noclip Launched", true)
		end
	end)

	DT = os.clock() - ST
	Notifier("Took " .. DT .. " seconds to load", true)
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