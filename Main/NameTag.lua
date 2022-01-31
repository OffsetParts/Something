local player = game:GetService("Players").LocalPlayer
local charc  = player.Character or player.CharacterAdded:Wait()
if charc and charc:WaitForChild('Humanoid') then
	charc.Humanoid.DisplayDistanceType = "None"
end

bl = false
local bgames = {
    blacklist = {
        Name = "Blacklist",
        PlaceIDs = {5580097107, 4855440772, 2768379856, 3823781113}, -- Known to kick/ban for having nametag tampered
        ScriptToRun = "https://raw.githubusercontent.com/Input50/Something/master/Main/NoNameTag.lua",
    }
}

for _, bgame in pairs(bgames) do
    for _, ID in pairs(bgame.PlaceIDs) do
        if ID ~= game.placeId then
            loadstring(game:HttpGet((bgame.ScriptToRun),true))()
    	elseif ID == game.placeId then
			bl = true
			if Logs then
				print("(4b) Nametag cannot not be removed due to blacklist")
			end
        end
    end
end
