---@class CompleteProject.PlayerHealth : UnityEngine.MonoBehaviour
---@field public healthSlider UnityEngine.UI.Slider
---@field public damageImage UnityEngine.UI.Image
---@field public deathClip UnityEngine.AudioClip
---@field public flashSpeed number
---@field public flashColour UnityEngine.Color
local m = {}

function m:TakeDamage() end

function m:Death() end

function m:RestartLevel() end

CompleteProject.PlayerHealth = m
return m
