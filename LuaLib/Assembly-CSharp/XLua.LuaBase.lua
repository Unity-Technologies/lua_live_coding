---@class XLua.LuaBase : System.Object
local m = {}

---@overload fun(disposeManagedResources:boolean) @virtual
---@virtual
function m:Dispose() end

---@virtual
---@param o any
---@return boolean
function m:Equals(o) end

---@virtual
---@return number
function m:GetHashCode() end

XLua.LuaBase = m
return m
