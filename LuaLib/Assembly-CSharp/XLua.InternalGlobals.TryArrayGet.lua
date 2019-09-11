---@class XLua.InternalGlobals.TryArrayGet : System.MulticastDelegate
local m = {}

---@virtual
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param obj any
---@param index number
---@return boolean
function m:Invoke(type, L, translator, obj, index) end

---@virtual
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param obj any
---@param index number
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(type, L, translator, obj, index, callback, object) end

---@virtual
---@param result System.IAsyncResult
---@return boolean
function m:EndInvoke(result) end

XLua.InternalGlobals.TryArrayGet = m
return m
