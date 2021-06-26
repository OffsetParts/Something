-- made by Scrumptious#0001
if not game.Loaded then
    game.Loaded:Wait()
end
wait(5)

local marketplaceService = game:GetService("MarketplaceService")
local place  = game.PlaceId
local isSuccessful, info = pcall(marketplaceService.GetProductInfo, marketplaceService, place)
local player = game.Players.LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
-- define player

if isSuccessful then
    print(info.Name .. ": Nametags has been cleared")
end

for i, v in pairs(charc:GetDescendants()) do
	if v:IsA("BillboardGui") then 	
		v:Destroy()
		print("Destroyed")
	end
end
print(".............")
local plr = game:GetService("Players").LocalPlayer
wait(0.5)
plr.CharacterAdded:Connect(function()
print(".............")
	for index, name in pairs(charc:GetDescendants()) do
		if name:IsA("BillboardGui") then
			name:Destroy()
			print("Reimburshed")
		end
	end
end)