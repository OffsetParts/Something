-- Old deprecated | Does more bad then good
-- bruh still can't believe i didn't read that this just fucks ups the remotes, god i was a skid

for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
	if v:IsA("RemoteEvent") then
		local mt = getrawmetatable(game)
		setreadonly(mt, true)
		make_writeable(mt)
		hookfunction(v.Destroy, function() return wait(9e9) end)
		local remote = v
		local old = mt.__namecall
		mt.__namecall = newcclosure(function(self, ...)
		   if self == remote and getnamecallmethod() == "FireServer" then
			   return wait(9e9)
		   end
		   return old(self, ...)
		end)
	end
end