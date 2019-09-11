---@class UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager : System.Object
---@field public mousePosition UnityEngine.Vector3 @static
local m = {}

---@static
---@param activeInputMethod UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.ActiveInputMethod
function m.SwitchActiveInputMethod(activeInputMethod) end

---@static
---@param name string
---@return boolean
function m.AxisExists(name) end

---@static
---@param name string
---@return boolean
function m.ButtonExists(name) end

---@static
---@param axis UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
function m.RegisterVirtualAxis(axis) end

---@static
---@param button UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualButton
function m.RegisterVirtualButton(button) end

---@static
---@param name string
function m.UnRegisterVirtualAxis(name) end

---@static
---@param name string
function m.UnRegisterVirtualButton(name) end

---@static
---@param name string
---@return UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
function m.VirtualAxisReference(name) end

---@static
---@param name string
---@return number
function m.GetAxis(name) end

---@static
---@param name string
---@return number
function m.GetAxisRaw(name) end

---@static
---@param name string
---@return boolean
function m.GetButton(name) end

---@static
---@param name string
---@return boolean
function m.GetButtonDown(name) end

---@static
---@param name string
---@return boolean
function m.GetButtonUp(name) end

---@static
---@param name string
function m.SetButtonDown(name) end

---@static
---@param name string
function m.SetButtonUp(name) end

---@static
---@param name string
function m.SetAxisPositive(name) end

---@static
---@param name string
function m.SetAxisNegative(name) end

---@static
---@param name string
function m.SetAxisZero(name) end

---@static
---@param name string
---@param value number
function m.SetAxis(name, value) end

---@static
---@param f number
function m.SetVirtualMousePositionX(f) end

---@static
---@param f number
function m.SetVirtualMousePositionY(f) end

---@static
---@param f number
function m.SetVirtualMousePositionZ(f) end

UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager = m
return m
