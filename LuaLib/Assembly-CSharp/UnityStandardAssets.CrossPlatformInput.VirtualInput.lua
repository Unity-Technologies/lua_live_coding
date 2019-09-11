---@class UnityStandardAssets.CrossPlatformInput.VirtualInput : System.Object
---@field public virtualMousePosition UnityEngine.Vector3
local m = {}

---@param name string
---@return boolean
function m:AxisExists(name) end

---@param name string
---@return boolean
function m:ButtonExists(name) end

---@param axis UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
function m:RegisterVirtualAxis(axis) end

---@param button UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualButton
function m:RegisterVirtualButton(button) end

---@param name string
function m:UnRegisterVirtualAxis(name) end

---@param name string
function m:UnRegisterVirtualButton(name) end

---@param name string
---@return UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
function m:VirtualAxisReference(name) end

---@param f number
function m:SetVirtualMousePositionX(f) end

---@param f number
function m:SetVirtualMousePositionY(f) end

---@param f number
function m:SetVirtualMousePositionZ(f) end

---@abstract
---@param name string
---@param raw boolean
---@return number
function m:GetAxis(name, raw) end

---@abstract
---@param name string
---@return boolean
function m:GetButton(name) end

---@abstract
---@param name string
---@return boolean
function m:GetButtonDown(name) end

---@abstract
---@param name string
---@return boolean
function m:GetButtonUp(name) end

---@abstract
---@param name string
function m:SetButtonDown(name) end

---@abstract
---@param name string
function m:SetButtonUp(name) end

---@abstract
---@param name string
function m:SetAxisPositive(name) end

---@abstract
---@param name string
function m:SetAxisNegative(name) end

---@abstract
---@param name string
function m:SetAxisZero(name) end

---@abstract
---@param name string
---@param value number
function m:SetAxis(name, value) end

---@abstract
---@return UnityEngine.Vector3
function m:MousePosition() end

UnityStandardAssets.CrossPlatformInput.VirtualInput = m
return m
