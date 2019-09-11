---@class XLua.ObjectTranslatorPool : System.Object
---@field public Instance XLua.ObjectTranslatorPool @static
local m = {}

---@static
---@param L System.IntPtr
---@return XLua.ObjectTranslator
function m.FindTranslator(L) end

---@param L System.IntPtr
---@param translator XLua.ObjectTranslator
function m:Add(L, translator) end

---@param L System.IntPtr
---@return XLua.ObjectTranslator
function m:Find(L) end

---@param L System.IntPtr
function m:Remove(L) end

XLua.ObjectTranslatorPool = m
return m
