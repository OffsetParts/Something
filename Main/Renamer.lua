local plr = Services.Players

for _, v in next, game:GetDescendants() do -- for every already loaded descendant of game by time of execution | replace any text of player name with replacement
    if v:IsA 'TextLabel' then 
        local has = string.find(v.Text, plr.Name) 
        if has then 
            local str = v.Text:gsub(plr.Name, getgenv()["Scrumpy"]["Alias"])
            v.Text = str 
        end
        v:GetPropertyChangedSignal("Text"):Connect(function()
            local str = v.Text:gsub(plr.Name, getgenv()["Scrumpy"]["Alias"])
            v.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(Value) -- Hook above functionality to every new descendant
    if Value:IsA 'TextLabel' then 
        local has = string.find(Value.Text, plr.Name)
        if has then 
            local str = Value.Text:gsub(plr.Name, getgenv()["Scrumpy"]["Alias"])
            Value.Text = str 
        end
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(plr.Name, getgenv()["Scrumpy"]["Alias"])
            Value.Text = str 
        end)
    end
end)