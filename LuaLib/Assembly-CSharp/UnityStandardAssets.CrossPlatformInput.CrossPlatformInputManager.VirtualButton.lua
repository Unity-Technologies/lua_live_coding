---@class UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualButton : System.Object
---@field public name string
---@field public matchWithInputManager boolean
---@field public GetButton boolean
---@field public GetButtonDown boolean
---@field public GetButtonUp boolean
local m = {}

function m:Pressed() end

function m:Released() end

function m:Remove() end

UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualButton = m
return m
