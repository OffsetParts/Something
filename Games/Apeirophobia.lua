-- TODO: get the level section done
-- game > https://www.roblox.com/games/9508087919/Apeirophobia-The-End-UPDATE

if not game:IsLoaded() then game.Loaded:Wait() end
if game.Players.LocalPlayer:FindFirstChild("inLobby") then return end -- if lobby stop script

repeat task.wait(0.01666666667) until game.ReplicatedStorage:FindFirstChild("Users") and game.ReplicatedStorage.Users.intro.Value and game.ReplicatedStorage.Users.h2p.Value -- wait until game launches

-- < Services > --
local Players           = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace         = game:GetService("Workspace")
local RunService        = game:GetService('RunService')
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Lighting          = game:GetService("Lighting")

getgenv().Apeirophobia = getgenv().Apeirophobia or {} -- made global so drawings and shit don't get lost


local Settings 
Apeirophobia.Settings = Apeirophobia.Settings or {
    WalkSpeed   = 10,
    JumpPower   = 30,
    WSEnable    = false,
    JPEnable    = false,
    Players     = false,
    Exits       = false,
    Monsters    = false,
    Interacts   = false,
    Cores       = false,
    disableCF   = false,
    disableSF   = false,
    ModifyChar  = false,
    unlockMouse = false,
    pathFinding = false,
    hooked = false,
}
Settings = Apeirophobia.Settings

-- < ESP > --
local Drawers 
Apeirophobia.Drawings = Apeirophobia.Drawings or {}
Drawers = Apeirophobia.Drawings
Drawers.ExitDrawings = Drawers.ExitDrawings or {}
Drawers.EntityDrawings = Drawers.EntityDrawings or {}
Drawers.CoresDrawings = Drawers.CoresDrawings or {}
Drawers.InteractDrawings = Drawers.InteractDrawings or {}
Drawers.PlayerDrawings = Drawers.PlayerDrawings or {}

local Props
Apeirophobia.Props = Apeirophobia.Props or {}
Props = Apeirophobia.Props

Props.InteractProps = {
    Color = Color3.fromRGB(207, 207, 207),
    Size = 16,
    Center = true,
    Outline = true,
    OutlineColor = Color3.fromRGB(49, 231, 255),
    Font = Drawing.Fonts.System,
    Visible = true
}

Props.EntityProps = {
    Color = Color3.fromRGB(207, 207, 207),
    Size = 16,
    Center = true,
    Outline = true,
    OutlineColor = Color3.fromRGB(255, 92, 92),
    Font = Drawing.Fonts.System,
    Visible = true
}

Props.CoreProps = {
    Color = Color3.fromRGB(207, 207, 207),
    Size = 16,
    Center = true,
    Outline = true,
    OutlineColor = Color3.fromRGB(237, 36, 255),
    Font = Drawing.Fonts.System,
    Visible = true
}

Props.ExitProps = {
    Color = Color3.fromRGB(207, 207, 207),
    Size = 16,
    Center = true,
    Outline = true,
    OutlineColor = Color3.fromRGB(77, 77, 77),
    Font = Drawing.Fonts.System,
    Visible = true
}

Props.PlayerProps = {
    Color = Color3.fromRGB(207, 207, 207),
    Size = 16,
    Center = true,
    Outline = true,
    OutlineColor = Color3.fromRGB(30, 233, 57),
    Font = Drawing.Fonts.System,
    Visible = true
}

-- < Vars > --
syn.set_thread_identity(2) 
local Network = require(game.ReplicatedStorage.Assets.Modules.Network) 
syn.set_thread_identity(7)

local GSettings    = ReplicatedStorage.GameSettings
local currentLevel = GSettings.currentLevel.Value
local Storage      = ReplicatedStorage.Assets
local UnRendered   = Storage.Maps

local LP            = Players.LocalPlayer
local Char          = LP.Character or LP.CharacterAdded:Wait()
local Hum           = Char:WaitForChild("Humanoid")
local HRP           = Hum.RootPart

local Camera         = Workspace.CurrentCamera
local Buildings      = Workspace:FindFirstChild("Buildings")
local Characters     = Workspace:FindFirstChild("Characters")
local Beings         = Workspace:FindFirstChild("Entities")
local Ignored        = Workspace:FindFirstChild("Ignored")

local Interacts      = Ignored:FindFirstChild("Interacts")
local Trophies       = Ignored:FindFirstChild("Trophies")
local CCachhe        = Ignored:FindFirstChild("ClientsCache") -- do not mess with

local cameraLight    = Camera:FindFirstChild(LP.Name .. "-cameraLight")
local LLocal         = cameraLight:FindFirstChild("Attachment"):FindFirstChild("Light")

local db = false
local currExit
local currGoal
local coreScript
local supported = true
local decrpytionKey
local doorCode

local Tools = {
    "PartyPlushie",
    "key",
    "valve",
    "puzzleBall",
    "StarButton",
    "button",
    "ScrewDriver",
    "WireCutters",
    "Lever",
    "Plate"
}

local Colors = {
    {a = 0, cc = 1, color = Color3.fromRGB(255, 0, 0)},
    {a = 0, cc = 2, color = Color3.fromRGB(0, 255, 0)},
    {a = 0, cc = 3, color = Color3.fromRGB(0, 0, 255)},
    {a = 0, cc = 4, color = Color3.fromRGB(77, 77, 77)},
    {a = 0, cc = 5, color = Color3.fromRGB(255, 255, 0)},
    {a = 0, cc = 6, color = Color3.fromRGB(85, 0, 127)},
    {a = 0, cc = 7, color = Color3.fromRGB(255, 85, 0)},
}

local Goals = {
    [0] = Vector3.new(-896.79638671875, 11.775812149047852, -92.27729797363281),
    [1] = Vector3.new(-794.0291137695312, -29.450159072875977, -1183.3409423828125),
    [2] = Vector3.new(-581.3582763671875, -176.95956420898438, -2539.600830078125),
    [3] = Vector3.new(552.2224731445312, 3.970996379852295, -116.6429443359375),
    [4] = Vector3.new(-2209.694580078125, -51.07357406616211, 558.4268188476562),
    [5] = Vector3.new(-608.9114379882812, 9.408474922180176, 3562.38037109375),
    [6] = Vector3.new(2577.73583984375, 2.1053123474121094, -2566.51025390625),
    [7] = Vector3.new(1177.4444580078125, 2.045313835144043, -2944.38232421875),
    [8] = Vector3.new(-3173.519775390625, 10.831992149353027, -213.09765625),
    [9] = Vector3.new(3798.71630859375, 51.89096450805664, -443.34759521484375),
    [10] = {
        [1] = Vector3.new(-70.89332580566406, 3.8714559078216553, -1821.67626953125),
        [2] = Vector3.new(660.23486328125, 3.8714563846588135, -1820.9541015625),
        [3] = Vector3.new(658.6499633789062, 3.871455669403076, -993.35009765625),
        [4] = Vector3.new(-72.15951538085938, 3.8714563846588135, -995.0171508789062),
    }
}

local coreValues = {
    Stamina = 0,
    flashBoost = 0,
    staminaDrain = 0,
    staminaRegen = 0,
    speed = 0,
}

-- < Functions > --

local function HasChar(Character) -- return if the character is valid
    if not Character then
        if Char and Char:FindFirstAncestorWhichIsA("Workspace") then
            return true
        end
    elseif Character and Character:FindFirstAncestorWhichIsA("Workspace") then
        return true
    end
    return
end

local function typeHumanoid(model) -- returns hasHumanoid, isPlayer
    if model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
        if Players:FindFirstChild(model.Name) then
            return true, true
        end
        return true, false
    end
    return
end

local function WTVP(NewVector) -- returns Vector2 for drawings
    local Vector, isVisible = Camera:WorldToViewportPoint(NewVector)
    return (isVisible and Vector2.new(Vector.X, Vector.Y)) or Vector2.new(9e9, 9e9)
end

local function vaildTool(tool) -- returns if the tool is valid
    if tool then
        for i, v in pairs(Tools) do
            -- print(tool.Name, v)
            if string.find(tool.Name, v) then
                return true
            end
        end
    end
    return
end

local function secureHL(model, color)
    if not model:FindFirstChildOfClass("Highlight") and model:FindFirstChildOfClass("Part") then
        local HL = Instance.new("Highlight", model)
        HL.Name = "Highlight"
        HL.Adornee = model
        -- HL.Color3 = Color3.fromRGB(255, 92, 92) box adornment
        HL.FillColor = color
        HL.OutlineColor = Color3.fromRGB(29, 29, 29)
        HL.LineThickness = 0.05
        
        return HL
    end
end

local OldNewIndex 
OldNewIndex = hookmetamethod(game, "__newindex", function(Self, ...) -- Disable Corescript WS and JP bindings
    local args = {...}
    if not checkcaller() and Settings.WSEnable and tostring(getcallingscript()) == "CoreScript" and (args[1] == "WalkSpeed" or args[1] == "CharacterWalkSpeed") then
        return
    end

    if not checkcaller() and Settings.JPEnable and tostring(getcallingscript()) == "CoreScript" and (args[1] == "JumpPower" or args[1] == "CharacterJumpPower") then
        return
    end

    return OldNewIndex(Self, ...)
end)

if not Settings.hooked then
    if HasChar() then -- initial hook
        for i,v in next, getconnections(RunService.RenderStepped) do
            if tostring(getfenv(v.Function).script) == "CoreScript" and #getupvalues(v.Function) == 93 then
                coreScript = v.Function
                -- print("--< Upvalues >--")
                for i2, v2 in pairs(getupvalues(coreScript)) do
                    -- print(i2, v2, typeof(v2))
                    if v2 == 0.085 then
                        coreValues.staminaDrain = i2
                    elseif v2 == 100 then
                        coreValues.Stamina = i2
                    elseif v2 == 50 then
                        coreValues.flashBoost = i2
                    elseif v2 == 1.25 then
                        coreValues.staminaRegen = i2
                    elseif v2 == 18 then
                        coreValues.speed = i2
                    end
                end
            end

        end
    end

    LP.CharacterAdded:Connect(function() -- hook corescript on respawn
        task.spawn(function()
            repeat task.wait(0.01666666667) until HasChar() and supported and Char:FindFirstChild("Scripts"):FindFirstChild("CoreScript")
            task.wait(2)
            for i,v in next, getconnections(RunService.RenderStepped) do
                warn(getinfo(v.Function).Name)
                --[[ if getinfo(v.Function). == "CoreScript" and #getupvalues(v.Function) > 20 then
                    coreScript = v.Function
                end ]]
            end
        end) 
    end)
    Settings.hooked = true
end

local Remotes
Apeirophobia.Remotes = Apeirophobia.Remotes or {}
Remotes = Apeirophobia.Remotes

for i,v in pairs(getgc(true)) do
    if type(v) == 'table' then
        if rawget(v, 'Remote') then
            v.Remote.Name = v.Name
            Remotes[v.Name] = v.Remote
        end
    end
end

-- < UI > --
local RayfieldLib     = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Rayfield        = CoreGui:FindFirstChild("Rayfield")
local Flags           = RayfieldLib.Flags

local Window = RayfieldLib:CreateWindow({
    Name = "Apeirophobia",
    LoadingTitle = "I am Fucking Alive",
    LoadingSubtitle = "by scrumptious",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Scrumpy",
        FileName = "Apeirophobia"
    },
    Discord = {
        Enabled = false,
        Invite = '',
        RememberJoins = true,
    },
    KeySystem = false,
    KeySettings = {
        Title = "Key Logger",
        Subtitle = 'say the magic word',
        Note = 'IDGAF bout you',
        FileName = 'AuthKey',
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = 'Nigger123'
    }
})

local ESP           = Window:CreateTab("ESP", 4483362458)
local Levels        = Window:CreateTab('Levels', 4483362458)
local LocalPlayer   = Window:CreateTab("LocalPlayer", 4483362458)
local Misc          = Window:CreateTab("Miscellanous", 4483362458)

local Level7 = Levels:CreateSection('Level 7')

local Monitor1 = Interacts:FindFirstChild("Monitor1")
local ventSprint

local sphereCodeL = Levels:CreateLabel('Sphere Code: ')
local CodeLabel = Levels:CreateLabel("Door Code: ")

local OldNamecall; OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if (ventSprint and method == "Raycast") and (args[2].Y == 3.5 or args[2].Y == 2.5) then
        return nil
    end
    return OldNamecall(Self, ...)
end)

local function getDecryption()
    local str = ""
    for i,v in next, Interacts:GetChildren() do
        if v.Name == "puzzleBall" then
            for I,V in next, Colors do
                if V.color == v.Color then
                    V.a = V.a + 1
                end
            end
        end
    end

    for i,v in next, Colors do
        if v.a > 0 then str ..= v.a .. v.cc end
    end
    return str
end

Levels:CreateButton({Name = 'Get Decryption Code', Callback = function()
    if not decrpytionKey then pcall(function () decrpytionKey = getDecryption() end) end
    sphereCodeL:Set("Sphere Code: ".. decrpytionKey)
end})

local getDoorCodeBtn = Levels:CreateButton({Name = "Get Door Code", Callback = function()
    if not decrpytionKey then pcall(function () decrpytionKey = getDecryption() end) end

    sphereCodeL:Set("Sphere Code: " .. decrpytionKey)
    
    Network:FireServer("input", decrpytionKey, Monitor1, false)
    task.wait()
    CodeLabel:Set("Door Code: " .. Monitor1.UI.Frame.code.Text)
    doorCode = Monitor1.UI.Frame.code.Text
end})

Levels:CreateToggle({Name = 'Sprint In Vent',
    CurrentValue = false,
    Flag = '7SIV',
    Callback = function(bool)
        ventSprint = bool
    end
})

Levels:CreateButton({Name = "Open First Door", Callback = function()
    if not decrpytionKey then pcall(function () decrpytionKey = getDecryption() end) end
    if not doorCode then Flags.getDoorCodeBtn.Callback() end

    sphereCodeL:Set("Sphere Code: " .. decrpytionKey)
    
    Network:FireServer("input", decrpytionKey, Monitor1, false)
    task.wait()
    CodeLabel:Set("Door Code: " .. Monitor1.UI.Frame.code.Text)
    Network:FireServer("input", doorCode, Interacts.Keypad1.Pad1, Interacts.Keypad1)
end})

Levels:CreateButton({Name = "Brute-Force Second Door", Callback = function()
    for i = 1, 9999 do
        Network:FireServer("input", tostring(i), Interacts.Keypad2.Pad2, Interacts.Keypad2)
        if Interacts.Keypad2.Display.Color == Color3.fromRGB(170, 255, 127) then
            break
        end 
    end
end})

Levels:CreateButton({Name = "Open Vent", Callback = function()
    Network:FireServer("input", "y", Interacts.Monitor2, false)
end})

-- local Level10 = Levels:CreateSection('Level 10')

ESP:CreateToggle({Name = 'Interacts ESP', CurrentValue = false, Flag = 'IESP', Callback = function(bool)
    Settings.Interacts = bool
    if Settings.Interacts then
        task.spawn(function()
            while Settings.Interacts do
                for interact, drawing in next, Drawers.InteractDrawings do
                    if (not interact or not interact.Parent) then
                        drawing:Remove()
                        Drawers.InteractDrawings[interact] = nil
                    else
                        drawing.Text = string.format("%s (%s)", interact.Name, math.floor(LP:DistanceFromCharacter(interact:GetPivot().Position)))
                        drawing.Position = WTVP(interact:GetPivot().Position)
                        secureHL(interact, Props.InteractProps.OutlineColor)
                    end
                end

                for i, v in next, Interacts:GetChildren() do
                    if vaildTool(v) and not Drawers.InteractDrawings[v] then
                        local newDraw = Drawing.new("Text")
                        newDraw.Text = string.format("%s (%s)", v.Name, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                        if v.Name == 'puzzleBall' then
                            newDraw.Color = Color3.fromRGB(207, 207, 207)
                            newDraw.Size = 16
                            newDraw.Center = true
                            newDraw.Outline = true
                            newDraw.OutlineColor = v.Color
                            newDraw.Font = Drawing.Fonts.System
                            newDraw.Visible = true
                        else
                            for _, c in next, Props.InteractProps do
                                newDraw[_] = c
                            end
                        end

                        Drawers.InteractDrawings[v] = newDraw
                    end
                end
                task.wait(0.01666666667) -- 1/60 of a second
            end
        end)
    else
        for _, v in next, Drawers.InteractDrawings do
            v:Remove()
            Drawers.InteractDrawings[_] = nil
        end
    end
end})

ESP:CreateToggle({Name = 'Monster ESP', CurrentValue = false, Flag = 'MESP', Callback = function(bool)
    Settings.Monsters = bool
    if Settings.Monsters then
        task.spawn(function()
            while Settings.Monsters do
                for monster, drawing in next, Drawers.EntityDrawings do
                    if (not monster or monster.Parent == nil) then
                        drawing:Remove()
                        Drawers.EntityDrawings[monster] = nil
                    else
                        drawing.Text = string.format("%s (%s)", monster.Name, math.floor(LP:DistanceFromCharacter(monster:GetPivot().Position)))
                        drawing.Position = WTVP(monster:GetPivot().Position)
                        secureHL(monster, Props.EntityProps.OutlineColor)
                    end
                end
                if currentLevel ~= 14 then
                    for i, v in next, Beings:GetChildren() do
                        local hasHumanoid, isPlayer = typeHumanoid(v)
                        if (hasHumanoid) and not Drawers.EntityDrawings[v] then
                            local newDraw = Drawing.new("Text")
                            newDraw.Text = string.format("%s (%s)", v.Name, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                            for _, c in next, Props.EntityProps do
                                newDraw[_] = c
                            end

                            Drawers.EntityDrawings[v] = newDraw
                        end
                    end
                end
                if currentLevel == 14 then
                    for i, v in next, Workspace:GetChildren() do
                        local hasHumanoid, isPlayer = typeHumanoid(v)
                        if (hasHumanoid and not isPlayer) and not Drawers.EntityDrawings[v] then
                            local newDraw = Drawing.new("Text")
                            newDraw.Text = string.format("%s (%s)", v.Name, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                            for _, c in next, Props.EntityProps do
                                newDraw[_] = c
                            end

                            Drawers.EntityDrawings[v] = newDraw
                        end
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    else
        for _, v in next, Drawers.EntityDrawings do
            v:Remove()
            Drawers.EntityDrawings[_] = nil
        end
    end
end})

ESP:CreateToggle({Name = 'Player ESP', CurrentValue = false, Flag = 'PESP', Callback = function(bool)
    Settings.Players = bool
    if Settings.Players then
        task.spawn(function()
            while Settings.Players do
                for player, drawing in next, Drawers.PlayerDrawings do
                    if (not player or player.Parent == nil) then
                        drawing:Remove()
                        Drawers.PlayerDrawings[player] = nil
                    else
                        drawing.Text = string.format("%s (%s)", player.Name, math.floor(LP:DistanceFromCharacter(player:GetPivot().Position)))
                        drawing.Position = WTVP(player:GetPivot().Position)
                        secureHL(player, Props.PlayerProps.OutlineColor)
                    end
                end

                for i, v in next, Characters:GetChildren() do
                    local hasHumanoid, isPlayer = typeHumanoid(v)
                    if (isPlayer) and not Drawers.PlayerDrawings[v] and v ~= Char then
                        local newDraw = Drawing.new("Text")
                        newDraw.Text = string.format("%s (%s)", v.Name, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                        for _, c in next, Props.PlayerProps do
                            newDraw[_] = c
                        end

                        Drawers.PlayerDrawings[v] = newDraw
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    else
        for _, v in next, Drawers.PlayerDrawings do
            v:Remove()
            Drawers.PlayerDrawings[_] = nil
        end
    end
end})

ESP:CreateToggle({Name = 'Cores ESP', CurrentValue = false, Flag = 'CESP', Callback = function(bool)
    Settings.Cores = bool
    if Settings.Cores then
        task.spawn(function()
            while Settings.Cores do
                for core, drawing in next, Drawers.CoresDrawings do
                    if not core or not core.Parent then
                        drawing:Remove()
                        Drawers.CoresDrawings[core] = nil
                    else
                        drawing.Text = string.format("%s (%s)", core.id.Value, math.floor(LP:DistanceFromCharacter(core:GetPivot().Position)))
                        drawing.Position = WTVP(core:GetPivot().Position)
                    end
                end

                for i, v in next, Trophies:GetChildren() do
                    if v:FindFirstChild("id") and not Drawers.CoresDrawings[v] then
                        local newDraw = Drawing.new("Text")
                        newDraw.Text = string.format("%s (%s)", v.id.Value, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                        for _, c in next, Props.CoreProps do
                            newDraw[_] = c
                        end

                        Drawers.CoresDrawings[v] = newDraw
                    elseif not v:FindFirstChild("id") and Drawers.CoresDrawings[v] then
                        Drawers.CoresDrawings[v]:Remove()
                        Drawers.CoresDrawings[v] = nil
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    else
        for _, v in next, Drawers.CoresDrawings do
            v:Remove()
            Drawers.CoresDrawings[_] = nil
        end
    end
end})

ESP:CreateToggle({Name = 'Exit ESP', CurrentValue = false, Flag = 'EXP', Callback = function(bool)
    Settings.Exits = bool
    if Settings.Exits then
        task.spawn(function()
            while Settings.Exits do
                task.wait(0.01666666667)
                for exit, drawing in next, Drawers.ExitDrawings do
                    if (exit and exit.Parent) then
                        drawing.Text = string.format("Exit_%s (%s)", currentLevel, math.floor(LP:DistanceFromCharacter(exit:GetPivot().Position)))
                        drawing.Position = WTVP(exit:GetPivot().Position)
                        currGoal = exit:GetPivot().Position
                        secureHL(exit, Props.ExitProps.OutlineColor)
                    else
                        drawing:Remove()
                        Drawers.ExitDrawings[exit] = nil
                    end
                end

                if not (currentLevel == 16 or currentLevel == 1 or currentLevel == 3) then
                    if Buildings[currentLevel]:FindFirstChild("Exit") then
                        for i, v in next, Buildings[currentLevel]["Exit"]:GetChildren() do
                            if v:FindFirstChildOfClass("TouchTransmitter") and not Drawers.ExitDrawings[v] then
                                local newDraw = Drawing.new("Text")
                                newDraw.Text = string.format("Exit_%s (%s)", currentLevel, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                                for _, c in next, Props.ExitProps do
                                    newDraw[_] = c
                                end

                                Drawers.ExitDrawings[v] = newDraw
                            end
                        end
                    end

                    if Buildings[currentLevel]:FindFirstChild("Exits") then
                        for i, v in next, Buildings[currentLevel]["Exits"]:GetChildren() do
                            if v:FindFirstChildOfClass("TouchTransmitter") and not Drawers.ExitDrawings[v] then
                                local newDraw = Drawing.new("Text")
                                newDraw.Text = string.format("Exit_%s (%s)", currentLevel, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                                for _, c in next, Props.ExitProps do
                                    newDraw[_] = c
                                end

                                Drawers.ExitDrawings[v] = newDraw
                            end
                        end
                    end
                elseif (currentLevel == 1 or currentLevel == 3) then
                    for i, v in next, Buildings.Rendered["Level".. currentLevel + 1 .. "Entrance"]:GetChildren() do
                        if v:FindFirstChildOfClass("TouchTransmitter") and not Drawers.ExitDrawings[v] then
                            local newDraw = Drawing.new("Text")
                            newDraw.Text = string.format("Exit_%s (%s)", currentLevel, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                            for _, c in next, Props.ExitProps do
                                newDraw[_] = c
                            end

                            Drawers.ExitDrawings[v] = newDraw
                        end
                    end
                elseif currentLevel == 16 then
                    for i, v in next, Buildings[currentLevel]:GetChildren() do
                        if v:FindFirstChildOfClass("TouchTransmitter") and not Drawers.ExitDrawings[v] then
                            local newDraw = Drawing.new("Text")
                            newDraw.Text = string.format("Exit_%s (%s)", currentLevel, math.floor(LP:DistanceFromCharacter(v:GetPivot().Position)))
                            for _, c in next, Props.ExitProps do
                                newDraw[_] = c
                            end

                            Drawers.ExitDrawings[v] = newDraw
                        end
                    end
                end
            end
        end)
    else
        for _, v in next, Drawers.ExitDrawings do
            v:Remove()
            Drawers.ExitDrawings[_] = nil
        end
    end
end})

LocalPlayer:CreateButton({Name = 'Modify Character', Callback = function(bool)
    Settings.ModifyChar = bool
    if Settings.ModifyChar then
        task.spawn(function()
            while Settings.ModifyChar do
                if coreScript and #getupvalues(coreScript) == 93 then
                    -- setupvalue(coreScript, coreValues.Stamina, 9e9)
                    setupvalue(coreScript, coreValues.StaminaRegen, 100)
                    setupvalue(coreScript, coreValues.staminaDrain, 0)
                    setupvalue(coreScript, coreValues.speed, 36)
                    setupvalue(coreScript, coreValues.flashBoost, 100)
                end
                task.wait(0.01666666667)
            end
        end)
    else
        if coreScript and #getupvalues(coreScript) == 93 then
            setupvalue(coreScript, coreValues.Stamina, 100)
            setupvalue(coreScript, coreValues.StaminaRegen, 5)
            setupvalue(coreScript, coreValues.staminaDrain, 0.085)
            setupvalue(coreScript, coreValues.speed, 18)
            setupvalue(coreScript, coreValues.flashBoost, 50)
        end
    end
end})

LocalPlayer:CreateToggle({Name = 'Bypass WalkSpeed', CurrentValue = false, Flag = 'TWS', Callback = function(bool)
    Settings.WSEnable = bool
    if Settings.WSEnable then
        task.spawn(function()
            while Settings.WSEnable do
                task.wait()
                game.StarterPlayer.CharacterWalkSpeed = Settings.WalkSpeed
                Hum.WalkSpeed = Settings.WalkSpeed
            end
        end)
    else
        game.StarterPlayer.CharacterWalkSpeed = 10
        Hum.WalkSpeed = 10
    end
end})

LocalPlayer:CreateToggle({Name = 'Bypass JumpPower', CurrentValue = false, Flag = 'TJP', Callback = function(bool)
    Settings.JPEnable = bool
    if Settings.JPEnable then
        task.spawn(function()
            while Settings.JPEnable do
                task.wait()
                game.StarterPlayer.CharacterJumpPower = Settings.JumpPower
                Hum.JumpPower = Settings.JumpPower
            end
        end)
    else
        game.StarterPlayer.CharacterJumpPower = 30
        Hum.JumpPower = 30
    end
end})

LocalPlayer:CreateSlider({Name = "WalkSpeed Slider", Range = {10, 100}, Increment = 5, Suffix = 'n.', CurrentValue = 10, Flag = 'SWS', Callback = function(n)
    Settings.WalkSpeed = n
    game.StarterPlayer.CharacterWalkSpeed = Settings.WalkSpeed
    Hum.WalkSpeed = Settings.WalkSpeed
end})

LocalPlayer:CreateSlider({Name = "JumpPower Slider", Range = {30, 100}, Increment = 5, Suffix = 'n.', CurrentValue = 30, Flag = 'SJP', Callback = function(n)
    Settings.JumpPower = n
    game.StarterPlayer.CharacterJumpPower = Settings.JumpPower
    Hum.JumpPower = Settings.JumpPower
end})

Misc:CreateButton({Name = "Teleport to exit", Callback = function()
    if HasChar() and currGoal then
        HRP.Position = currGoal
    end
end})

Misc:CreateButton({Name = "Return to lobby", Callback = function()
    Network:FireServer("lobby")
end})

--[[ Misc:CreateButton({Name = "Force Respawn", Callback = function()
    Network:FireServer("respawn")
end}) ]]

Misc:CreateButton({Name = "Get All Simulation Cores", Callback = function()
    if not db and HasChar() then
        local oldCF = HRP.CFrame
        db = true
        for i,v in next, Trophies:GetChildren() do
            HRP.Position = v:GetPivot().Position
            task.wait(1)
        end
        db = false
        HRP.CFrame = oldCF
    end
end})

local UM = Misc:CreateToggle({Name = "Unlock Mouse", CurrentValue = true, Flag = 'unlockMouse', Callback = function(bool)
    Settings.unlockMouse = bool
    if Settings.unlockMouse then
        RunService:BindToRenderStep("tempMouse", 0, function()
            LP.PlayerGui:WaitForChild("UI").image:WaitForChild("mouse").Value = true
        end)
    else
        RunService:UnbindFromRenderStep("tempMouse")
        LP.PlayerGui:WaitForChild("UI").image:WaitForChild("mouse").Value = false
    end
end})

Misc:CreateKeybind({Name = "Unlock Mouse Bind", CurrentKeybind = "R", HoldToInteract = false, Flag = 'UMK', Callback = function(bind)
    UM:Set(not UM.CurrentValue)
end})

Misc:CreateToggle({Name = "Remove Camera Filters", CurrentValue = false, Flag = 'RCF', Callback = function(bool)
    Settings.disableCF = bool
    if Settings.disableCF and Camera then
        task.spawn(function()
            while Settings.disableCF do
                for _, i in pairs(Camera:GetChildren()) do
                    if (i.Name == "ColorCorrection" or i.Name == "Blur" or i.Name == "s" or i.Name == 'underwaterBlur' or i.Name == 'underwaterColor') then
                        i:Destroy()
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    end
end})

Misc:CreateToggle({Name = "Remove Screen Filters", CurrentValue = false, Flag = 'RSS', Callback = function(bool)
    Settings.disableSF = bool
    if Settings.disableSF then
        task.spawn(function()
            while Settings.disableSF do
                for i, v in pairs(Beings:GetChildren()) do
                    local hasHumanoid, isPlayer = typeHumanoid(v)
                    if v:FindFirstChild("gVars") and hasHumanoid then
                        v.gVars.isHostile.Value = false
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    elseif Settings.disableSF then
        task.spawn(function()
            while not Settings.disableSF do
                for i, v in pairs(Beings:GetChildren()) do
                    local hasHumanoid, isPlayer = typeHumanoid(v)
                    if v:FindFirstChild("gVars") and hasHumanoid then
                        v.gVars.isHostile.Value = true
                    end
                end
                task.wait(0.01666666667)
            end
        end)
    end
end})

Misc:CreateKeybind({Name = "No Fog", CurrentKeybind = "G", HoldToInteract = false, Flag = "NF", Callback = function(bind)
    Lighting.FogEnd = 786543
    for i,v in pairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
end})

RayfieldLib:LoadConfiguration()