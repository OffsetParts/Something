--[[
   Eden Orphan Home Anti Cheat Bypass
   - Place in autoexec folder
   - Enable automatic injection
   - Join the game
   - Anti cheat bypassed
   Credits to Dosage
--]]
if game.PlaceId ~= 4786930269 then return end
game.DescendantAdded:Connect(function(d)
   if d.Name == "ClientLoader" then
       d:Destroy()
       print'bypassed'
   end
end)