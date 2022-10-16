whitelist = { -- ! You can add / remove here for more settings to be saved / loaded
"CameraYInverted",
"ComputerCameraMovementMode",
"ComputerMovementMode",
"ControlMode",
"Fullscreen",
"GamepadCameraSensitivity",
"MasterVolume",
"MouseSensitivity",
"OnScreenProfilerEnabled",
"PerformanceStatsVisible",
"SavedQualityLevel",
"TouchCameraMovementMode",
"TouchMovementMode",
}
propertiesWithOwnSignal = { Fullscreen = "FullscreenChanged", PerformanceStatsVisible = "PerformanceStatsVisibleChanged" }
loadstring(game:HttpGetAsync("https://gist.githubusercontent.com/htt-py/92db22eeefad0042a6da9117501ad827/raw/ForceRobloxSettings.luau", true))()