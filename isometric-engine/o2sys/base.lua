----------------------------------------------------------------------------------------------------
-- Goroboids v1.4 by Wil                                                                        ----
-- Fev/2011                                                                                     ----
-- base.lua                                                                                     ----
----------------------------------------------------------------------------------------------------

-- This is the package to be required when using the class system.

-- Obviously, it requires the class system itself.
require("class")

-- Metatable to protect the class system.
--[[
meta_protection = {
    __newindex = function(obj, key, index)
        error("DO NOT CHANGE THE CLASS SYSTEM.")
    end
}
]]
-- With this, no normal means should alter the class system.
setmetatable(class, meta_protection)

module("base")
