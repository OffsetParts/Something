-- Bypass remote calls (No prints/warns as they like to monitor the game logs)
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and self.Name == "53qowq2mZO\227\129\158" and method == "FireServer" then
        if args[1] == "babnnanfbnWLafnb" or args[1] == "egaregafgdartg" or args[1] == "dgsgrdgareg" or args[1] == "HP" or args[1] == "LLLLNLLLPLTSFT" or args[1] == "SAGRESDVRERGYRDSGRDVRDGV" or args[1] == "areghbtredghtrsthsarth" or args[1] == "disdasfasafsasiris" or args[1] == "dsgarbsfa" then
           return;
        else
           return namecall(self, table.unpack(args));
        end
    end

    return OldNamecall(self, ...)
end)

local OldIndex
OldIndex = hookmetamethod(game, "__index", newcclosure(function(...)
    local self, k = ...
    
    if not checkcaller() and k == "ChildAdded" and self.Name == "game" then
        return;
    elseif not checkcaller() and k == "Changed" and self.Name == "Humanoid" and self.Parent == game:GetService("Players").LocalPlayer.Character then
        return;
    end
    
    return OldIndex(...)
end))

local s1 = game:GetService("Players").LocalPlayer.Character:WaitForChild("General", 30) local s2 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Shiftlock", 30) local s3 = game:GetService("Players").LocalPlayer.Character:WaitForChild("Looking", 30)
s1.Disabled = true; s2.Disabled = true; s3.Disabled = true;

--[[
Arguments and meaning/cause:

babnnanfbnWLafnb - Walkspeed Changed
egaregafgdartg - Walkspeed Changed above 57
dgsgrdgareg - HumanoidRootPart.Size.Magnitude > 10
HP - Player child .Changed:Connect()
LLLLNLLLPLTSFT - GetPropertyChangedSignal("PlatformStand")
SAGRESDVRERGYRDSGRDVRDGV - ChildAdded to Player Character
areghbtredghtrsthsarth - Player Character Neck.Part1.Size.Magnitude > 3
disdasfasafsasiris - Logservice contains "dino was" or "Iris's"
dsgarbsfa - game Child added that isn't sound
omomgomgmmg - LocalPlayer.Character.Shiftlock not Disabled
]]
