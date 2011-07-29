----------------------------------------------------------------------------------------------------
-- O2Sys v1.4 by Wil                                                                            ----
-- Fev/2011                                                                                     ----
-- class.lua                                                                                    ----
----------------------------------------------------------------------------------------------------

-- In this ugly-code-filled file is constructed the class system.
-- Lots of nonsense and complicated stuff.
-- But have a go if you wanna know XD

-- USAGE:
-- require("base")
-- And everything should work.

----
-- Table which contains the class system.
-- You should not be able to add members to it directly.
----


----------------------------------------------------------------------------------------------------

local classmod_mttab = { __index = getfenv(0) }

module("o2sys.class", function(t) setmetatable(t, classmod_mttab) end)

----------------------------------------------------------------------------------------------------

local DIR = "o2sys/class/"

if USE_UNSAFE then
    dofile(DIR.."class_unsafe.lua")
else
    dofile(DIR.."class_safe.lua")
end

----------------------------------------------------------------------------------------------------
