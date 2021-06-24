wait(5)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Input50/Something/master/Notification.lua"))()

getgenv().BypassSettings = {
   ["Crystal AntiCheat"] = false,
   ["Adonis"] = true,

   ["Anti-Obfuscated Scripts"] = false,-- CANNOT BE ENABLED WITH CRYSTAL This will block any obfuscated script on the client from running (Not executed by your exploit thought)
   ["Random"] = true, -- Will disallow scripts calling, GetPropertyChanged signal on WalkSpeed, JumpPower, Gravity, Health, LogService

   ["Enable Kill Logs"] = true, -- Say if you want to get told what's bypassed
}

loadstring(game:HttpGet("https://irisapp.ca/TheGoodSucc/iAntiCheat.lua"))()

Library:Notification("UN bypass Injected", "Universal AntiCheat Bypass", 5, Color3.fromRGB(255, 255 ,255))
