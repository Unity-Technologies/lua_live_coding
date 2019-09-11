---@class XLua.ObjectCast : System.MulticastDelegate
local m = {}

---@virtual
---@param L System.IntPtr
---@param idx number
---@param target any
---@return any
function m:Invoke(L, idx, target) end

---@virtual
---@param L System.IntPtr
---@param idx number
---@param target any
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(L, idx, target, callback, object) end

---@virtual
---@param result System.IAsyncResult
---@return any
function m:EndInvoke(result) end

XLua.ObjectCast = m
return m
