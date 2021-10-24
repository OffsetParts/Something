getgenv().name = _G.Name


local plr = game.Players.LocalPlayer
for Index, Value in next, game:GetDescendants() do 
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,plr.Name) 
        if has then 
            local str = Value.Text:gsub(plr.Name,name)
            Value.Text = str 
        end
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(plr.Name,name)
            Value.Text = str 
        end)
    end
end

game.DescendantAdded:Connect(function(Value)
    if Value.ClassName == "TextLabel" then 
        local has = string.find(Value.Text,plr.Name)
        Value:GetPropertyChangedSignal("Text"):Connect(function()
            local str = Value.Text:gsub(plr.Name,name)
            Value.Text = str 
        end)
        if has then 
            local str = Value.Text:gsub(plr.Name,name)
            Value.Text = str 
        end
        
    end
end)
