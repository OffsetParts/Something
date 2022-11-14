local Players = game:GetService'Players'
local Player  = Players.LocalPlayer
local GetConnections = getconnections or get_signal_cons -- syn and sw support

if GetConnections then -- AntiAFK
	for i, ob in pairs(GetConnections(Player.Idled)) do
		if ob["Disable"] then
			ob["Disable"](ob)
		elseif ob["Disconnect"] then
			ob["Disconnect"](ob)
		end
	end
end