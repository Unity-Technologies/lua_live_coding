local UIUtil = require 'LuaScripts.G6Framework.G6Core.Misc.UIUtil'

---@class LuaBehaviour
local LuaBehaviour = _G.Class("LuaBehaviour")

-- 示例setting写法
--[[
local setting = 
{    
    -- 普通的UI控件
    Elements = 
    {
        -- Element支持的参数:
        -- Name      GameObject的Path
        -- Alias     便利访问的名字, 有Count时，这是一个数组
        -- Count     一次绑定多个控件，从1开始
        -- Type      需要的MonoBehaviour类型, 不指定则绑定GameObject
        -- Necessary 是否必须找到，Necessary = false时可以不报错
        -- Handles   回调函数
        -- Hide      是否默认隐藏掉

        {
            Name = "CloseButton",
            Type = CS.UIButton,
            Handles = 
            {
                onClick = "OnCloseButtonClick",
            }
        },
        -- 一次注册多个控件，自动通过数字下标去查找
        -- Item1, Item2, Item3
        {
            Name = "Item",
            Count = 3,
            Type = CS.UIButton,
            Handles = 
            {
                onClick = "OnCloseButtonClick",
            }
        },
    },

    -- Lua端定义的自定义脚本
    Behaviours =
    {
        -- Behaviour支持的参数:
        -- Name      GameObject的Path
        -- Alias     便利访问的名字, 有Count时，这是一个数组
        -- Count     一次绑定多个控件，从1开始
        -- Necessary 是否必须找到，Necessary = false时可以不报错

        {
            Name = "PlayerInfo",
        },
    },

    -- 自动注册的Event消息
    Events =
    {
    	["Event1"] = "OnEvent1"
	},

    -- 自动注册的Timer
    Timers =
    {
        {
            Name = "SceneLoadedTimer",
            Timer = Timer:Always(1),
            Handler = "CheckSceneLoaded"
        }
    },

	-- 自动绑定的Action
	StaticActions =
	{
        {
            Event = BagModel.InfoRefreshEvent
            Handler = "OnInfoRefreshEvent"
        }
    }
	}
}
]]

function LuaBehaviour:ctor(target, setting)
  self._target = target
  self._targetID = target:GetInstanceID()
  self._luaOperation = target:GetComponent(typeof(CS.LuaOperation))
  self._setting = setting
  self._lambdaMap = {}

  UIUtil.BindElements(self)
end

-- 默认的一些消息/Events的注册
-- setting中没有需要就不注册
-- 同时，可以避免在子类中写super.OnStart等
function LuaBehaviour:CheckAndBindPrevEvents()
    local setting = self._setting
    local lo = self._luaOperation

    if setting.Behaviours ~= nil then
            UIUtil.BindBehaviours(self)
    end

    if setting.Events ~= nil then
        lo:EnableEvent("+", function()
            UIUtil.BindEvents(self)
        end)

        lo:DisableEvent("+", function()
            UIUtil.UnbindEvents(self)
        end)
    end
end

function LuaBehaviour:CheckAndBindLaterEvents()
    local lo = self._luaOperation

    if self.OnVisible ~= nil then
        lo:StartEvent("+", function()
            self:OnVisible()
            self.__started = true
        end)

        lo:EnableEvent("+", function()
            if self.__started == true then
                __BehaviourManager:RegisterForVisibleEvent(self)
            end
        end)

        lo:DisableEvent("+", function()
            if self.__started == true then
                __BehaviourManager:UnregisterForVisibleEvent(self)
            end
        end)
    end

    -- 这个最后绑定
    lo:DestroyEvent('+', function()
        --GScope.Scope.Destroy("globe.ui." .. self._targetID .. ".visible")
        __BehaviourManager:DestroyBehaviour(self)
    end)
end

-- 可选的预定义事件回调
-- 如果需要监听，就写上对应的方法就好了

-- function LuaBehaviour:OnAwake()
-- 	-- print("OnAwake")
-- end

-- function LuaBehaviour:OnStart()
-- 	-- print("OnStart")
-- end

-- function LuaBehaviour:OnEnable()
-- 	-- print("OnEnable")
-- end

-- function LuaBehaviour:OnVisible()
--  -- print("OnVisible")
-- end

-- function LuaBehaviour:OnDisable()
-- 	-- print("OnDisable")
-- end

-- function LuaBehaviour:OnDestroy()
-- 	-- print("OnDestroy")
-- end

return LuaBehaviour