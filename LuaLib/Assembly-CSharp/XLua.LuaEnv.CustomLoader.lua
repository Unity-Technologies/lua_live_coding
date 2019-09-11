---@class XLua.LuaEnv.CustomLoader : System.MulticastDelegate
local m = {}

---@virtual
---@param filepath System.String
---@return string, System.String
function m:Invoke(filepath) end

---@virtual
---@param filepath System.String
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult, System.String
function m:BeginInvoke(filepath, callback, object) end

---@virtual
---@param filepath System.String
---@param result System.IAsyncResult
---@return string, System.String
function m:EndInvoke(filepath, result) end

XLua.LuaEnv.CustomLoader = m
return m
