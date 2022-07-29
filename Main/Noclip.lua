if not game:IsLoaded() then
    game.Loaded:Wait()
end

if not Promise then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/Libraries/Promise.lua"))()
    getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

local plr = game:GetService("Players").LocalPlayer

local client, cleanup = plr, 
function () 
    local runDummyScript = function(f, scri) -- run isolation
        local oldenv = getfenv(f)
        local newenv =
            setmetatable(
            {},
            {
                __index = function(_, k)
                    if k:lower() == "script" then
                        return scri
                    else
                        return oldenv[k]
                    end
                end
            }
        )

        setfenv(f, newenv)
        pcall(
            function()
                f()
            end
        )
    end

    getgenv().cors = {}

    local mas = Instance.new("Model")
    local o1 = Instance.new("HopperBin")
    local o2 = Instance.new("LocalScript")

    mas.Parent = game:GetService("Lighting")
    mas.Name = "ClipModel"
    o1.Name = "Clip" -- Tool Name
    o1.Parent = mas
    o2.Name = "ClipScript" -- tool script name
    o2.Parent = o1

    table.insert(
        cors,
        coroutine.create(function()
            task.wait()
            runDummyScript(function()
                local c = workspace.CurrentCamera
                local userInput = game:GetService("UserInputService")

                local selected = false
                local speed = 100
                local lastUpdate = 0.001 -- interval to update
                function getNextMovement(deltaTime) -- predict next position every dt
                    local nextMove = Vector3.new()
                    -- Left/Right
                    if userInput:IsKeyDown("A") or userInput:IsKeyDown("Left") then
                        nextMove = Vector3.new(-1, 0, 0)
                    elseif userInput:IsKeyDown("D") or userInput:IsKeyDown("Right") then
                        nextMove = Vector3.new(1, 0, 0)
                    end
                    -- Forward/Back
                    if userInput:IsKeyDown("W") or userInput:IsKeyDown("Up") then
                        nextMove = nextMove + Vector3.new(0, 0, -1)
                    elseif userInput:IsKeyDown("S") or userInput:IsKeyDown("Down") then
                        nextMove = nextMove + Vector3.new(0, 0, 1)
                    end
                    -- Up/Down
                    if userInput:IsKeyDown("Space") then
                        nextMove = nextMove + Vector3.new(0, 1, 0)
                    elseif userInput:IsKeyDown("LeftControl") then
                        nextMove = nextMove + Vector3.new(0, -1, 0)
                    end
                    return CFrame.new(nextMove * (speed * deltaTime))
                end

                function onSelected()
                    local char = plr.Character
                    if char then
                        local humanoid = char:WaitForChild("Humanoid")
                        local root = char:WaitForChild("HumanoidRootPart")
                        selected = true
                        root.Anchored = true
                        lastUpdate = tick()
                        humanoid.PlatformStand = true -- stop player movement
                        while selected do
                            task.wait()
                            local delta = tick() - lastUpdate
                            local look = (c.Focus.p - c.CoordinateFrame.p).unit -- where to point character too
                            local move = getNextMovement(delta)
                            local pos = root.Position
                            root.CFrame = CFrame.new(pos, pos + look) * move
                            lastUpdate = tick()
                        end
                        root.Anchored = false
                        root.Velocity = Vector3.new()
                    end
                end

                function onDeselected()
                    local char = plr.Character
                    local hum = char:WaitForChild("Humanoid")
                    local root = char:WaitForChild("HumanoidRootPart")
                    root.Anchored = false -- ensure that root is unanchored cause it can get buggy.
                    hum.PlatformStand = false
                    selected = false
                end
                
                script.Parent.Selected:connect(onSelected)
                script.Parent.Deselected:connect(onDeselected)
            end,
            o2)
        end)
    )

    mas.Parent = workspace
    mas:MakeJoints()
    local mas1 = mas:GetChildren()
    for i, v in pairs(mas1) do
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

local blacklist = {4786930269}

local bl
for _, x in pairs(blacklist) do
    if x == game.PlaceId then
        bl = true
		if Notifier then Notifier("(4a) NameTag couldn't proceed as game is blacklisted", true) end
    end
end

if not bl then
    cleanup()

    Promise.fromEvent(
        client.CharacterAdded,
        function()
            if client.Character and client:FindFirstChildOfClass'Backpack' then 
                return true 
            end
        end
    ):andThenCall(cleanup)
end