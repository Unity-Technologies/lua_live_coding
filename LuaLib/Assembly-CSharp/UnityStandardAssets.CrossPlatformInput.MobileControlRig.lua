---@class UnityStandardAssets.CrossPlatformInput.MobileControlRig : UnityEngine.MonoBehaviour
---@field public callbackOrder number
local m = {}

---@virtual
---@param previousTarget UnityEditor.BuildTarget
---@param newTarget UnityEditor.BuildTarget
function m:OnActiveBuildTargetChanged(previousTarget, newTarget) end

UnityStandardAssets.CrossPlatformInput.MobileControlRig = m
return m
