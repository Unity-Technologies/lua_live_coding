---@class XLua.CodeEmit : System.Object
local m = {}

---@param groups System.Collections.Generic.IEnumerable_1_System_Linq_IGrouping_2_System_Reflection_MethodInfo_System_Type__
---@return System.Type
function m:EmitDelegateImpl(groups) end

---@param gen_interfaces System.Type[]
function m:SetGenInterfaces(gen_interfaces) end

---@param to_be_impl System.Type
---@return System.Type
function m:EmitInterfaceImpl(to_be_impl) end

---@param typeBuilder System.Reflection.Emit.TypeBuilder
---@param field System.Reflection.FieldInfo
---@param genGetter boolean
---@return System.Reflection.Emit.MethodBuilder
function m:emitFieldWrap(typeBuilder, field, genGetter) end

---@param typeBuilder System.Reflection.Emit.TypeBuilder
---@param prop System.Reflection.PropertyInfo
---@param op System.Reflection.MethodInfo
---@param genGetter boolean
---@return System.Reflection.Emit.MethodBuilder
function m:emitPropertyWrap(typeBuilder, prop, op, genGetter) end

---@param toBeWrap System.Type
---@return System.Type
function m:EmitTypeWrap(toBeWrap) end

XLua.CodeEmit = m
return m
