# 如果你想要, 你得自己来拿

阅读自机相关的data内容对理解自机运行的原理有很大帮助.
翻data这件事并不容易, 我会帮你作一些整理,
但是我仍然非常希望你亲自去读一读data里面相关的内容.
如果你不知道如何查看data的相关内容, 也许这里可以帮到你.

要查看data, 通常你需要一个代码编辑器, 比如 Visual Studio Code (VSCode). 
为了方便查阅, 通常需要编辑器有全局查找功能, 以及对lua语言的语法高亮, 查找引用等的支持.
我将以VSCode为例介绍查阅自机相关data的方法, 如果你在使用其他编辑器也可以适当的参考.
如果你在使用记事本, 呃, 你开心就好......

我们在编辑器中打开 LuaSTG 所在的文件夹, 文件夹里应当包含所有的lua文件,
我们说翻data的时候就是指翻这些lua文件.

<img src="/lstg-player-tutorial/assets/images/if-you-want-it-1.png" alt="VSCode文件搜索" style="width: 90%; display: block; margin: 0 auto;">

我们可以按下 `ctrl+p` 快捷键搜索名字里带 "`player`" 的文件,
有 `player.lua, player_system.lua` 两个lua文件,
这两个文件包含了大部分的自机逻辑, 我们之后会重点分析.

<img src="/lstg-player-tutorial/assets/images/if-you-want-it-3.png" alt="文件列表" style="width: 90%; display: block; margin: 0 auto;">

使用全局搜索功能 (在VSCode中有快捷键 `ctrl+shift+f`),
我们可以搜索所有文件中出现的 "`player`".
由于自机的特殊性, 与自机相关的地方几乎都会含有 "`player`" (不区分大小写).
虽然搜索结果大部分并不重要而且挺难看懂, 但这样我们可以几乎没有遗漏地找到所有的自机相关内容.

<img src="/lstg-player-tutorial/assets/images/if-you-want-it-2.png" alt="全局搜索" style="width: 70%; display: block; margin: 0 auto;">

于是自机相关的文件如下:
+ [`THlib\player\player.lua`](../appendix/player-lua.md) \
  浅层的自机逻辑, 涉及自机的基类以及一些自机相关的class和函数;
+ [`THlib\player\player_system.lua`](../appendix/player-system-lua.md) \
  深层的自机逻辑, 涉及大量的自机特有的属性和行为;
+ `plugins\PlayerExtensions` \
  自带的灵梦, 魔理沙, 咲夜自机;
+ [`THlib\WalkImageSystem.lua`](../appendix/wisys-lua.md) \
  自机使用的行走图系统 `PlayerWalkImageSystem`
+ [`doc\core\lstg.GameObject.lua`](../appendix/lstg-gameobject.md) \
  虽然不是自机相关, 但这里说明了所有 class, object 共有的属性;

