---@class PlayerManager : System.Object
---@field public Instance PlayerManager @static
---@field public startingHealth number
---@field public currentHealth number
---@field public IsDead boolean
---@field public Damaged boolean
---@field public PlayerBehaviour CompleteProject.PlayerHealth
---@field public Player UnityEngine.GameObject
local m = {}

---@return UnityEngine.Bounds
function m:GetPlayerBounds() end

---@param player UnityEngine.GameObject
function m:SetPlayer(player) end

function m:InitHealth() end

---@param amount number
function m:TakeDamage(amount) end

function m:Quit() end

PlayerManager = m
return m
