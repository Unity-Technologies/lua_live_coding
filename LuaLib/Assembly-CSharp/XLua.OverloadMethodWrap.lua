---@class XLua.OverloadMethodWrap : System.Object
---@field public HasDefalutValue boolean
local m = {}

---@param objCheckers XLua.ObjectCheckers
---@param objCasters XLua.ObjectCasters
function m:Init(objCheckers, objCasters) end

---@param L System.IntPtr
---@return boolean
function m:Check(L) end

---@param L System.IntPtr
---@return number
function m:Call(L) end

XLua.OverloadMethodWrap = m
return m
