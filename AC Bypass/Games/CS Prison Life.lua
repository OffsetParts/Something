-- init 
if not game:IsLoaded(game) then 
    game.Loaded:Wait();
end

-- variables
local client, FindFirstChild = game:GetService("Players").LocalPlayer, game.FindFirstChild
local replicatedStorage = game:GetService("ReplicatedStorage");
local antiExploitRemotes = FindFirstChild(replicatedStorage, "CSAntiExploitRemotes");

local blacklistedRemotes = {
    Communication = FindFirstChild(antiExploitRemotes, "Communication"),
    GetSetting = FindFirstChild(antiExploitRemotes, "GetSetting")
};

-- hooks 
local namecall; do 
    namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local namecall_method, parameters = (getnamecallmethod or get_namecall_method)(), {...};
        
        if namecall_method == "Kick" and self == client then 
            return wait(9e9);
        elseif namecall_method == "InvokeServer" and self == blacklistedRemotes.GetSetting then 
            return wait(9e9)
        elseif namecall_method == "FireServer" and self == blacklistedRemotes.Communication then 
            return wait(9e9);
        end
        
        return namecall(self, ...);
    end));
end