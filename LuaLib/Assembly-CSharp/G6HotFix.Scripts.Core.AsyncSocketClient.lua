---@class G6HotFix.Scripts.Core.AsyncSocketClient : G6HotFix.Scripts.Core.BaseAsyncSocket
local m = {}

---@virtual
---@param ioEndPoint System.Net.IPEndPoint
function m:Start(ioEndPoint) end

---@virtual
---@param data string
function m:Send(data) end

G6HotFix.Scripts.Core.AsyncSocketClient = m
return m
