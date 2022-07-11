local Workspace = game:GetService("Workspace")
local plr = game:GetService("Players").LocalPlayer
local chara = plr.Character or plr.CharacterAdded:Wait()

if not Promise then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/Libraries/Promise.lua"))()
    getgenv().Promise = require("{AB02623B-DEB2-4994-8732-BF44E3FDCFBC}")
end

local blacklist = {5580097107, 2768379856, 3823781113} -- Known to kick/ban for having nametag tampered no im not gonna bother making a bypass for them unless i find a universal one

local ID = game.PlaceId

local bl
for _, x in pairs(blacklist) do
    if x == ID then
        bl = true
		if Notifier then Notifier("(4a) NameTag couldn't proceed as game is blacklisted", true) end
    end
end


local function cleanup()

	for _,v in pairs(chara:GetDescendants()) do
		task.wait()
		if v:IsA 'BillboardGui' then
			v:Destroy()
		end
	end
	chara.DescendantAdded:Connect(function(Obj)
		if not bl then
			if Obj:IsA("BillboardGui") then
				Obj:Destroy()
			end
		end
	end)
end

cleanup()

Promise.fromEvent(
    plr.CharacterAdded,
    function()
        if not bl then return true end
    end
):andThenCall(cleanup())