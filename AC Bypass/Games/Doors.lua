task.defer(function()
    while wait() do
        pcall(function()
            Workspace.CurrentRooms["0"].StarterElevator.DoorHitbox:Destroy()
        end)
    end
end)
game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Disabled = true