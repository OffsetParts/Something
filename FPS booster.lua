if not game:IsLoaded() then repeat wait() until game:IsLoaded() end
if hookfunction and setreadonly then
	local mt = getrawmetatable(game)
	local old = mt.__newindex
	setreadonly(mt, false)
	local sda
	sda = hookfunction(old, function(t, k, v)
		if k == "Material" then
			if v ~= Enum.Material.Neon and v ~= Enum.Material.Plastic and v ~= Enum.Material.ForceField then v = Enum.Material.Plastic end
		elseif k == "TopSurface" then v = "Smooth"
		elseif k == "Reflectance" or k == "WaterWaveSize" or k == "WaterWaveSpeed" or k == "WaterReflectance" then v = 0
		elseif k == "WaterTransparency" then v = 1
		elseif k == "GlobalShadows" then v = false end
		return sda(t, k, v)
	end)
	setreadonly(mt, true)
end
local g = game
local w = g.Workspace
local l = g:GetService"Lighting"
local t = w:WaitForChild"Terrain"
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 1
l.GlobalShadows = false

function change(v)
	pcall(function()
		if v.Material ~= Enum.Material.Neon and v.Material ~= Enum.Material.Plastic and v.Material ~= Enum.Material.ForceField then
			pcall(function() v.Reflectance = 0 end)
			pcall(function() v.Material = Enum.Material.Plastic end)
			pcall(function() v.TopSurface = "Smooth" end)
		end
	end)
end

game.DescendantAdded:Connect(function(v)
	pcall(function()
		if v:IsA"Part" then change(v)
		elseif v:IsA"MeshPart" then change(v)
		elseif v:IsA"TrussPart" then change(v)
		elseif v:IsA"UnionOperation" then change(v)
		elseif v:IsA"CornerWedgePart" then change(v)
		elseif v:IsA"WedgePart" then change(v) end
	end)
end)
for i, v in pairs(game:GetDescendants()) do
	pcall(function()
		if v:IsA"Part" then change(v)
		elseif v:IsA"MeshPart" then change(v)
		elseif v:IsA"TrussPart" then change(v)
		elseif v:IsA"UnionOperation" then change(v)
		elseif v:IsA"CornerWedgePart" then change(v)
		elseif v:IsA"WedgePart" then change(v) end
	end)
	if string.find(tostring(i), "50$") or string.find(tostring(i), "00$") then game:FindService"RunService".Heartbeat:wait() end
end
