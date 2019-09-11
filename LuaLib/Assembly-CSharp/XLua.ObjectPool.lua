---@class XLua.ObjectPool : System.Object
---@field public Item any
local m = {}

function m:Clear() end

---@param obj any
---@return number
function m:Add(obj) end

---@param index number
---@return boolean, System.Object
function m:TryGetValue(index) end

---@param index number
---@return any
function m:Get(index) end

---@param index number
---@return any
function m:Remove(index) end

---@param index number
---@param o any
---@return any
function m:Replace(index, o) end

---@param check_pos number
---@param max_check number
---@param checker fun(arg:any):
---@param reverse_map table<any, number>
---@return number
function m:Check(check_pos, max_check, checker, reverse_map) end

XLua.ObjectPool = m
return m
