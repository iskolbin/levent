event
=====

Lua event emitter/listener implementation. Implementation is using queue, so
it's always ok to emit messages during processing of previous message. While
you can use this library as singleton, another possibility is define separate
pool (see below).

In the library there is defined type `EventPool` which handles emitting and 
binding of listeners.

```lua
local eventpool = EventPool.new()
--or
local eventpool2 = EventPool()
```

As a convinience `event` has default pool to use static functions.

EventPool.new()
---------------

Creates new `EventPool`.

EventPool:bind( source, listener )
----------------------------------

Bind `listener` to messages emitable by `source`. After `source` emits any messages
pool will lookup callbacks from `listener`. Returns `true` on success and `false` + 
error on fail. Possible errors are:

* `event.ERROR_NIL_LISTENER`, if `listener` is `nil`
* `event.ERROR_LISTENER_ALREADY_BINDED`, if `listener` is already binded to `source`

```lua
local src = {}
local list = {}
event.bind( src, list ) -- now list listens to src
```

EventPool:unbind( source, listener )
------------------------------------

Unbind `listener` from `source`. Returns `true` on success and `false` + error
on fail. Possible errors are:

* `event.ERROR_NIL_LISTENER`, if `listener` is `nil`
* `event.ERROR_LISTENER_NOT_BINDED`, if `listener` is not binded to `source`

EventPool:emit( source, message, ... )
--------------------------------------

Emits `message` from `source`. All binded listeners with field `message` will
be notified and according method (`message`) will be called with passed varargs.
Function can return:

* `event.STATUS_PROCESSED`, if events queue was empty
* `event.STATUS_QUEUED`, if events queue wasn't empty and message was queued

```lua
local src = { name = 'src', }
local list1 = { name = 'list1', onMessage = function( self, source, msg )
	print( self.name, source.name, msg )
end }
event.bind( src, list1 )
event.emit( src, 'onMessage', 42 ) -- will print list1, src, 42
```

EventPool:notify( source, message, ... )
----------------------------------------

Lower level of `emit` (internally `emit` is implemented using `notify`) this
function directly notifies all listeners without queueing. This is a bit faster,
but in many cases it can lead to very hard to catch bugs. It's better just not
to use this function.
