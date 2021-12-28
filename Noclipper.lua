if not game:IsLoaded() then game.Loaded:Wait() end

local plr = game:GetService("Players").LocalPlayer

local function check()
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if backpack ~= nil then return else return true end
end

function Noclip()
    plr.CharacterAdded:Connect(function()
		if check() == true then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
		end
    end)
end

if check() then
	Noclip()
end
