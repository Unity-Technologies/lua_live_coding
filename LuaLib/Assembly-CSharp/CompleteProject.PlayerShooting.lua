---@class CompleteProject.PlayerShooting : UnityEngine.MonoBehaviour
---@field public damagePerShot number
---@field public timeBetweenBullets number
---@field public range number
---@field public faceLight UnityEngine.Light
---@field public gunLine1 UnityEngine.LineRenderer
---@field public gunLine2 UnityEngine.LineRenderer
---@field public gunLine3 UnityEngine.LineRenderer
local m = {}

function m:DisableEffects() end

CompleteProject.PlayerShooting = m
return m
