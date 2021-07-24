loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()

local plr = game:GetService("Players").LocalPlayer
plr.CharacterAdded:Connect(function()
wait(1)
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
end)
