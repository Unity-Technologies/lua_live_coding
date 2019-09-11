---@class XLua.SignatureLoader : System.Object
local m = {}

---@static
---@param signatureLoader XLua.SignatureLoader
---@return fun(filepath:System.String):(, System.String)
function m.op_Implicit(signatureLoader) end

XLua.SignatureLoader = m
return m
