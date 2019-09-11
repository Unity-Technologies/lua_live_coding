---@class XLua.ObjectTranslator : System.Object
---@field public cacheRef number
local m = {}

---@param type System.Type
---@param loader fun(obj:System.IntPtr)
function m:DelayWrapLoader(type, loader) end

---@param type System.Type
---@param creator fun(arg1:number, arg2:XLua.LuaEnv):
function m:AddInterfaceBridgeCreator(type, creator) end

---@param L System.IntPtr
---@param type System.Type
---@return boolean
function m:TryDelayWrapLoader(L, type) end

---@param type System.Type
---@param alias string
function m:Alias(type, alias) end

---@param L System.IntPtr
---@param delegateType System.Type
---@param idx number
---@return any
function m:CreateDelegateBridge(L, delegateType, idx) end

---@return boolean
function m:AllDelegateBridgeReleased() end

---@param L System.IntPtr
---@param reference number
---@param is_delegate boolean
function m:ReleaseLuaBase(L, reference, is_delegate) end

---@param L System.IntPtr
---@param interfaceType System.Type
---@param idx number
---@return any
function m:CreateInterfaceBridge(L, interfaceType, idx) end

---@param L System.IntPtr
function m:CreateArrayMetatable(L) end

---@param L System.IntPtr
function m:CreateDelegateMetatable(L) end

---@param L System.IntPtr
function m:OpenLib(L) end

---@param L System.IntPtr
---@param idx number
---@return System.Type
function m:GetTypeOf(L, idx) end

---@overload fun(L:System.IntPtr, index:number, type:System.Type):
---@param L System.IntPtr
---@param index number
---@return boolean
function m:Assignable(L, index) end

---@param L System.IntPtr
---@param index number
---@param type System.Type
---@return any
function m:GetObject(L, index, type) end

---@overload fun(L:System.IntPtr, index:number):
---@param L System.IntPtr
---@param index number
---@return any
function m:Get(L, index) end

---@param L System.IntPtr
---@param v any
function m:PushByType(L, v) end

---@overload fun(L:System.IntPtr, index:number, type:System.Type):
---@param L System.IntPtr
---@param index number
---@return any[]
function m:GetParams(L, index) end

---@param L System.IntPtr
---@param ary System.Array
function m:PushParams(L, ary) end

---@param L System.IntPtr
---@param index number
---@return any
function m:GetDelegate(L, index) end

---@param L System.IntPtr
---@param type System.Type
---@return number
function m:GetTypeId(L, type) end

---@param L System.IntPtr
---@param type System.Type
function m:PrivateAccessible(L, type) end

---@param L System.IntPtr
---@param o any
function m:PushAny(L, o) end

---@param L System.IntPtr
---@param type System.Type
---@param idx number
---@return number
function m:TranslateToEnumToTop(L, type, idx) end

---@overload fun(L:System.IntPtr, o:XLua.LuaBase)
---@overload fun(L:System.IntPtr, o:any)
---@param L System.IntPtr
---@param o fun(L:System.IntPtr):
function m:Push(L, o) end

---@param L System.IntPtr
---@param o any
---@param type_id number
function m:PushObject(L, o, type_id) end

---@param L System.IntPtr
---@param index number
---@param obj any
function m:Update(L, index, obj) end

---@param type System.Type
---@return boolean
function m:HasCustomOp(type) end

---@param push fun(arg1:System.IntPtr, arg2:any)
---@param get fun(L:System.IntPtr, idx:number):
---@param update fun(arg1:System.IntPtr, arg2:number, arg3:any)
function m:RegisterPushAndGetAndUpdate(push, get, update) end

---@param get fun(L:System.IntPtr, idx:number):
function m:RegisterCaster(get) end

---@param L System.IntPtr
---@param val System.Decimal
function m:PushDecimal(L, val) end

---@param L System.IntPtr
---@param index number
---@return boolean
function m:IsDecimal(L, index) end

---@param L System.IntPtr
---@param index number
---@return System.Decimal
function m:GetDecimal(L, index) end

XLua.ObjectTranslator = m
return m
