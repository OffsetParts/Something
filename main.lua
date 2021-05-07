print("working...")
-- setting flags
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
wait(0.1)

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrillyX/Resources/main/NFLib"))()
-- Free Notification system by TrillyX ^^

-- there anti is so they need to be executed a little bit later or they won't load
-- AntiCheat by Daddy Iris
local placeid1 = 2772166173 -- Fort brag
local placeid2 = 920587237 -- Adopt Me
local placeid3 = 286090429 -- Arsenal
local placeid4 = 6539893534 -- Testing
local placeid5 = 6006653296 -- -- Frot Bradley
-- game specifics
-- if its anything else if will just execute default
local games = {"2772166173", "920587237", "286090429", "6539893534", "6006653296"}


for _, placeid in pairs(games) do
    if placeid5 == game.PlaceId then
	-- crystal
	lib:Notification("CAC bypass Injected", "Crystal AntiCheat Bypass by Scrumptious", 5, Color3.fromRGB(255, 255 ,255) )
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Crystal.lua?token=AKSKDDX2SQX76BH5HJKSB4DAT27Z6'),true))()
	elseif placeid == placeid1 or placeid2 or placeid3 or placeid4 then
	-- adonis)
	print("adonis")
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Adonis.lua?token=AKSKDDUHRYODOESLTM4Z7LTAT257A'),true))()
	else
	print("default")
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/default.lua?token=AKSKDDWFTJRCFIQC7BM3PBLAT3BLA'),true))()
	end
    return placeid
end

print("Loading Logs ...")
-- changes locallogs for anyone who trys to get it it won't change for your LogHistory
-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Logs.lua?token=AKSKDDU2HRCE7CGWHY7YMB3AT25QI'),true))()

-- Semi Net bypass
hookfunction(setsimulationradius, function(a,b) end)