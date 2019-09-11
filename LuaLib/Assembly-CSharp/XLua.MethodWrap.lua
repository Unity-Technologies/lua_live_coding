---@class XLua.MethodWrap : System.Object
local m = {}

---@param L System.IntPtr
---@return number
function m:Call(L) end

XLua.MethodWrap = m
return m
