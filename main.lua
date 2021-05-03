print("working...")

wait(5)
-- setting flags
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")

wait(0.1)

-- there anti is so they need to be executed a little bit later oh they won't load
-- AntiCheat by Daddy Iris
--        adopt me  , arsenal
games = {"920587237","286090429"}

for _, placeid in pairs(games) do
    if placeid == game.PlaceId then
        wait(20)
			getgenv().BypassSettings = {
			   ["Crystal AntiCheat"] = true,
			   ["Adonis"] = true,

			   ["Anti-Obfuscated Scripts"] = false,-- CANNOT BE ENABLED WITH CRYSTAL This will block any obfuscated script on the client from running (Not executed by your exploit thought)
			   ["Random"] = true, -- Will disallow scripts calling, GetPropertyChanged signal on WalkSpeed, JumpPower, Gravity, Health, LogService

			   ["Enable Kill Logs"] = true, -- Say if you want to get told what's bypassed
			}

			loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()
		print(":: Adonis :: Has Loaded")
        else
		getgenv().BypassSettings = {
		   ["Crystal AntiCheat"] = true,
		   ["Adonis"] = true,

		   ["Anti-Obfuscated Scripts"] = false,-- CANNOT BE ENABLED WITH CRYSTAL This will block any obfuscated script on the client from running (Not executed by your exploit thought)
		   ["Random"] = true, -- Will disallow scripts calling, GetPropertyChanged signal on WalkSpeed, JumpPower, Gravity, Health, LogService

		   ["Enable Kill Logs"] = true, -- Say if you want to get told what's bypassed
		}

		loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()
        print(":: Adonis :: Has Loaded")
    end
end



print("Loading Logs ...")
-- Clears logs
local LogService = game:GetService("LogService")

local Old
Old = hookfunction(LogService.GetLogHistory, function(...)
    if checkcaller() then return Old(...) end
return {
    {
        message = ":: Adonis :: Ready",
        messageType = Enum.MessageType.MessageInfo,
        timeStamp = 0
    }
}
end)

-- Semi Net bypass
hookfunction(setsimulationradius, function(a,b) end)