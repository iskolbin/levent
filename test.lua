local EventPool = require'EventPool'
assert( getmetatable( EventPool()) == EventPool )
assert( getmetatable( EventPool.new()) == EventPool )
local pool = EventPool()

local processed = {}
local function onEvent( self, source, ... )
	processed[#processed+1] = self.name
	pool:emit( self, 'onEvent' )
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

for _, obj in pairs{oA, oB, oC, oD} do assert( pool:bind( o, obj )) end
for _, obj in pairs{oA1, oA2, oA3, oA4} do pool:bind( oA, obj ) end
for _, obj in pairs{oB1, oB2, oB3, oB4} do pool:bind( oB, obj ) end
for _, obj in pairs{oC1, oC2, oC3, oC4} do pool:bind( oC, obj ) end
for _, obj in pairs{oD1, oD2, oD3, oD4} do pool:bind( oD, obj ) end

pool:notify( o, 'onEvent' )

for i = 1, #processed, 5 do
	assert( #processed[i] == 2 )
	assert( #processed[i+1] == 3 )
	assert( #processed[i+2] == 3 )
	assert( #processed[i+3] == 3 )
	assert( #processed[i+4] == 3 )
end

local processed = {}
local function onEvent( self, source, ... )
	processed[#processed+1] = self.name
	assert( pool:emit( self, 'onEvent' ) == EventPool.STATUS_QUEUED )
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

for _, obj in pairs{oA, oB, oC, oD} do pool:bind( o, obj ) end
for _, obj in pairs{oA1, oA2, oA3, oA4} do pool:bind( oA, obj ) end
for _, obj in pairs{oB1, oB2, oB3, oB4} do pool:bind( oB, obj ) end
for _, obj in pairs{oC1, oC2, oC3, oC4} do pool:bind( oC, obj ) end
for _, obj in pairs{oD1, oD2, oD3, oD4} do pool:bind( oD, obj ) end

assert( pool:emit( o, 'onEvent' ), EventPool.STATUS_PROCESSED )

for i = 1, 4 do
	assert( #processed[i] == 2 )
end

for i = 5, #processed do
	assert( #processed[i] == 3 )
end

local ok, status = pool:bind( nil, {} )
assert( ok == false, status == EventPool.ERROR_NIL_SOURCE )

local ok, status = pool:bind( {}, nil )
assert( ok == false, status == EventPool.ERROR_NIL_LISTENER )

local ok, status = pool:bind( o, obj )
assert( ok == false, status == EventPool.ERROR_LISTENER_ALREADY_BINDED )

local ok, status = pool:unbind( nil, {} )
assert( ok == false, status == EventPool.ERROR_NIL_SOURCE )

local ok, status = pool:unbind( o, nil )
assert( ok == false, status == EventPool.ERROR_NIL_LISTENER )

local ok, status = pool:unbind( o, {} )
assert( ok == false, status == EventPool.ERROR_LISTENER_NOT_BINDED )

processed = {}
pool:unbind( o, oA )
pool:unbind( o, oB )
pool:unbind( o, oD )
pool:emit( o, 'onEvent' )
local expected = { oC = true, oC1 = true, oC2 = true, oC3 = true, oC4 = true }
assert( #processed == 5 )
for _, v in pairs( processed ) do
	expected[v] = nil
end
assert( next(expected) == nil )
