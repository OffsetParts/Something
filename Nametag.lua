local Player = game:GetService("Players").LocalPlayer
local char = Player.Character

while true do
    for i, v in pairs(char:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
    wait(1)
end
