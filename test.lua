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

local games = {2772166173, 920587237, 286090429, 6539893534, 6006653296}
-- game specifics
-- if its anything else if will just execute default

local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {6006653296},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Crystal.lua?token=AKSKDDX2SQX76BH5HJKSB4DAT27Z6",
    },
	adonis = {
		Name = "Adonis",
		PlaceIDs = {2772166173, 920587237, 286090429, 6539893534},
		ScriptToRun = "https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Adonis.lua?token=AKSKDDUHRYODOESLTM4Z7LTAT257A",
	},
}
for _, bgame in pairs(bgames) do
    for _, placeid in pairs(PlaceIDs) do
        if placeid == game.PlaceId then
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
            print("Loaded "..bgame.Name)
			else
			loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/default.lua?token=AKSKDDWFTJRCFIQC7BM3PBLAT3BLA'),true))()
			print("Loaded ".. bgame.Name)
        end
    end
end

print("Loading Logs ...")
-- changes locallogs for anyone who trys to get it it won't change for your LogHistory
-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Logs.lua?token=AKSKDDU2HRCE7CGWHY7YMB3AT25QI'),true))()

-- Semi Net bypass
hookfunction(setsimulationradius, function(a,b) end)