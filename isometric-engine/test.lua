
x = "hey"

dofile("test2.lua")

print(y)

-- some interesting env tests.

env = { y = 10 }
env_mttab = {}
env_mttab.__index = getfenv(0)
setmetatable(env, env_mttab)
--[[function env:__index(idx)
    print(idx)
    return self[idx];
end]]

f = function (x) print(x+y) end

--print(env.y)

setfenv(f, env)

f(2)

