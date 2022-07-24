local plyr = game.Players.LocalPlayer
local hum = plyr.Character:WaitForChild("Humanoid")
local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Orion/main/source")))()
local Flags    = OrionLib.Flags
local Window = OrionLib:MakeWindow({Name = "ABLEYM HUB", HidePremium = false, SaveConfig = true, ConfigFolder = "./ABLEYM HUB"})


local Tab =
    Window:MakeTab(
    {
        Name = "Local Player",
        Icon = "rbxassetid://7549504320",
        PremiumOnly = false
    }
)
local Section =
    Tab:AddSection(
    {
        Name = "Local-Player"
    }
)

Tab:AddToggle({
    Name = "Loop god mode", 
    Default = false,
    Flag = "B", 
    Save = true, 
    Callback = function(bool)
        while Flags["B"] do
            task.wait()
            plyr.Character:WaitForChild("Humanoid").Health = 100
        end
end})
