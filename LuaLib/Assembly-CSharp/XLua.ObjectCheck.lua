---@class XLua.ObjectCheck : System.MulticastDelegate
local m = {}

---@virtual
---@param L System.IntPtr
---@param idx number
---@return boolean
function m:Invoke(L, idx) end

---@virtual
---@param L System.IntPtr
---@param idx number
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(L, idx, callback, object) end

---@virtual
---@param result System.IAsyncResult
---@return boolean
function m:EndInvoke(result) end

XLua.ObjectCheck = m
return m
