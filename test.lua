print("working...")
-- setting flags
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
wait(0.1)

-- there anti is so they need to be executed a little bit later or they won't load
-- AntiCheat by Daddy Iris

local games = {"2772166173", "920587237", "286090429", "6539893534", "6006653296"}
-- game specifics
-- if its anything else if will just execute default
local crystal = {"6006653296"}
local adonis = {"2772166173", "920587237", "286090429", "6539893534"}

for _, placeid in pairs(games) do
    if games == game.PlaceId then
	-- crystal
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Logs.lua?token=AKSKDDU2HRCE7CGWHY7YMB3AT25QI'),true))()
	elseif placeid == game.PlaceId then
	-- adonis
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Adonis.lua?token=AKSKDDUHRYODOESLTM4Z7LTAT257A'),true))()
	else
	
    end
    return placeid
end

print("Loading Logs ...")
-- changes locallogs for anyone who trys to get it it won't change for your LogHistory
-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Logs.lua?token=AKSKDDU2HRCE7CGWHY7YMB3AT25QI'),true))()

-- Semi Net bypass
hookfunction(setsimulationradius, function(a,b) end)