if not game.Loaded then
    game.Loaded:Wait()
end
wait(7.5)

local player = game.Players.LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
-- define player

local plr = game:GetService("Players").LocalPlayer
wait(0.5)
plr.CharacterAdded:Connect(function(charca)
	wait(6)
	for index, v in pairs(charca:GetDescendants()) do
		if v:IsA("BillboardGui") then
			v:Destroy()
			print("NameTag Removed")
		end
	end
end)
