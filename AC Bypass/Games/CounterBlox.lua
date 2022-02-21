local Meta = getrawmetatable(game)
setreadonly(Meta,false)
local oldNamecall = Meta.__namecall
Meta.__namecall = newcclosure(function(self,...)
   local Arguments = {...}
   local Method = getnamecallmethod()
   if self == game.Players.LocalPlayer and Method == "Kick" then
       print("Attempted kick")
       return
   end
   return oldNamecall(self,unpack(Arguments))
end)
