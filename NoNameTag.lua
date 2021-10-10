local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
local Hum = charc:WaitForChild("Humanoid")
local HRP = charc:WaitForChild("HumanoidRootPart")

Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

--local player = game:GetService("Players").LocalPlayer
local name = player.Name

player.CharacterAdded:Connect(function(charca)
	if bl == false then
		wait(3)
		for index, v in pairs(charca:GetDescendants()) do
			if v:IsA("BillboardGui") then
				if v.Name == name then
					v:Destroy()
				elseif v.Parent.Parent.Parent:GetDescendants() == name then
					v:Destroy()
				else
					v:Destroy()
					if Logs then
						print("NameTag Removed")
					end
				end
					
				if Logs then
					print("NameTag Removed")
				end
			end
		end
	end
end)
