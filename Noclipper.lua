local plr = game:GetService("Players").LocalPlayer

local blacklist = {
    0000000,
}

function Noclip(type)
    if type == false then
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
    elseif type == true then
        plr.CharacterAdded:Connect(function()
            loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
            print('Noclip')
        end)
    end
end

Noclip(false)

for _, games in pairs(blacklist) do
    if game.placeId == games then
        if _G.Logs then
            print('Game is blacklisted cant execute due to ac detection risk')
        end
    else
        Noclip(true)
    end
end
