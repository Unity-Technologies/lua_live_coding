--游戏的装载模块，负责装载各种文件
GameBooter = {}

_G.G6DebugLog = function(msg)
    CS.G6Debugger.Log(msg)
end

_G.G6DebugError = function(msg)
    CS.G6Debugger.LogError(msg)
end

-- 热更所需方法,执行完后加载方式即发生变化，后面require的各种非“_G”的package在单独的沙盒env中
require "LuaScripts.G6Framework.G6Core.Misc.G6Helper"
_G.G6HotFix = require("LuaScripts.G6Framework.G6Core.Misc.G6Hotfix")
loadfile = CS.G6HotFix.LuaScripts.LuaScriptManager.LoadLuaFile

require "LuaScripts.G6Framework.G6Core.GlobalPackage"

-- 加载GamePath中配置的所有脚本
function GameBooter.ReloadScripts()
    for _, path in ipairs(GamePath) do
        local pathPrefix = path.path or ""
        local files = path.files
        for i, file in ipairs(files) do
            file = pathPrefix .. file
            require(file)
        end
    end
end