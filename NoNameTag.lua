local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

local plr = game:GetService("Players").LocalPlayer
local name = plr.Name

plr.CharacterAdded:Connect(function(charca)
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
end)
