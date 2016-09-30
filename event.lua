local pairs, unpack = _G.pairs, _G.unpack or table.unpack

local _listeners = setmetatable( {}, {__mode = 'k'} )
local _n = setmetatable( {}, {__mode = 'k'} )
local _queue = {}
local _m = 0
local _locked = false

local event = {} 

function event.bind( source, listener )
	if listener ~= nil then
		local listeners = _listeners[source]
		if not listeners then
			_listeners[source] = {[listener] = listener}
			_n[source] = 1
		else
			if listeners[listener] == nil then
				_n[source] = _n[source] + 1
			end
			listeners[listener] = listener
		end
	end
end
		
function event.unbind( source, listener )
	if listener ~= nil then
		local listeners = _listeners[source] 
		if listeners and listeners[listener] then
			local n = _n[source]
			if n > 1 then
				listeners[listener] = nil
				_n[source] = n - 1
			else
				_listeners[source] = nil
				_n[source] = nil
			end
		end
	end
end

local function async( source, message, ... )
	local listeners = _listeners[source]
	if listeners then
		for listener, _ in pairs( listeners ) do
			if listener[message] then
				listener[message]( listener, source, ... )
			end
		end
	end
end

event.async = async

function event.emit( source, message, ... )
	if _locked == false then
		_locked = true
		async( source, message, ... )
		local i = 0
		while i < _m do
			i = i + 1
			async( unpack( _queue[i] ))
		end

		if _m > 0 then
			_queue, _m = {}, 0
		end

		_locked = false
	else
		_m = _m + 1
		_queue[_m] = {source, message, ...}
	end
end

return event
