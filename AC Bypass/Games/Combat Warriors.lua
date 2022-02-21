for i,v in pairs(getgc(true)) do
   if type(v) == "table" and rawget(v,"Remote") then
       v.Remote.Name = v.Name
   end
end
