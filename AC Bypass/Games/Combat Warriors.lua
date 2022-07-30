for i,v in pairs(getgc(true)) do
    task.wait()
    if typeof(v) == 'table' then

        if rawget(v, 'getIsMaxed') then
            v.getIsMaxed = function(...)
                return false
            end
            v.getFlags = function(...)
                return 1
            end
            v.addFlags = function(a,b)
                a:setFlags(0)
                return
            end
        end
        if rawget(v, 'punish') then
            v.punish = function(...)
                task.wait(9e9)
                return
            end
        end
        if rawget(v, 'spawnCharacter') then
            print(getcallingscript(v.spawnCharacter):GetFullName())
            local oldfunc
            oldfunc = hookfunction(v.spawnCharacter, newcclosure(function(a)
                for _,f in pairs(getgc(true)) do
                    task.wait()
                    if typeof(f) == 'table' and rawget(f, 'getIsMaxed') then
                        f.getIsMaxed = function(...)
                            return false
                        end
                        f.getFlags = function(...)
                            return 1
                        end
                        f.addFlags = function(aa,b)
                            aa:setFlags(0)
                            return
                        end
                    end
                end
            end))
        end
        if rawget(v, 'getCanJump') then
            v.getCanJump = function(...)
                return true
            end
        end
        if rawget(v, 'JUMP_DELAY_ADD') then
            v.JUMP_DELAY_ADD = 0.5
        end
        if rawget(v, '_setStamina') then
            v._setStamina = function(a, b)
                a._stamina = math.huge
                a._staminaChangedSignal:Fire(99)
            end
        end
    end
end 