local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

for index, v in pairs(charc:GetDescendants()) do
	if v:IsA("BillboardGui") then
	v:Destroy()
		if Print then
			print("NameTag Removed")
		end
	end
end

local plr = game:GetService("Players").LocalPlayer
local name = plr.Name
wait(0.5)
plr.CharacterAdded:Connect(function(charca)
	wait(4.5)
	for index, v in pairs(charca:GetDescendants()) do
		if v:IsA("BillboardGui") then
			if v.Name == name then
				v:Destroy()
				break
			elseif v.Parent.Parent.Parent:GetDescendants() == name then
				v:Destroy()
				break
			else
				v:Destroy()
				print("NameTag Removed")
			end
			if Print then
				print("NameTag Removed")
			end
		end
	end
end)
