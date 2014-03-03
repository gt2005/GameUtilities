
WindowsManager
=============
在游戏制作过程中经常会遇到ui界面互斥或共存的问题，WindowsManager用来解决此类问题。它将ui面板分组，同一组的ui面板默认是共存的，不同组的ui面板默认是互斥的。但是可以通过调用特定的接口让不同组的ui面板共存，同时也可以实现同组的ui面板互斥，并且提供了两种共存互斥关系的优先级。BigInteger类来自[as3crypto](http://code.google.com/p/as3crypto/)项目

Ascript控制台
=============
Ascript控制台程序是Ascript脚本的控制台程序，任何as3程序都可以通过简单的加载一个15KB的GDebug.swf文件来内嵌Ascript脚本和Ascript控制台，Ascript脚本语言是一种解释型语言，和AS3几乎无缝结合，可以允许开发者在开发过程中**动态调用主程序自定义和As3的接口**，也可以让开发者在开发过程中向控制台输出一些内容。在主程序运行的过程中默认可以通过Ctrl+F2呼出控制台。

[**点我了解Ascript脚本语言**](https://github.com/softplat/ascript)
