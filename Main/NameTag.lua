local Workspace = game:GetService("Workspace")
local plr = getlplayer()

blacklist = {5580097107, 2768379856, 3823781113} -- Known to kick/ban for having nametag tampered no im not gonna bother making a bypass for them unless i find a universal one

local ID = game.PlaceId
local bl

local function Removal()
    plr.Character.DescendantAdded:Connect(function(Obj)
    	if not bl then
    		task.wait(2)
			if Obj:IsA("BillboardGui") then
				Obj:Destroy()
			end
    	end
    end)
end

for _, x in pairs(blacklist) do
    if x == ID then
        bl = true
    end
end

if not bl then
	Removal()
	Notifier("(4a) NameTag couldn't proceed as game is blacklisted", true)
end