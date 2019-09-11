---@class XLua.LuaEnv : System.Object
---@field public CSHARP_NAMESPACE string @static
---@field public MAIN_SHREAD string @static
---@field public Global XLua.LuaTable
---@field public GcPause number
---@field public GcStepmul number
---@field public Memroy number
local m = {}

---@static
---@param initer fun(arg1:XLua.LuaEnv, arg2:XLua.ObjectTranslator)
function m.AddIniter(initer) end

---@overload fun(chunk:string, chunkName:string):
---@overload fun(chunk:string):
---@overload fun(chunk:string, chunkName:string, env:XLua.LuaTable):
---@overload fun(chunk:string, chunkName:string):
---@overload fun(chunk:string):
---@overload fun(chunk:string, chunkName:string, env:XLua.LuaTable):
---@overload fun(chunk:string, chunkName:string):
---@overload fun(chunk:string):
---@param chunk string
---@param chunkName string
---@param env XLua.LuaTable
---@return any
function m:LoadString(chunk, chunkName, env) end

---@overload fun(chunk:string, chunkName:string):
---@overload fun(chunk:string):
---@overload fun(chunk:string, chunkName:string, env:XLua.LuaTable):
---@overload fun(chunk:string, chunkName:string):
---@overload fun(chunk:string):
---@param chunk string
---@param chunkName string
---@param env XLua.LuaTable
---@return any[]
function m:DoString(chunk, chunkName, env) end

---@param type System.Type
---@param alias string
function m:Alias(type, alias) end

function m:Tick() end

function m:GC() end

---@return XLua.LuaTable
function m:NewTable() end

---@overload fun(dispose:boolean) @virtual
---@virtual
function m:Dispose() end

---@param oldTop number
function m:ThrowExceptionFromError(oldTop) end

---@param loader fun(filepath:System.String):(, System.String)
function m:AddLoader(loader) end

---@param name string
---@param initer fun(L:System.IntPtr):
function m:AddBuildin(name, initer) end

function m:FullGc() end

function m:StopGc() end

function m:RestartGc() end

---@param data number
---@return boolean
function m:GcStep(data) end

XLua.LuaEnv = m
return m
