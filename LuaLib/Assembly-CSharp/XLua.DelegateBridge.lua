---@class XLua.DelegateBridge : XLua.DelegateBridgeBase
---@field public Gen_Flag boolean @static
local m = {}

---@param L System.IntPtr
---@param nArgs number
---@param nResults number
---@param errFunc number
function m:PCall(L, nArgs, nResults, errFunc) end

---@overload fun(p1:any)
---@overload fun(p1:any, p2:any)
---@overload fun(p1:any, p2:any, p3:any)
---@overload fun(p1:any, p2:any, p3:any, p4:any)
function m:Action() end

---@overload fun(p1:any):
---@overload fun(p1:any, p2:any):
---@overload fun(p1:any, p2:any, p3:any):
---@overload fun(p1:any, p2:any, p3:any, p4:any):
---@return any
function m:Func() end

XLua.DelegateBridge = m
return m
