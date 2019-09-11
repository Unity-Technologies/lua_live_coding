---@class XLua.TypeExtensions : System.Object
local m = {}

---@static
---@param type System.Type
---@return boolean
function m.IsValueType(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsEnum(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsPrimitive(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsAbstract(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsSealed(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsInterface(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsClass(type) end

---@static
---@param type System.Type
---@return System.Type
function m.BaseType(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsGenericType(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsGenericTypeDefinition(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsNestedPublic(type) end

---@static
---@param type System.Type
---@return boolean
function m.IsPublic(type) end

---@static
---@param type System.Type
---@return string
function m.GetFriendlyName(type) end

XLua.TypeExtensions = m
return m
