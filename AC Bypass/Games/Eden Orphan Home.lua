game.DescendantAdded:Connect(function(d)
   if d.Name == "ClientLoader" then -- lmao
       d:Destroy()
   end
end)
