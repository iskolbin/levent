![Build Status](https://travis-ci.org/iskolbin/event.svg?branch=master)
[![license](https://img.shields.io/badge/license-public%20domain-blue.svg)]()

Event
=====

Lua event emitter/listener implementation. Implementation uses queueing, so
it's always ok to emit messages during processing of previous message. The
only pitfall you may encounter is that you can actually create deadlock if
you recursively emit messages.

In the library there is defined type `EventPool` which handles emitting and 
binding of listeners.

```lua
local pool = EventPool.new()
--or
local pool2 = EventPool()
```

EventPool.new()
---------------

Creates new `EventPool`.

EventPool:bind( source, listener )
----------------------------------

Bind `listener` to messages emitable by `source`. After `source` emits any messages
pool will lookup callbacks from `listener`. Returns `true` on success and `false` + 
error on fail. Possible errors are:

* `EventPool.ERROR_NIL_SOURCE`, if `source` is `nil`
* `EventPool.ERROR_NIL_LISTENER`, if `listener` is `nil`
* `EventPool.ERROR_LISTENER_ALREADY_BINDED`, if `listener` is already binded to `source`

```lua
local src = {}
local list = {}
pool:bind( src, list ) -- now list listens to src
```

EventPool:unbind( source, listener )
------------------------------------

Unbind `listener` from `source`. Returns `true` on success and `false` + error
on fail. Possible errors are:

* `EventPool.ERROR_NIL_SOURCE`, if `source` is `nil`
* `EventPool.ERROR_NIL_LISTENER`, if `listener` is `nil`
* `EventPool.ERROR_LISTENER_NOT_BINDED`, if `listener` is not binded to `source`

EventPool:emit( source, message, ... )
--------------------------------------

Emits `message` from `source`. All binded listeners with field `message` will
be notified and according method (`message`) will be called with passed varargs.
Function can return:

* `EventPool.STATUS_PROCESSED`, if events queue was empty
* `EventPool.STATUS_QUEUED`, if events queue wasn't empty and message was queued

```lua
local src = { name = 'src', }
local list1 = { name = 'list1', onMessage = function( self, source, msg )
	print( self.name, source.name, msg )
end }
pool:bind( src, list1 )
pool:emit( src, 'onMessage', 42 ) -- will print list1, src, 42
```

EventPool:notify( source, message, ... )
----------------------------------------

Lower level of `emit` (internally `emit` is implemented using `notify`) this
function directly notifies all listeners without queueing. This is a bit faster,
but in many cases it can lead to very hard to catch bugs. It's better just not
to use this function.
