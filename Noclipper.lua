local plr = game:GetService("Players").LocalPlayer

local blacklist = {
    0000000,
}

function Noclip()
    plr.CharacterAdded:Connect(function()
        loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
    end
end
    
Noclip()

for _, games in pairs(blacklist) do
    if game.placeId == games then
        if _G.Logs then
            print('Game is blacklisted cant execute due to ac detection risk')
        end
    else
        Noclip()
    end
end
