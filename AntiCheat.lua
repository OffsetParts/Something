-- AntiCheatV2 by IrisV3rm
-- if its anything else if will just execute default
print("test")

local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {6006653296, 5580097107, 5849392844},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/CAC.lua"
    },
    
    adonis = {
        Name = "Adonis",
        PlaceIDs = {2772166173, 920587237, 286090429, 6539893534},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AAC.lua"
    },
    
    dahood = {
        Name = "Dahood",
        PlaceIDs = {2788229376},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/Da%20Hood%20Premium%20Stopper.lua"
    },

    lt2 = {
        Name = "LumberTycoon2",
        PlaceIDs = {13822889},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/LT2-anticheatbypass.lua"
    }
}

logs(".")
un = true
for _, games in pairs(bgames) do
    for _, placeid in ipairs(games.PlaceIDs) do
        if placeid == game.placeId then
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
            un = false
        end
    end
end
logs("..")

if un then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/DAC.lua"))()
end
("...")

-- Game Exclusives
--- Dahood
--- Lumber Tycoon 2

-- Full protection with sensible logs that are common to confuse any dev or admin
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Logs.lua"),true))()
