local debounce = false

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetChildren()) do
    if v.Name == "RbxCharacterSounds" or v.Name == "Clearall" then -- Locates each "Anti-Cheat script"
        for i,v in pairs(getconnections(v.Changed)) do -- Gets each connection (userdata) that is utilized by the Changed event
            v:Disable()
        end
        for i,v in pairs(getconnections(v.AncestryChanged)) do
            v:Disable()
        end
        debounce = true -- Lets the script know its time to disable the Anti-Cheat for real
    end
end

if debounce then
    print("Script may now disable Anti-Cheat")
    for i2, v2 in pairs(game:GetService("Players").LocalPlayer.PlayerScripts:GetChildren()) do
        if v2.Name == "RbxCharacterSounds" then
            v2.Disabled = true
        end
        if v2.Name == "Clearall" then
            v2.Disabled = true
        end
    end
end