---@class UnityStandardAssets.CrossPlatformInput.PlatformSpecific.MobileInput : UnityStandardAssets.CrossPlatformInput.VirtualInput
local m = {}

---@virtual
---@param name string
---@param raw boolean
---@return number
function m:GetAxis(name, raw) end

---@virtual
---@param name string
function m:SetButtonDown(name) end

---@virtual
---@param name string
function m:SetButtonUp(name) end

---@virtual
---@param name string
function m:SetAxisPositive(name) end

---@virtual
---@param name string
function m:SetAxisNegative(name) end

---@virtual
---@param name string
function m:SetAxisZero(name) end

---@virtual
---@param name string
---@param value number
function m:SetAxis(name, value) end

---@virtual
---@param name string
---@return boolean
function m:GetButtonDown(name) end

---@virtual
---@param name string
---@return boolean
function m:GetButtonUp(name) end

---@virtual
---@param name string
---@return boolean
function m:GetButton(name) end

---@virtual
---@return UnityEngine.Vector3
function m:MousePosition() end

UnityStandardAssets.CrossPlatformInput.PlatformSpecific.MobileInput = m
return m
