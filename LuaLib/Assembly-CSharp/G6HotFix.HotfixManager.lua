---@class G6HotFix.HotfixManager : System.Object
---@field public Instance G6HotFix.HotfixManager @static
---@field public ipPort number
local m = {}

---@return G6HotFix.Scripts.Core.AsyncSocketClient
function m:GetSocketClient() end

function m:StartConnectSocketServer() end

function m:Update() end

G6HotFix.HotfixManager = m
return m
