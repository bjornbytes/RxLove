RxLove
===

Turn Love2D events into reactive streams:

```lua
require 'rx'
require 'rx-love'

love.keypressed
  :filter(function(key) return key == ' ' end)
  :subscribe(function()
    print('You pressed the space bar')
  end)
```

See [dragAndDrop.lua](dragAndDrop.lua) and [pong.lua](pong.lua) for more examples. Requires [RxLua](https://github.com/bjornbytes/RxLua).
See [Reactive Extensions](http://reactivex.io) for more info.

License
---

MIT, see [`LICENSE`](LICENSE) for details.
