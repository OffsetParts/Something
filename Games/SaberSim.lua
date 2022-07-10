getgenv()["Saber_Sim"] = {
    AutoSwing = true,
    AutoSell  = false,

}

Settings = getgenv()["Saber_Sim"]

local LP = game.Players.LocalPlayer
local Backpack = LP:FindFirstChildOfClass("Backpack")
local char = LP.Character

local equip = char:FindFirstChildOfClass("Tool") or Backpack:FindFirstChildOfClass("Tool")

-- Auto Swing
if equip then
    local RE = equip.RemoteClick
    if Settings.AutoSwing then
        repeat
            task.wait()
            RE:FireServer()
        until char.Humanoid.Health == 0
    end
end