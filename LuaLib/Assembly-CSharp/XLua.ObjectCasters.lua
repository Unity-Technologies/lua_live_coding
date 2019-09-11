---@class XLua.ObjectCasters : System.Object
local m = {}

---@param type System.Type
---@param oc fun(L:System.IntPtr, idx:number, target:any):
function m:AddCaster(type, oc) end

---@param type System.Type
---@return fun(L:System.IntPtr, idx:number, target:any):
function m:GetCaster(type) end

XLua.ObjectCasters = m
return m
