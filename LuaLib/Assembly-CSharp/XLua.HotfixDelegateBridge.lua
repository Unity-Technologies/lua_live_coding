---@class XLua.HotfixDelegateBridge : System.Object
local m = {}

---@static
---@param idx number
---@return boolean
function m.xlua_get_hotfix_flag(idx) end

---@static
---@param idx number
---@return XLua.DelegateBridge
function m.Get(idx) end

---@static
---@param idx number
---@param val XLua.DelegateBridge
function m.Set(idx, val) end

XLua.HotfixDelegateBridge = m
return m
