wait(2.5)
local light = false
startupsound = 1364317494
theme = true
themedata = {
ThemeName = "Pornhub",
BGColor1 = Color3.fromRGB(0,0,0),
BGColor2 = Color3.fromRGB(255, 153, 0),
LogoIcon = 000000,
}

if light then 
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Light.lua'),true))()
elseif not light then
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/DomainV2.lua'),true))()
end