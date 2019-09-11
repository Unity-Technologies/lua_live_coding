
------------------------------------------
--- 作用域
--- 1: 提供Scope相关的基本函数
--- 2: 支持 Global/Scene/Table
------------------------------------------
---@class G6Scope
local G6Scope = {};

-- Scope类型定义
G6Scope.SCOPE_NONE = 0;
G6Scope.SCOPE_GLOBAL = 1;
G6Scope.SCOPE_SCENE = 2;
G6Scope.SCOPE_TABLE = 3;

---Scope中Event/Timer定义
G6Scope.SCOPE_CONTENT_TYPE_NONE = 0;
G6Scope.SCOPE_CONTENT_TYPE_EVENT = 1;
G6Scope.SCOPE_CONTENT_TYPE_TIMER = 2;

---系统中所有Scope的列表
G6Scope.m_tScope = {};
--setmetatable(G6Scope.m_tScope,{__mode = "kv"});

---当前Scene的名字，默认是登陆Scene，在SceneManager中切换Scene时被设置
G6Scope.m_strCurSceneName = "LoginScene";
---@type G6Scope[]
G6Scope.m_tSceneScope = {};
--setmetatable(G6Scope.m_tSceneScope,{__mode = "kv"});

--- 获取作用域类型
--- @param scope G6Scope 作用域
--- @return number 作用域的类型
function G6Scope:GetScopeType(scope)
	if (nil == scope) then
		return G6Scope.SCOPE_NONE;
	elseif (type(scope) == "table" and scope._GLOBAL_SCOPE) then
		return G6Scope.SCOPE_GLOBAL;
	elseif (type(scope) == "table" and scope._SCENE_SCOPE) then
		return G6Scope.SCOPE_SCENE;
	elseif (type(scope) == "table") then
		return G6Scope.SCOPE_TABLE;
	end
	return G6Scope.SCOPE_NONE;
end

--- 作用域是否有效
--- @param scope G6Scope 作用域
--- @return boolean 有效则返回true，否则返回false
function G6Scope:IsScopeValid(scope)
	local nScopeType = self:GetScopeType(scope);
	if (G6Scope.SCOPE_NONE == nScopeType) then
		return false;
	elseif (G6Scope.SCOPE_SCENE == nScopeType) then
		return nil ~= string.find(scope.strSceneName,self.m_strCurSceneName);
	end

	return true;
end

--- 获取作用域描述
--- @param scope G6Scope 作用域
--- @return string 作用域描述
function G6Scope:ToString(scope)
	local nScopeType = self:GetScopeType(scope);
	if (G6Scope.SCOPE_SCENE == nScopeType) then
		return "SCOPE : Scene[" .. tostring(scope.strSceneName) .. "]";
	elseif (G6Scope.SCOPE_GLOBAL == nScopeType) then
		return "SCOPE : GLOBAL";		
	elseif (G6Scope.SCOPE_TABLE == nScopeType) then
		return "SCOPE : Table[" .. tostring(scope) .. "]";
	end

	return "SCOPE : NONE";
end

--- 获取指定SceneScope对象
---@param strSceneName string SceneScope名称
---@return G6Scope
function G6Scope:GetSceneScope(strSceneScope)
	return self.m_tSceneScope[strSceneScope];
end

--- 注册指定Scene的Scope对象
---@param strSceneScopeName string SceneScope名称
---@param strSceneName string 该SceneScope内Scene名字列表,逗号分割
function G6Scope:RegisterSceneScope(strSceneScopeName,strSceneName)
	if (strSceneScopeName and nil == self.m_tSceneScope[strSceneScopeName]) then
		self.m_tSceneScope[strSceneScopeName] = {_SCENE_SCOPE = true,strSceneName = strSceneName};
	end
end

--- 设置当前Scene
---@param strSceneName string Scene名称
function G6Scope:SetSceneName(strSceneName)
	self.m_strCurSceneName = strSceneName;
end


--- 注册Event/Timer到Scope管理器
---@param tScope G6Scope
---@param tScopeItem any @该Scope内的事件或定时器
function G6Scope:RegisterScope(tScope,tScopeItem)
	if (tScope and tScopeItem) then
		local tScopeItems = self.m_tScope[tScope];
		if (nil == tScopeItems) then
			tScopeItems = {};
			setmetatable(tScopeItems,{__mode = "kv"});
			self.m_tScope[tScope] = tScopeItems;		
		end
		tScopeItems[tScopeItem] = tScopeItem;
	end
end

--- 移除scope的注册，如果移除后scope为空，则移除整个scope
---@param Scope G6Scope 
function G6Scope:UnRegisterScope(tScope,tScopeItem)
	if (tScope) then
		local nScopeItemNum = 0;
		local tScopeItems = self.m_tScope[tScope];
		if (tScopeItems) then
			-- 移除指定scope注册
			if (tScopeItem) then	
				tScopeItems[tScopeItem] = nil;
			end

            -- 查看移除后scope是否为空
			for k,v in pairs(tScopeItems) do
				nScopeItemNum = nScopeItemNum + 1;
				break;
			end
		end

		-- 整个scope为空，移除scope
		if (0 == nScopeItemNum) then
			self.m_tScope[tScope] = nil;
		end
	end
end

--- 获取所有系统Scope定义
function G6Scope:GetAllScope()
	return self.m_tScope;
end

--- Dump所有Scope和其关联的Event/Timer
function G6Scope:DumpAllScope()
	print("---------------------------------");
	for k1,v1 in pairs(self.m_tScope) do
		print(self:ToString(k1));
		local i = 0;
		for k2,v2 in pairs(v1) do
			i = i + 1;
			print(i .. " = " .. v2:ToString());
		end
	end
end

return G6Scope;