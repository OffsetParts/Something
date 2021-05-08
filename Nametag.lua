wait(5)
local marketplaceService = game:GetService("MarketplaceService")
local place  = game.PlaceId
local isSuccessful, info = pcall(marketplaceService.GetProductInfo, marketplaceService, place)
-- define player
local Player = game:GetService("Players").LocalPlayer
local char = Player.Character

if isSuccessful then
    print(info.Name .. ": Nametags has been cleared")
end

-- get nametag within the local player character and destory it
while true do
    for i, v in pairs(char:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
    wait(5)
end
