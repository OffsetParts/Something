local Workspace = game:GetService("Workspace")
local UIS  = game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer
local cam = Workspace.CurrentCamera

--------------------
-- Changeable Speeds:
local speed = 20
local maxspeed = 100
local acceleration = 1.2 -- 1 - inf > recommended 1.2
--------------------

local function isKeyHeld(Key) 
	return UIS:IsKeyDown(Key)
end

-- Controls
local StartK = Enum.KeyCode.Z
local RespawnK = Enum.KeyCode.X
local ToggleK = Enum.KeyCode.E
local FK 	= Enum.KeyCode.W
local BK 	= Enum.KeyCode.S
local LK  	= Enum.KeyCode.A
local RK 	= Enum.KeyCode.D

-- local lockedstate = false
spawn(function()
	local message = Instance.new("Message", Workspace)
	message.Text = "IF Loaded\nPress Z to start\nPress X to respawn"
	wait(2)
	message:Destroy()
end)



local mouse = plr:GetMouse()
local groot = nil
local flying
local ocf

UIS.InputBegan:connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == StartK and not flying then
			flying = true
			spawn(function()
				local message = Instance.new("Message", Workspace)
				message.Text = "Please Wait...\nWe are bypassing your respawn timer"
				wait(6)
				message:Destroy()
			end)
	
			local ch = plr.Character or plr.CharacterAdded:Wait()
			local SChar = Instance.new("Model", Workspace)
	
			local z1 =  Instance.new("Part", SChar)
			z1.Name = "Torso"
			z1.CanCollide = false
			z1.Anchored = true
	
			local z2  = Instance.new("Part", SChar)
			z2.Name = "Head"
			z2.Anchored = true
			z2.CanCollide = false
	
			local z3 = Instance.new("Humanoid", SChar)
			z3.Name = "Humanoid"
			z1.Position = Vector3.new(0, 9999, 0)
			z2.Position = Vector3.new(0, 9991, 0)
			plr.Character = SChar
	
			wait(3)
	
			plr.Character = ch
			wait(3)
	
			mouse = plr:GetMouse()
	
			local Hum = Instance.new("Humanoid")
			Hum.Parent = ch
	
			local HRP =  ch:WaitForChild("HumanoidRootPart")
	
			for i, v in pairs(ch:GetChildren()) do
				if v ~= HRP and v.Name ~= "Humanoid" then
					v:Destroy()
				end
			end
			
			cam.CameraSubject = HRP
	
			local se = Instance.new("SelectionBox", HRP) se.Adornee = HRP
	
			game:GetService('RunService').Stepped:connect(function()
				HRP.CanCollide = false
			end)
	
			local power = 999999
	
			wait(.1)
			local bambam = Instance.new("BodyThrust")
			bambam.Parent = HRP
			bambam.Force = Vector3.new(power, 0, power)
			bambam.Location = HRP.Position
			local ctrl = {
				f = 0, -- forward
				b = 0, -- back
				l = 0, -- left
				r = 0  -- right
			}
			local lastctrl = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
	
			groot = HRP
	
			function Fly()
				ocf = groot.Position
				local bg = Instance.new("BodyGyro", HRP)
				bg.P = 9e4 -- Power/Pressure
				bg.maxTorque = Vector3.new(0, 0, 0)
				bg.cframe = HRP.CFrame
	
				local bv = Instance.new("BodyVelocity", HRP)
				bv.velocity = Vector3.new(0, 0, 0)
				bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
				while flying do
					task.wait()
	
					if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
						speed = speed + .2
						if speed > maxspeed then
							speed = maxspeed
						end
					elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
						speed = speed - 1
						if speed < 0 then
							speed = 0
						end
					end
					if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
						bv.velocity = ((cam.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + ((cam.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) - cam.CoordinateFrame.p)) * speed
						lastctrl = {
							f = ctrl.f,
							b = ctrl.b,
							l = ctrl.l,
							r = ctrl.r
						}
					elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
						bv.velocity = ((cam.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + ((cam.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) - cam.CoordinateFrame.p)) * speed
					else
						bv.velocity = Vector3.new(0, 0.1, 0)
					end
				end
	
				ctrl = {
					f = 0,
					b = 0,
					l = 0,
					r = 0
				}
				lastctrl = {
					f = 0,
					b = 0,
					l = 0,
					r = 0
				}

				speed = 0
				bg:Destroy()
				bv:Destroy()
			end
	
			UIS.InputBegan:Connect(function(input, gp)
				if input.KeyCode == FK then
					ctrl.f = 1 * acceleration
				elseif input.KeyCode == BK then
					ctrl.b = -1 * acceleration
				elseif input.KeyCode == LK then
					ctrl.l = -1 * acceleration
				elseif input.KeyCode == RK then
					ctrl.r = 1 * acceleration
				end
			end)

			UIS.InputEnded:Connect(function(input, gp)
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == FK then
						ctrl.f = 0
					elseif input.KeyCode == BK then
						ctrl.b = 0
					elseif input.KeyCode == LK then
						ctrl.l = 0
					elseif input.KeyCode == RK then
						ctrl.r = 0
					end
				end
			end)
			Fly()
	
		elseif input.KeyCode == RespawnK and flying then
			flying = false
			spawn(function()
				local message = Instance.new("Message", Workspace)
				message.Text = "Respawning Character..."
				wait(1)
				message:Destroy()
			end)
			local ch = plr.Character
			local prt = Instance.new("Model", Workspace)
			local z1 =  Instance.new("Part", prt)
			z1.Name = "Torso"
			z1.CanCollide = false
			z1.Anchored = true
			local z2  = Instance.new("Part", prt)
			z2.Name = "Head"
			z2.Anchored = true
			z2.CanCollide = false
			local z3 = Instance.new("Humanoid", prt)
			z3.Name = "Humanoid"
			z1.Position = Vector3.new(0, 9999, 0)
			z2.Position = Vector3.new(0, 9991, 0)
			plr.Character = prt
			wait(3)
			plr.Character = ch
			local poop = nil
			repeat
				task.wait()
				poop = ch:FindFirstChild("Head") and ch:FindFirstChild("HumanoidRootPart")
			until poop ~= nil
			ch.HumanoidRootPart.CFrame = CFrame.new(ch:GetPivot() or ocf)
		end
	end
end)
