---@class G6HotFix.Scripts.Core.SocketStateObject : System.Object
---@field public BufferSize number @static
---@field public workSocket System.Net.Sockets.Socket
---@field public sendBuffer string
---@field public buffer string
local m = {}

function m:Dispose() end

G6HotFix.Scripts.Core.SocketStateObject = m
return m
