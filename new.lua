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
local placeid1 = 6006653296 -- Fort bradly
local placeid2 = 6539893534 -- Testing[My shit]
local placeid3 = 286090429 -- arsenal
local placeid4 = 920587237 -- adopt me
local placeid5 = 2772166173 -- fort brag
local games = {
	"2772166173", "920587237", "286090429", "6539893534", "6006653296",
crystal = "6006653296",
adonis = {"2772166173", "920587237", "286090429", "6539893534"}
}

for _, placeid in pairs(games) do
    if placeid == placeid1 then
	
	elseif placeid == placeid2 or placeid3 or placeid4 or placeid5 then
	
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