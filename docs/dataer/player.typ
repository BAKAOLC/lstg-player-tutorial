#import "/include.typ": *

#show: book-page

= `player.lua` 解析

== `player_lib: table`（全局变量）

起到一个命名空间的作用，纯粹就是含有一些自机组件的一个table。

== `player_class: class`（全局变量）

这是自机需要继承的class（也就是每个自机都会有的`xxx_player = Class(player_class)`）。

根据`Class`函数的原理（`thlib-scripts\lib\Lobject.lua`），当一个自机class继承`player_class`时，它会自动获得`player_class`的`init,frame,render,colli,kill,del`六个函数。

同样地，`player_class = Class(object)`会让`player_class`获得`object`的六个函数。`object`是最基础的class，然后，data重写了其中四个：`init,frame,render,colli`。

至于`kill,del`，自机在这里是非常特殊的：一般的object在触发碰撞时会执行`kill`回调函数删掉自己，或者在需要时触发`del`回调函数删掉自己，而自机在触发碰撞时进行了特殊的处理，被设计成不会触发`kill,del`回调（具体见 \/\*TODO\*\/）。所以data没有重写`player_class`的对应回调。

这四个回调写的很简单，主要就是对 `player_lib.system` 的调用，详细的逻辑见 #cross-ref("/docs/dataer/player-system.typ")[`player_system.lua`解析]。

=== `player_class:findtarget()`

这个函数用于给自机寻找一个要追踪的敌人。

虽然看起来像是自机特有的一个回调函数，但是它只是一个普通的函数，挂在`player_class`这个table上，它是不会继承给自机class的。

用冒号 ":" 表示成员函数是Lua的一种简写语法（语法糖），
```lua
function player_class:findtarget() ... end
```
实际上等价于
```lua
function player_class.findtarget(self) ... end
```
这里的参数`self`没有什么特殊的语法性质，调用的时候填什么都可以，而LuaSTG的类方法通常将`self`作为object进行处理。

所以如果查找出现`player_class.findtarget`的地方，我们会发现有一些并不是自机的obj也会调用这个函数，这样做不符合面向对象的理念，但是在Lua里没有任何问题。

这个函数的逻辑是这样的：对于`player_class.findtarget(obj)`的调用，

#set enum(numbering: "(1)")
+ 遍历所有的开启碰撞（`.colli`为真）的敌人（有体术判定的`GROUP_ENEMY`碰撞组和没有体术的`GROUP_NONTJT`碰撞组），
+ 比较敌人与`obj`连线斜率的绝对值大小，选择绝对值最大的敌人，赋值给`obj.target`。

也就是说，追踪敌人的优先级如下图：
#figure(
  cetz.canvas({
    import cetz.draw: *

    let r = 2

    line((-r, 0), (r, 0), stroke: main-color)
    line((0, -r), (0, r), stroke: main-color)

    content((0, 0), `obj`)
    content((90deg, r), [`优先级最高`], anchor: "south")
    content((-90deg, r), [`优先级最高`], anchor: "north")
    content((0deg, r), [`优先级最低`], anchor: "west")
    content((180deg, r), [`优先级最低`], anchor: "east")
  }),
)
