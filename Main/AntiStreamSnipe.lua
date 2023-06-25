-- For when your streaming and want to cloak your server and players.
local secureLabels = true; --// Secures labels that are parented to the heads of players
local removePlayers = false; --// Choose if you want to remove the people's characters from the game (Locally)
local SecureTag = "SCP" --// Change to whatever you want to
local UpdateTime = .5 --// Recommended, can go up and down if needed
local start, ending = 1, 9999 --// start is the number you'd like for the number gen to start, ending is the max number you'd like the gen to go to

local labelWhitelist = {"labelname","anotherlabelname", "onemorelabelname"} --// enter the label names (if you know them)

local function secureText()
    local randomNumber = math.random(start, ending);
    local f = SecureTag .. "-" .. randomNumber
    return f
end


local function update()
    if game.CoreGui:WaitForChild("PlayerList") then
        for i,v in next, game:GetService("CoreGui").PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame:GetChildren() do
            if v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName then
                v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = secureText()
            else
                v:Destroy()
            end
        end

        for i,v in next, game.Players:GetChildren() do
            if v.Character and v.Character:FindFirstChild("Humanoid") then
                local secured = secureText();
                
                v.Name = secured
                v.Character.Humanoid.DisplayName = secured
            end
        end

        if secureLabels then
            local secured = secureText();
            
            task.spawn(function()
                for i,v in next, game.Players:GetChildren() do
                    for a,x in next, v.Character.Head:GetDescendants() do
                        if x:IsA("TextLabel") and not table.find(labelWhitelist, x.Name) then
                            x.Text = secured
                        end
                    end
                end
            end)
        end
                
        if removePlayers then
            for i,v in next, game.Players:GetChildren() do
                task.spawn(function()
                    if v.Character ~= game.Players.LocalPlayer.Character then
                        v.Character:Destroy()
                    end
                end)
            end
        end
    end
end

--// Notification

Notifier("SCP Alert!", "Game Instance protected using Scrambler")

--// Check for update

while task.wait(UpdateTime) do
    task.spawn(function()
        update();
    end)
end

Notifier("(4a) Anti-Stream Snipe", true)