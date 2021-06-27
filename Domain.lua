wait(2.5)
-- light or dark mode
local light = false
-- individual settings for light or dark mode

if light then
startupsound = 1364317494
theme = true
themedata = {
ThemeName = "Light Mode",
BGColor1 = Color3.fromRGB(0,0,0),
BGColor2 = Color3.fromRGB(64, 78, 237),
LogoIcon = 000000,
}
wait(0.01)
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/Light.lua'),true))()
elseif not light then
startupsound = 1364317494
theme = true
themedata = {
ThemeName = "Pornhub",
BGColor1 = Color3.fromRGB(0,0,0),
BGColor2 = Color3.fromRGB(255, 153, 0),
LogoIcon = 000000,
}
wait(0.01)
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Input50/Something/master/DomainV2.lua'),true))()
end