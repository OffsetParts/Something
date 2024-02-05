-- TODO: Make detection more advanced, and add more games.
if not game:IsLoaded() then game.Loaded:Wait() end

local DB = {
    [1] = {
        Name = "Dahood",
        PlaceIDs = {2788229376},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Da%20Hood.lua"
    },
    [2] = {
        Name = "Lumber Tycoon 2",
        PlaceIDs = {13822889},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Lumber%20Tycoon%202.lua"
    },
    [3] = {
        Name = "Combat Warriors",
        PlaceIDs = {4282985734},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Combat%20Warriors.lua"
    },
--[[     [4] = {
        Name = "ZO",
        PlaceIDs = {6678877691},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/ZO.lua"
    }, ]]
    [5] = {
        Name = "Isle",
        PlaceIDs = {3095204897},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Isle.txt"
    },
    [6] = {
        Name = "Magic Training",
        PlaceIDs = {527730528},
        ScriptToRun = "https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Magic%20Training.lua"
    },
    [7] = {
        Name = "SCP - 3008",
        PlaceIDs = {2768379856, 4855440772},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/3008.lua'
    },
    [8] = {
        Name = "TTD3",
        PlaceIDs = {5771467270},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/TTD3.lua2768379856,'
    },
    [9] = { 
        Name = "Untitled Hood",
        PlaceIDs = {7800644383},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/UntitledHood.lua'
    },
    [10] = { 
        Name = "Mr Hood",
        PlaceIDs = {8169234858},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Mr%20Hood.lua'
    },
    [11] = {
        Name = "Berkeley County, Concord",
        PlaceIDs = {6622795055},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Berkeley%20County%2C%20Concord.lua'
    },
    [12] = {
        Name = "CS Prison Life",
        PlaceIDs = {8278412720},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/CS%20Prison%20Life.lua'
    },
    [13] = {
        Name = "Stay alive and flex your time on others",
        PlaceIDs = {5278850819},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Stay%20alive%20and%20flex%20your%20time%20on%20others%20ACB.lua'
    },
    [14] = {
        Name = "Street Warz",
        PlaceIDs = {9796315265},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Streetz%20War.lua'
    },
    [15] = {
        Name = "Trenchz",
        PlaceIDs = {5648523896},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Trenches.lua'
    },
    [16] = {
        Name = "Survive the disasters 2",
        PlaceIDs = {180364455},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Survive%20The%20Disaster%202.lua'
    },
    [17] = {
        Name = "Military Tycoon",
        PlaceIDs = {7180042682},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Military%20Tycoon.lua'
    },
    [18] = {
        Name = "SCP Site 006",
        PlaceIDs = {5897938254},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/SCP%20Site%20006.lua'
    },
    [19] = {
        Name = "Doors",
        PlaceIDs = {6839171747},
        ScriptToRun = 'https://raw.githubusercontent.com/OffsetParts/Something/master/AC%20Bypass/Games/Doors.lua'
    }
}

for i, v in pairs(DB) do
    task.spawn(function()
        for x, placeid in pairs(v.PlaceIDs) do
            if placeid == game.PlaceId then
                -- print(v.Name)
                if Notifier then Notifier('Bypass found, ' .. v.Name, true) end
                loadstring(game:HttpGetAsync((v.ScriptToRun),true))()
            end
        end
    end)
end

Notifier("(#) ACBs", true)