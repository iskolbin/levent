local event = require'event'

print( 'Async' )

local function onEvent( self, source, ... )
	print( 'Processed by:', self.name, 'received from:', source.name )
	event.emit( self, 'onEvent' )
end

local o = {name = 'o'}
local oA = {name = 'oA', onEvent = onEvent}
local oB = {name = 'oB', onEvent = onEvent}
local oC = {name = 'oC', onEvent = onEvent}
local oD = {name = 'oD', onEvent = onEvent}
local oA1 = {name = 'oA1', onEvent = onEvent}
local oA2 = {name = 'oA2', onEvent = onEvent}
local oA3 = {name = 'oA3', onEvent = onEvent}
local oA4 = {name = 'oA4', onEvent = onEvent}
local oB1 = {name = 'oB1', onEvent = onEvent}
local oB2 = {name = 'oB2', onEvent = onEvent}
local oB3 = {name = 'oB3', onEvent = onEvent}
local oB4 = {name = 'oB4', onEvent = onEvent}
local oC1 = {name = 'oC1', onEvent = onEvent}
local oC2 = {name = 'oC2', onEvent = onEvent}
local oC3 = {name = 'oC3', onEvent = onEvent}
local oC4 = {name = 'oC4', onEvent = onEvent}
local oD1 = {name = 'oD1', onEvent = onEvent}
local oD2 = {name = 'oD2', onEvent = onEvent}
local oD3 = {name = 'oD3', onEvent = onEvent}
local oD4 = {name = 'oD4', onEvent = onEvent}

event.bindAll( o, {oA, oB, oC, oD} )
event.bindAll( oA, {oA1, oA2, oA3, oA4} )
event.bindAll( oB, {oB1, oB2, oB3, oB4} )
event.bindAll( oC, {oC1, oC2, oC3, oC4} )
event.bindAll( oD, {oD1, oD2, oD3, oD4} )

event.async( o, 'onEvent' )


print()
print('Sync')

local function onEvent( self, source, ... )
	print( 'Processed by:', self.name, 'received from:', source.name )
	event.emit( self, 'onEvent' )
end

local o = {name = 'o'}
local oA = {name = 'oA', onEvent = onEvent}
local oB = {name = 'oB', onEvent = onEvent}
local oC = {name = 'oC', onEvent = onEvent}
local oD = {name = 'oD', onEvent = onEvent}
local oA1 = {name = 'oA1', onEvent = onEvent}
local oA2 = {name = 'oA2', onEvent = onEvent}
local oA3 = {name = 'oA3', onEvent = onEvent}
local oA4 = {name = 'oA4', onEvent = onEvent}
local oB1 = {name = 'oB1', onEvent = onEvent}
local oB2 = {name = 'oB2', onEvent = onEvent}
local oB3 = {name = 'oB3', onEvent = onEvent}
local oB4 = {name = 'oB4', onEvent = onEvent}
local oC1 = {name = 'oC1', onEvent = onEvent}
local oC2 = {name = 'oC2', onEvent = onEvent}
local oC3 = {name = 'oC3', onEvent = onEvent}
local oC4 = {name = 'oC4', onEvent = onEvent}
local oD1 = {name = 'oD1', onEvent = onEvent}
local oD2 = {name = 'oD2', onEvent = onEvent}
local oD3 = {name = 'oD3', onEvent = onEvent}
local oD4 = {name = 'oD4', onEvent = onEvent}

event.bindAll( o, {oA, oB, oC, oD} )
event.bindAll( oA, {oA1, oA2, oA3, oA4} )
event.bindAll( oB, {oB1, oB2, oB3, oB4} )
event.bindAll( oC, {oC1, oC2, oC3, oC4} )
event.bindAll( oD, {oD1, oD2, oD3, oD4} )

event.emit( o, 'onEvent' )
