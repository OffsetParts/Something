if not game:IsLoaded() then game.Loaded:Wait() end

local plr = game:GetService("Players").LocalPlayer

local exist
local function check()
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if backpack ~= nil then exist = true else return end
end

function Noclip()
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
	o1 = Instance.new("HopperBin") -- don't use tool, hopperbin is old/Undetected and not recognized as a tool | Hide from inv tool view
	o2 = Instance.new("LocalScript")
	o1.Name = "Clip"
	o1.Parent = mas
	o2.Name = "ClipScript"
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
			local speed = 100
			local lastUpdate = 0.001 -- interval to update

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
					selected = true
					root.Anchored = true
					lastUpdate = tick()
					humanoid.PlatformStand = true -- stop player movement
					while selected do
						wait() 
						local delta = tick()-lastUpdate
						local look = (c.Focus.p - c.CoordinateFrame.p).unit -- point charater to facing with camera.
						local move = getNextMovement(delta)
						local pos = root.Position
						root.CFrame = CFrame.new(pos, pos + look) * move
						lastUpdate = tick()
					end
					root.Anchored = false
					root.Velocity = Vector3.new()
					humanoid.PlatformStand = false
				end
			end

			function onDeselected()
				local char = player.Character
				local hum = char:WaitForChild("Humanoid")
				local root = char:WaitForChild("HumanoidRootPart")
				root.Anchored = false -- ensure that root is unanchored cause it can get buggy.
				hum.PlatformStand = false
				selected = false
			end

			script.Parent.Selected:connect(onSelected)
			script.Parent.Deselected:connect(onDeselected)
		end,o2)
	end))

	mas.Parent = workspace
	mas:MakeJoints()
	local mas1 = mas:GetChildren()
	for i = 1, #mas1 do
		mas1[i].Parent = game:GetService("Players").LocalPlayer.Backpack 
		ypcall(function()
			mas1[i]:MakeJoints()
		end)
	end
	mas:Destroy()

	for i = 1, #cors do
	coroutine.resume(cors[i])
	end
end

Workspace:WaitForChild(tostring(plr.Name))
Noclip()

function Run()
    plr.CharacterAdded:Connect(function()
        if exist ~= false or nil then
		    Noclip()
		end
    end)
end

Run()
