---@class XLua.LuaTable : XLua.LuaBase
---@field public Item any
---@field public Item any
---@field public Length number
local m = {}

---@overload fun(key:any):
---@overload fun(key:any):
---@overload fun(key:string):
---@param key any
---@return any
function m:Get(key) end

---@param key any
---@return boolean
function m:ContainsKey(key) end

---@param key any
---@param value any
function m:Set(key, value) end

---@param path string
---@return any
function m:GetInPath(path) end

---@param path string
---@param val any
function m:SetInPath(path, val) end

---@param action fun(arg1:any, arg2:any)
function m:ForEach(action) end

---@overload fun():
---@return System.Collections.IEnumerable
function m:GetKeys() end

---@param metaTable XLua.LuaTable
function m:SetMetaTable(metaTable) end

---@return any
function m:Cast() end

---@virtual
---@return string
function m:ToString() end

XLua.LuaTable = m
return m
