---@class XLua.InternalGlobals.TryArraySet : System.MulticastDelegate
local m = {}

---@virtual
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param obj any
---@param array_idx number
---@param obj_idx number
---@return boolean
function m:Invoke(type, L, translator, obj, array_idx, obj_idx) end

---@virtual
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param obj any
---@param array_idx number
---@param obj_idx number
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(type, L, translator, obj, array_idx, obj_idx, callback, object) end

---@virtual
---@param result System.IAsyncResult
---@return boolean
function m:EndInvoke(result) end

XLua.InternalGlobals.TryArraySet = m
return m
