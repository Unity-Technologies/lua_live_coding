------------------------------------------
--- 事件系统
--- 1: 提供 Bind/UnBind Event
--- 2: 支持 Global/Scene/Table 三种Scope
--- 3: Scope不满足时，Event将会被自动移除
--- 4: Event的清理是在触发时清理
------------------------------------------

--------------------------------------------------------
----单个事件的定义
-- 当且仅当Name,Scope,Method为同一个时才是同一个Event实例
local G6Scope = require "LuaScripts.G6Framework.G6Core.Core.G6Scope";

---@class G6EventRsp
local G6EventRspMeta = {};
G6EventRspMeta.__index = G6EventRspMeta;

--- 创建事件处理器
--- @param string eventName  事件名字
--- @param scope scope 事件作用域
--- @param function funcMethod 事件处理器
--- @param nil ... 事件处理器参数   
--- @return G6EventSys 新创建的事件
function G6EventRspMeta:new(tEvent,scope, funcMethod,...)
    local tEventRsp = {};

    -- 事件的名称
    tEventRsp.m_tEvent = tEvent;

    -- 事件处理函数定义
    tEventRsp.m_tScope = {};
    setmetatable(tEventRsp.m_tScope,{__mode = "kv"});

    tEventRsp.m_tScope.scope = scope;
    tEventRsp.m_funcMethod = funcMethod;
    tEventRsp.m_param = {...};

    setmetatable(tEventRsp, G6EventRspMeta);
    return tEventRsp;
end

--- 获取对应的事件对象
--- @return table 对应的事件对象
function G6EventRspMeta:GetEvent()
    return self.m_tEvent;
end

--- 获取事件的描述
--- @return string 事件的描述
function G6EventRspMeta:ToString()
    return "G6Event : " .. self:GetEvent().m_eventName .. "," .. tostring(self);
end

-- 获取事件类型定义
-- @return 事件类型定义
function G6EventRspMeta:GetType()
    return G6Scope.SCOPE_CONTENT_TYPE_EVENT;
end

---@class G6Event
local G6EventMeta = {};
G6EventMeta.__index = G6EventMeta;

--- 创建事件
--- @param eventName string 事件名字
--- @return G6EventSys 新创建的事件
function G6EventMeta:new(eventName)
    local tEvent = {};

    -- 事件的名称
    tEvent.m_eventName = eventName;

    --绑定的事件处理函数，{m_tScope,m_funcMethod}
    tEvent.m_tRspSet = {};
    
    setmetatable(tEvent, G6EventMeta);
    return tEvent;
end

--- Event是否已存在？
--- @param scope G6Scope 事件作用阈
--- @param funcMethod function 事件处理函数
--- @return boolean 已存在返回true，否则返回false
function G6EventMeta:IsEventExists(scope, funcMethod)
    for _,rsp in pairs(self.m_tRspSet) do
        if (rsp.m_tScope.scope == scope) and (rsp.m_funcMethod == funcMethod) then
            return true;
        end
    end
    return false;
end

--- 绑定事件回调
--- @param scope G6Scope 事件作用阈
--- @param funcMethod function 事件处理函数
--- @param ... any[] 事件处理函数参数
--- @return boolean 成功返回true，失败返回false
function G6EventMeta:Bind(scope, funcMethod,...)
	if nil == scope or nil == funcMethod or type(funcMethod) ~= "function" then
		return false;
	end

    if (self:IsEventExists(scope,funcMethod)) then
        print("Event binding more than once " .. tostring(self.m_eventName));
    else
        -- Event Responser,Weak table
        local responser = G6EventRspMeta:new(self,scope,funcMethod,...);
        table.insert(self.m_tRspSet, responser);

        -- 注册到Scope中，调试用
        G6Scope:RegisterScope(scope,responser);
    end
	
	return true;
end

--- 解除该事件绑定
--- @param scope G6Scope 事件作用阈
--- @param funcMethod function 事件处理函数,当处理函数为nil，则移除该event下scope匹配的event实例
function G6EventMeta:Unbind(scope, funcMethod)
    if (nil == scope) then
        return;
    end

    for _key, _rsp in pairs(self.m_tRspSet) do
        if (_rsp.m_tScope.scope == scope) and ((nil == funcMethod) or (_rsp.m_funcMethod == funcMethod)) then
            G6Scope:UnRegisterScope(scope,_rsp);
            self.m_tRspSet[_key] = nil; 
        end
    end
end

--- 触发事件
--- @param ... any[] Fire参数
function G6EventMeta:Fire(...)
    for _key, _rsp in pairs(self.m_tRspSet) do
        if BeginProfiler then _G.BeginProfiler(self.m_eventName) end
        if (G6Scope:IsScopeValid(_rsp.m_tScope.scope)) then
            -- 通过xpcall才能得到正确堆栈
            -- 如果注册时提供了参数，此时传递到处理函数, 注册时函数最多支持3个，
            local bOK,strErr;
            if (3 <= #_rsp.m_param) then
                if (3 < #_rsp.m_param) then
                    print("too many param on event " .. self.m_eventName .. ",some params discarded");
                end
                local _param_1 = select(1,table.unpack(_rsp.m_param));
                local _param_2 = select(2,table.unpack(_rsp.m_param));
                local _param_3 = select(3,table.unpack(_rsp.m_param));
                bOK,strErr = xpcall(_rsp.m_funcMethod, error_handler, _param_1,_param_2,_param_3,...);
            elseif (2 <= #_rsp.m_param) then
                local _param_1 = select(1,table.unpack(_rsp.m_param));
                local _param_2 = select(2,table.unpack(_rsp.m_param));
                bOK,strErr = xpcall(_rsp.m_funcMethod, error_handler, _param_1,_param_2,...);
            elseif (1 <= #_rsp.m_param) then
                local _param_1 = select(1,table.unpack(_rsp.m_param));
                bOK,strErr = xpcall(_rsp.m_funcMethod, error_handler, _param_1,...);
            else 
                bOK,strErr = xpcall(_rsp.m_funcMethod, error_handler,...);                
            end

            if (not bOK) then
                print("error on event ", tostring(self.m_eventName), strErr)
            end
        else
            -- scope无效，则移除当前responser
            self.m_tRspSet[_key] = nil;
        end
        if EndProfiler then _G.EndProfiler(self.m_eventName) end
    end
end

--------------------------------------------------------

---事件系统
---@class G6EventSys
local G6EventSysMeta = {}
G6EventSysMeta.__index = G6EventSysMeta;

function G6EventSysMeta:new(strName)
    local tEventSys = {}; ---@type G6EventSys

    -- Name
    tEventSys.m_strName = strName; 

    -- EventSet
    ---@type table<string, G6Event>
    tEventSys.tEventSet = {};

    setmetatable(tEventSys, G6EventSysMeta);

    return tEventSys;
end

--- 创建事件注册
--- @param eventName string 事件名字
--- @param scope G6Scope 事件作用阈
--- @param funcMethod function 事件处理函数
--- @param ... any[] 事件处理函数参数
--- @return boolean 成功返回true，否则返回false
function G6EventSysMeta:RegistedEvent(eventName, scope, funcMethod,...)
    -- 参数检查
    if nil == eventName or nil == scope or nil == funcMethod then
        return false;
    end

    -- 创建事件，如果已经存在则直接使用
    local tEvent = self.tEventSet[eventName]
    if nil == tEvent then
        tEvent = G6EventMeta:new(eventName);
		self.tEventSet[eventName] = tEvent;
    end

    -- 绑定事件
    tEvent:Bind(scope, funcMethod,...);
    
    return true;
end

--- 解除事件注册
--- @param eventName string 事件名字
--- @param scope G6Scope 事件作用阈，可为nil
--- @param funcMethod function 事件处理函数，可为nil
function G6EventSysMeta:UnRegistedEvent(eventName, scope, funcMethod)
    -- 参数检查
    if nil == eventName then
        return;
    end

    -- 解绑
    if (nil == scope) then
        -- scope为nil，则移除整个Event
        self.tEventSet[eventName] = nil;
    else
        -- 按name/scope/funcMethod组合移除Event
        local tEvent = self.tEventSet[eventName]
        if nil ~= tEvent then
            tEvent:Unbind(scope,funcMethod);
        end
    end
end

--- 解除事件注册,移除整个作用域
--- @param scope G6Scope  事件作用阈
function G6EventSysMeta:UnRegistedScopeEvent(scope)
    -- 参数检查
    if nil == scope then
        return;
    end

    local tAllScope = G6Scope:GetAllScope();
    if (nil ~= tAllScope) then
        local tScopeItems = tAllScope[scope];
        if (tScopeItems) then
            for _,event_rsp in pairs(tScopeItems) do
                if (event_rsp:GetType() == G6Scope.SCOPE_CONTENT_TYPE_EVENT) then
                    event_rsp:GetEvent():Unbind(scope);
                    G6Scope:UnRegisterScope(scope,event_rsp);
                end
            end
        end
    end
end

--- 触发事件
--- @param eventName string 事件名字
--- @param ... any[]       事件参数
function G6EventSysMeta:FireEvent(eventName, ...)
    -- 参数检查
    if nil == eventName then
        return;
    end

    -- 触发
    local tEvent = self.tEventSet[eventName]
    if nil ~= tEvent then
        tEvent:Fire(...);
    end
end

local G6EventSys = G6EventSysMeta;
return G6EventSys;