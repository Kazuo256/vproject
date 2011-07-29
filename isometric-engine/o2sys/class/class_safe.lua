----------------------------------------------------------------------------------------------------
-- O2Sys v1.4 by Wil                                                                            ----
-- Fev/2011                                                                                     ----
-- class/class_safe.lua                                                                         ----
----------------------------------------------------------------------------------------------------

-- Safe version assumes the user WILL NOT EVER use these functions on any of the O2Sys-related
-- variables:
--
-- rawget
-- rawset
-- setmetatable
-- getmetatable
--
-- If the user deliberatly abuse them, there is no guarantee that the system will work.

local DIR = "o2sys/class/"

----------------------------------------------------------------------------------------------------
-- PRIVATE.
-- Tables for inner use.
----

local reserved = dofile(DIR.."reserved.lua")

local primitive = dofile(DIR.."primitive.lua")

local binary_ops, unary_ops, multiple_ops = dofile(DIR.."operator.lua")

local err = dofile(DIR.."err.lua")

local registered = {}

----------------------------------------------------------------------------------------------------
-- PRIVATE.
-- Handful functions for inner use.
----

local function raw_type(value)
    return rawget(value, "__type")
end

local function raw_class(obj)
    return rawget(obj, "__class")
end

local function type_match(expected, received)
    return expected == "any" or received == "nil" or expected == received
end

-- Gets an object method, returning nil in case it is not found.
local function get_method(obj, method_name)
    local obj_class = registered[obj] or raw_class(obj)
    while obj_class ~= nil do
        local method = obj_class.methods[method_name]
        if method ~= nil then
            return method
        else
            obj_class = obj_class.super
        end
    end
    return nil
end

-- Gets an object attribute type, returning nil in case it is not found.
local function get_attrib(obj, attrib_name)
    local obj_class = registered[obj] or raw_class(obj)
    while obj_class ~= nil do
        local attrib_type = obj_class.attributes[attrib_name]
        if attrib_type ~= nil then
            return attrib_type
        else
            obj_class = obj_class.super
        end
    end
    return nil
end

----------------------------------------------------------------------------------------------------
-- PUBLIC.
-- Handful functions to manage objects.
----

-- Returns the type of a variable, be it a normal lua type or an an object class.
function typeof(value)
    local t = type(value)
    return t == "table" and raw_type(value) or t
end

-- Checks for a valid object.
function isobject(obj)
    return typeof(obj) == "object" and class[raw_class(obj)]
end

-- Returns the class of an object.
function getclass(obj)
    return isobject(obj) and raw_class(obj) or nil
end

-- Checks if child_class inherits mother_class.
function inherits(child_class, mother_class)
    local child, mother = registered[child_class], registered[mother_class]
    if child and mother then
        return child == mother
            or inherits(child.super, mother)
    end
end

-- Checks if an object is an instance of a class.
function instanceof(obj, some_class)
    return inherits(getclass(obj), some_class)
end

-- Checks for a valid class.
function isclass(some_class)
    return registered[some_class]
end

-- Returns the super class table.
function super(obj)
    return getclass(obj).super
end

----------------------------------------------------------------------------------------------------
-- PRIVATE.
-- Metatable for objects.
----

local object_mttab = {}

-- Member access.
function object_mttab:__index(key)

    -- Valid object.
    assert(valid_object(self), err.MALFORMED_OBJ)

    -- Valid key type.
    assert(type(key) == string, err.INV_INDEX_TYPE)

    -- The possible getter for the member.
    local getter = get_method(self, "get_"..key)

    -- If there is a getter, use it.
    if getter then return getter(self) end

    -- Otherwise, directly get the member, be it a method or an attribute.
    return get_method(self, key) or rawget(self, key)

end

-- Member attribution.
function object_mttab:__newindex(key, value)

    -- Valid object.
    assert(valid_object(self), err.MALFORMED_OBJ)

    -- Valid key type.
    assert(type(key) == string, err.INV_INDEX_TYPE)

    -- Key is not a reserved index.
    assert(not reserved[key], err.RESERVED_INDEX(key))

    -- The object's class.
    local obj_class = raw_class(self)

    -- The possible setter for the member.
    local setter = get_method(self, "set_"..key)

    -- If there is a setter, use it.
    if setter then return setter(self, key, value) end

    -- Otherwise, look for attribute itself.
    local attrib = get_attrib(self, key)

    -- Attribute exists.
    assert(attrib, err.INDEX_NOT_FOUND(key))

    -- Attribute and value types.
    local attrib_type = typeof(attrib)
    local value_type = typeof(value)

    -- If the attribute is a primitive type, check if such type matches the value's type.
    if primitive[attrib_type] then
        -- Attribute's and value's primitive types match.
        assert(type_match(attrib_type, value_type), err.TYPE_MISMATCH(attrib_type, value_type))
    -- Else, if the value is not nil, it must be an adequated object.
    elseif value_type ~= "nil" then
        -- Value is of type object.
        assert(value_type == "object", err.UNKNOWN_TYPE(value_type))
        -- As an object, we acquire its class.
        local value_class = raw_class(value)
        -- Such class is registered, and thus the value is an valid object.
        assert(registered[value_class], err.MALFORMED_VALUE)
        -- The value received is an instance of the attribute's class.
        assert(value:is_instance(attrib), err.CLASS_MISMATCH(attrib.__name, value_class.__name))
    end

    -- Everything ok until here, apply attribution.
    rawset(self, key, value)

end

-- Binary operators.
for i, op_name in ipairs(binary_ops) do
    object_mttab[op_name] = function(obj1, obj2)
        local op =
            raw_class(obj1).methods[op_name] or raw_class(obj2).methods[op_name]
        return op(obj1, obj2)
    end
end

-- Unary operators.
for i, op_name in ipairs(unary_ops) do
    object_mttab[op_name] = function(obj)
        local op = raw_class(obj).methods[op_name]
        return op(obj)
    end
end

-- Multiple operators (aka __call).
for i, op_name in ipairs(multiple_ops) do
    object_mttab[op_name] = function(obj, ...)
        local op = raw_class(obj).methods[op_name]
        return op(obj, ...)
    end
end

----------------------------------------------------------------------------------------------------
-- Private.
-- Metatable for class.
----

local clstruct_mttab = {}

function clstruct_mttab:__newindex(index, value)
    local idx_t = type(index)
    assert(idx_t == "string", err.BAD_INDEX_TYPE(idx_t))
    assert(not self[index], err.DOUBLE_DEF)
    local t = typeof(value)
    if t == "table" then
        if index == "attrib" then
            assert(not self[index], err.DOUBLE_ATTRIB)
            for k, v in pairs(value) do
                idx_t = type(k)
                assert(idx_t == "string", err.BAD_INDEX_TYPE(idx_t))
                assert(primitive[v] or registered[v] or v == "any", err.UNKNOWN_ATTRIB)
            end
            return
        elseif index == "method" then
            assert(not self[index], err.DOUBLE_METHOD)
            for k, v in pairs(value) do
                idx_t = type(k)
                assert(idx_t == "string", err.BAD_INDEX_TYPE(idx_t))
                assert(type(v) == "function", err.INV_METHOD)
            end
            return
        end
        error(err.INV_MEMBER_TYPE)
    end
    assert(t == "string" or t == "class" or t == "function", err.INV_MEMBER_TYPE)
    if t == "function" then
        self.method[index] = value
    else
        assert(primitive[value] or registered[value] or value == "any", err.UNKNOW_ATTRIB)
        self.attrib[index] = value
    end
end

local class_mttab = {}

function class_mttab:__call(...)
    local obj = {}
    local constructor = self.constructor
    rawset(obj, "__class", self)
    setmetatable(obj, object_mttab)
    if constructor then
        constructor(obj, ...)
    end
    return obj
end

function class_mttab:__index(index)
    return get_method(self, index) or get_attrib(self, index)
end

function class_mttab:__newindex(index, value)
    error(err.ALTER_CLASS)
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
        if type(typeid) ~= "string" or typeid == "" then
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
        class_table.methods.is_instance = class.is_instance
        -- Set the class metatable.
        setmetatable(class_table, class.class_mttab)
        -- Add it to the list of classes.
        rawset(class, typeid, class_table)
        -- Done.

    end

    --[[
    ----
    -- Private.
    -- Definies a Lua primitive type. Used only here and in nowhere else.
    ----
    define_primitive = function(typeid)
        class.define(typeid, {
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
class_mt.__index.super = class.super
]]
-- Register this module.
--module("class")

