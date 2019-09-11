------------------------------------------
--- 定时器系统
--- 1: 提供Time/Frame两种类型定时器
--- 2: 定时器均支持Once/Repeat
--- 3: 定时器支持Scope自动解绑
------------------------------------------

local G6Scope = require "LuaScripts.G6Framework.G6Core.Core.G6Scope";
local G6EventSys = require "LuaScripts.G6Framework.G6Core.Core.G6Event";
local G6EventSys_Timer = G6EventSys:new("G6EventSys_Timer");
--------------------------------------------------------
----单个Timer的定义
-- Timer使用名字来唯一区分

---@class G6Timer
local G6TimerMeta = {};

---@private
G6TimerMeta.__index = G6TimerMeta;

-- 定时器类型
G6TimerMeta.TIMER_TYPE_NONE = 0;
G6TimerMeta.TIMER_TYPE_ONCE_TIME = 1;
G6TimerMeta.TIMER_TYPE_ONCE_FRAME = 2;
G6TimerMeta.TIMER_TYPE_REPEAT_TIME = 3;
G6TimerMeta.TIMER_TYPE_REPEAT_FRAME = 4;
G6TimerMeta.TIMER_TYPE_MIN = 1;
G6TimerMeta.TIMER_TYPE_MAX = 4;

G6TimerMeta.INFINITE_LENGTH = 2147483647;
G6TimerMeta.DEFAULT_INTERVAL = 0;
G6TimerMeta.DEFAULT_LENGTH = 1;


---创建定时器
---@param timerName string  定时器名字
---@param timerScope G6Scope  定时器作用域
---@param nType number  定时器类型
---@param nStart number 从当前计算定时器首次触发的时间
---@param nInterval number 定时器两次触发之间的时间间隔
---@param nLength number 从首次触发算定时器持续的时间
---@return G6Timer 新创建的定时器
function G6TimerMeta:new(timerName,timerScope,nType,nStart,nInterval,nLength,...)
    local tTimer = {}; ---@type G6Timer
	setmetatable(tTimer, G6TimerMeta);

    tTimer.m_timerName = timerName;

    ---引用了Timer的Scope，要用WeakTable不影响引用
    ---@type G6Scope
    tTimer.m_tScope = {};
	setmetatable(tTimer.m_tScope,{__mode = "kv"});

    ---如果是SceneScope，则做个转换
    tTimer.m_tScope.scope = timerScope;

    tTimer.m_nType = nType;
    tTimer.m_nStart = nStart;
    tTimer.m_nInterval = nInterval;

    ---到下一次触发的剩余时间/帧数
	tTimer.m_nCurInterval = 0;
    tTimer.m_nLength = nLength;

    ---定时器事件参数
    tTimer.m_param = {...};

    ---注册到Scope中，调试用
    G6Scope:RegisterScope(tTimer.m_tScope.scope,tTimer);

    return tTimer;
end

---获取定时器名字
---@return string 返回定时器名字
function G6TimerMeta:GetTimerName()
	return self.m_timerName;
end

---Timer.Tick
---@param deltaTime number 两次Tick之间间隔的时间
function G6TimerMeta:Tick(deltaTime)

	-- 每次Tick时间移动量
	local nMoveVal = self:GetMoveValue(deltaTime);

	-- 查看是否到可以开始Tick
	if (0 < self.m_nStart) then
		self.m_nStart = self.m_nStart - nMoveVal;
	end
	if (self.m_nStart <= 0) then
		
		-- self.m_nCurInterval默认值为0,保证所有的Timer都会被执行一次
		self.m_nCurInterval = self.m_nCurInterval - nMoveVal;
		if (self.m_nCurInterval <= 0) then
			-- 触发Timer对应的Event
			G6EventSys_Timer:FireEvent(self.m_timerName,table.unpack(self.m_param));
			self.m_nCurInterval = self.m_nInterval;
		end
		
		-- 刷新剩余时间，如果是永久Repeat，则不用刷新
		if (self.m_nLength ~= self.INFINITE_LENGTH) then
			-- 对于Once类型Timer，执行一次后，self.m_nLength必然小于0，从而结束Tick
			self.m_nLength = self.m_nLength - nMoveVal;
            if (self.m_nType == self.TIMER_TYPE_ONCE_TIME) or (self.m_nType == self.TIMER_TYPE_ONCE_FRAME) then
                self.m_nLength = 0;
            end
		end

        --print("self.m_nLength " .. self.m_nLength);
	end
end


---获取每次Tick时间移动量
---@param deltaTime number 两次Tick之间间隔的时间
function G6TimerMeta:GetMoveValue(deltaTime)
	if (self.m_nType == self.TIMER_TYPE_ONCE_TIME) or (self.m_nType == self.TIMER_TYPE_REPEAT_TIME) then
		return deltaTime;
	elseif (self.m_nType == self.TIMER_TYPE_ONCE_FRAME) or (self.m_nType == self.TIMER_TYPE_REPEAT_FRAME) then
		return 1;
	end

	return 0;
end

---定时器是否执行结束
---@return boolean 结束则返回true，否则返回false
function G6TimerMeta:IsTimerOver()
	return (self.m_nLength ~= self.INFINITE_LENGTH) and (self.m_nLength <= 0);
end

---定时器作用域是否有效
---@return boolean 有效则返回true，否则返回false
function G6TimerMeta:IsScopeValid()
	return G6Scope:IsScopeValid(self.m_tScope.scope);
end

---获取定时器的描述
---@return string 定时器描述
function G6TimerMeta:ToString()
    return "G6Timer : " .. self.m_timerName .. "," .. tostring(self);
end

---获取事件类型定义
---@return number 事件类型定义
function G6TimerMeta:GetType()
    return G6Scope.SCOPE_CONTENT_TYPE_TIMER;
end


--------------------------------------------------------

---定时器系统
---@class G6TimerSys
local G6TimerSysMeta = {}
G6TimerSysMeta.__index = G6TimerSysMeta;

G6TimerSysMeta.TIMER_TYPE_MIN = G6TimerMeta.TIMER_TYPE_MIN;
G6TimerSysMeta.TIMER_TYPE_MAX = G6TimerMeta.TIMER_TYPE_MAX;
G6TimerSysMeta.TIMER_TYPE_NONE = G6TimerMeta.TIMER_TYPE_NONE;
G6TimerSysMeta.TIMER_TYPE_ONCE_TIME = G6TimerMeta.TIMER_TYPE_ONCE_TIME;
G6TimerSysMeta.TIMER_TYPE_ONCE_FRAME = G6TimerMeta.TIMER_TYPE_ONCE_FRAME;
G6TimerSysMeta.TIMER_TYPE_REPEAT_TIME = G6TimerMeta.TIMER_TYPE_REPEAT_TIME;
G6TimerSysMeta.TIMER_TYPE_REPEAT_FRAME = G6TimerMeta.TIMER_TYPE_REPEAT_FRAME;

G6TimerSysMeta.INFINITE_LENGTH = G6TimerMeta.INFINITE_LENGTH;
G6TimerSysMeta.DEFAULT_INTERVAL = G6TimerMeta.DEFAULT_INTERVAL;
G6TimerSysMeta.DEFAULT_LENGTH = G6TimerMeta.DEFAULT_LENGTH;

function G6TimerSysMeta:new(strName)
    local tTimerSys = {}; ---@type G6TimerSys

    -- Name
    tTimerSys.m_strName = strName; 

    ---EventSet
    ---@type G6Timer[]
    tTimerSys.tTimerSet = {};

    -- Timer自增SN
    tTimerSys.SN = 0;

    setmetatable(tTimerSys, G6TimerSysMeta);

    return tTimerSys;
end

---创建定时器
---@param timerName string 定时器名字
---@param timerScope any 定时器作用域
---@param funcHandler fun():void 定时器处理函数
---@param nType number 定时器类型
---@param nStart number 从当前计算定时器首次触发的时间
---@param nInterval number 定时器两次触发之间的时间间隔
---@param nLength number 从首次触发算定时器持续的时间
---@param ... any 定时器处理函数参数
---@return G6Timer 成功返回Timer句柄，否则返回nil
function G6TimerSysMeta:RegistedTimer(timerName,timerScope,funcHandler,nType,nStart,nInterval,nLength,...)
    -- 参数检查
    if nil == timerScope or nil == funcHandler 
    	or nType < self.TIMER_TYPE_MIN or self.TIMER_TYPE_MAX < nType
    	or nStart < 0 or nInterval < 0 or nLength < 0 then
    	print("RegistedTimer error : Invalid Parameter");
        return nil;
    end

    -- 如果名字为空，则创建名字
    if (nil == timerName or "" == timerName) then
    	timerName = "G6Timer_" .. tostring(nType) .. "_" .. tostring(self.SN);
    	self.SN = self.SN + 1;
    end

    -- 创建Timer，如果已经存在则名字进行修饰建立新的Timer，不能直接使用已有的,存在这样的使用场景
    local tTimer = self.tTimerSet[timerName]
    if (nil ~= tTimer) then
        timerName = timerName .. "_" .. tostring(self.SN);
        self.SN = self.SN + 1;
    end
    tTimer = G6TimerMeta:new(timerName,timerScope,nType,nStart,nInterval,nLength,...);
	self.tTimerSet[timerName] = tTimer;

    -- 创建Timer对应的Event
    G6EventSys_Timer:RegistedEvent(timerName,timerScope,funcHandler,...);
    
    return tTimer;
end

---解除定时器
---@param tTimer G6Timer 定时器句柄
function G6TimerSysMeta:UnRegistedTimer(tTimer)
    -- 参数检查
    if nil == tTimer then
        return;
    end

    -- Timer从作用域移除
    G6Scope:UnRegisterScope(tTimer.m_tScope.scope,tTimer);

    -- 解除Timer
    local timerName = tTimer:GetTimerName();
    if (nil == self.tTimerSet[timerName]) then
    	print("UnRegistedTimer error : no timer found for target " .. tostring(timerName));
    else
    	self.tTimerSet[timerName] = nil;
    end

    -- 解绑Timer对应的Event
    G6EventSys_Timer:UnRegistedEvent(timerName);
end

---解除作用域内所有定时器
---@param tScope G6Scope 定时器作用域
function G6TimerSysMeta:UnRegistedScopeTimer(tScope)
    -- 参数检查
    if nil == tScope then
        return;
    end

    local tAllScope = G6Scope:GetAllScope();
    if (nil ~= tAllScope) then
        local tScopeItems = tAllScope[tScope];
        if (tScopeItems) then
            for _,tVTimer in pairs(tScopeItems) do
                if (tVTimer:GetType() == G6Scope.SCOPE_CONTENT_TYPE_TIMER) then
                    self:UnRegistedTimer(tVTimer);
                end
            end
        end
    end
end

---Tick定时器系统
---@param deltaTime number 两次Tick之间的间隔
function G6TimerSysMeta:Tick(deltaTime)
    for _, tTimer in pairs(self.tTimerSet) do
    	if (nil ~= tTimer) then
    		-- 判断Timer是否还需要Tick？
    		if (tTimer:IsScopeValid() and not tTimer:IsTimerOver()) then
    			tTimer:Tick(deltaTime);
    		else
                self:UnRegistedTimer(tTimer);
    		end
    	end
    end
end

---创建Once Time 类型的定时器
---@param timerName string 定时器名字
---@param timerScope G6Scope 定时器作用域
---@param funcHandler function 定时器处理函数
---@param nStart number 从当前计算定时器首次触发的时间
---@param ... any[] 定时器处理函数参数
---@return G6Timer 成功返回Timer句柄，否则返回nil
function G6TimerSysMeta:RegistedOnceTimeTimer(timerName,timerScope,funcHandler,nStart,...)
	-- TIMER_TYPE_ONCE_TIME 则nInterval,nLength会被忽略掉
	return self:RegistedTimer(timerName,timerScope,funcHandler,self.TIMER_TYPE_ONCE_TIME,nStart,self.DEFAULT_INTERVAL,self.DEFAULT_LENGTH,...);
end

---创建Once Frame 类型的定时器
---@param timerName string 定时器名字
---@param timerScope G6Scope 定时器作用域
---@param funcHandler function 定时器处理函数
---@param nStart number 从当前计算定时器首次触发的时间
---@param ... any[] 定时器处理函数参数
---@return G6Timer 成功返回Timer句柄，否则返回nil
function G6TimerSysMeta:RegistedOnceFrameTimer(timerName,timerScope,funcHandler,nStart,...)
	-- TIMER_TYPE_ONCE_FRAME 则nInterval,nLength会被忽略掉
	return self:RegistedTimer(timerName,timerScope,funcHandler,self.TIMER_TYPE_ONCE_FRAME,nStart,self.DEFAULT_INTERVAL,self.DEFAULT_LENGTH,...);
end

---创建Repeat Time 类型的定时器
---@param timerName string 定时器名字
---@param timerScope G6Scope 定时器作用域
---@param funcHandler function 定时器处理函数
---@param nStart number 从当前计算定时器首次触发的时间
---@param nInterval number 定时器两次触发之间的时间间隔
---@param nLength number 从首次触发算定时器持续的时间
---@param ... any[] 定时器处理函数参数
---@return G6Timer 成功返回Timer句柄，否则返回nil
function G6TimerSysMeta:RegistedRepeatTimeTimer(timerName,timerScope,funcHandler,nStart,nInterval,nLength,...)
	-- TIMER_TYPE_REPEAT_TIME
	return self:RegistedTimer(timerName,timerScope,funcHandler,self.TIMER_TYPE_REPEAT_TIME,nStart,nInterval,nLength,...);
end

---创建Repeat Frame 类型的定时器
---@param timerName string 定时器名字
---@param timerScope G6Scope 定时器作用域
---@param funcHandler function 定时器处理函数
---@param nStart number 从当前计算定时器首次触发的时间
---@param nInterval number 定时器两次触发之间的时间间隔
---@param nLength number 从首次触发算定时器持续的时间
---@param ... any[] 定时器处理函数参数
---@return G6Timer 成功返回Timer句柄，否则返回nil
function G6TimerSysMeta:RegistedRepeatFrameTimer(timerName,timerScope,funcHandler,nStart,nInterval,nLength,...)
	-- TIMER_TYPE_REPEAT_FRAME
	return self:RegistedTimer(timerName,timerScope,funcHandler,G6TimerMeta.TIMER_TYPE_REPEAT_FRAME,nStart,nInterval,nLength,...);
end

return G6TimerSysMeta

