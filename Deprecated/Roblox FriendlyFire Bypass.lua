-- Literally who tf uses this

if not game:IsLoaded() then game.Loaded:Wait() end

pcall(function()
      if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Tracker") then

            for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Tracker.Changed)) do
                  v:Disable();
            end

            for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Loop.Changed)) do
                  v:Disable();
            end

            for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Loop.AncestryChanged)) do
                  v:Disable();
            end

            for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Tracker.AncestryChanged)) do
                  v:Disable();
            end

            game:GetService("Players").LocalPlayer.PlayerGui.Tracker.Disabled = true
            game:GetService("Players").LocalPlayer.PlayerGui.Loop.Disabled = true
            game:GetService("Players").LocalPlayer.PlayerGui.Tracker:Destroy()
            game:GetService("Players").LocalPlayer.PlayerGui.Loop:Destroy()

      end
end)