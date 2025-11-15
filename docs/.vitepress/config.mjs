import { defineConfig } from 'vitepress'
import mathjax3 from 'markdown-it-mathjax3'

export default defineConfig({
  title: '何日完工?',
  description: 'LuaSTG 自机教程',
  base: '/lstg-player-tutorial/',
  
  themeConfig: {
    nav: [
      { text: '首页', link: '/' },
      { text: 'GitHub', link: 'https://github.com/TengoDango/lstg-player-tutorial' }
    ],
    
    sidebar: [
      {
        text: '从零开始的写自机之旅',
        items: [
          { text: '那么从哪里开始呢', link: '/mainline/beginning' }
        ]
      },
      {
        text: '我要翻 data!',
        items: [
          { text: '如果你想要, 你得自己来拿', link: '/dataer/if-you-want-it' },
          { text: 'player.lua 解析', link: '/dataer/player' },
          { text: 'player_system.lua 解析', link: '/dataer/player-system' },
          { text: 'PlayerWalkImageSystem 解析', link: '/dataer/wisys' },
          { text: '杂项', link: '/dataer/others' }
        ]
      },
      {
        text: '没人看的附录',
        items: [
          { text: 'lstg.GameObject.lua', link: '/appendix/lstg-gameobject' },
          { text: 'player.lua', link: '/appendix/player-lua' },
          { text: 'player_system.lua', link: '/appendix/player-system-lua' },
          { text: 'PlayerWalkImageSystem', link: '/appendix/wisys-lua' }
        ]
      }
    ],
    
    socialLinks: [
      { icon: 'github', link: 'https://github.com/TengoDango/lstg-player-tutorial' }
    ],
    
    search: {
      provider: 'local'
    }
  },
  
  markdown: {
    lineNumbers: true,
    math: true,
    config: (md) => {
      md.use(mathjax3)
    }
  }
})

