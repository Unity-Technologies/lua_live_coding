---@class XLua.StaticLuaCallbacks : System.Object
local m = {}

---@static
---@param L System.IntPtr
---@return number
function m.EnumAnd(L) end

---@static
---@param L System.IntPtr
---@return number
function m.EnumOr(L) end

---@static
---@param L System.IntPtr
---@return number
function m.DelegateCall(L) end

---@static
---@param L System.IntPtr
---@return number
function m.LuaGC(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ToString(L) end

---@static
---@param L System.IntPtr
---@return number
function m.DelegateCombine(L) end

---@static
---@param L System.IntPtr
---@return number
function m.DelegateRemove(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ArrayIndexer(L) end

---@static
---@param type System.Type
---@param L System.IntPtr
---@param obj any
---@param array_idx number
---@param obj_idx number
---@return boolean
function m.TryPrimitiveArraySet(type, L, obj, array_idx, obj_idx) end

---@static
---@param L System.IntPtr
---@return number
function m.ArrayNewIndexer(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ArrayLength(L) end

---@static
---@param L System.IntPtr
---@return number
function m.MetaFuncIndex(L) end

---@static
---@param L System.IntPtr
---@return number
function m.LoadAssembly(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ImportType(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ImportGenericType(L) end

---@static
---@param L System.IntPtr
---@return number
function m.Cast(L) end

---@static
---@param L System.IntPtr
---@return number
function m.XLuaAccess(L) end

---@static
---@param L System.IntPtr
---@return number
function m.XLuaPrivateAccessible(L) end

---@static
---@param L System.IntPtr
---@return number
function m.XLuaMetatableOperation(L) end

---@static
---@param L System.IntPtr
---@return number
function m.DelegateConstructor(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ToFunction(L) end

---@static
---@param L System.IntPtr
---@return number
function m.GenericMethodWraper(L) end

---@static
---@param L System.IntPtr
---@return number
function m.GetGenericMethod(L) end

---@static
---@param L System.IntPtr
---@return number
function m.ReleaseCsObject(L) end

XLua.StaticLuaCallbacks = m
return m
