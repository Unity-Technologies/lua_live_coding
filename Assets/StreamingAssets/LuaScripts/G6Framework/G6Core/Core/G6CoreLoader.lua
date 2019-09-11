
------------------------------------------
--- 事件自动绑定支持
--- 基于hotfix 回调，完成 OnNet_ OnEvent_ 语法糖的自动绑定
--- 1: 事件处理函数名字OnEvent_XXX XXX为事件名字(ID), 
--- 2: 适用于函数和Module生命周期一致，而且注册时无需额外参数的事件
--- 3: 需要提前设置MsgIdMap
------------------------------------------

local G6Scope = require "LuaScripts.G6Framework.G6Core.Core.G6Scope";
local G6EventSys = require "LuaScripts.G6Framework.G6Core.Core.G6Event";
local G6TimerSys = require "LuaScripts.G6Framework.G6Core.Core.G6Timer";
local NetworkConfig = require "LuaScripts.G6Config.NetworkConfig";
local G6EventSet = require "LuaScripts.G6Framework.G6Core.G6EventSet";
---@class G6CoreLoader
local G6CoreLoader = {};

-- scope clean hookers
function G6CoreLoader.__G6_Destruct(self);
	local tDefModule = getmetatable(self);
	local funcDestruct = rawget(tDefModule,"__Destruct");
	if (funcDestruct) then
		funcDestruct(self);
	end

	-- 清理Scope下的注册，Scope为self
	_G.TimerSys:UnRegistedScopeTimer(self);
	_G.EventSys:UnRegistedScopeEvent(self);
	_G.NetEventSys:UnRegistedScopeEvent(self);
	G6Scope:UnRegisterScope(self);
end

function G6CoreLoader.__G6_EndPlay(self);
	local tDefModule = getmetatable(self);
	local funcEndPlay = rawget(tDefModule,"_EndPlay");
	if (funcEndPlay) then
		funcEndPlay(self);
	end

	-- 清理Scope下的注册，Scope为self
	_G.TimerSys:UnRegistedScopeTimer(self);
	_G.EventSys:UnRegistedScopeEvent(self);
	_G.NetEventSys:UnRegistedScopeEvent(self);
	G6Scope:UnRegisterScope(self);
end

function G6CoreLoader.PreHotfixCallback();
	-- 所有绑定过的Destruct都会被清理，当HotFix完成后，本次未参与HotFix的Module要进行修复
	if (G6CoreLoader.m_tAutoBindTracker) then
		for k,_ in pairs(G6CoreLoader.m_tAutoBindTracker) do
			if (k) then
				rawset(k,"Destruct",nil);
				rawset(k,"EndPlay",nil);
			end
		end
	end
end

function G6CoreLoader.PostHotfixCallback();
	-- 所有绑定过的Destruct都会被清理，当HotFix完成后，本次未参与HotFix的Module要进行修复
	if (G6CoreLoader.m_tAutoBindTracker) then
		for k,_ in pairs(G6CoreLoader.m_tAutoBindTracker) do
			if (k) then
				rawset(k,"Destruct",G6CoreLoader.__G6_Destruct);
				rawset(k,"EndPlay",G6CoreLoader.__G6_EndPlay);
			end
		end
	end
end

function G6CoreLoader.TrimEventNamePrefix(strEventName,strPrefix);
	local nStart, nEnd = string.find(strEventName, strPrefix);
	if nStart == 1 then
		return string.sub(strEventName, nEnd + 1);
	end
	return nil;
end

-- 自定义事件
function G6CoreLoader.AutoBindEvent(module,strFileName,bHotFix,bRebind)

	-- 记录加载的Module/Path的映射关系
	if (strFileName) then
		_G.EventSys:FireEvent(G6EventSet.G6_EVENT_LUA_REQUIRE,strFileName);
	end

	-- 只有和C++/BP绑定的Lua才需要
	local tDefModule = module;
	if (tDefModule.__className == "LuaUnrealClass") then
		if (bRebind) then
			-- rebind模式下，module的metatable才是真正的module：函数定义在其中，参数的module只是作用域
			tDefModule = getmetatable(module);
		else
			-- Hook UObject的清理函数，确保Scope可以正确清理

			-- UWidget
			local funcDestruct = rawget(tDefModule,"Destruct");
			if (funcDestruct ~= G6CoreLoader.__G6_Destruct) then
				
				rawset(tDefModule,"__Destruct",funcDestruct);
				rawset(tDefModule,"Destruct",G6CoreLoader.__G6_Destruct);
				
				if (not G6CoreLoader.m_tAutoBindTracker) then
					G6CoreLoader.m_tAutoBindTracker = {};
					setmetatable(G6CoreLoader.m_tAutoBindTracker,{__mode = "kv"});
				end
				G6CoreLoader.m_tAutoBindTracker[tDefModule] = tDefModule;
			end

			-- AActor
			local funcEndPlay = rawget(tDefModule,"EndPlay");
			if (funcEndPlay ~= G6CoreLoader.__G6_EndPlay) then
				
				rawset(tDefModule,"__EndPlay",funcEndPlay);
				rawset(tDefModule,"EndPlay",G6CoreLoader.__G6_EndPlay);
				
				if (not G6CoreLoader.m_tAutoBindTracker) then
					G6CoreLoader.m_tAutoBindTracker = {};
					setmetatable(G6CoreLoader.m_tAutoBindTracker,{__mode = "kv"});
				end
				G6CoreLoader.m_tAutoBindTracker[tDefModule] = tDefModule;
			end			
		end
	end

	for k,v in pairs(tDefModule) do
		if type(v) == "function" then
			local strEventName = G6CoreLoader.TrimEventNamePrefix(k,"OnEvent_");
			if nil ~= strEventName then
				-- LuaUnrealClass在rebind模式下才绑定
				if (not bRebind and tDefModule.__className == "LuaUnrealClass") then
					print("Delay bind: OnEvent_" .. strEventName);
				else
					print("Bind: OnEvent_" .. strEventName);
					_G.EventSys:UnRegistedEvent(strEventName, module, v);
					_G.EventSys:RegistedEvent(strEventName, module, v,module);
				end
			end
		end
	end
end

-- 网络事件
function G6CoreLoader.AutoBindNetEvent(module,strFileName,bHotFix,bRebind)
	
	-- rebind模式下，module的metatable才是真正的module：函数定义在其中，参数的module只是作用域
	local tDefModule = module;
	if (bRebind) then
		tDefModule = getmetatable(module);
	end

	for k,v in pairs(tDefModule) do
		if type(v) == "function" then
			local strEventName = G6CoreLoader.TrimEventNamePrefix(k,"OnNet_");
			if nil ~= strEventName then
				strEventName = string.upper(strEventName);
				local NetMessageID = NetworkConfig:GetNetMessageID("MSGID_" .. strEventName);
				if NetMessageID == nil then
					print("error : NO Msg define : ", strEventName);
				else
					-- LuaUnrealClass在rebind模式下才绑定
					if (not bRebind and tDefModule.__className == "LuaUnrealClass") then
						print("Delay bind: OnNet_" .. strEventName);
					else
						_G.NetEventSys:UnRegistedEvent(NetMessageID, module, v);
						_G.NetEventSys:RegistedEvent(NetMessageID, module, v,module);
					end
				end
			end
		end
	end
end

-- 加载作用域

-- GlobalScope对象
_G._GLOBAL_SCOPE = {_GLOBAL_SCOPE = true};

---获取指定的SceneScope对象
---@param strSceneName string @SceneScope对象名字
---@return G6Scope @SceneScope对象
function _G.SCENE_SCOPE(strSceneScope)
	return G6Scope:GetSceneScope(strSceneScope);
end

-- 加载Event/Timer系统
function CreateEventSys()
	if (nil == _G.EventSys) then
		_G.EventSys = G6EventSys:new("G6EventSys_Default");
	end
	if (nil == _G.NetEventSys) then
		_G.NetEventSys = G6EventSys:new("G6EventSys_Net");
	end
end

function CreateTimerSys()
	if (nil == _G.TimerSys) then
		_G.TimerSys = G6TimerSys:new("G6TimerSys_Default");
	end
end

CreateEventSys();
CreateTimerSys();

-- 加载Event/Timer自动注册支持
-- 当Event/Timer作用域保持和Module一致，并且无需额外参数时使用
-- 明显的例子是网络协议事件注册
_G.AutoBindEvent = G6CoreLoader.AutoBindEvent;
_G.AutoBindNetEvent = G6CoreLoader.AutoBindNetEvent;
_G.G6HotFix.RegistedFileLoadCallback(G6CoreLoader.AutoBindEvent);
_G.G6HotFix.RegistedFileLoadCallback(G6CoreLoader.AutoBindNetEvent);
_G.G6HotFix.RegistedPreHotfixCallback(G6CoreLoader.PreHotfixCallback);
_G.G6HotFix.RegistedPostHotfixCallback(G6CoreLoader.PostHotfixCallback);

return G6CoreLoader;