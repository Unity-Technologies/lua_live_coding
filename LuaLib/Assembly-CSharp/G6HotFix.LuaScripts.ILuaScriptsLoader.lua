---@class G6HotFix.LuaScripts.ILuaScriptsLoader : table
local m = {}

---@abstract
function m:ReloadScripts() end

G6HotFix.LuaScripts.ILuaScriptsLoader = m
return m
