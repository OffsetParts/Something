-- Universal AntiCheat by IrisV3rm
-- TODO: Auto Detect ACs and execute on its own to counter both game exclusive ACs and common ones.
-- Most are somewhat outdated but still works... maybe??????

local bgames = {
    crystal = {
        Name = "Crystal",
        PlaceIDs = {"Universal"},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/ACs/Presets/CAC.lua"
    },
    dahood = {
        Name = "Dahood",
        PlaceIDs = {2788229376},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Da%20Hood.lua"
    },
    lt2 = {
        Name = "Lumber Tycoon 2",
        PlaceIDs = {13822889},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Lumber%20Tycoon%202.lua"
    },
	cw = {
        Name = "Combat Warriors",
        PlaceIDs = {4282985734},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Combat%20Warriors.lua"
    },
    zo = {
        Name = "ZO",
        PlaceIDs = {6678877691},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/ZO.lua"
    },
    counterb = {
        Name = "CounterBlox",
        PlaceIDs = {301549746},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/CounterBlox.lua"
    },
    edh = {
        Name = "Eden Orphan's Home",
        PlaceIDs = {4786930269},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Eden%20Orphan%20Home.lua"
    },
    isle = {
        Name = "Isle",
        PlaceIDs = {3095204897},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Isle.txt"
    },
    mt = {
        Name = "Magic Training",
        PlaceIDs = {527730528},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Magic%20Training.lua"
    },
    ikea = {
	Name = "SCP - 3008",
	PlaceIDs = {2768379856, 4855440772},
	ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/3008.lua'
    },
    TTD3 = {
	Name = "TTD3",
	PlaceIDs = {5771467270},
	ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/TTD3.lua2768379856,'
    },
    UTH = { 
        Name = "Untitled Hood Game",
        PlaceIDs = {7800644383},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/UntitledHood.lua'
    }
    
}


for i, games in pairs(bgames) do
    for v, placeid in ipairs(games.PlaceIDs) do
        if placeid == game.placeId then
            loadstring(game:HttpGet((games.ScriptToRun),true))()
            logs(v.Name, true)
        elseif placeid == "Universal" then
			-- TODO
        end
    end
end

-- Hooks and detects Adonis and HD admin on its own
getgenv()["AntiCheatSettings"] = {};
getgenv()["AntiCheatSettings"]["Adonis"] = true;
getgenv()["AntiCheatSettings"]["HD Admin"] = true;
loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/Bypasses.lua"))()


-- idk if they even use this anymore but to try and replace logs so when they check it it looks somewhat normal.
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Logs.lua"),true))()
