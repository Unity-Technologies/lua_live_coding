---@class G6HotFix.LuaScripts.UpdateEventSystemDelegate : System.MulticastDelegate
local m = {}

---@virtual
---@param dt number
function m:Invoke(dt) end

---@virtual
---@param dt number
---@param callback fun(ar:System.IAsyncResult)
---@param object any
---@return System.IAsyncResult
function m:BeginInvoke(dt, callback, object) end

---@virtual
---@param result System.IAsyncResult
function m:EndInvoke(result) end

G6HotFix.LuaScripts.UpdateEventSystemDelegate = m
return m
