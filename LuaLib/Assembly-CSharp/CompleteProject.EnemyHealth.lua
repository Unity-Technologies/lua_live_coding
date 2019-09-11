---@class CompleteProject.EnemyHealth : UnityEngine.MonoBehaviour
---@field public startingHealth number
---@field public currentHealth number
---@field public sinkSpeed number
---@field public scoreValue number
---@field public deathClip UnityEngine.AudioClip
local m = {}

---@param amount number
---@param hitPoint UnityEngine.Vector3
function m:TakeDamage(amount, hitPoint) end

function m:StartSinking() end

CompleteProject.EnemyHealth = m
return m
