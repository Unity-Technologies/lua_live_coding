---@class XLua.ReferenceEqualsComparer : System.Object
local m = {}

---@virtual
---@param o1 any
---@param o2 any
---@return boolean
function m:Equals(o1, o2) end

---@virtual
---@param obj any
---@return number
function m:GetHashCode(obj) end

XLua.ReferenceEqualsComparer = m
return m
