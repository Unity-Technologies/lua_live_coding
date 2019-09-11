---@class UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis : System.Object
---@field public name string
---@field public matchWithInputManager boolean
---@field public GetValue number
---@field public GetValueRaw number
local m = {}

function m:Remove() end

---@param value number
function m:Update(value) end

UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis = m
return m
