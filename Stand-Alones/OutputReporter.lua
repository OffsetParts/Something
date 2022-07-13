if not game:IsLoaded() then game.Loaded:Wait() end

local _genv = getgenv() or _G

_genv.ER = {
	Enable = true,
	url = 'https://discord.com/api/webhooks/885291049508032574/jRENCMdEews5OVNgxkBiQryXfecA86AKJhFrk0GHI24iFdXVj-9pjZnsD7ROSAhn-W_k', -- webhook url
	mode = 'wh', -- wh or cli | console only works with syn, krnl, and sw
	types = { -- enables the logging of each type | Warning: this will override the default behavior and redirect the enabled to your selected mode and will not replicate on client consles
		["print"] = false, -- Not recommeded
		["error"] = true,
		["warn"]  = true,
	}
}

if ER.Enable then
	loadstring(game:HttpGet(("https://raw.githubusercontent.com/Input50/Something/master/Misc/Output%20Reporter.lua"),true))()
end