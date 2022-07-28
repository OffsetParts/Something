if not game:IsLoaded() then game.Loaded:Wait() end

local _senv = getgenv() or _G

_senv.ER = {
	Enable = false,
	url = '', -- webhook url
	mode = 'wh', -- wh or cli | console only works with syn, krnl, and sw
	types = { -- enables the logging of each type | Warning: this will override the default behavior and redirect the enabled to your mode of choosing and will not replicate
		["print"] = false, -- Not recommeded
		["error"] = true,
		["warn"]  = true,
	}
}

loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Output%20Reporter.lua"),true))()