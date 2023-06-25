local plr = Services.Players.LocalPlayer

for _, v in next, game:GetDescendants() do -- for every already loaded descendant of game by time of execution | replace any text of player name with the replacement
    if v:IsA 'TextLabel' then 
        if string.find(v.Text, plr.Name)  then 
            local str = v.Text:gsub(plr.Name, Scrumpy["Alias"])
            v.Text = str 
        end
        v:GetPropertyChangedSignal("Text"):Connect(function()
            local str = v.Text:gsub(plr.Name, Scrumpy["Alias"])
            v.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(descendant) -- Hook above functionality to every new descendant
    if descendant:IsA 'TextLabel' then 
        if string.find(descendant.Text, plr.Name) then 
            local str = descendant.Text:gsub(plr.Name, Scrumpy["Alias"])
            descendant.Text = str 
        end
        descendant:GetPropertyChangedSignal("Text"):Connect(function()
            local str = descendant.Text:gsub(plr.Name, Scrumpy["Alias"])
            descendant.Text = str 
        end)
    end
end)

Notifier("(1) Obscurer", true)