if not game:IsLoaded() then game.Loaded:Wait() end

local plr = game:GetService("Players").LocalPlayer

local exist
local function check()
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if backpack ~= nil then exist = true else return end
end

check()

function Noclip()
    plr.CharacterAdded:Connect(function()
        check()
		if exist == true then
			loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Noclip.lua"),true))()
		    print('noclip')
		end
    end)
end

Noclip()
