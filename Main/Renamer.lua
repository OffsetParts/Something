local plr = game.Players.LocalPlayer

for _, v in next, game:GetDescendants() do -- for every new instance in game do find text if has our player's name then change it with our subname
    if v.ClassName == "TextLabel" then 
        local has = string.find(v.Text, plr.Name) 
        if has then 
            local str = v.Text:gsub(plr.Name, _G.Name)
            v.Text = str 
        end
        v:GetPropertyChangedSignal("Text"):Connect(function()
            local str = v.Text:gsub(plr.Name, _G.Name)
            v.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(Value) -- Value is the Instance itself and it just check its classname and repeats the same process
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,plr.Name)
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(plr.Name, _G.Name)
            Value.Text = str 
        end)
        if has then 
            local str = Value.Text:gsub(plr.Name, _G.Name)
            Value.Text = str 
        end
        
    end
end)
