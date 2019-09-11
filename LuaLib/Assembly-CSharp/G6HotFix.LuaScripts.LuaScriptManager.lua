---@class G6HotFix.LuaScripts.LuaScriptManager : ObjectSingleton_1_G6HotFix_LuaScripts_LuaScriptManager_
local m = {}

---@return XLua.LuaEnv
function m:GetLuaEnv() end

---@return XLua.LuaTable
function m:GetScriptEnv() end

---@return boolean
function m:LoadScripts() end

function m:Dispose() end

function m:GC() end

---@param key string
---@return XLua.LuaTable
function m:GetLuaTable(key) end

---@param deltatime number
function m:UpdateScript(deltatime) end

---@param context UnityEngine.ResourceManagement.IResourceLocation[]
---@param luaSource UnityEngine.TextAsset[]
function m:SetLuaSource(context, luaSource) end

---@param context UnityEngine.ResourceManagement.IResourceLocation[]
---@param luaSource UnityEngine.TextAsset[]
function m:ReplaceLuaSource(context, luaSource) end

---@param name string
---@param src string
function m:ReplaceLuaSrcText(name, src) end

---@param luaName string
---@return boolean
function m:IsContainsLuaScript(luaName) end

---@param luaName string
---@return string
function m:GetLuaScriptText(luaName) end

---@param luaName string
---@return string
function m:GetLuaScriptBytes(luaName) end

---@static
---@param luaName string
---@param mode string
---@param env XLua.LuaTable
---@return XLua.LuaFunction
function m.LoadLuaFile(luaName, mode, env) end

---@static
---@param packageName string
---@return string
function m.ConvertPackageNameToFileFullPath(packageName) end

---@static
---@param filePath string
---@return string
function m.ConvertFileFullPathToPackageName(filePath) end

---@static
---@param filePath string
---@return string
function m.ConvertProjectPathToScriptPath(filePath) end

---@static
---@param filePath string
---@return string
function m.ConvertScriptPathToPackageName(filePath) end

G6HotFix.LuaScripts.LuaScriptManager = m
return m
