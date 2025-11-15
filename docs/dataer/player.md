# `player.lua` 解析

## `player_lib`

起到一个命名空间的作用, 纯粹就是含有一些自机组件的一个table.

## `player_class`

这是自机需要继承的class (也就是每个自机都会有的`xxx_player = Class(player_class)`).

根据`Class`函数的原理 (`thlib-scripts\lib\Lobject.lua`),
当一个自机class继承`player_class`时, 它会自动获得`player_class`的
`init,frame,render,colli,kill,del`六个函数.

同样地, `player_class = Class(object)`会让`player_class`获得`object`的六个回调.
然后, data重写了其中四个: `init,frame,render,colli`.

至于`kill,del`, 自机在这里是非常特殊的:
一般的object在触发碰撞时会执行`kill`回调函数删掉自己,
或者在需要时触发`del`或`kill`回调函数删掉自己.
而自机在触发碰撞时进行了特殊的处理, 被设计成不会触发`kill,del`回调
(具体见 `/*TODO*/`), 所以data没有重写`player_class`的对应回调.

这四个回调写的很简单, 主要就是对 `player_lib.system` 的调用,
详细的逻辑见 [`player_system.lua`解析](./player-system.md).

### `player_class:findtarget()`

这个函数用于给自机寻找一个要追踪的敌人.

虽然看起来像是自机特有的一个回调函数, 但是它只是一个普通的函数,
普通地挂在`player_class`这个表上.

用冒号 ":" 表示成员函数是Lua的一种简写语法 (语法糖),
```lua
function player_class:findtarget() ... end
```
实际上等价于
```lua
function player_class.findtarget(self) ... end
```
这里的参数`self`没有什么特殊的语法性质, 调用的时候填什么都可以.
而LuaSTG的类方法通常将`self`作为object进行处理.

所以如果查找出现`player_class.findtarget`的地方,
我们会发现有一些并不是自机的obj也会调用这个函数,
这不符合面向对象的理念, 但是在Lua里没有任何问题.

这个函数的逻辑是这样的: 对于`player_class.findtarget(obj)`的调用,

(1) 遍历所有的开启碰撞 (`.colli`为真) 的敌人
    (有体术判定的`GROUP_ENEMY`碰撞组和没有体术的`GROUP_NONTJT`碰撞组),
(2) 比较敌人与`obj`连线斜率的绝对值大小, 选择绝对值最大的敌人, 赋值给`obj.target`.

也就是说, 追踪敌人的优先级如下图:

<div style="text-align: center; margin: 20px 0;">
  <div style="position: relative; display: inline-block; width: 300px; height: 300px;">
    <svg width="300" height="300" style="position: absolute; top: 0; left: 0;">
      <line x1="50" y1="150" x2="250" y2="150" stroke="#333" stroke-width="2"></line>
      <line x1="150" y1="50" x2="150" y2="250" stroke="#333" stroke-width="2"></line>
      <line x1="50" y1="50" x2="250" y2="250" stroke="#333" stroke-width="1" stroke-dasharray="5,5"></line>
      <line x1="250" y1="50" x2="50" y2="250" stroke="#333" stroke-width="1" stroke-dasharray="5,5"></line>
      <rect x="130" y="130" width="40" height="40" fill="white" stroke="#333" stroke-width="2" rx="4"></rect>
      <circle cx="220" cy="80" r="8" fill="#ff9800"></circle>
    </svg>
    <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); padding: 10px; background: white; border: 2px solid #333; border-radius: 4px; font-weight: bold;">obj</div>
    <div style="position: absolute; top: 10px; left: 50%; transform: translateX(-50%); color: #d32f2f; font-weight: bold; font-size: 12px;">优先级最高</div>
    <div style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); color: #d32f2f; font-weight: bold; font-size: 12px;">优先级最高</div>
    <div style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #1976d2; font-weight: bold; font-size: 12px;">优先级最低</div>
    <div style="position: absolute; top: 50%; right: 10px; transform: translateY(-50%); color: #1976d2; font-weight: bold; font-size: 12px;">优先级最低</div>
    <div style="position: absolute; top: 80px; right: 80px; font-size: 11px;">enemy</div>
  </div>
</div>

## `MixTable(x, t1, t2)`

"子机位置表的线性插值", 注释如是写道. 具体解析见 `/*TODO*/`.

## `grazer`

负责自机擦弹圈的判定和低速aura的渲染, 不知道有什么能写的.

值得注意的是`grazer`的碰撞组是`GROUP_PLAYER`, 某些特殊需求可能会用到.

## `death_weapon`

负责在自机miss时对敌人造成反伤, 在自机miss时自动生成一个.

手写判定, 从第60f开始,
对半径800范围内的开启碰撞的每个敌人造成 $30\text{f} \cdot 0.75/\text{f} = 22.5$ 的伤害.

## `player_bullet_straight` {#player_bullet_straight}

直线自机子弹的模板, 展示了一个自机子弹需要配置的基本属性.
除了所有obj共有的属性之外, 还有`dmg`属性 (damage, 伤害).

注意它的 `init()` 参数中没有判定大小 `a,b`,
它的判定大小是由贴图加载时设置的判定大小确定的.
如果你的子弹需要单独修改判定, 需要在设置`img`属性之后再设置`a,b`属性.

## `player_bullet_hide`

隐形的直线自机子弹, 在`delay`帧后开启判定.
如果需要一开始就开启判定, 可以不传入`delay`参数, 或者传入0.

函数内容有一句 `self.delay = delay or 0`,
这样在不传入`delay`参数时 (此时`delay == nil`),
`self.delay`会设置为0. 这是有默认值的函数参数的常见写法.

## `player_bullet_trail`

诱导弹模板, 在灵梦机体中被用到. 它的目标obj在init回调传入, 之后不再改变.

它的追踪原理写的很难懂, 我也没有完全理解. 代码直译如下:

设子弹当前位置为 $S$, 目标位置为 $T$,
子弹朝向 `self.rot` = $\theta$, 传入参数 `trail` = $t$.

子弹的速度大小不变, 运动方向和贴图朝向一致.
当目标存在且开启碰撞时, 子弹的朝向发生改变:

<div style="overflow: visible; margin: 1em 0;">

$$
\begin{aligned}
\Delta\theta &:= (\text{Angle}(S,T) - \theta) \bmod 360°,\\
&\quad -180° < \Delta\theta \leq 180°,\\
\gamma &:= \frac{t \cdot 1°}{|ST| + 1},\\
\theta' &:= \begin{cases}
\text{Angle}(S,T) & \text{若 } |\Delta\theta| \leq \gamma,\\
\theta + \gamma \cdot \text{sign}(\Delta\theta) & \text{若 } |\Delta\theta| > \gamma.
\end{cases}
\end{aligned}
$$

</div>

其中 $|ST|$ 表示 $S$ 和 $T$ 之间的距离.

$\theta'$ 为更新后的子弹朝向.

追踪的过程是子弹朝向逐渐靠近与敌人连线方向的方向,
当朝向足够接近时直接设置为连线方向.
与敌人距离越近, 朝向变化速率越快.

## `player_spell_mask`

自机bomb的遮罩特效.

`r,g,b`参数表示整体颜色.

`0 ~ t1`时间段, 不透明度从0过渡到255;
`t1 ~ (t1+t2)`时间段, 不透明度不变;
`(t1+t2) ~ (t1+t2+t3)`时间段, 不透明度从255过渡到0.

## `player_death_ef, deatheff`

负责自机死亡特效的渲染, 好像也没有能讲的东西.

特效一般由effect这个词表示, 进而缩写为ef或eff.

## `AddPlayerToPlayerList(...)`

其他几个自机加载的函数不用看, 都没有实际用到.

`AddPlayerToPlayerList`负责将自机信息添加到一个全局表.
所谓的自机信息, 就是三个字符串, 含义在函数注释中说明了.

值得注意的是`classname`, 它对应我们编写自机class的变量名.
这就要求我们的自机class必须是全局变量. 这涉及全局变量的原理.

在Lua中, 全局变量被保存在名为`_G`的table中,
以变量名为索引可以获取对应的全局变量.
比如我们可以通过`_G["lstg"]`读取全局变量`lstg`.

对于自机也是这样.在*进入关卡*时,
data会根据变量名查找全局的自机class, 从而生成对应的自机obj.

这意味着, 我们对`AddPlayerToPlayerList`的调用位置其实是比较随意的.
自带自机将调用写在自机文件最后面,
我们也可以把调用写在定义自机class变量之后,
甚至写在定义自机之前也不会影响运行.

