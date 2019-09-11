---@class UnityStandardAssets.CrossPlatformInput.TouchPad : UnityEngine.MonoBehaviour
---@field public axesToUse UnityStandardAssets.CrossPlatformInput.TouchPad.AxisOption
---@field public controlStyle UnityStandardAssets.CrossPlatformInput.TouchPad.ControlStyle
---@field public horizontalAxisName string
---@field public verticalAxisName string
---@field public Xsensitivity number
---@field public Ysensitivity number
local m = {}

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerDown(data) end

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerUp(data) end

UnityStandardAssets.CrossPlatformInput.TouchPad = m
return m
