
local G6LuaList = {}
G6LuaList.__index = G6LuaList

function G6LuaList:new()
	local t = {length = 0, _prev = 0, _next = 0}
	t._prev = t
	t._next = t
	return setmetatable(t, G6LuaList)
end

function G6LuaList:clear()
	self._next = self
	self._prev = self
	self.length = 0
end

function G6LuaList:push(value)
	--assert(value)
	local node = {value = value, _prev = 0, _next = 0, removed = false}

	self._prev._next = node
	node._next = self
	node._prev = self._prev
	self._prev = node

	self.length = self.length + 1
	return node
end

function G6LuaList:pushnode(node)
	if not node.removed then return end

	self._prev._next = node
	node._next = self
	node._prev = self._prev
	self._prev = node
	node.removed = false
	self.length = self.length + 1
end

function G6LuaList:pop()
	local _prev = self._prev
	self:remove(_prev)
	return _prev.value
end

function G6LuaList:unshift(v)
	local node = {value = v, _prev = 0, _next = 0, removed = false}

	self._next._prev = node
	node._prev = self
	node._next = self._next
	self._next = node

	self.length = self.length + 1
	return node
end

function G6LuaList:shift()
	local _next = self._next
	self:remove(_next)
	return _next.value
end

function G6LuaList:remove(iter)
	if iter.removed then return end

	local _prev = iter._prev
	local _next = iter._next
	_next._prev = _prev
	_prev._next = _next
	
	self.length = math.max(0, self.length - 1)
	iter.removed = true
end

function G6LuaList:find(v, iter)
	iter = iter or self

	repeat
		if v == iter.value then
			return iter
		else
			iter = iter._next
		end		
	until iter == self

	return nil
end

function G6LuaList:findlast(v, iter)
	iter = iter or self

	repeat
		if v == iter.value then
			return iter
		end

		iter = iter._prev
	until iter == self

	return nil
end

function G6LuaList:next(iter)
	local _next = iter._next
	if _next ~= self then
		return _next, _next.value
	end

	return nil
end

function G6LuaList:prev(iter)
	local _prev = iter._prev
	if _prev ~= self then
		return _prev, _prev.value
	end

	return nil
end

function G6LuaList:erase(v)
	local iter = self:find(v)

	if iter then
		self:remove(iter)		
	end
end

function G6LuaList:insert(v, iter)	
	if not iter then
		return self:push(v)
	end

	local node = {value = v, _next = 0, _prev = 0, removed = false}

	if iter._next then
		iter._next._prev = node
		node._next = iter._next
	else
		self.last = node
	end

	node._prev = iter
	iter._next = node
	self.length = self.length + 1
	return node
end

function G6LuaList:head()
	return self._next.value
end

function G6LuaList:tail()
	return self._prev.value
end

function G6LuaList:clone()
	local t = G6LuaList:new()

	for i, v in G6LuaList.next, self, self do
		t:push(v)
	end

	return t
end

G6LuaList.iG6LuaList = function(_G6LuaList) return G6LuaList.next, _G6LuaList, _G6LuaList end
G6LuaList.riG6LuaList = function(_G6LuaList) return G6LuaList.prev, _G6LuaList, _G6LuaList end

setmetatable(G6LuaList, {__call = G6LuaList.new})
return G6LuaList