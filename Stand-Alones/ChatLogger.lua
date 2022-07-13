if not game:IsLoaded() then game.Loaded:Wait() end

local _genv = getgenv() or _G

_genv.CH = {
    Enable = true, -- on/off
	url = ''
}

if CH.Enable then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Chat%20Logger.lua"), true))()
end