--[[ 
 
 event -- v0.6.4 public domain Lua event emitting/listening
 no warranty implied; use at your own risk

 author: Ilya Kolbin (iskolbin@gmail.com)
 url: github.com/iskolbin/event

 COMPATIBILITY

 Lua 5.1, 5.2, 5.3, LuaJIT 1, 2

 LICENSE

 This software is dual-licensed to the public domain and under the following
 license: you are granted a perpetual, irrevocable license to copy, modify,
 publish, and distribute this file as you see fit.

--]]

local setmetatable, pairs, next, unpack = _G.setmetatable, _G.pairs, _G.next, _G.unpack or table.unpack

local EventPool = {
	STATUS_PROCESSED = 'Processed',
	STATUS_QUEUED = 'Queued',
	ERROR_NIL_LISTENER = 'Listener is nil',
	ERROR_NIL_SOURCE = 'Source is nil',
	ERROR_LISTENER_ALREADY_BINDED = 'Listener is already binded',
	ERROR_LISTENER_NOT_BINDED = 'Listener is not binded',
}

EventPool.__index = EventPool

function EventPool.new()
	return setmetatable( {
		_listeners = setmetatable( {}, {__mode = 'k'} ),
		_queue = {},
	}, EventPool )
end

function EventPool:bind( source, listener )
	if source == nil then return false, EventPool.ERROR_NIL_SOURCE end
	if listener == nil then return false, EventPool.ERROR_NIL_LISTENER end

	local listeners = self._listeners[source]
	if not listeners then
		self._listeners[source] = {[listener] = listener}
	else
		if listeners[listener] == nil then
			listeners[listener] = listener
		else
			return false, EventPool.ERROR_LISTENER_ALREADY_BINDED
		end
	end
	return true
end
		
function EventPool:unbind( source, listener )
	if source == nil then return false, EventPool.ERROR_NIL_SOURCE end
	if listener == nil then return false, EventPool.ERROR_NIL_LISTENER end

	local listeners = self._listeners[source] 
	if listeners and listeners[listener] then
		listeners[listener] = nil
		if not next( listeners ) then	
			self._listeners[source] = nil
		end
	else
		return false, EventPool.ERROR_LISTENER_NOT_BINDED
	end
	return true
end

function EventPool:notify( source, message, ... )
	local listeners = self._listeners[source]
	if listeners then
		for listener, _ in pairs( listeners ) do
			if listener[message] then
				listener[message]( listener, source, ... )
			end
		end
	end
end

function EventPool:emit( source, message, ... )
	local queue = self._queue
	if not queue[1] then
		queue[1] = true
		self:notify( source, message, ... )
		local processed = 2
		while queue[processed] ~= nil do
			self:notify( unpack( queue[processed] ))
			processed = processed + 1
		end

		if processed > 2 then
			self._queue = {}
		else
			self._queue[1] = nil
		end

		return EventPool.STATUS_PROCESSED
	else
		queue[#queue+1] = {source, message, ...}
		return EventPool.STATUS_QUEUED
	end
end

return setmetatable( EventPool, { __call = function(_,...)
	return EventPool.new( ... )
end })
