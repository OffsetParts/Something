-- Universal AntiCheat by IrisV3rm/Iris I take no credit for any of it
-- TODO: Auto Detect ACs and execute on its own to counter both game exclusive ACs and common ones.
-- Most are somewhat outdated but still works... maybe??????
if not game:IsLoaded() then game.Loaded:Wait() end


local DB = {
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
--[[     [5] = {
        Name = "CounterBlox",
        PlaceIDs = {301549746},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/CounterBlox.lua"
    }, ]]
--[[     [6] = {
        Name = "Eden Orphan's Home",
        PlaceIDs = {4786930269},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Eden%20Orphan%20Home.lua"
    } ]]
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
--[[     [9] = {
        Name = "SCP - 3008",
        PlaceIDs = {2768379856, 4855440772},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/3008.lua'
    }, ]]
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
    [14] = {
        Name = "Berkeley County, Concord",
        PlaceIDs = {6622795055},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Berkeley%20County%2C%20Concord.lua'
    },
    [15] = {
        Name = "CS Prison Life",
        PlaceIDs = {8278412720},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/CS%20Prison%20Life.lua'
    },
    [16] = {
        Name = "Stay alive and flex your time on others",
        PlaceIDs = {5278850819},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Stay%20alive%20and%20flex%20your%20time%20on%20others%20ACB.lua'
    },
    [17] = {
        Name = "Street Warz",
        PlaceIDs = {9796315265},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Streetz%20War.lua'
    },
    [18] = {
        Name = "Trenchz",
        PlaceIDs = {5648523896},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Trenches.lua'
    },
    [19] = {
        Name = "Survive the disasters 2",
        PlaceIDs = {180364455},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Survive%20The%20Disaster%202.lua'
    },
    [20] = {
        Name = "Strucid",
        PlaceIDs = {286090429},
        ScriptToRun = 'https://raw.githubusercontent.com/Input50/Something/master/AC%20Bypass/Games/Strucid.lua'
    }
}

for i, v in ipairs(DB) do
    task.wait()
    for x, placeid in pairs(v.PlaceIDs) do
        if placeid == game.PlaceId then
            local Name = tostring(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
            loadstring(game:HttpGetAsync((v.ScriptToRun),true))()
            if Notifier then Notifier('Bypassed', true) end
        end
    end
end


--[[ getgenv()["AntiCheatSettings"] = {};
getgenv()["AntiCheatSettings"]["Adonis"] = true;
getgenv()["AntiCheatSettings"]["HD Admin"] = true;
loadstring(game:HttpGetAsync("https://api.irisapp.ca/Scripts/Bypasses.lua"))() ]]

-- This just replaces the log entries in LogService with believeable ones so moderators don't suspect you when looking at them.
-- loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Logs.lua"),true))() | Apparently adonis check log hijacking
