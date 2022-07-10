-- TODO: Make function to get eggs and world table for dropdowns

if not game:IsLoaded() then game.Loaded:Wait() end

getfenv().autoClick = false
getfenv().autoRebirth = false
getfenv().rebirthAmount = 0;
getfenv().buyEgg = false


local RS        = game:GetService('ReplicatedStorage')
local RP        = game:GetService('ReplicatedStorage').Aero:WaitForChild("AeroRemoteServices")
local Workspace = game:GetService('Workspace')
local Players   = game:GetService('Players')

local LP     = Players.LocalPlayer
local worlds = Workspace:WaitForChild("Worlds")
local eggFlr = RS:WaitForChild("EggObjects")
local egs    = {}
local wlds   = {}

local ClickModule = require(LP.PlayerScripts.Aero.Controllers.UI.Click)
local BoostModule = require(RS.Aero.Shared.List.Boosts)
local CraftingTModule = require(RS.Aero.Shared.List.CraftingTiers)
local PetModule   = require(LP.PlayerScripts.Aero.Controllers.UI.Pets)
local gamepasses  = require(RS.Aero.Shared.Gamepasses)
local OrionLib    = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow  = OrionLib:MakeWindow({Name = "Clicker Madness GUI", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Functions = MainWindow:MakeTab({Name = ' Functions ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Eggs      = MainWindow:MakeTab({Name = ' Eggs ', Icon = "rbxassetid://4483345998", premiumOnly = false})
local Teleport  = MainWindow:MakeTab({Name = ' Teleport ', Icon = "rbxassetid://4483345998", premiumOnly = false})

BoostModule.GetDurations = function(...) return -1 end -- return infinite duration

--[[
local oldFunc1

local oldFunc1 = hookfunction(gamepasses.HasPassOtherwisePrompt, newcclosure(function(...)
    local args = {...}

    for i, v in next, args do
        print(i, v, typeof(v))
    end

    return oldFunc1(unpack(args))
end))
]]

--[[
Functions:AddButton({Name = 'Get gamepasses', Callback = spawn(function()
    gamepasses.HasPass = function(...)
        return true 
    end 
end) })
]]--

Functions:AddToggle({
	Name = "AutoTap",
    default = false,
	Callback = function(bool: boolean)
        autoClick = bool
        spawn(function()
            while autoClick == true do
                task.wait(0.01) 
                ClickModule:Click()     
            end
        end)
    end
})

Functions:AddTextbox({
	Name = "Rebirth Amount",
	Default = "Ex: 1000",
	TextDisappear = false,
	Callback = function(value: number)
        rebirthAmount = value
       --print(RebirthAmount)
	end	  
})

Functions:AddToggle({
	Name = "Auto Rebirth",
    default = false,
	Callback = function(bool: boolean) 
        autoRebirth = bool
        spawn(function()
            while autoRebirth == true do
                task.wait()
                RP.RebirthService.BuyRebirths:FireServer(rebirthAmount)
            end
        end)
    end
})

Functions:AddButton({Name = 'inf pet equip', Callback = function() end})

local function AddChildren(obj, arr)
    if obj[1] and obj[2] then
        for i = 1, #obj do
            task.wait()
            table.insert(arr, obj[i])
        end
    end
    return arr
end

Eggs:AddLabel("Enable toggle first")

Eggs:AddToggle({
	Name = "Autobuy egg",
    default = false,
	Callback = function(bool: boolean) 
        buyEgg = bool
    end
})

local EggsD = Eggs:AddDropdown({Name = 'Buy Eggs', Default = '1', options = {'1', '2'}, 
    Callback = function(value: string)
        spawn(function()
            while task.wait(0.05) do
                if not buyEgg then break end
                RP.EggService.Purchase:FireServer(value)
            end
        end)
    end
})


function TeleportTo(pos) -- CFrame
    if not LP.Character then return end
    LP.Character:WaitForChild("HumanoidRootPart").CFrame = pos
end

local TeleD = Teleport:AddDropdown({Name = 'Teleport to island', Default = '1',  options = {'1', '2'}, 
    Callback = function(value: string)
        if worlds then
            TeleportTo(worlds:WaitForChild(value).Teleport.CFrame)
        end
    end
})

AddChildren(eggFlr, egs) AddChildren(worlds, wlds)
EggsD:Refresh(egs, true) TeleD:Refresh(wlds, true)

--[[ Deprecated:

    local function getPos()
        if not LP.Character then return end
        local char = LP.Character
        local HRP = char:WaitForChild("HumanoidRootPart")
        local pos = HRP.CFrame

        return pos
    end


    Functions:AddButton({
        Name = "Destroy GUI",
        Callback = function() OrionLib:Destroy() end
    })

    local Drops = Workspace:WaitForChild(game:GetService("Workspace").ScriptObjects)
    local Playerhead = game.Players.LocalPlayer.Character.Head


    for i, v in pairs(Drops:GetDescendants()) do
        if v.ClassName == 'TouchInterest' and v.Parent.Name == 'HumanoidRootPart' then
            for i = 0, 1 do
                wait(0.1)
                firetouchinterest(Playerhead, v.Parent, i)
            end
        end
    end
]]--


OrionLib:MakeNotification({
	Name = "GUI loaded",
	Content = "Made by Scrumptious, this is skidded",
	Image = "rbxassetid://4483345998",
	Time = 3
})

OrionLib:Init()