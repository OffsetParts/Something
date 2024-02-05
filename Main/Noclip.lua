if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not Promise then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/OffsetParts/Something/master/Libraries/Promise.lua"))()
    getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

-- < Services > --
local Workspace = Services.Workspace
local Players = Services.Players
local Lighting = Services.Lighting
local UserInputService = Services.UserInputService

-- Vars
local c   = Workspace.CurrentCamera
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local HUM = char:WaitForChild("Humanoid")
local HRP = HUM.RootPart

local blacklist = {4786930269}
local cors = {}

local client, fn = plr, function ()  -- Noclip tool creation
    local runDummyScript = function(f, scri) -- run isolation
        local oldenv = getfenv(f)
        local newenv = setmetatable({}, {
            __index = function(_, k)
                if k:lower() == "script" then
                    return scri
                else
                    return oldenv[k]
                end
            end
        })

        setfenv(f, newenv)
        pcall(task.spawn(function() f() end))
    end

    local mas = Instance.new("Model", Lighting) mas.Name = "ClipModel"
    local o1 = Instance.new("HopperBin") o1.Name = "Clip" o1.Parent = mas
    local o2 = Instance.new("LocalScript") o2.Name = "ClipScript" o2.Parent = o1

    table.insert(cors, coroutine.create(function()
        task.wait()
        runDummyScript(function()

            local selected = false
            local speed = 100
            local lastUpdate = 0.001 -- interval to update
            local function getNextMovement(deltaTime) -- predict next position every dt
                local nextMove = Vector3.new()
                -- Left/Right
                if UserInputService:IsKeyDown("A") or UserInputService:IsKeyDown("Left") then
                    nextMove = Vector3.new(-1, 0, 0)
                elseif UserInputService:IsKeyDown("D") or UserInputService:IsKeyDown("Right") then
                    nextMove = Vector3.new(1, 0, 0)
                end
                -- Forward/Back
                if UserInputService:IsKeyDown("W") or UserInputService:IsKeyDown("Up") then
                    nextMove = nextMove + Vector3.new(0, 0, -1)
                elseif UserInputService:IsKeyDown("S") or UserInputService:IsKeyDown("Down") then
                    nextMove = nextMove + Vector3.new(0, 0, 1)
                end
                -- Up/Down
                if UserInputService:IsKeyDown("Space") then
                    nextMove = nextMove + Vector3.new(0, 1, 0)
                elseif UserInputService:IsKeyDown("LeftControl") then
                    nextMove = nextMove + Vector3.new(0, -1, 0)
                end
                return CFrame.new(nextMove * (speed * deltaTime))
            end

            local function onSelected()
                if char then
                    selected = true
                    HRP.Anchored = true
                    lastUpdate = tick()
                    HUM.PlatformStand = true -- stop player movement
                    while selected  and task.wait() do
                        task.wait()
                        local delta = tick() - lastUpdate
                        local look = (c.Focus.p - c.CoordinateFrame.p).unit -- where to point character too
                        local move = getNextMovement(delta)
                        local pos = HRP.Position
                        HRP.CFrame = CFrame.new(pos, pos + look) * move
                        lastUpdate = tick()
                    end
                    HRP.Anchored = false
                    HRP.Velocity = Vector3.new()
                end
            end

            local function onDeselected()
                HRP.Anchored = false -- ensure that root is unanchored cause it can get buggy.
                HUM.PlatformStand = false
                selected = false
            end
            
            script.Parent.Selected:connect(onSelected)
            script.Parent.Deselected:connect(onDeselected)
        end,
        o2)
    end))

    mas.Parent = Workspace
    mas:MakeJoints()

    for i, v in pairs(mas:GetChildren()) do
        v.Parent = plr.Backpack
        pcall(function()
            v:MakeJoints()
        end)       
    end

    mas:Destroy()

    for i = 1, #cors do
        coroutine.resume(cors[i])
    end
end

local bl
for _, x in pairs(blacklist) do
    if x == game.PlaceId then
        bl = true
		if Notifier then Notifier("(4a) Noclip is blacklisted here", true) end
    end
end

if not bl then
    fn()

    Promise.fromEvent(client.CharacterAdded, function()
        if client.Character and client:FindFirstChildOfClass'Backpack' then 
            return true 
        end
    end):andThenCall(fn)
end

Notifier("(4b) Noclip Tool", true)