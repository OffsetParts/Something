for i,v in pairs(getgc(true)) do -- made by a furry
    if type(v) == "function" and tostring(getfenv(v).script) == "AntiCheat" then
        hookfunction(v,function() return print("SexSlaves3 the Movie coming in 2023") end)
    end
end