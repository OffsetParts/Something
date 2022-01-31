local player = game:GetService("Players").LocalPlayer
local charc  = player.Character
local Hum = charc:WaitForChild("Humanoid")
local HRP = charc:WaitForChild("HumanoidRootPart")
local Name = player.Name

local function getPath(part)
	local str = part
	repeat
		wait(0.5)
		local currPar = part.Parent
		str = currPar.Name .. "\" .. str
		currPar = currPar.Parent
	until currPar.Name = "game" or nil
	print('str')
	return str
end

player.CharacterAdded:Connect(function(charca)
	if bl == false then
		wait(2)
		for index, v in pairs(charca:GetDescendants()) do
			if v:IsA("BillboardGui") then
				if v.Name == name then
					if DebugMode == true then getPath(v) end
					v:Destroy()
				elseif v.Parent.Parent.Parent:GetDescendants() == name then -- Delete if in workspace
					if DebugMode == true then getPath(v) end
					v:Destroy()
				else
					if DebugMode == true then getPath(v) end
					v:Destroy()
				end
			end
		end
	end
end)
