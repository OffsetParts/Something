loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()

plr.CharacterAdded:Connect(function()
wait(0.5)
    local REP = plr.Character:WaitForChild("HumanoidRootPart")
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
end)
