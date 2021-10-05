-- AntiCheatV2 by IrisV3rm
-- if its anything else if will just execute default
--[[
local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {6006653296, 5580097107, 5849392844},
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
            un = false
        end
    end
end

if un == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/DAC.lua"))()
end
]]

-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Logs.lua"),true))()
