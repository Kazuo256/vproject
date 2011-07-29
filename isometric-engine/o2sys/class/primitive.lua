----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- O2Sys v0.1 by V-Project                                                                      ----
-- Fev/2011                                                                                     ----
-- o2sys/class/primitive.lua                                                                    ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--   Here are defined the primitive types' names                                                ----
--   There are 'true' values indexed by the primitive types' names in the 'primitive' table,    ----
-- which is returned to the caller of the chunk-file.                                           ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- This is the table that will tell whether a string corresponds to a primitive type name or not.
local primitive = {}

----------------------------------------------------------------------------------------------------

-- The indexes with the primitive types' names receive a 'true' value, and any other will be 'nil'.
primitive.number = true
primitive.boolean = true
primitive.string = true
primitive.table = true
primitive.userdata = true
primitive.thread = true
primitive["nil"] = true     -- nil is a reserved word, so it is necessary to do it like this.

----------------------------------------------------------------------------------------------------

-- Return the 'primitive' table containing 'true' values in the indexes with primitive types' names.
return primitive

----------------------------------------------------------------------------------------------------

