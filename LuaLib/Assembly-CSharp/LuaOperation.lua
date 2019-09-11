---@class LuaOperation : UnityEngine.MonoBehaviour
---@field public classPath string
local m = {}

---@param value fun()
function m:add_AwakeEvent(value) end

---@param value fun()
function m:remove_AwakeEvent(value) end

---@param value fun()
function m:add_StartEvent(value) end

---@param value fun()
function m:remove_StartEvent(value) end

---@param value fun()
function m:add_EnableEvent(value) end

---@param value fun()
function m:remove_EnableEvent(value) end

---@param value fun()
function m:add_DisableEvent(value) end

---@param value fun()
function m:remove_DisableEvent(value) end

---@param value fun()
function m:add_DestroyEvent(value) end

---@param value fun()
function m:remove_DestroyEvent(value) end

---@param value fun()
function m:add_UpdateEvent(value) end

---@param value fun()
function m:remove_UpdateEvent(value) end

---@param value fun()
function m:add_FixedUpdateEvent(value) end

---@param value fun()
function m:remove_FixedUpdateEvent(value) end

function m:AwakeByBehaviour() end

---@param to_yield any
---@param callback fun()
function m:YieldAndCallback(to_yield, callback) end

---@param to_yield any
function m:StopYield(to_yield) end

LuaOperation = m
return m
