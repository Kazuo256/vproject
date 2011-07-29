----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- O2Sys v0.1 by V-Project                                                                      ----
-- Fev/2011                                                                                     ----
-- o2sys/class/operator.lua                                                                     ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--   Here are listed the operator function names that are present on metatables.                ----
--   These lists are returned to the caller of this chunk-file so that they can be used to      ----
-- iterate through a metatable filling it with generic simply made functions in the appropriate ----
-- operators.                                                                                   ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- Binary operator function names that are present on a metatable.
local binary_ops = {

    "__add",
    "__sub",
    "__mul",
    "__div",
    "__mod",
    "__pow",
    "__concat",
    "__eq",
    "__lt",
    "__le"
    
}

----------------------------------------------------------------------------------------------------

-- Unary operator function names that are present on a metatable.
local unary_ops = {

    "__unm",
    "__len"
    
}

----------------------------------------------------------------------------------------------------

-- Multiple operator function names that are present on a metatable.
local multiple_ops = {

    "__call"
    
}

----------------------------------------------------------------------------------------------------

-- Return the operator function names lists.
return binary_ops, unary_ops, multiple_ops


----------------------------------------------------------------------------------------------------


