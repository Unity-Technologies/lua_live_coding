---@class UnityStandardAssets.CrossPlatformInput.CustomJoystick : UnityEngine.MonoBehaviour
---@field public maxMoveDistance number
---@field public horizontalAxisName string
---@field public verticalAxisName string
---@field public virtualAxisHorizontal UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
---@field public virtualAxisVertical UnityStandardAssets.CrossPlatformInput.CrossPlatformInputManager.VirtualAxis
local m = {}

---@virtual
---@param eventData UnityEngine.EventSystems.PointerEventData
function m:OnDrag(eventData) end

---@virtual
---@param eventData UnityEngine.EventSystems.PointerEventData
function m:OnPointerDown(eventData) end

---@virtual
---@param eventData UnityEngine.EventSystems.PointerEventData
function m:OnPointerUp(eventData) end

UnityStandardAssets.CrossPlatformInput.CustomJoystick = m
return m
