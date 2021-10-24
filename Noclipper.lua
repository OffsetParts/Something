local plr = game:GetService("Players").LocalPlayer:Wait()
loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()

plr.CharacterAdded:Connect(function()
wait(0.2)
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
end)
