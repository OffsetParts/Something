-- [[ Variables ]] --
_G.Logs = true -- enable logs for benchmark and testing
_G.Name = "Nil" -- Obscure Name
Debug = true -- Run debugs for some scripts | prints and adds additional functions for testing | Not finished

function logs(str, debu) -- Debug print only functionality
	if _G.Logs == true then
		if debu == nil or debu ~= true then
			print(tostring(str))
		elseif debu == true then
			if Debug == true then
				print("DEBUG: " .. tostring(str))
			end
		end
	end
end

local DT;
local ST = os.clock()
if not game:IsLoaded() then game.Loaded:Wait() end
place = game.placeId

-- ver - 2.2 | still written like shit but better
-- Order: Security/Bypasses/Settings, Loggers, Tools, Customs

setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"),true))()

Settings = {
    ON = false, -- Obscure Names | Nametag remover and name local name changer
    ASS = false, -- Anti-stream Snipe | Interferes with ADN choose wisely
    ADN = false, -- Anti Display Names by mothra
    NC = false, -- Noclip tool
    -- Chat Logger
    CH = {
	    on = false, -- on/off
		wh = '' -- web url
	},
    dmnX = {
		on = false,
		prem = false, -- if premium
	},
    ER = { -- Error Reporter
		on = false,
		wh = '', -- webhook url
		mode = 'cli', -- wh or cli | console or webhook | console only works with syn, krnl, and sw| webhook only works with syn and sw
		types = { -- enables the logging of each category
			prints = false,
			errors = false,
			warns  = false,
	    }
    },
	
	Customs = true, -- load custom scripts url onlys | custom functions maybe in the future
	CGames = {
		[6536671967] = 'https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua',
	-- 	[gameID]     = '<link>',
	},
}

config = Settings

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"),true))()
logs('(1/2) Security/Settings Loaded', true)
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Display-Names
if config.ADN == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
	logs("(3a) Anti-DisplayName Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Streamsnipe
if config.ASS == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
	logs("(3b) Anti-Streamsnipe protection", true)
end
-----------------------------------------------------------------------------------------------------------------------	
--- Obscure Names
if config.ON == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"),true))()
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"),true))()
	logs("(3c) NameGuard Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------

---	Loggers 
-- Errors
if config.ER.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Error%20Reporter.lua"),true))()
	logs('(4a) Error Reporter loaded', true)
end

-- Chat
if config.CH.on == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/ChatLogger.lua"),true))()
	logs('(4b) Chat Logger Enabled', true)
end
-----------------------------------------------------------------------------------------------------------------------

---	Tools

-- Noclip
if config.NC == true then
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua'),true))()
	logs('(5a) Noclip Loaded', true)
end

--- Custom | Possibly more addons in the future

local CG
if config.Customs == true then
	for i = 1, #config.CGames do
		if config.Games[i] == place then CG = true end
	end
	if CG == true then
		local link = config.CGames[place]
		loadstring(game:HttpGet((link),true))()
		logs(place.. ": " .. link, true)
	end
end

DT = os.clock() - ST
logs("Benchmark time is " ..DT)
logs('Loaded', false)

-- domainX | Has to load last cause its code doesn't end like a moron
if config.dmnX.on == true then

	-- [[ DomainX Theme ]] --
	if config.dmnX.prem == true then
		ThemeEnabled = true
		Theme = {
		  Name = "",
		  PrimaryColor = Color3.fromRGB(0,0,0),
		  SecondaryColor = Color3.fromRGB(0,0,0),
		  Font = "",
		}
	end
	
	loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftworks/DomainX/main/source',true))()
end