---@class ILuaBehaviourManager : table
local m = {}

---@abstract
---@param typename string
---@param obj UnityEngine.GameObject
function m:CreateBehaviour(typename, obj) end

---@abstract
---@param typename string
function m:CleanBehaviourCache(typename) end

---@abstract
---@param typename string
function m:ReloadBehaviour(typename) end

---@abstract
---@param id number
---@return XLua.LuaTable
function m:GetBehaviour(id) end

---@abstract
function m:Update() end

ILuaBehaviourManager = m
return m
