wait(5)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/AntiCheatBypass/master/Notification.lua?token=AKSKDDR4GGPWTPFCPCBJXFLAUKHYM"))()

getgenv().BypassSettings = {
   ["Crystal AntiCheat"] = true,
   ["Adonis"] = false,

   ["Anti-Obfuscated Scripts"] = false,-- CANNOT BE ENABLED WITH CRYSTAL This will block any obfuscated script on the client from running (Not executed by your exploit thought)
   ["Random"] = false, -- Will disallow scripts calling, GetPropertyChanged signal on WalkSpeed, JumpPower, Gravity, Health, LogService

   ["Enable Kill Logs"] = true, -- Say if you want to get told what's bypassed
}

loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()

Library:Notification("CAC bypass Injected", "Crystal AntiCheat Bypass by Scrumptious", 5, Color3.fromRGB(255, 255 ,255))
