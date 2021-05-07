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

local games = {
	"2772166173", "920587237", "286090429", "6539893534", "6006653296"
}

crystal = {"6006653296"}
adonis = {"2772166173", "920587237", "286090429", "6539893534"}

for _, placeid in pairs(games) do
    if games == game.PlaceId then
	
	elseif placeid == game.PlaceId then
	
    end
    return placeid
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