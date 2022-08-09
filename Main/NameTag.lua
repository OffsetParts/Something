-- So there is this guy that made a Anti-fling and for this update i skidded his method of monitoring the LP Character and service which i must say is cool as fuck. So i just stole it and it works really well.

-- [ Services ] -- 
local Services = setmetatable({}, {__index = function(Self, Index)
	local NewService = game.GetService(game, Index)
	if NewService then
		Self[Index] = NewService
	end
	return NewService
end})

local Workspace = Services.Workspace
local plr = Services.Players.LocalPlayer

local blacklist = {5580097107, 2768379856, 3823781113, 7229033818,
10421123948,
9668084201,
7942446389,
8061174649,
8061174873,
8365571520,
8892853383,
8452934184}

local bl
for _, x in pairs(blacklist) do
    if x == game.PlaceId then
        bl = true
		if Notifier then Notifier("(4a) NameTag couldn't proceed as game is blacklisted", true) end
    end
end

local Character;
local PrimaryPart;

local function CharacterAdded(NewCharacter)
	Character = NewCharacter
	repeat
		task.wait()
		PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
	until PrimaryPart
end

CharacterAdded(plr.Character or plr.CharacterAdded:Wait())
plr.CharacterAdded:Connect(CharacterAdded()
	if (Character and Character:IsDescendantOf(Workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
		for _,v in pairs(Character:GetDescendants()) do
			task.wait()
			if v:IsA 'BillboardGui' then
				v:Destroy()
			end
		end
		Character.DescendantAdded:Connect(function(Child)
			if not bl then
				if Child:IsA 'BillboardGui' then Child:Destroy() end
			end
		end)
	end
end)