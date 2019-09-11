---@class UnityStandardAssets.CrossPlatformInput.AxisTouchButton : UnityEngine.MonoBehaviour
---@field public axisName string
---@field public axisValue number
---@field public responseSpeed number
---@field public returnToCentreSpeed number
local m = {}

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerDown(data) end

---@virtual
---@param data UnityEngine.EventSystems.PointerEventData
function m:OnPointerUp(data) end

UnityStandardAssets.CrossPlatformInput.AxisTouchButton = m
return m
