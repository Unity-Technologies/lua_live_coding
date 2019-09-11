---@class XLua.TemplateEngine.LuaTemplate : System.Object
local m = {}

---@static
---@param chunks XLua.TemplateEngine.Chunk[]
---@return string
function m.ComposeCode(chunks) end

---@overload fun(L:System.IntPtr): @static
---@static
---@param luaenv XLua.LuaEnv
---@param snippet string
---@return XLua.LuaFunction
function m.Compile(luaenv, snippet) end

---@overload fun(compiledTemplate:XLua.LuaFunction): @static
---@overload fun(L:System.IntPtr): @static
---@static
---@param compiledTemplate XLua.LuaFunction
---@param parameters XLua.LuaTable
---@return string
function m.Execute(compiledTemplate, parameters) end

---@static
---@param L System.IntPtr
function m.OpenLib(L) end

XLua.TemplateEngine.LuaTemplate = m
return m
