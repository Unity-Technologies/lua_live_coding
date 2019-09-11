---@class XLua.ObjectCheckers : System.Object
local m = {}

---@param oc fun(L:System.IntPtr, idx:number):
---@return fun(L:System.IntPtr, idx:number):
function m:genNullableChecker(oc) end

---@param type System.Type
---@return fun(L:System.IntPtr, idx:number):
function m:GetChecker(type) end

XLua.ObjectCheckers = m
return m
