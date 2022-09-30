-- Sword Factory X

-- < Services > --
local CoreGui               = game:GetService("CoreGui")
local Players               = game:GetService("Players")
local Workspace             = game:GetService("Workspace")
local RunService            = game:GetService("RunService")
local ReplicatedStorage     = game:GetService("ReplicatedStorage")

-- < Variables > --
local localPlayer           = Players.LocalPlayer

local Character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local Settings = {
    Enabled = true,
}

-- Example
--[[ local args = {
    [1] = 0,
    [2] = "UpgradeServer",
    [3] = "Upgrade",
    [4] = {
        [1] = "Molder",
        [2] = 50,
        [3] = true -- marks for prestige
    }
} ]]

-- ReplicatedStorage.Framework.RemoteFunction:InvokeServer(unpack(args))

local Machines = {
    ["Conveyor"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Molder"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Polisher"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Classifier"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Upgrader"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Enchanter"] = { 
        Auto = true, 
        Prestige = true
    }, 
    ["Appraiser"] = { 
        Auto = true, 
        Prestige = true
    }
}

function auto(Machine: string, Amount: number)
    task.spawn(function ()
        local args = {
            [1] = 0,
            [2] = "UpgradeServer",
            [3] = "Upgrade",
            [4] = {
                [1] = Machine,
                [2] = Amount,
            }
        }

        ReplicatedStorage.Framework.RemoteFunction:InvokeServer(unpack(args))
    
        args = { -- find a way to determine if prestige is avaliable
            [1] = 0,
            [2] = "UpgradeServer",
            [3] = "Upgrade",
            [4] = {
                [1] = Machine,
                [2] = 1,
                [3] = true
            }
        }
        
        ReplicatedStorage.Framework.RemoteFunction:InvokeServer(unpack(args))
    end)
end

while task.wait(0.5) do
    if Settings.Enabled then
        for i, v in pairs(Machines) do
            if v.Auto then
                task.spawn(function () auto(i, 50) end)
            end
        end
    end
end
