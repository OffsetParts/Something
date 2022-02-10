-- AntiCheatV2 by IrisV3rm
-- if its anything else it will just execute default

local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {6006653296, 5580097107, 5849392844},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/ACs/Presets/CAC.lua"
    },
--[[
    adonis = {
        Name = "Adonis",
        PlaceIDs = {2772166173, 920587237, 286090429, 6539893534},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/ACs/Presets/AAC.lua"
    },
]]--
    dahood = {
        Name = "Dahood",
        PlaceIDs = {2788229376},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Da%20Hood.lua"
    },

    lt2 = {
        Name = "LumberTycoon2",
        PlaceIDs = {13822889},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Lumber%20Tycoon%202.lua"
    }
}

un = true
for _, games in pairs(bgames) do
    for _, placeid in ipairs(games.PlaceIDs) do
        if placeid == game.placeId then
            loadstring(game:HttpGet((games.ScriptToRun),true))()
            un = false
        end
    end
end

if un then
    getgenv()["AntiCheatSettings"] = {};
    getgenv()["AntiCheatSettings"]["Adonis"] = true;
    getgenv()["AntiCheatSettings"]["HD Admin"] = true;
    loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/Bypasses.lua"))()
end


-- idk if they even use this anymore but to try and replace logs so when they check it it looks somewhat normal.
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Logs.lua"),true))()
