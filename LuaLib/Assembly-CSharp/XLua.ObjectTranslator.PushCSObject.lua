---@class XLua.ObjectTranslator.PushCSObject : System.MulticastDelegate
local m = {}

---@virtual
---@param L System.IntPtr
---@param obj any
function m:Invoke(L, obj) end

---@virtual
---@param L System.IntPtr
---@param obj any
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(L, obj, callback, object) end

---@virtual
---@param result System.IAsyncResult
function m:EndInvoke(result) end

XLua.ObjectTranslator.PushCSObject = m
return m
