---@class XLua.Utils : System.Object
---@field public OBJ_META_IDX number @static
---@field public METHOD_IDX number @static
---@field public GETTER_IDX number @static
---@field public SETTER_IDX number @static
---@field public CLS_IDX number @static
---@field public CLS_META_IDX number @static
---@field public CLS_GETTER_IDX number @static
---@field public CLS_SETTER_IDX number @static
---@field public LuaIndexsFieldName string @static
---@field public LuaNewIndexsFieldName string @static
---@field public LuaClassIndexsFieldName string @static
---@field public LuaClassNewIndexsFieldName string @static
local m = {}

---@static
---@param L System.IntPtr
---@param idx number
---@param field_name string
---@return boolean
function m.LoadField(L, idx, field_name) end

---@static
---@param L System.IntPtr
---@return System.IntPtr
function m.GetMainState(L) end

---@overload fun(): @static
---@static
---@param exclude_generic_definition boolean
---@return System.Type[]
function m.GetAllTypes(exclude_generic_definition) end

---@static
---@param L System.IntPtr
---@param type System.Type
---@param metafunc string
---@param num number
function m.loadUpvalue(L, type, metafunc, num) end

---@static
---@param L System.IntPtr
---@param type System.Type
function m.MakePrivateAccessible(L, type) end

---@static
---@param L System.IntPtr
---@param type System.Type
---@param privateAccessible boolean
function m.ReflectionWrap(L, type, privateAccessible) end

---@overload fun(type:System.Type, L:System.IntPtr, translator:XLua.ObjectTranslator, meta_count:number, method_count:number, getter_count:number, setter_count:number) @static
---@static
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param meta_count number
---@param method_count number
---@param getter_count number
---@param setter_count number
---@param type_id number
function m.BeginObjectRegister(type, L, translator, meta_count, method_count, getter_count, setter_count, type_id) end

---@static
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param csIndexer fun(L:System.IntPtr):
---@param csNewIndexer fun(L:System.IntPtr):
---@param base_type System.Type
---@param arrayIndexer fun(L:System.IntPtr):
---@param arrayNewIndexer fun(L:System.IntPtr):
function m.EndObjectRegister(type, L, translator, csIndexer, csNewIndexer, base_type, arrayIndexer, arrayNewIndexer) end

---@static
---@param L System.IntPtr
---@param idx number
---@param name string
---@param func fun(L:System.IntPtr):
function m.RegisterFunc(L, idx, name, func) end

---@static
---@param L System.IntPtr
---@param idx number
---@param name string
---@param type System.Type
---@param memberType XLua.LazyMemberTypes
---@param isStatic boolean
function m.RegisterLazyFunc(L, idx, name, type, memberType, isStatic) end

---@static
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
---@param idx number
---@param name string
---@param obj any
function m.RegisterObject(L, translator, idx, name, obj) end

---@static
---@param type System.Type
---@param L System.IntPtr
---@param creator fun(L:System.IntPtr):
---@param class_field_count number
---@param static_getter_count number
---@param static_setter_count number
function m.BeginClassRegister(type, L, creator, class_field_count, static_getter_count, static_setter_count) end

---@static
---@param type System.Type
---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
function m.EndClassRegister(type, L, translator) end

---@static
---@param L System.IntPtr
---@param type System.Type
function m.LoadCSTable(L, type) end

---@static
---@param L System.IntPtr
---@param type System.Type
---@param cls_table number
function m.SetCSTable(L, type, cls_table) end

---@static
---@param delegateMethod System.Reflection.MethodInfo
---@param bridgeMethod System.Reflection.MethodInfo
---@return boolean
function m.IsParamsMatch(delegateMethod, bridgeMethod) end

---@static
---@param method System.Reflection.MethodInfo
---@return boolean
function m.IsSupportedMethod(method) end

---@static
---@param method System.Reflection.MethodInfo
---@return System.Reflection.MethodInfo
function m.MakeGenericMethodWithConstraints(method) end

---@static
---@param csFunction fun(L:System.IntPtr):
---@return boolean
function m.IsStaticPInvokeCSFunction(csFunction) end

---@static
---@param type System.Type
---@return boolean
function m.IsPublic(type) end

XLua.Utils = m
return m
