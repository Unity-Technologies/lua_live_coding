---@class XLua.LuaFunction : XLua.LuaBase
local m = {}

---@overload fun(a1:any, a2:any)
---@param a any
function m:Action(a) end

---@overload fun(a1:any, a2:any):
---@param a any
---@return any
function m:Func(a) end

---@overload fun(...:any|any[]):
---@overload fun():
---@param args any[]
---@param returnTypes System.Type[]
---@return any[]
function m:Call(args, returnTypes) end

---@return any
function m:Cast() end

---@param env XLua.LuaTable
function m:SetEnv(env) end

---@virtual
---@return string
function m:ToString() end

---@overload fun(eventname:string) @static
---@static
---@param eventname string
---@param ... any|any[]
function m.FireEvent(eventname, ...) end

XLua.LuaFunction = m
return m
