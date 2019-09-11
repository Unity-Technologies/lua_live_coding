---@class XLua.CopyByValue : System.Object
local m = {}

---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:number): @static
---@overload fun(buff:System.IntPtr, offset:number, field:System.Decimal): @static
---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.Pack(buff, offset, field) end

---@overload fun(buff:System.IntPtr, offset:number):(, System.SByte) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Int16) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.UInt16) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Int32) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.UInt32) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Int64) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.UInt64) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Single) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Double) @static
---@overload fun(buff:System.IntPtr, offset:number):(, System.Decimal) @static
---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Byte
function m.UnPack(buff, offset) end

---@static
---@param type System.Type
---@return boolean
function m.IsStruct(type) end

XLua.CopyByValue = m
return m
