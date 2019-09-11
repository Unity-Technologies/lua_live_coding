---@class G6HotFix.Scripts.Core.AsyncSocketServer : G6HotFix.Scripts.Core.BaseAsyncSocket
---@field public isConnected boolean
local m = {}

---@virtual
---@param ipEndPoint System.Net.IPEndPoint
function m:Start(ipEndPoint) end

function m:Stop() end

---@virtual
---@param data string
function m:Send(data) end

G6HotFix.Scripts.Core.AsyncSocketServer = m
return m
