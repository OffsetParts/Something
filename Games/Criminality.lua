if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

_senv["Criminality"] = {
    InfiniteStamina = false,
    NoJumpCooldown = false,
    SpaceJump = false,
    EasyLockPick = false,
    AutoPickCash = false,
    IsDead = true,
    NoBarbwire = false,
    NoFallDamage = false,
    NoRagdoll = false,
    NoClip = false,
    AutoPickScrap = false,
    AutoPickTools = false,
    GunModsNoRecoil = false,
    GunModsInstantEquip = false,
    GunModsSpread = false,
    GunModsAutoMode = false,
    GunModsSpreadAmount = 0,
    MoneyCooldown = false,
    ScrapCooldown = false,
    ToolCooldown = false
}

local Settings = _senv["Criminality"]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Https = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera
local worldToViewportPoint = Camera.worldToViewportPoint

local OrionLib = loadstring(game:HttpGet(("https://raw.githubusercontent.com/shlexware/Orion/main/source")))()
local Window   = OrionLib:MakeWindow({Name = "Criminality by Voxy+Woody", HidePremium = false, SaveConfig = false, ConfigFolder = ".\Scrumpy\Criminality"})

local Visuals   = Window:MakeTab({Name = "Visuals", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Functions = Window:MakeTab({Name = "Functions", Icon = "rbxassetid://4483345998", PremiumOnly = false})


local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP:Toggle(true)
ESP.Players = false
ESP.Tracers = false
ESP.Boxes = false
ESP.Names = false


function BypassAnticheat()
    local function CheckTable(tbl, ...)
        local Indexes = {...}
    
        for _, v in pairs(Indexes) do
            if not (rawget(tbl, v)) then
                return false
            end
        end
    
        return true
    end
    
    local u21
    for _,v in ipairs(getgc(true)) do
        if (typeof(v) == "table" and CheckTable(v, "A", "B", "GP", "EN")) then
            u21 = v
            break
        end
    end
    
    hookfunction(u21.A, function()
        task.wait(9e9)       
    end)

    hookfunction(u21.B, function()
        task.wait(9e9)                    
    end)
end

local Tab = Window:MakeTab({Name = "Tab", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local Section =
    Tab:AddSection(
    {
        Name = "Misc locations"
    }
)

Tab:AddButton(
    {
        Name = "Top Of Big Tower",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4499.18652,
                149.349579,
                -778.905823,
                -0.998596847,
                4.50936035e-08,
                0.0529554971,
                4.8429122e-08,
                1,
                6.17040143e-08,
                -0.0529554971,
                6.4182025e-08,
                -0.998596847
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Subway Dealer",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4600.4585,
                -32.3005524,
                -695.927612,
                0.530305207,
                2.03601158e-09,
                0.847806811,
                -6.67458693e-08,
                1,
                3.93481976e-08,
                -0.847806811,
                -7.74541604e-08,
                0.530305207
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Random Park",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4851.82471,
                5.94496632,
                -952.589172,
                -0.204288766,
                4.55907703e-08,
                -0.978910685,
                1.76995698e-08,
                1,
                4.28792433e-08,
                0.978910685,
                -8.56655014e-09,
                -0.204288766
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Motel",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4598.73633,
                3.79444528,
                -899.746826,
                -0.00993905962,
                1.4557183e-08,
                0.999950588,
                3.12706838e-09,
                1,
                -1.45268206e-08,
                -0.999950588,
                2.98253089e-09,
                -0.00993905962
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Club Vibing",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4402.354,
                6.26440477,
                -395.832977,
                -0.142332435,
                -1.14957629e-07,
                0.989818931,
                -4.04555038e-08,
                1,
                1.10322702e-07,
                -0.989818931,
                -2.43411229e-08,
                -0.142332435
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Gunstore",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4201.65283,
                3.99884629,
                -186.468964,
                0.0162894446,
                8.433895e-08,
                0.99986732,
                2.79714847e-08,
                1,
                -8.48058406e-08,
                -0.99986732,
                2.93492128e-08,
                0.0162894446
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Gunstore ATM",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4147.74316,
                3.79415846,
                -169.388138,
                0.222692311,
                8.81103119e-08,
                0.974888802,
                -8.20928605e-08,
                1,
                -7.16275181e-08,
                -0.974888802,
                -6.40805098e-08,
                0.222692311
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "Bottom Elevator",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                -4777.29248,
                -200.966492,
                -966.458313,
                -0.999919474,
                -6.53394281e-08,
                -0.0126896836,
                -6.43712141e-08,
                1,
                -7.67077069e-08,
                0.0126896836,
                -7.58846781e-08,
                -0.999919474
            )
        end
    }
)

Tab:AddButton(
    {
        Name = "TPNAME",
        Callback = function()
            Player.Character.HumanoidRootPart.CFrame = CFrame.new()
        end
    }
)

local Section = Visuals:AddSection({Name = "ESP"})

-- Med safes
for i, v in pairs(Workspace.Map.BredMakurz:GetDescendants()) do
    if string.find(v.Name, "MediumSafe") then
        if v:FindFirstChild("MainPart") then
            ESP:Add(
                v.MainPart,
                {
                    Name = "Medium Safe",
                    IsEnabled = "mediumSafe",
                    Color = Color3.fromRGB(139, 203, 255)
                }
            )
        end
    end
end

-- Small safes
for i, v in pairs(Workspace.Map.BredMakurz:GetDescendants()) do
    if string.find(v.Name, "SmallSafe") then
        if v:FindFirstChild("MainPart") then
            ESP:Add(
                v.MainPart,
                {
                    Name = "Small Safe",
                    IsEnabled = "smallSafe",
                    Color = Color3.fromRGB(228, 236, 243)
                }
            )
        end
    end
end

-- Registers
for i, v in pairs(Workspace.Map.BredMakurz:GetDescendants()) do
    if string.find(v.Name, "Register") then
        if v:FindFirstChild("MainPart") then
            ESP:Add(
                v.MainPart,
                {
                    Name = "Register",
                    IsEnabled = "registerSafe",
                    Color = Color3.fromRGB(255, 0, 128)
                }
            )
        end
    end
end

-- ATMs
for i, v in pairs(Workspace.Map.ATMz:GetDescendants()) do
    if string.find(v.Name, "ATM") then
        if v:FindFirstChild("MainPart") then
            ESP:Add(
                v.MainPart,
                {
                    Name = "ATM",
                    IsEnabled = "atmPart",
                    Color = Color3.fromRGB(0, 255, 42)
                }
            )
        end
    end
end

-- Dealers
for i, v in pairs(Workspace.Map.Shopz:GetDescendants()) do
    if string.find(v.Name, "Dealer") then
        if v:FindFirstChild("MainPart") then
            ESP:Add(
                v.MainPart,
                {
                    Name = "Dealer",
                    IsEnabled = "dealerStore",
                    Color = Color3.fromRGB(255, 189, 128)
                }
            )
        end
    end
end

-- Scraps
ESP:AddObjectListener(
    Workspace.Filter.SpawnedPiles,
    {
        Type = "Model",
        CustomName = "Scrap",
        Color = Color3.fromRGB(216, 255, 164),
        IsEnabled = "scrapPart"
    }
)

Visuals:AddToggle(
    {
        Name = "ESP Toggle",
        Default = false,
        Callback = function(Value)
            ESP:Toggle(Value)
        end
    }
)

Visuals:AddToggle(
    {
        Name = "ESP Boxes",
        Default = false,
        Callback = function(Value)
            ESP.Boxes = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "ESP Tracers",
        Default = false,
        Callback = function(Value)
            ESP.Tracers = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "ESP Names",
        Default = false,
        Callback = function(Value)
            ESP.Names = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Players",
        Default = false,
        Callback = function(Value)
            ESP.Players = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Medium Safes",
        Default = false,
        Callback = function(Value)
            Settings.mediumSafe = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Small Safes",
        Default = false,
        Callback = function(Value)
            Settings.smallSafe = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Registers",
        Default = false,
        Callback = function(Value)
            Settings.registerSafe = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show ATMs",
        Default = false,
        Callback = function(Value)
            Settings.atmPart = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Dealers",
        Default = false,
        Callback = function(Value)
            Settings.dealerStore = Value
        end
    }
)

Visuals:AddToggle(
    {
        Name = "Show Scraps",
        Default = false,
        Callback = function(Value)
            Settings.scrapPart = Value
        end
    }
)

Player.PlayerGui.ChildAdded:Connect(
    function(Item)
        if Settings.EasyLockPick == true then
            if Item.Name == "LockpickGUI" then
                Item.MF["LP_Frame"].Frames.B1.Bar.UIScale.Scale = 11
                Item.MF["LP_Frame"].Frames.B2.Bar.UIScale.Scale = 11
                Item.MF["LP_Frame"].Frames.B3.Bar.UIScale.Scale = 11
            end
        elseif Settings.EasyLockPick == false then
            if Item.Name == "LockpickGUI" then
                Item.MF["LP_Frame"].Frames.B1.Bar.UIScale.Scale = 1
                Item.MF["LP_Frame"].Frames.B2.Bar.UIScale.Scale = 1
                Item.MF["LP_Frame"].Frames.B3.Bar.UIScale.Scale = 1
            end
        end
    end
)

coroutine.wrap(function ()
    RunService.RenderStepped:Connect(function()
        if Settings.AutoPickScrap == true then
            for i, v in pairs(Workspace.Filter.SpawnedPiles:GetChildren()) do
                if Settings.IsDead == false then
                    if (Player.Character:FindFirstChild("HumanoidRootPart").Position - v:FindFirstChild("MeshPart").Position).Magnitude < 5 then
                        if Settings.ScrapCooldown == false then
                            Settings.ScrapCooldown = true
                            ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(v:GetAttribute("zp")))
                            wait(1)
                            Settings.ScrapCooldown = false
                        end
                    end
                end
            end
        end
    end)
end)()

coroutine.wrap(function ()
    RunService.RenderStepped:Connect(function()
        if Settings.AutoPickTools == true then
            for i, v in pairs(Workspace.Filter.SpawnedTools:GetChildren()) do
                if ESP.IsDead == false then
                    if (Player.Character:FindFirstChild("HumanoidRootPart").Position - v:FindFirstChildWhichIsA("MeshPart").Position).Magnitude < 5 then
                        if Settings.ToolCooldown == false then
                            Settings.ToolCooldown = true
                            ReplicatedStorage.Events.PIC_TLO:FireServer(v:FindFirstChildWhichIsA("MeshPart"))
                            wait(1)
                            Settings.ToolCooldown = false
                        end
                    end
                end
            end
        end
    end)
end)()

coroutine.wrap(function()
    RunService.RenderStepped:Connect(function()
    if Settings.AutoPickCash == true then
        for i, v in pairs(Workspace.Filter.SpawnedBread:GetChildren()) do
                if Settings.IsDead == false then
                    if (Player.Character:FindFirstChild("HumanoidRootPart").Position - v:FindFirstChild("MeshPart").Position).Magnitude < 5 then
                        if Settings.MoneyCooldown == false then
                            Settings.MoneyCooldown = true
                            ReplicatedStorage.Events.CZDPZUS:FireServer(v)
                            wait(1)
                            Settings.MoneyCooldown = false
                        end
                    end
                end
            end
        end
    end)
end)()

local oldNamecall; oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local tab = ...
    if (not checkcaller() and getnamecallmethod() == "FireServer" and Settings.NoFallDamage) and tostring(tab) == "__DFfDD" then
        return wait(9e9)
    elseif (not checkcaller() and getnamecallmethod() == "FireServer" and Settings.NoBarbwire) and tostring(tab) == "BHHh" then
        return wait(9e9)
    elseif (not checkcaller() and getnamecallmethod() == "FireServer" and Settings.NoRagdoll) and tostring(tab) == "__--r" then
        return wait(9e9)
    end

    return oldNamecall(...)
end))

local __newindex; __newindex = hookmetamethod(game, "__newindex", function(t, k, v)
    if (t:IsDescendantOf(Character) and k == "Jump" and v == false) then
        if Settings.NoJumpCooldown == true then
            return
        end
    end

    return __newindex(t, k, v)
end)

local oldStamina; oldStamina = hookfunction(getupvalue(getrenv()._G.S_Take, 2), function(v1, ...)
    if (Settings.InfiniteStamina) then
        v1 = 0
    end
    return oldStamina(v1, ...)
end)

local Section =
    Functions:AddSection(
    {
        Name = "Utilities"
    }
)

Functions:AddToggle(
    {
        Name = "Inf Stamina",
        Default = false,
        Callback = function(Value)
            Settings.InfiniteStamina = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "No Jump Cooldown",
        Default = false,
        Callback = function(Value)
            Settings.NoJumpCooldown = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "Inf Jump",
        Default = false,
        Save = true,
        Flag = "Player_InfiniteJumpToggle",
        Callback = function(state)
            mouse.KeyDown:connect(
                function(key)
                    if OrionLib.flags["Player_InfiniteJumpToggle"] and key == " " then
                        Player.Character.Humanoid:ChangeState(3)
                        wait()
                    end
                end
            )
        end
    }
)

Functions:AddToggle(
    {
        Name = "NoFail Lockpick",
        Default = false,
        Callback = function(Value)
            Settings.EasyLockPick = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "Auto Pick Up Cash",
        Default = false,
        Callback = function(Value)
            Settings.AutoPickCash = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "Auto Pick Up Tools",
        Default = false,
        Callback = function(Value)
            Settings.AutoPickTools = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "Auto Pick Up Scrap",
        Default = false,
        Callback = function(Value)
            Settings.AutoPickScrap = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "No Fall Damage",
        Default = false,
        Callback = function(Value)
            Settings.NoFallDamage = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "No Barbwire",
        Default = false,
        Callback = function(Value)
            Settings.NoBarbwire = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "No Ragdoll",
        Default = false,
        Callback = function(Value)
            Settings.NoRagdoll = Value
        end
    }
)

Functions:AddToggle(
    {
        Name = "Noclip Doors",
        Default = false,
        Callback = function(Value)
            Settings.NoClip = Value

            if Settings.NoClip == true then
                for _, v in pairs(Workspace.Map.Doors:GetChildren()) do
                    if v:FindFirstChild("DoorBase") then
                        v.DoorBase.CanCollide = false
                    end
                    if v:FindFirstChild("DoorA") then
                        v.DoorA.CanCollide = false
                    end
                    if v:FindFirstChild("DoorB") then
                        v.DoorB.CanCollide = false
                    end
                    if v:FindFirstChild("DoorC") then
                        v.DoorC.CanCollide = false
                    end
                    if v:FindFirstChild("DoorD") then
                        v.DoorD.CanCollide = false
                    end
                end
            else
                for _, v in pairs(Workspace.Map.Doors:GetChildren()) do
                    if v:FindFirstChild("DoorBase") then
                        v.DoorBase.CanCollide = true
                    end
                    if v:FindFirstChild("DoorA") then
                        v.DoorA.CanCollide = true
                    end
                    if v:FindFirstChild("DoorB") then
                        v.DoorB.CanCollide = true
                    end
                    if v:FindFirstChild("DoorC") then
                        v.DoorC.CanCollide = true
                    end
                    if v:FindFirstChild("DoorD") then
                        v.DoorD.CanCollide = true
                    end
                end
            end
        end
    }
)

OrionLib:Init()
