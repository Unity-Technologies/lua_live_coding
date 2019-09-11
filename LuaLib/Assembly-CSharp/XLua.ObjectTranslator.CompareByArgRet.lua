---@class XLua.ObjectTranslator.CompareByArgRet : System.Object
local m = {}

---@virtual
---@param x System.Reflection.MethodInfo
---@param y System.Reflection.MethodInfo
---@return boolean
function m:Equals(x, y) end

---@virtual
---@param method System.Reflection.MethodInfo
---@return number
function m:GetHashCode(method) end

XLua.ObjectTranslator.CompareByArgRet = m
return m
