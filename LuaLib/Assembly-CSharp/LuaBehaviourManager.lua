---@class LuaBehaviourManager : SingletonDontDestroy_1_LuaBehaviourManager_
local m = {}

function m:Init() end

---@param typename string
---@param obj UnityEngine.GameObject
function m:CreateBehaviour(typename, obj) end

---@param typename string
function m:CleanBehaviourCache(typename) end

---@param typename string
function m:ReloadBehaviour(typename) end

---@param instanceId number
---@return XLua.LuaTable
function m:GetLuaBehaviour(instanceId) end

LuaBehaviourManager = m
return m
