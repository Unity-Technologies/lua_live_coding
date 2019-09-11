---@class UnityStandardAssets.CrossPlatformInput.Joystick : UnityEngine.MonoBehaviour
---@field public MovementRange number
---@field public axesToUse UnityStandardAssets.CrossPlatformInput.Joystick.AxisOption
---@field public horizontalAxisName string
---@field public verticalAxisName string
local m = {}

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnDrag(data) end

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerUp(data) end

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerDown(data) end

UnityStandardAssets.CrossPlatformInput.Joystick = m
return m
