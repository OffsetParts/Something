local secureLabels = true; --// Secures labels that are parented to the heads of players
local removePlayers = false; --// Choose if you want to remove the people's characters from the game (Locally)
local SecureTag = "SCP" --// Change to whatever you want to
local UpdateTime = .1 --// Recommended, can go up and down if needed
local start, ending = 1, 999 --// start is the number you'd like for the number gen to start, ending is the max number you'd like the gen to go to

local labelWhitelist = {"labelname","anotherlabelname", "onemorelabelname"} --// enter the label names (if you know them)

local function secureText()
   local randomNumber = math.random(start, ending);
   
   local f = SecureTag.."-"..randomNumber
   
   return f
end


local function update()
   for i,v in next, game.CoreGui.PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame:GetChildren() do
       if v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName ~= nil then
           if not string.find(string.lower(v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text), string.lower(SecureTag)) then
               local gen = secureText();

               v.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = gen
           end
       else
           v:Destroy()
       end
   end
   
   for i,v in next, game.Players:GetChildren() do
       if v.Character and v.Character:FindFirstChild("Humanoid") ~= nil and not string.find(string.lower(v.DisplayName), string.lower(SecureTag)) and not string.find(string.lower(v.Name), string.lower(SecureTag)) then
           local secured = secureText();
           
           v.Name = secured
           v.Character.Humanoid.DisplayName = secured
       end
   end
   
   if secureLabels then
       local secured = secureText();
       
       spawn(function()
           for i,v in next, game.Players:GetChildren() do
               for a,x in next, v.Character.Head:GetDescendants() do
                   if x:IsA("TextLabel") and not string.find(string.lower(x.Text), string.lower(SecureTag)) and not table.find(labelWhitelist, x.Name) then
                       x.Text = secured
                   end
               end
           end
       end)
   end
           
   if removePlayers then
       for i,v in next, game.Players:GetChildren() do
           spawn(function()
               if v.Character ~= game.Players.LocalPlayer.Character then
                   v.Character:Destroy()
               end
           end)
       end
   end
end

--// Notification

game.StarterGui:SetCore("SendNotification", {
   Title = SecureTag.." Alert",
   Text = "Game Instance protected using Scrambler"
});

--// Check for update

while wait(UpdateTime) do
   spawn(function()
       update();
   end)
end
