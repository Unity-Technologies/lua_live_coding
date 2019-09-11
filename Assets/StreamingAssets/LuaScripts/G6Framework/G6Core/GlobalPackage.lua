-- 管理unity中gameObject上的脚本，设为global，以便C#代码中能够以性能较高的方式调用
local BehaviourManager = require 'LuaScripts.G6Framework.G6Core.Misc.BehaviourManager'
_G.__BehaviourManager = BehaviourManager.New()