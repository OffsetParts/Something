syn.set_thread_identity(2)
Tools = require(game:GetService("ReplicatedStorage").Modules.Database.Tools)
Vehicles = require(game:GetService("ReplicatedStorage").Modules.Database.Vehicles)
syn.set_thread_identity(7)

for i, v in pairs(Tools) do
    print(i, v)
    if v['Speed'] then
        v['Controller'] = "ThermalCore"
        v['SnowTypes'] = { "Snow", "Slush" }
        v['Strength'] = 10
        v['Speed'] = 0
        v['Multiplier'] = 4
        v['Tiles'] = 6
    end
end

for i, v in pairs(Vehicles) do
    print(i, v)
    if v['PlowSpeed'] then
        v['Controller'] = "Abominable"
        v['TileTypes'] = { "Snow", "Slush" }
        v['InstaSell'] = true
        v['Strength'] = 10
        v['PlowSpeed'] = 0
        v['Multiplier'] = 4
        v['MaxStorage'] = math.huge
    end
end