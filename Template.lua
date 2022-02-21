--[[ decided to published this here cause why not.
This is a collection of scripts i formulated to execute as essentials pack in autoexec.
Nearly none of scripts are originally made by me
but i modified them over time, as i continued to learn lua.
This is meant to be used in autoexec
It lists of basic shit to just enchance or modified the roblox experience. Nothing here is to be hvh or hacking others other than the scripts in Games
Shit like Anti-Stream-Sniping, anti-report, AC bypasses I collected, Remove your nametags, basic noclip tool, multitool chatlogger, and more.
This thing is fully customizable and feel free to take anything.
Supports SW and Synapse and maybe some others I haven't fully tested.
Made by you, elsewhere

Note: I will leave comments to explain what each somewhat important shit does
]]--

if not game:IsLoaded() then game.Loaded:Wait() end

-- [[ Stuff ]] --
_G.Logs = true -- enable logs for debugging
_G.Name = "Me" -- Obscure Name

Settings = {
    CH = { -- Chat Logger
	    on = true, -- on/off
	    wh = ''; -- wh link
	},
    ADN = { -- Anti-Display Names
		on 	= true,
		loaded  = false,
	},
    ON 		= true, -- Obscure Names
    ASS 	= true, -- Anti-stream Snipe | Will not load if ADN loaded first
    NC 		= true, -- Noclip tool
    dmnX 	= true, -- DomainX
	ER = { -- Error Reporter
		on = false,
		webby = '', -- webhook url
		mode = 'wh' -- wh or cli | console or webhook | console only works with krnl or syn, while webhook only works in syn and SW
		types = { -- enables the logging of each category
			prints = true,
			errors = true,
			warns  = true,
		}
	
	},
	games = {
		6536671967 = { -- SlayerUnleashed Admin by Septex
			link = 'https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua'
		},  -- steal custom scripts from shlex :)
	},
}

function logs(str)
	if _G.Logs == true then
		print(str)
	end
end


-- [[ DomainX Theme ]] --
ThemeEnabled = true
Theme = {
  Name = "Cornhub",
  PrimaryColor = Color3.fromRGB(25, 25, 25),
  SecondaryColor = Color3.fromRGB(255, 155, 0),
  Font = "",
}

---------- Security
-- flags | Known Flags that can mess with scripts or have you reported
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")

-- Detection Bypass -- Outdated as shit but I still keep for some reason
if syn and syn.run_secure_lua then
	--syn.run_secure_lua("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")
end

logs("(1) Security Modules Loaded")
----------
-- Save Settings | Saves your roblox in-game settings | Graphics, volume, etc
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"),true))()
logs("(2) Saved Settings Loaded")

-- Universal Anticheat | can break some games/scripts | Will be updated to be more adaptive
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"),true))()
logs("(3) Anticheat Bypass Loaded")
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Display-Names
if Settings.ADN.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
	Settings.ADN.loaded = false
	logs("(4a) Anti-DisplayName Deployed")
end
-----------------------------------------------------------------------------------------------------------------------	
--- Obscure Names
if Settings.ON == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"),true))()
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"),true))()
	logs("(4b) NameGuard Deployed")
end
-----------------------------------------------------------------------------------------------------------------------	

--Chat Logger
if Settings.CH.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/ChatLogger.lua"),true))()
	logs('(5a) Chat Logger Enabled')
end
	
-- Noclip
if Settings.NC then
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua'),true))()
	logs('(5b) Noclip Loaded')
end
	
-- Domain X
if Settings.dmnX then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftworks/DomainX/main/source',true))()
	logs('(5c) DomainX Loaded')
end

--- Anti-Streamsnipe
if Settings.ASS == true and Settings.ADN.loaded ~= true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
	logs("(6) Anti-Streamsnipe protection")
else
	logs("(6) Anti-Streamsnipe protection off")
end

-- Custom Scripts
for i = 1, #Settings.games do
	local ID = Settings.games[i]
	local link =  ID.link
	if ID == game.placeId then
		if DebugMode then print('Custom script' .. link ' executed')
		loadstring(game:HttpGet((link),true))()
	end
end
