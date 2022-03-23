for i,v in pairs(getgc(true)) do
   if typeof(v) == 'table' and rawget(v, 'getIsMaxed') then
       v.getIsMaxed = function()
           return false
       end
       v.getFlags = function()
           return 1
       end
       v.addFlags = function(a,b)
           a:setFlags(0)
           return
       end
   end
   if typeof(v) == 'table' and rawget(v, 'punish') then
       v.punish = function(a,b,c)
           return
       end
   end
   if typeof(v) == 'table' and rawget(v, 'spawnCharacter') then
       local oldfunc = v.spawnCharacter
       v.SpawnCharacter = function(a)
           for _,f in pairs(getgc(true)) do
               if typeof(f) == 'table' and rawget(f, 'getIsMaxed') then
                   f.getIsMaxed = function()
                       return false
                   end
                   f.getFlags = function()
                       return 1
                   end
                   f.addFlags = function(aa,b)
                       aa:setFlags(0)
                       return
                   end
               end
           end
       end
   end
   if typeof(v) == 'table' and rawget(v, 'getCanJump') then
       v.getCanJump = function()
           return true
       end
   end
   if typeof(v) == 'table' and rawget(v, 'JUMP_DELAY_ADD') then
       v.JUMP_DELAY_ADD = 0.5
   end
   if typeof(v) == 'table' and rawget(v, '_setStamina') then
       v._setStamina = function(a, b)
           a._stamina = math.huge
           a._staminaChangedSignal:Fire(99)
       end
   end
end
