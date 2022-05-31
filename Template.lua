-- [[ Variables ]] --
getgenv().Logs = true -- enable logs for benchmark and testing
getgenv().Name = "Nil" -- Obscure Name
getgenv().Debug = true -- Run debugs for some scripts | prints and enables additional functions for testing | Not finished

-- [[ Libraries ]] --
if not Promise then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/stellar-4242/Source/main/Promise.lua'))(); getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

function logs(str, debu) -- Debug print only functionality
	if Logs == true then
		if debu == nil or debu ~= true then
			print(tostring(str))
		elseif debu == true then
			if Debug == true then
				print("DEBUG: " .. tostring(str))
			end
		end
	end
end

local ST = os.clock()
if not game:IsLoaded() then game.Loaded:Wait() end
getgenv().place = game.placeId

-- ver - 2.2 | still written like shit but better
-- Order: Security/Bypasses/Settings, Loggers, Tools, Customs

setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Utilites/Settings.lua"),true))()

getgenv().config = {
    ON = false, -- Obscure Names | Nametag remover and name local name changer
    ASS = false, -- Anti-stream Snipe | Interferes with ADN choose wisely
    ADN = false, -- Anti Display Names by mothra
	NC = false, -- Noclip tool
	dmnX = { -- DomainX
		on = true,
		theme = true, -- if premium
	},
    CH = { -- Chat Logger
	    on = false, -- on/off
		wh = '' -- web url
	},
    ER = { -- Error Reporter
		on = false,
		wh = '', -- webhook url
		mode = 'wh', -- wh or cli | console only works with rconsole funcs
		types = { -- enables the logging of each type
			prints = false, -- Not recommeded
			errors = true,
			warns  = true,
	    }
    },
	
	Customs = true, -- load custom scripts url onlys
	CGames = {
		[6536671967] = 'https://raw.githubusercontent.com/Input50/Something/master/Games/SlayersUnleased.lua',
		[8982709021] = 'https://raw.githubusercontent.com/RegularVynixu/Scripts/main/YouTube%20Life/Auto%20Farm.lua',
	 -- 	[gameID]     = '<link>',
	},
}

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Bypass.lua"),true))()
logs('(1/2) Security/Settings Loaded', true)

--- Obscure Names
if config.ON == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Renamer.lua"),true))()
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/NameTag.lua"),true))()
	logs("(3a) NameGuard Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Display-Names
if config.ADN == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Anti-DisplayName.lua"),true))()
	logs("(3b) Anti-DisplayName Deployed", true)
end
-----------------------------------------------------------------------------------------------------------------------	
--- Anti-Streamsnipe
if config.ASS == true then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/AntiStreamSnipe.lua"),true))()
	logs("(3c) Anti-Streamsnipe protection", true)
end

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
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Main/Noclip.lua"),true))()
	logs('(5a) Noclip Loaded', true)
end

-- DomainX
spawn(function()
	if config.dmnX.on == true then
		-- [[ DomainX Theme ]] --
		if config.dmnX.theme == true then
			ThemeEnabled = true
			Theme = {
			  Name = "Pornhub",
			  PrimaryColor = Color3.fromRGB(20, 20, 20),
			  SecondaryColor = Color3.fromRGB(234, 143, 28),
			  Font = ""
			}
		end
		
		loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexsoftworks/DomainX/main/source',true))()
	end
end)

--- Custom | Possibly more addons in the future
if config.Customs == true then
	for i = 1, #config.CGames do
		task.wait()
		if config.CGames[i] == place then
			local link = config.CGames[place]
			spawn(function()
				loadstring(game:HttpGet((link),true))()
			end)
			logs(place.. ": " .. link, true)
		end
	end
end

DT = os.clock() - ST
-- Benchmark execution speed 
logs("Took " .. DT .. " seconds to load", true)
logs('Loaded', false)