local Workspace = Services.Workspace
local plr = Services.Players.LocalPlayer

local blacklist = {
    5580097107,
    2768379856,
    3823781113,
    7229033818,
    10421123948,
    9668084201,
    7942446389,
    8061174649,
    8061174873,
    8365571520,
    8892853383,
    8452934184
}

local bl
for _, x in pairs(blacklist) do
    if x == game.PlaceId then
        bl = true
        if Notifier then Notifier("(4a) game is bled, shutting down NT", true) end
    end
end

local Character
local PrimaryPart

local function CharacterAdded(NewCharacter)
    Character = NewCharacter
    repeat
        task.wait()
        PrimaryPart = Character:FindFirstChild("HumanoidRootPart")
    until PrimaryPart

    if not bl then
        if (Character and Character:IsDescendantOf(Workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA "BillboardGui" then
                    v:Destroy()
                end
            end

            Character.DescendantAdded:Connect(function(Child)
                if Child:IsA "BillboardGui" then
                    Child:Destroy()
                end
            end)
        end
    end
end

CharacterAdded(plr.Character or plr.CharacterAdded:Wait())
plr.CharacterAdded:Connect(function()
    CharacterAdded(plr.Character or plr.CharacterAdded:Wait())
end)

Notifier("(2) Nametag Remover", true)