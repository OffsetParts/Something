local player = game:GetService("Players").LocalPlayer
local name = player.Name

blacklist = {5580097107, 2768379856, 3823781113} -- Known to kick/ban for having nametag tampered


local function getPath(part) -- give it object not object name
	local partPath = part:GetFullName()
	local appendStr = 'game.' 
	for _, token in ipairs(partPath:split(".")) do
		local appendToken = token
	
		if token:match(" ") then
			appendToken = "[\"" .. token .. "\"]"
		end
	
		appendStr = appendStr .. appendToken
	end
	return appendStr
end

local bl
local function Removal()
    player.CharacterAdded:Connect(function(charca)
    	if bl == false then
    		wait(2)
    		for index, v in pairs(charca:GetDescendants()) do
    			if v:IsA("BillboardGui") then
    				if v.Name == name then
    					if Debug == true then getPath(v) end
    					v:Destroy()
    				elseif v.Parent.Parent.Parent:GetDescendants() == name then -- Delete if in workspace
    					if Debug == true then getPath(v) end
    					v:Destroy()
    				else
    					if Debug == true then getPath(v) end
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
