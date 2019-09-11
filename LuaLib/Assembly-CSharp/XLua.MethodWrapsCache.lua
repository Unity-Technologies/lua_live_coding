---@class XLua.MethodWrapsCache : System.Object
local m = {}

---@param type System.Type
---@return fun(L:System.IntPtr):
function m:GetConstructorWrap(type) end

---@param type System.Type
---@param methodName string
---@return fun(L:System.IntPtr):
function m:GetMethodWrap(type, methodName) end

---@param type System.Type
---@param methodName string
---@return fun(L:System.IntPtr):
function m:GetMethodWrapInCache(type, methodName) end

---@param type System.Type
---@return fun(L:System.IntPtr):
function m:GetDelegateWrap(type) end

---@param type System.Type
---@param eventName string
---@return fun(L:System.IntPtr):
function m:GetEventWrap(type, eventName) end

---@overload fun(type:System.Type, methodName:string, methodBases:System.Collections.Generic.IEnumerable_1_System_Reflection_MemberInfo_):
---@param type System.Type
---@param methodName string
---@param methodBases System.Collections.Generic.IEnumerable_1_System_Reflection_MemberInfo_
---@param forceCheck boolean
---@return XLua.MethodWrap
function m:_GenMethodWrap(type, methodName, methodBases, forceCheck) end

XLua.MethodWrapsCache = m
return m
