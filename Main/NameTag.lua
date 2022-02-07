local player = game:GetService("Players").LocalPlayer
local name = player.Name

local games = {
    blacklist = {
        Name = "Blacklist",
        PlaceIDs = {5580097107, 4855440772, 2768379856, 3823781113}, -- Known to kick/ban for having nametag tampered
    }
}

local function getPath(part)
	local str = part
	repeat
		wait(0.5)
		local currPar = part.Parent
		str = currPar.Name .. "/" .. str
		currPar = currPar.Parent
	until currPar.Name == "game" or nil
	print(str)
	return str
end

local bl
local function Start()
    player.CharacterAdded:Connect(function(charca)
    	if bl == false then
    		wait(2)
    		for index, v in pairs(charca:GetDescendants()) do
    			if v:IsA("BillboardGui") then
    				if v.Name == name then
    					if DebugMode == true then getPath(v) end
    					v:Destroy()
    				elseif v.Parent.Parent.Parent:GetDescendants() == name then -- Delete if in workspace
    					if DebugMode == true then getPath(v) end
    					v:Destroy()
    				else
    					if DebugMode == true then getPath(v) end
    					v:Destroy()
    				end
    			end
    		end
    	end
    end)
end

for _,x in pairs(games.blacklist.PlaceIDs) do
    if x ~= game.placeId then
        Start()
    elseif ID == game.placeId then
        bl = true
        logs("(4a) NameTag couldn't proceed as game is bled")
    end
end
