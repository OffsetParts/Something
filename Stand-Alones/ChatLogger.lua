if not game:IsLoaded() then game.Loaded:Wait() end
local _senv = getgenv() or _G

_senv.CH = {
    Enable = true, -- on/off
	url = ''
}

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Chat%20Logger.lua"), true))()