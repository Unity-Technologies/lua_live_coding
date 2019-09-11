---@class XLua.ObjectTranslator.UpdateCSObject : System.MulticastDelegate
local m = {}

---@virtual
---@param L System.IntPtr
---@param idx number
---@param obj any
function m:Invoke(L, idx, obj) end

---@virtual
---@param L System.IntPtr
---@param idx number
---@param obj any
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(L, idx, obj, callback, object) end

---@virtual
---@param result System.IAsyncResult
function m:EndInvoke(result) end

XLua.ObjectTranslator.UpdateCSObject = m
return m
