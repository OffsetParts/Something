local plr = game:GetService("Players").LocalPlayer

for _, v in next, game:GetDescendants() do -- for every already loaded descendant of game by time of execution | replace any text of player name with replacement
    if v.ClassName == "TextLabel" then 
        local has = string.find(v.Text, plr.Name) 
        if has then 
            local str = v.Text:gsub(plr.Name, _senv["Scrumpy"]["Alias"])
            v.Text = str 
        end
        v:GetPropertyChangedSignal("Text"):Connect(function()
            local str = v.Text:gsub(plr.Name, _senv["Scrumpy"]["Alias"])
            v.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(Value) -- Hook above functionality to every new descendant
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text, plr.Name)
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(plr.Name, _senv["Scrumpy"]["Alias"])
            Value.Text = str 
        end)
        if has then 
            local str = Value.Text:gsub(plr.Name, _senv["Scrumpy"]["Alias"])
            Value.Text = str 
        end
        
    end
end)