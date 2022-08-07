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

local blacklist = {5580097107, 2768379856, 3823781113} -- Known to kick/ban for having nametag tampered no im not gonna bother making a bypass for them unless i find a universal one

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
		wait()
		PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
	until PrimaryPart
	Detected = false
end

CharacterAdded(plr.Character or plr.CharacterAdded:Wait())
plr.CharacterAdded:Connect(CharacterAdded)
Services.RunService.Heartbeat:Connect(function()
	if (Character and Character:IsDescendantOf(Workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
		for _,v in pairs(Character:GetDescendants()) do
			task.wait()
			if v:IsA 'BillboardGui' then
				v:Destroy()
			end
		end
		Character.DescendantAdded:Connect(function(Obj)
			if not bl then
				if Obj:IsA("BillboardGui") then
					Obj:Destroy()
				end
			end
		end)
	end
end)