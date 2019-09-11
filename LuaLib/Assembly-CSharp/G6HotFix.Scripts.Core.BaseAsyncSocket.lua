---@class G6HotFix.Scripts.Core.BaseAsyncSocket : System.Object
local m = {}

---@return string
function m:PopResponse() end

---@virtual
---@param ipEndPoint System.Net.IPEndPoint
function m:Start(ipEndPoint) end

---@virtual
---@param data string
function m:Send(data) end

G6HotFix.Scripts.Core.BaseAsyncSocket = m
return m
