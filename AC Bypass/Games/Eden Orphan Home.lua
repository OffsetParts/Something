if game.PlaceId ~= 4786930269 then return end

game.DescendantAdded:Connect(function(d)
   if d.Name == "ClientLoader" then -- lmao
       d:Destroy()
   end
end)
