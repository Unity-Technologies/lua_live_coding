---@class XLua.DelegateBridgeBase : XLua.LuaBase
local m = {}

---@param key System.Type
---@return boolean, System.Delegate
function m:TryGetDelegate(key) end

---@param key System.Type
---@param value fun(...:any|any[]):
function m:AddDelegate(key, value) end

---@virtual
---@param type System.Type
---@return fun(...:any|any[]):
function m:GetDelegateByType(type) end

XLua.DelegateBridgeBase = m
return m
