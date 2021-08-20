local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = "None"

print("check 1")
local bgames = {
    blacklisted = {
        Name = "Blacklisted",
        PlaceIDs = {5580097107},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/NoNameTag.lua",
    }
}

print("check 2")
for _, bgame in pairs(bgames) do
	print("check 3")
    for _, placeid in pairs(bgame.PlaceIDs) do
        if placeid ~= game.PlaceId then
		print("check 4")
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
            bl = false
    	elseif placeid == game.PlaceId then
	if Logs then
		print("(4b)Nametag cannot not be removed due to blacklist")
	end
		break
        end
    end
end
