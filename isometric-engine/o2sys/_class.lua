----------------------------------------------------------------------------------------------------
-- OsSys v1.4 by Wil                                                                            ----
-- Fev/2011                                                                                     ----
-- class.lua                                                                                     ----
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
--class = {

class = {}

seeall = function(t)
	class_mt = {}
	class_mt.__index = getfenv(0)
	setmetatable(t, class_mt)
end
--class_mt = {}
--class_mt.__index = getfenv(0)
--setmetatable(class, class_mt)

module("class", seeall)
--require("base")

    ----
    -- Private.
    -- Metatable for objects.
    ----
    meta_object = {

        -- Member access
        __index = function(obj, key)

            -- Valid object.
            if valid_object(obj) then

                -- Bad key type.
                if type(key) ~= "string" then
                    error("Bad object operation. Invalid member access.")
                end
                local obj_class = rawget(obj, "class")
                -- Request for class table.
                if key == "class" then
                    return obj_class
                -- Request for super class method.
                elseif key == "super" then
                    return obj_class.super.methods
                -- Normal member access.
                else
                    -- Method access.
                    local method = get_method(obj, key)
                    if method ~= nil then
                        return method
                    -- Attribute access.
                    else

                        -- Getter name.
                        local getter = "get_"..key
                        -- Access with getter.
                        if obj_class.methods[getter] ~= nil then
                            return obj_class.methods[getter](obj)
                        -- Access without getter.
                        else
                            return rawget(obj, key)
                        end

                    end

                end
            -- Invalid object.
            else
                error("Bad object operation. Malformed object.")
            end
        end,

        -- Member attribution
        __newindex = function(obj, key, value)

            -- Valid object.
            if valid_object(obj) then

                -- Bad key type.
                if type(key) ~= "string" then
                    error("Bad object operation. Invalid member attribution.")
                -- Trying to change class! Oh noes!
                elseif key == "class" then
                    error("Bad object operation. YOU MAY NOT CHANGE ITS CLASS.")
                -- Normal member attribution.
                else
                    -- The object's class.
                    local obj_class = rawget(obj, "class")
                    -- Method attribution -> invalid.
                    if get_method(obj, key) ~= nil then
                        error("Bad object operation. Tried to change method \""..key.."\".")
                    end
                    -- Look for attribute.
                    local attrib_type = get_attrib_type(obj, key)
                    -- Correct attribution.
                    if attrib_type ~= nil then
                        -- The attribute's type id.
                        local typeid = attrib_type.typeid
                        -- Attribution type match.
                        if value == nil or attrib_type == any or type(value) == typeid or
                           (valid_object(value) and value:is_instance(attrib_type)) then
                            -- Setter name.
                            local setter = "set_"..key
                            -- Attribution with setter.
                            if obj_class.methods[setter] ~= nil then
                                obj_class.methods[setter](obj, value)
                            -- Attribution without setter.
                            else
                                rawset(obj, key, value)
                            end
                        -- Attribution type does not match.
                        else
                            error("Bad object operation. Attribution type mismatch.")
                        end

                    -- Unknown member.
                    else
                        error("Bad object operation. Unknown attribute \""..key.."\".")
                    end

                end
            -- Invalid object.
            else
                error("Bad object operation. Malformed object.")
            end
        end,

        __add = function(obj1, obj2)
            local op = rawget(obj1, "class").methods.__add or rawget(obj2, "class").methods.__add
            return op(obj1, obj2)
        end,

        __sub = function(obj1, obj2)
            local op = rawget(obj1, "class").methods.__sub or rawget(obj2, "class").methods.__sub
            return op(obj1, obj2)
        end,

        __mul = function(obj1, obj2)
            local op = rawget(obj1, "class").methods.__mul or rawget(obj2, "class").methods.__mul
            return op(obj1, obj2)
        end,

    }

    ----
    -- Private.
    -- Metatable for classes.
    ----
    meta_class = {
        __call = function(class_table, ...)
            if valid_class(class_table) then

                local obj = {}
                local constructor = class_table.constructor

                obj.class = class_table
                setmetatable(obj, meta_object)
                if constructor ~= nil then
                    constructor(obj, ...)
                end

                return obj
            end
        end
    }

    ----
    -- Private.
    -- Gets an object method, returning nil in case it is not found.
    ----
    get_method = function(obj, method_name)
        local class_table = rawget(obj, "class")
        while class_table ~= nil do
            local method = class_table.methods[method_name]
            if method ~= nil then
                return method
            else
                class_table = class_table.super
            end
        end
        return nil
    end

    ----
    -- Private.
    -- Gets an object attribute type, returning nil in case it is not found.
    ----
    get_attrib_type = function(obj, attrib_name)
        local class_table = rawget(obj, "class")
        while class_table ~= nil do
            local attrib_type = class_table.attributes[attrib_name]
            if attrib_type ~= nil then
                return attrib_type
            else
                class_table = class_table.super
            end
        end
        return nil
    end

    ----
    -- Public.
    -- Checks for valid object
    ----
    valid_object = function(obj)
        return	type(obj) == "table"						-- valid type
            and	getmetatable(obj) == meta_object		-- valid metatable
            and rawget(obj, "class") ~= nil					-- has a class
            and	class[rawget(obj, "class").typeid] ~= nil	-- and it is a valid class
    end

    ----
    -- Public.
    -- Checks if an object is an instance of a class.
    ----
    is_instance = function(obj, class_table)
        if class_table == nil then return false end
        return	obj.class == class_table or is_instance(obj, class_table.super)
    end

    ----
    -- Public.
    -- Returns the super class method table.
    ----
    super = function(obj)
        return obj.class.super.methods
    end

    ----
    -- Public.
    -- Checks for valid class typeid
    ----
    valid_typeid = function(typeid)
        return type(typeid) == "string" and class[typeid] ~= nil
    end

    ----
    -- Public.
    -- Checks for a valid class.
    ----
    valid_class = function(class_table)
        return type(class_table) == "table" and valid_typeid(class_table.typeid)
    end

    ----
    -- Private.
    -- Throws a class definition error.
    ----
    definition_error = function(typeid, text)
        error("Class "..((typeid.." ") or "").."definition error. "..text)
    end

    ----
    -- Class-only.
    -- Defines a new class with the typeid and member table passed.
    ----
    define = function(typeid, class_table)
        -- First, we check if the class is correctly constructed.
        -- Check class typeid.
        if _G.type(typeid) ~= "string" or typeid == "" then
            definition_error(nil, "Bad type id argument.")
        end
        -- Check class table type.
        if type(class_table) ~= "table" then
            definition_error(typeid, "Bad class table argument.")
        end
        -- Check class attribute table.
        if type(class_table.attributes) ~= "table" then
            definition_error(typeid, "No attribute table.")
        end
        -- Check attributes definitions.
        for k, v in pairs(class_table.attributes) do
            -- Check attribute name.
            if type(k) ~= "string" or k == "" or k == "class" then
                definition_error(typeid, "Invalid attribute name.")
            end
            -- Check valid attribute type.
            if type(v) ~= "table" or type(v.typeid) ~= "string" then
                definition_error(typeid, "Invalid attribute type for "..k)
            end
            -- Check if attribute type id exists.
            if class[v.typeid] == nil then
                definition_error(typeid, "Unknown attribute type for "..k..": "..v)
            end
        end
        -- Check methods definitions.
        for k, v in pairs(class_table.methods) do
            -- Check method name.
            if type(k) ~= "string" or k == "" or k == "class" then
                definition_error(typeid, "Invalid method name.")
            end
            -- Check valid method type.
            if type(v) ~= "function" then
                definition_error("Method "..k.." is not a function.")
            end
        end

        -- Everything is supposedly ok.
        -- Let's do it.

        -- Give it the type id.
        class_table.typeid = typeid
        -- Prepare the constructor, even if it is not defined.
        class_table.constructor = class_table.methods[typeid]
        -- Adds a little method to help.
        class_table.methods.is_instance = is_instance
        -- Set the class metatable.
        setmetatable(class_table, meta_class)
        -- Add it to the list of classes.
        rawset(class, typeid, class_table)
        -- Done.

    end

    ----
    -- Private.
    -- Definies a Lua primitive type. Used only here and in nowhere else.
    ----
    define_primitive = function(typeid)
        define(typeid, {
            attributes = {},
            methods = {}
        })
    end


--}

-- Defining primitives. The any is for any-type attribute, following Lua's
-- light-weight typage (dunno if such word exists).
define_primitive("number")
define_primitive("string")
define_primitive("function")
define_primitive("table")
define_primitive("userdata")
define_primitive("any")

-- Global reference to make coding easier.
--class_mt.__index.super = super
getmetatable(class).__index.super = super

-- Register this module.
--module("class")
