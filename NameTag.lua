local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
charc.Humanoid.DisplayDistanceType = Enum.Humanoid.DisplayDistanceType.None

local bgames = {
    blacklisted = {
        Name = "Blacklisted",
        PlaceIDs = {5580097107},
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/NoNameTag.lua",
    }
}

for _, bgame in pairs(bgames) do
    for _, placeid in pairs(bgame.PlaceIDs) do
        if placeid ~= game.PlaceId then
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
