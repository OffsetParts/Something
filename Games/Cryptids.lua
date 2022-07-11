local _senv = getgenv() or _G

-- Switches --
_senv["CoTC"] = {
    MobESP = false,
    ItemESP = false,
    PlayerESP = false,
}

local Settings = _senv["CoTC"]


local Players           = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService('RunService')
local CoreGui           = game:GetService("CoreGui")

local LP           = Players.LocalPlayer
local Hum          = LP.Character:FindFirstChild("HumanoidRootPart")
local cam          = Workspace.CurrentCamera

local OrionLib     = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

local ESP           = MainWindow:MakeTab({Name = ' ESP ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Functions     = MainWindow:MakeTab({Name = ' Miscellanous ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Config        = MainWindow:MakeTab({Name = ' Settings ', Icon = "rbxassetid://4483345998", premiumOnly = false})

if game.PlaceId == 5202597474 then

end

Functions:AddBind({
    Name = "Fullbright",
    Default = "Enum.KeyCode.F",
    Hold = false,
    Callback = function() loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Utilites/Fullbright.lua'), true))() end,
    Flag = "FB",
    Save = true
})

Functions:AddBind({
    Name = "No Fog",
    Default = "Enum.KeyCode.C",
    Callback = function()
        game:GetService("Lighting").FogEnd = 786543
        for i,v in pairs(game:GetService("Lighting"):GetDescendants()) do
            if v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end,
    Flag = "NF",
    Save = true
})

Config:AddBind({
    Name = "GUI Keybind",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function() Orion.Enabled = not Orion.Enabled end,
    Flag = "GUI_Keybind",
    Save = true,
})

OrionLib:MakeNotification({
	Name = "GUI loaded",
	Content = "Made by Scrumptious, this is skidded",
	Image = "rbxassetid://4483345998",
	Time = 3
})

OrionLib:Init()