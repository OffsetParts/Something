-- Blacklist: kick yourself or notify you if BLed homo saipen joins
-- Make sure to configure the settings array, dumbass.

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService('Players')
local Player  = Players.LocalPlayer
local Notification = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/saucekid/UI-Libraries/main/NotificationLib.lua"))()

local creatorID, creatorType = function()
	if game.CreatorType == Enum.CreatorType.User then
		return game.CreatorId, "user"
	elseif game.CreatorType == Enum.CreatorType.Group then
		return game.CreatorId, "group"
	end
end

local Settings = {
	Kick = false,
	userBL = false,
	groupBL = false,
    robloxBL = false,
	alertIfOwner = false
}

local robloxGroups = {
	[14593111] = { Tag = "Avator Emotion Tester" },
	[12513722] = { Tag = "Bri'ish Person" },
	[10279336] = { Tag = "Sony Music Person" },
	[1200769] = { Tag = "Roblox Staff" },
	[3055661] = { Tag = "QA Tester" },
	[6821794] = { Tag = "Graphics Tester" },
	[3253689] = { Tag = "Member of the SML coalition" },
}

local userlist = {
	"156", -- builderman
	"1", -- ROBLOX
	"3088079407", -- random monke
}

local grouplist = {
    [84894894] = { -- groupID / Template
        blacklist_all = false, -- blacklisted ENTIRE group
        blacklisted_ranks = {105}, -- BLed only specific staff ranks
        game_locked = true, -- locked to specific game(s)
        games = {238464579, 8975780235, 7895489345},
    },
}

local function signal(ID, identifier, name, typ, override)
	if Setting.Kick and not override then
		if creatorType == 'group' then
			Player:Kick(typ .. " in your game, detection method: " .. identifier .. ", Group ID: (" .. ID .. ") with Username: " .. name)
		else
			Player:Kick(typ .. " in your game: detection method: " .. identifier .. ", User in question: " .. name)
		end
	else
		if creatorType == 'group' then
			Notification.WallNotification(typ .. " in your game, detection method: " .. identifier .. ", Group ID: (" .. ID .. ") with Username: " .. name)
		else
			Notification.WallNotification(typ .. " in your game: detection method: " .. identifier .. ", User in question: " .. name)
		end
	end
end

local function track(player)
    if player == Player then return end
	local char = player.Character or player.CharacterAdded:Wait()
	
	if Settings.userBL then
		for _, ID in pairs(userlist) do -- ID Check
			if ID == player.UserId then
				signal(nil, 'UserID', player.Name, 'Blacklisted User')
			end
		end
	end
	
	local Rank, Role = function() 
	    if creatorType == 'group' then
	        return player:GetRankInGroup(creatorID), player:GetRoleInGroup(creatorID)
	    end
	end
	
	if Settings.alertIfOwner then
	    if creatorType == 'group' and (Rank and Rank == 255) then
	        signal(creatorID, 'groupID', player.Name, 'Owner', true) -- you can change the true to false if you want it to kick
	    elseif creatorType == 'user' and player.UserID == creatorID then
	        signal(creatorID, 'UserID', player.Name, 'Owner', true)
	    end
	end
	
    if Settings.groupBL and (creatorType == 'group' and grouplist[creatorID]) then
		local groupSettings = grouplist[creatorID]
		if (groupSettings['game_locked'] and groupSettings['games'][game.PlaceID]) then
			if groupSettings['blacklist_all'] then
				signal(creatorID, 'groupID', player.Name, 'Blacklisted Group member')
			else
				for _, rank in pairs(groupSettings['blacklisted_ranks']) do
					if Rank == rank then
						signal(creatorID, 'groupID', player.Name, 'Blacklisted: ' .. Role)
					end
				end
			end
		elseif groupSettings['game_locked'] == false then
			if groupSettings['blacklist_all'] then
				signal(creatorID, 'groupID', player.Name, 'Blacklisted Group member')
			else
				for _, rank in pairs(groupSettings['blacklisted_ranks']) do
					if Rank == rank then
						signal(creatorID, 'groupID', player.Name, 'Blacklisted: ' .. Role)
					end
				end
			end
		end
	end

    if Settings.robloxBL then
    	for ID, tbl in pairs(robloxGroups) do
    		if player:IsInGroup(ID) then
    			signal(ID, "Roblox Employee/Tester", player.Name, tbl["Tag"])
    		end
    	end
    
    	local function checkChar(char)
    		for i, Int in next, char:GetChildren() do
    			if Int:IsA("Accessory") and (Int.Name == "Valiant Top Hat of Testing" or Int.Name == "Valiant Valkyrie of Testing" or Int.Name == "Thoroughly-Tested Hat of QA") then
    				signal(nil, "Instance Detection", player.Name, "QA Tester")
    			end
    		end
    	end
		
    	checkChar(char)
	    player.CharacterAdded:Connect(checkChar)
	end
end

task.spawn(function()
	for i, player in pairs(Players:GetPlayers()) do
		track(player)
	end
end)

Players.PlayerAdded:Connect(track)