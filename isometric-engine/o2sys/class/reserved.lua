----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- O2Sys v0.1 by V-Project                                                                      ----
-- Fev/2011                                                                                     ----
-- o2sys/class/reserved.lua                                                                     ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--   Here are defined the reserved (meta or not) indexes of an object.                          ----
--   There are 'true' values indexed by the reserved indexes in the 'reserved' table, which is  ----
-- returned to the caller of this chunk-file.
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- This is the table that will tell whether a string is a reserved index or not.
local reserved = {}

----------------------------------------------------------------------------------------------------

-- The reserved indexes receive 'true' values, and any other will be 'nil'.
reserved.__index = true
reserved.__newindex = true
reserved.__type = true
reserved.__class = true
reserved.__name = true

----------------------------------------------------------------------------------------------------

-- Return the 'reserved' table containing 'true' values in the reserved indexes.
return reserved

----------------------------------------------------------------------------------------------------

