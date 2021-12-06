-- Fixed by Scrumptious#0001
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @CloneTrooper1019, 2015
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local runDummyScript = function(f,scri) -- run the script on the command
    local oldenv = getfenv(f)
    local newenv = setmetatable({}, {
        __index = function(_, k)
        if k:lower() == 'script' then
            return scri
        else
            return oldenv[k]
        end
    end})

    setfenv(f, newenv)
    ypcall(function() 
        f() 
    end)
end

cors = {}

mas = Instance.new("Model",game:GetService("Lighting")) 
mas.Name = "CompiledModel"
o1 = Instance.new("HopperBin") -- don't use tool, hopperbin is old and undetected by most admin cmds like adonis
o2 = Instance.new("LocalScript")
o1.Name = "Clip"
o1.Parent = mas
o2.Name = "NoclipScript"
o2.Parent = o1
table.insert(cors,coroutine.create(function()
	wait()
	runDummyScript(function()

		local c = workspace.CurrentCamera
		local player = game.Players.LocalPlayer
		local userInput = game:GetService("UserInputService")
		local rs = game:GetService("RunService")
		local starterPlayer = game:GetService("StarterPlayer")

		local selected = false
		local speed = 100 -- how fast to check
		local lastUpdate = 0 -- interval to update

		function getNextMovement(deltaTime) -- predict next position every dt
			local nextMove = Vector3.new()
			-- Left/Right
			if userInput:IsKeyDown("A") or userInput:IsKeyDown("Left") then
				nextMove = Vector3.new(-1,0,0)
			elseif userInput:IsKeyDown("D") or userInput:IsKeyDown("Right") then
				nextMove = Vector3.new(1,0,0)
			end
			-- Forward/Back
			if userInput:IsKeyDown("W") or userInput:IsKeyDown("Up") then
				nextMove = nextMove + Vector3.new(0,0,-1)
			elseif userInput:IsKeyDown("S") or userInput:IsKeyDown("Down") then
				nextMove = nextMove + Vector3.new(0,0,1)
			end
			-- Up/Down
			if userInput:IsKeyDown("Space") then
				nextMove = nextMove + Vector3.new(0,1,0)
			elseif userInput:IsKeyDown("LeftControl") then
				nextMove = nextMove + Vector3.new(0,-1,0)
			end
			return CFrame.new( nextMove * (speed * deltaTime) )
		end

		function onSelected()
			local char = player.Character
			if char then
				local humanoid = char:WaitForChild("Humanoid")
				local root = char:WaitForChild("HumanoidRootPart")
				currentPos = root.Position -- we don't utilize for some reason
				selected = true
				root.Anchored = true -- anchors our char HRP
				lastUpdate = tick()
				humanoid.PlatformStand = true
				while selected do
					wait()
					local delta = tick()-lastUpdate -- idk why he subtracted 0 - 0
					local look = (c.Focus.p-c.CoordinateFrame.p).unit -- where we facing
					local move = getNextMovement(delta) -- move every delta
					local pos = root.Position
					root.CFrame = CFrame.new(pos,pos+look) * move
					lastUpdate = tick()
				end
				root.Anchored = false
				root.Velocity = Vector3.new()
				humanoid.PlatformStand = false
			end
		end

		function onDeselected()
			selected = false
		end

		script.Parent.Selected:connect(onSelected) -- on equip
		script.Parent.Deselected:connect(onDeselected)-- on unequip just set other stuff to false
	end,o2)
end))

mas.Parent = workspace
mas:MakeJoints()
local mas1 = mas:GetChildren()
for i=1,#mas1 do
	mas1[i].Parent = game:GetService("Players").LocalPlayer.Backpack 
	ypcall(function()
		mas1[i]:MakeJoints()
	end)
end
mas:Destroy()

for i=1,#cors do
coroutine.resume(cors[i])
end
