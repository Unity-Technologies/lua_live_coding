---@class XLua.LuaDLL.lua_CSFunction : System.MulticastDelegate
local m = {}

---@virtual
---@param L System.IntPtr
---@return number
function m:Invoke(L) end

---@virtual
---@param L System.IntPtr
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(L, callback, object) end

---@virtual
---@param result System.IAsyncResult
---@return number
function m:EndInvoke(result) end

XLua.LuaDLL.lua_CSFunction = m
return m
