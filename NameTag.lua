local player = game:GetService("Players").LocalPlayer
local charc  = player.Character or player.CharacterAdded:Wait()
charc.Humanoid.DisplayDistanceType = "None"
bl = false

local bgames = {
    blacklisted = {
        Name = "Blacklisted",
        PlaceIDs = {5580097107, 4855440772, 2768379856, 3823781113},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/NoNameTag.lua",
    }
}


for _, bgame in pairs(bgames) do
    for _, placeid in pairs(bgame.PlaceIDs) do
        if placeid ~= game.PlaceId then
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
    	elseif placeid == game.PlaceId then
	    bl = true
	    if Logs then
		print("(4b)Nametag cannot not be removed due to blacklist")
	    end
		break
        end
    end
end
