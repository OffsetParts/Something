local Lighting = game:GetService'Lighting'
local _senv = getgenv() or _G

local OriginalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient
}

if not _senv.FullBrightExecuted then

	_senv.FullBrightEnabled = false

	Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
		if Lighting.Brightness ~= 2 and Lighting.Brightness ~= OriginalLighting.Brightness then -- if lighting doesn't equal our original brightness and not our desired brightness(2) then save and change that
			OriginalLighting.Brightness = Lighting.Brightness
			if not _senv.FullBrightEnabled then
				repeat
					task.wait()
				until _senv.FullBrightEnabled
			end
			Lighting.Brightness = 2
		end
	end)

	Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
		if Lighting.ClockTime ~= 12 and Lighting.ClockTime ~= OriginalLighting.ClockTime then
			OriginalLighting.ClockTime = Lighting.ClockTime
			if not _senv.FullBrightEnabled then
				repeat
					task.wait()
				until _senv.FullBrightEnabled
			end
			Lighting.ClockTime = 12
		end
	end)

	Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
		if Lighting.FogEnd ~= 786543 and Lighting.FogEnd ~= OriginalLighting.FogEnd then
			OriginalLighting.FogEnd = Lighting.FogEnd
			if not _senv.FullBrightEnabled then
				repeat
					task.wait()
				until _senv.FullBrightEnabled
			end
			Lighting.FogEnd = 786543
		end
	end)

	Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
		if Lighting.GlobalShadows ~= false and Lighting.GlobalShadows ~= OriginalLighting.GlobalShadows then
			OriginalLighting.GlobalShadows = Lighting.GlobalShadows
			if not _senv.FullBrightEnabled then
				repeat
					task.wait()
				until _senv.FullBrightEnabled
			end
			Lighting.GlobalShadows = false
		end
	end)

	Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
		if Lighting.Ambient ~= Color3.fromRGB(200, 200, 200) and Lighting.Ambient ~= OriginalLighting.Ambient then
			OriginalLighting.Ambient = Lighting.Ambient
			if not _senv.FullBrightEnabled then
				repeat
					task.wait()
				until _senv.FullBrightEnabled
			end
			Lighting.Ambient = Color3.fromRGB(200, 200, 200)
		end
	end)

	Lighting.Brightness = 1
	Lighting.ClockTime = 12
	Lighting.FogEnd = 786543
	Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.fromRGB(178, 178, 178)

	local LatestValue = true
	task.spawn(function()
		repeat
			task.wait()
		until _senv.FullBrightEnabled
		while task.wait() do
			if _senv.FullBrightEnabled ~= LatestValue then
				if not _senv.FullBrightEnabled then -- if disable go back to original
					Lighting.Brightness = OriginalLighting.Brightness
					Lighting.ClockTime = OriginalLighting.ClockTime
					Lighting.FogEnd = OriginalLighting.FogEnd
					Lighting.GlobalShadows = OriginalLighting.GlobalShadows
					Lighting.Ambient = OriginalLighting.Ambient
				else -- else to desired variables
					Lighting.Brightness = 2 -- fullbright
					Lighting.ClockTime = 12 -- noon
					Lighting.FogEnd = 786543 -- no fog
					Lighting.GlobalShadows = false -- no shadows
					Lighting.Ambient = Color3.fromRGB(178, 178, 178) -- normal ambient color
				end
				LatestValue = not LatestValue -- honest to god don't know how this still works
			end
		end
	end)
end

_senv.FullBrightExecuted = true
_senv.FullBrightEnabled = not _senv.FullBrightEnabled
