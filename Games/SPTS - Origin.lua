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

local TAs = Workspace:WaitForChild("Map"):WaitForChild("Training_Collisions")

local Settings = {
    FMS = false,
    FFS = false,
    FBT = false,
    FJF = false,
    FPP = false
}

local Multipliers = {
    FS = 1,
    MS = 1,
    BT = 1,
    JF = 1,
    PP = 1
}

-- < Functions > --
function getList(Parent: Instance)
    local list = {}
    for _,v in pairs(Parent:GetChildren()) do
        table.insert(list, v.Name)
    end
    return list
end

-- < GUI > --
local OrionLib     = loadstring(game:HttpGetAsync(('https://raw.githubusercontent.com/shlexware/Orion/main/source'), true))()
local Orion        = CoreGui:FindFirstChild("Orion")

local MainWindow   = OrionLib:MakeWindow({Name = "SPTS - Origin", HidePremium = false, SaveConfig = true, ConfigFolder = "./Scrumpy/SPTS", IntroEnabled = true, IntroText = "Amigos",})

local MLT    = MainWindow:MakeTab({Name = ' Multipliers '})
local AF     = MainWindow:MakeTab({Name = ' Auto Farm '})
local TP     = MainWindow:MakeTab({Name = ' Teleports '})
local Misc   = MainWindow:MakeTab({Name = ' Misc '})

local Info   = MLT:AddSection({Name = ' Info '})
local Pliers = MLT:AddSection({Name = ' Pliers '})

Info:AddParagraph("Quick Note", "Go your limit, or you will die or do to little.")
Info:AddParagraph("Example", "Fist Strength - Rock(100 FS), Crystal(10K), same everything else. Default is always 1.")
Pliers:AddParagraph("Q/N","Can't Farm BT and FS at the same time, game bugs out.")

Pliers:AddDropdown({
    Name = "Fist Strength",
    Default = "Default",
    Options = {
        "Default",
        "Rock",
        "Crystal",
        "Blue God Star",
        "Green God Star",
        "Red God Star",
    },
    Callback = function(value)
        local index = {
            ["Default"] = 1,
            ["Rock"] = 2,
            ["Crystal"] = 3,
            ["Blue God Star"] = 4,
            ["Green God Star"] = 5,
            ["Red God Star"] = 6,
        }
        Multipliers.FS = index[value]
    end,
    Flag = "FSM",
    Save = true
})

--[[ Pliers:AddDropdown({
    Name = "Body Toughness",
    Default = "Default",
    Options = {
        "Default",
        "Water_b",
        "Fire_b",
        "Iceberg",
        "Tornado",
        "Valcano",
    },
    Callback = function(value)
        local index = {
            ["Default"] = 1,
            ["Acid_b"] = 2,
            ["Fire_b"] = 3,
            ["Iceberg"] = 4,
            ["Tornado"] = 5,
            ["Valcano"] = 6
        }
        Multipliers.BT = index[value]
    end,
    Flag = "BTM",
    Save = true
}) ]]

Pliers:AddDropdown({
    Name = "Psychic Power",
    Default = "Default",
    Options = {
        "Default",
        "Flying",
        "First_Lawn",
        "Second_Lawn",
        "Bridge",
        "Waterfall"
    },
    Callback = function(value)
        local index = {
            ["Default"] = 1,
            ["Flying"] = 2,
            ["First_Lawn"] = 3,
            ["Second_Lawn"] = 4,
            ["Bridge"] = 5,
            ["Waterfall"] = 6
        }
        Multipliers.PP = index[value]
    end,
    Flag = "PPM",
    Save = true
})

Pliers:AddDropdown({
    Name = "Movement Speed",
    Default = "Default",
    Options = {
        "Default",
        "100_LB",
        "1_TON",
        "10_TON",
        "100_TON",
    },
    Callback = function(value)
        local index = {
            ["Default"] = 1,
            ["100_LB"] = 2,
            ["1_TON"] = 3,
            ["10_TON"] = 4,
            ["100_TON"] = 5,
        }
        Multipliers.MS = index[value]
    end,
    Flag = "MSM",
    Save = true
})

Pliers:AddDropdown({
    Name = "Jump Force",
    Default = "Default",
    Options = {
        "Default",
        "100_LB",
        "1_TON",
        "10_TON",
        "100_TON",
    },
    Callback = function(value)
        local index = {
            ["Default"] = 1,
            ["100_LB"] = 2,
            ["1_TON"] = 3,
            ["10_TON"] = 4,
            ["100_TON"] = 5,
        }
        Multipliers.JF = index[value]
    end,
    Flag = "JFM",
    Save = true
})

AF:AddToggle({
    Name = "Auto MS",
    Note = "Farm Movement Speed",
    Default = false,
    Callback = function(Value)
        Settings.FMS = Value
        if Settings.FMS then
            task.spawn(function()
                while Settings.FMS do
                    local args = {
                        [1] = "Add_MS_Request",
                        [2] = Multipliers.MS
                    }
                    ReplicatedStorage.RemoteEvent:FireServer(args)
                    task.wait(1) -- there is a cooldown to when you can fire these, cry about it
                end
            end)
        end
    end,
    Flag = "MS",
    Save = true
})

AF:AddToggle({
    Name = "Auto JF",
    Note = "Farm Jump Force",
    Default = false,
    Callback = function(Value)
        Settings.FJF = Value
        if Settings.FJF then
            task.spawn(function()
                while Settings.FJF do
                    local args = {
                        [1] = "Add_JF_Request",
                        [2] = Multipliers.JF
                    }
                    ReplicatedStorage.RemoteEvent:FireServer(args)
                    task.wait(1)
                end
            end)
        end
    end,
    Flag = "JF",
    Save = true
})

AF:AddToggle({
    Name = "Auto FS",
    Note = "Farm Fist Strength",
    Default = false,
    Callback = function(Value)
        Settings.FFS = Value
        if Settings.FFS then
            task.spawn(function()
                while Settings.FFS do
                    local args = {
                        [1] = "+FS" .. tostring(Multipliers.FS),
                    }
                    ReplicatedStorage.RemoteEvent:FireServer(args)
                    task.wait(1)
                end
            end)
        end
    end,
    Flag = "FS",
    Save = true
})

--[[ AF:AddToggle({
    Name = "Auto BT",
    Note = "Farm Body Toughness",
    Default = false,
    Callback = function(Value)
        Settings.FBT = Value
        if Settings.FBT then
            task.spawn(function()
                while Settings.FBT do
                    local args = {
                        [1] = "+BT" .. tostring(Multipliers.BT),
                    }
                    ReplicatedStorage.RemoteEvent:FireServer(args)
                    task.wait(1.25)
                end
            end)
        end
    end,
    Flag = "BT",
    Save = true
}) ]]

AF:AddToggle({
    Name = "Auto PP",
    Note = "Farm Psychic Power",
    Default = false,
    Callback = function(Value)
        Settings.FPP = Value
        if Settings.FPP then
            task.spawn(function()
                while Settings.FPP do
                    local args = {
                        [1] = "+PP" .. tostring(Multipliers.PP),
                    }
                    ReplicatedStorage.RemoteEvent:FireServer(args)
                    task.wait(1.5)
                end
            end)
        end
    end,
    Flag = "PP",
    Save = true
})

TP:AddDropdown({
    Name = "TP to FS training area",
    Default = "N\A",
    Options = getList(TAs:WaitForChild("FistStrength")),
    Callback = function(value)
        local tpTo = TAs:WaitForChild("FistStrength"):WaitForChild(value)
        print(tpTo.Name)
        HRP.CFrame = tpTo.CFrame
    end
})

TP:AddDropdown({
    Name = "TP to BT training area",
    Default = "N\A",
    Options = getList(TAs:WaitForChild("BodyToughness")),
    Callback = function(value)
        local tpTo = TAs:WaitForChild("BodyToughness"):WaitForChild(value)
        HRP.CFrame = tpTo.CFrame
    end
})

TP:AddDropdown({
    Name = "TP to PP training area",
    Default = "N\A",
    Options = getList(TAs:WaitForChild("PsychicPower")),
    Callback = function(value)
        local tpTo = TAs:WaitForChild("PsychicPower"):WaitForChild(value)
        HRP.CFrame = tpTo.CFrame
    end
})

Misc:AddBind({
    Name = "Control Gui",
    Default = Enum.KeyCode.RightShift,
    Hold = false,
    Callback = function() 
        Orion.Enabled = not Orion.Enabled 
    end,
    Flag = "GUI",
    Save = true,
})

OrionLib:MakeNotification({
	Name = "Loaded",
	Content = "All scripts are skidded by default",
	Image = "rbxassetid://4483345998",
	Time = 3.5
})

OrionLib:Init()