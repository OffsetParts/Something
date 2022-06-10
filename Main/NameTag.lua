local player = game:GetService("Players").LocalPlayer
local name = player.Name

blacklist = {5580097107, 2768379856, 3823781113} -- Known to kick/ban for having nametag tampered no im not gonna bother making a bypass for them unless i find a universal one

local bl
local function Removal()
    player.CharacterAdded:Connect(function(charca)
    	if bl == false then
    		wait(2)
    		for index, v in pairs(charca:GetDescendants()) do
    			if v:IsA("BillboardGui") then
    				if v.Name == name then
    					v:Destroy()
    				elseif v.Parent.Parent.Parent:GetDescendants() == name then -- Delete if in workspace
    					v:Destroy()
    				else
    					v:Destroy()
    				end
    			end
    		end
    	end
    end)
end

for _,x in pairs(blacklist) do
    if x ~= game.placeId then
        Removal()
    elseif place == game.placeId then
        bl = true
        logs("(4a) NameTag couldn't proceed as game is bled")
    end
end
