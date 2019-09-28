DanmakuLove is a open source Shmup engine using LÖVE, a 2D game framework. LÖVE is a free 2D framework that uses Lua for programming. DanmakuLove was inspired by Touhou Danmakufu, a similar STG maker, and has many of the same features.

Vs Danmakufu:

Pros:
-Open source
-All defaults are configurable
-Regular updates
-Lua, a relatively easy to learn language with wide usage and support (compared to Danmakufu's special C-like language)
-Generally higher performance (needs testing)
-Does not have most of Danmakufu's weird quirks (e.g. shotsheet bullet rotation)
-Ability to use multiple processing threads
-Access to LÖVE's powerful array of advanced features, including physics, particle effects, and video rendering
-Access to a wide variety of libraries and tools made by the LÖVE community

Cons:
-No native 3D support, including 3D models. 3D Touhou-like backgrounds can be achieved but with limitations. Among the libraries packaged with DanmakuLove is Playmat, which can greatly assist with this. However, some effects provided by Danmakufu, like fog, are much more difficult to replicate, requiring the usage of shaders.
-A third-party 3D module called LÖVE3D also exists, but its utilization is very complicated.
-No native support for text effects, e.g. bolding, stroke (outline), and gradient overlays. Workarounds exist through the usage of Bitmap Fonts (BMFonts) that LÖVE is capable of using. Bitmap Fonts can be created from standard TrueType Fonts with the desired effects with outside programs and then used by LÖVE. I recommend Littera as an easy to use, browser based BMFont generator.
-Still missing a number of essential features (WIP)
