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

-- [[ Variables ]] --
_G.Logs = false -- enable logs for debugging
_G.Name = "" -- Obscure Name
DebugMode = false -- Run debugs for some scripts | prints and different function execution

function logs(str, debu) -- Debug print only functionality
	if _G.Logs == true then
		if debu == nil or debu ~= true then
			print(tostring(str))
		elseif debu == true then
			if DebugMode == true then
				print("DEBUG: " .. tostring(str))
			end
		end
	end
end

if not game:IsLoaded() then game.Loaded:Wait() end
place = game.placeId

-- ver - 2.0 | Re structuring of script order to run smoother and securely and also remove unneeded stuff
	-- Order: Security, Settings, Loggers, Tools

-- Security and Settings
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"),true))()
logs("(2) Saved Settings Loaded")

Settings = {
    -- Chat Logger
    CH = {
	    on = false, -- on/off
		wh = '' -- web url
	},
    ADN = { -- Anti-Display Names
		on = false,
		loaded = false,
	},
    ON = false, -- Obscure Names
    ASS = false, -- Anti-stream Snipe | Will not load if ADN loaded first
    NC = false, -- Noclip tool
    dmnX = {
		on = false,
		prem = false}, -- DomainX
	ER = { -- Error Reporter
		on = false,
		webby = '', -- webhook url
		mode = 'wh', -- wh or cli | console or webhook | console only works with krnl or syn | webhook aswell with syn and SW
		types = { -- enables the logging of each category
			prints = false,
			errors = true,
			warns  = true,
		}
	},
	games = {
		[6536671967] = {
			link = 'https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua'
		},  -- nvm his shit is horrible
	},
}
config = Settings

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"),true))()
logs('Main: Loaded', false)
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Display-Names
if config.ADN.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
	config.ADN.loaded = true
	logs("(3a) Anti-DisplayName Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------	
--- Obscure Names
if config.ON == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"),true))()
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"),true))()
	logs("(3b) NameGuard Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------
--- Error Reporter
if config.ER.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Error%20Reporter.lua"),true))()
	logs('(3c) Error Reporter loaded', true)
end
-----------------------------------------------------------------------------------------------------------------------

--[[	 Tools		]]--
-- Chat Logger
if config.CH.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/ChatLogger.lua"),true))()
	logs('(4a) Chat Logger Enabled', true)
end

-- Noclip
if config.NC == true then
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua'),true))()
	logs('(4b) Noclip Loaded', true)
end

-- [[ DomainX Theme ]] --
if config.dmnX.prem == true then
	ThemeEnabled = true
	Theme = {
	  Name = "", -- Theme Name
	  PrimaryColor = Color3.fromRGB(0, 0, 0), -- Ex: Background Frame colors
	  SecondaryColor = Color3.fromRGB(0, 0, 0), -- Ex: Button background colors
	  Font = "",
	}
end
-- domainX
if config.dmnX.on == true then
	loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftworks/DomainX/main/source',true))()
	logs('(4c) DomainX Loaded', true)
end

--- Anti-Streamsnipe
if config.ASS == true and config.ADN.loaded ~= true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
	logs("(5a) Anti-Streamsnipe protection", true)
else
	logs("(5a) Anti-Streamsnipe protection off", true)
end

-- Custom Scripts
for i = 1, #config.games do
	local ID = config.games[i]
	local link =  ID.link
	if ID == game.placeId then
		logs(link, true)
		loadstring(game:HttpGet((link),true))()
	end
end

logs('finished', true)
	
