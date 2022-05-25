-- Universal AntiCheat by IrisV3rm/Iris I take no credit for any of it
-- TODO: Auto Detect ACs and execute on its own to counter both game exclusive ACs and common ones.
-- Most are somewhat outdated but still works... maybe??????

local Name = tostring(game:GetService("MarketplaceService"):GetProductInfo(place).Name)
local Universal = {
    [1] = {
        Name = "Crystal",
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/ACs/Presets/CAC.lua"
    },
}

local bgames = {
    [1] = {
        Name = "Dahood",
        PlaceIDs = {2788229376},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Da%20Hood.lua"
    },
    [2] = {
        Name = "Lumber Tycoon 2",
        PlaceIDs = {13822889},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Lumber%20Tycoon%202.lua"
    },
    [3] = {
        Name = "Combat Warriors",
        PlaceIDs = {4282985734},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Combat%20Warriors.lua"
    },
    [4] = {
        Name = "ZO",
        PlaceIDs = {6678877691},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/ZO.lua"
    },
    [5] = {
        Name = "CounterBlox",
        PlaceIDs = {301549746},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/CounterBlox.lua"
    },
    [6] = {
        Name = "Eden Orphan's Home",
        PlaceIDs = {4786930269},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Eden%20Orphan%20Home.lua"
    },
    [7] = {
        Name = "Isle",
        PlaceIDs = {3095204897},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Isle.txt"
    },
    [8] = {
        Name = "Magic Training",
        PlaceIDs = {527730528},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Magic%20Training.lua"
    },
    [9] = {
        Name = "SCP - 3008",
        PlaceIDs = {2768379856, 4855440772},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/3008.lua'
    },
    [10] = {
        Name = "TTD3",
        PlaceIDs = {5771467270},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/TTD3.lua2768379856,'
    },
    [11] = { 
        Name = "Untitled Hood",
        PlaceIDs = {7800644383},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/UntitledHood.lua'
    },
    [12] = { 
        Name = "Mr Hood",
        PlaceIDs = {8169234858},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Mr%20Hood.lua'
    },
    [13] = {
        Name = "Kaiju Paradise",
        PlaceIDs = {64563517760},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Kaiju%20Paradise.lua'
    },
    [14] = {
        Name = "Berkeley County, Concord",
        PlaceIDs = {6622795055},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Berkeley%20County%2C%20Concord.lua'
    },
    [15] = {
        Name = "Prison Life Remastered",
        PlaceIDs = {8278412720},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Prison%20life%20Remastered.lua'
    }
}

--[[
    BB = { -- Old version
        Name = "Bad Business",
        PlaceIDs = {64563517760},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Bad%20Business%203.03.lua'
    }


]]--

for _, k in next, Universal do
    local link = k.ScriptToRun
    spawn(function() loadstring(game:HttpGet((link),true))() end)
end


for i, v in ipairs(bgames) do
    for x, placeid in ipairs(v.PlaceIDs) do
        if placeid == place then
            loadstring(game:HttpGet((v.ScriptToRun),true))()
            logs(tostring('Bypass script loaded for '.. Name, v.ScriptToRun))
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
