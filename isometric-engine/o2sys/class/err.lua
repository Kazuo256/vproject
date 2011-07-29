----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
-- O2Sys v0.1 by V-Project                                                                      ----
-- Fev/2011                                                                                     ----
-- o2sys/class/err.lua                                                                          ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--   Here are listed the error messages that may be produced by O2Sys.                          ----
--   They are stored in the 'err' table and returned to the caller of this chunk-file.          ----
--   Some error messages are actually functions that return the appropriate message depending   ----
-- on the given arguments. To avoid as much error-specific usage of the messages (that is,      ----
-- whether they are a string or a function returning a string) as possible, the interface for   ----
-- using this 'err' table is the following:                                                     ----
--                                                                                              ----
--  err(error_name [, args])                                                                    ----
--                                                                                              ----
-- where 'error_name' is the string indexing the correnponding error message in the 'err'       ----
-- table, and 'args' are the eventual arguments the error message demands.                      ----
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- This is the 'err' table containing the error messages.
local err = {}

----------------------------------------------------------------------------------------------------

-- Here are defined the error messages. Error are organized in a nesting fashion, and generally only
-- the more specific messages are used.

-- When a bad operation is executed upon an object.
err.BAD_OP = "Bad object operation."

-- BAD_OP sub-errors:

    -- When the object is malformed.
    MALFORMED_OBJ = err.BAD_OP.." ".."Malformed object."

    -- When an invalid access is performed on the object.
    err.INV_ACCESS = err.BAD_OP.." ".."Invalid member access: "

    -- INV_ACCESS sub-errors:

        -- When a non-string object was used as an index to an object member.
        err.INV_INDEX_TYPE = err.INV_ACCESS.."objects have only string-indexed members."

        -- When there is an attempt to change a value in a reserved index.
        function err.RESERVED_INDEX(index)
            return err.INV_ACCESS.."index "..index.." is reserved and cannot be changed."
        end

        -- When a requested attribute index is not found when attempting to set it a new value.
        function err.INDEX_NOT_FOUND(index)
            return err.INV_ACCESS.."could not find attribute "..index.."."
        end

        -- When there is a type mismatch between the attribute and its new intended value.
        function err.TYPE_MISMATCH(expected, received)
            return
                err.INV_ACCESS..
                "type mismatch, expected "..expected.." but got "..received.."."
        end

        -- When there is a class mismatch between the attribute and its new intended value.
        function err.CLASS_MISMATCH(expected, received)
            return
                err.INV_ACCESS..
                "class mismatch, expected instance of "..expected.." but got "..received.."."
        end

        -- When an unknown value type is used on a member attribution.
        function err.UNKNOWN_TYPE(member, unknown)
            return
                err.INV_ACCESS..
                "unknown type "..unknown.." cannot be assigned to member."
        end

        err.MALFORMED_VALUE = err.INV_ACCESS.."malformed object value cannot be assigned."

-- When a class definition error ocurrs.
err.CLASS_DEF = "Class definition error."

-- CLASS_DEF sub-errors:

    function err.BAD_INDEX_TYPE(t)
        return "Bad index type '"..t.."'."
    end

    function err.DOUBLE_DEF(member)
        return err.CLASS_DEF.." Duplicate definition of member '"..member"'"
    end

    err.DOUBLE_ATTRIB = err.CLASS_DEF.." Duplicate definition of the attribute table."

    err.DOUBLE_METHOD = err.CLASS_DEF.." Duplicate definition ot the method table."

    err.INV_METHOD = err.CLASS_DEF.." Invalid method: not a function."
    err.INV_ATTRIB = " Invalid attribute: "

    -- INV_ATTRIB sub-errors:

    function err.INV_MEMBER_TYPE(member_type)
        return
            err.CLASS_DEF.." Invalid member type '"..member_type"'.\n"..
            "Must be either 'class', 'string' or 'function'."
    end

    function err.UNKNOWN_ATTRIB(attrib)
        return
            err.CLASS_DEF.." Attribute '"..attrib..
            "'is neither a primitive type nor any registered class."
    end

-- When a class is not properly  registered.
function err.UNREGISTERED(some_class)
    local t = typeof(some_class)
    return "Unregistered class: "..
        (t == "class" and some_class.__name or (tostring(some_class).."(t)"))
end

-- When there is an attempt to alter a class structure table.
err.ALTER_CLASS = "A class structure table cannot be altered."

return err


