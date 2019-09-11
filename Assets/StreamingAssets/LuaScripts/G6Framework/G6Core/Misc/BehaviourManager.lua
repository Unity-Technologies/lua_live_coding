local BehaviourManager = _G.Class("BehaviourManager")

function BehaviourManager:ctor()
	self._behaviours = {}
	self._waitForVisibleBehaviours = {}
end

function BehaviourManager:CreateBehaviour(typename, go)
	local path = typename
	local Class = require(path)

	local lb = Class.New(go)

	self._behaviours[lb._targetID] = lb

	self:BindEvents(lb)

	return lb
end

function BehaviourManager:ReloadBehaviour(typename)
	g6hotfix.HotFixOneFile(typename)
end

function BehaviourManager:Update()
	for i,v in ipairs(self._waitForVisibleBehaviours) do
		if v ~= nil then
			local lb = v
			lb:OnVisible()
		end
	end

	self._waitForVisibleBehaviours = {}
end

function BehaviourManager:BindEvents(lb)
	local go = lb._target
	local lo = lb._luaOperation

	lb:CheckAndBindPrevEvents()
	
	local target_methods = { "OnAwake", "OnStart", "OnEnable", "OnDisable", "OnDestroy", "OnUpdate", "OnFixedUpdate" }
	local events = { "AwakeEvent", "StartEvent", "EnableEvent", "DisableEvent", "DestroyEvent", "UpdateEvent", "FixedUpdateEvent" }
  
	for i = 1, #target_methods do
		local func = lb[target_methods[i]]
		if func then
		  local event = lo[events[i]]
		  if event then
			  event(lo, '+', 
			    function()
				    func(lb)
			    end)
			end
		end
	end

	lb:CheckAndBindLaterEvents()
end

function BehaviourManager:GetBehaviour(id)
	return self._behaviours[id]
end

function BehaviourManager:DestroyBehaviour(lb)
	self._behaviours[lb._targetID] = nil
	-- print("Destroy frome LuaBehaviourManager: " .. lb._targetID)
end

function BehaviourManager:RegisterForVisibleEvent(lb)
	table.insert(self._waitForVisibleBehaviours, lb)
end

function BehaviourManager:UnregisterForVisibleEvent(lb)
	for i,v in ipairs(self._waitForVisibleBehaviours) do
		if v == lb then
			table.remove(self._waitForVisibleBehaviours, i)
			break
		end
	end
end

function BehaviourManager:CleanBehaviourCache(typename)
	--local klass = package.loaded[typename]
	--if klass then
	--	local className = klass:name()
	--	classic._registry[className] = nil -- NOTE : remove the check of duplicate class definition, be careful
	--	package.loaded[typename] = nil
	--end
end

return BehaviourManager