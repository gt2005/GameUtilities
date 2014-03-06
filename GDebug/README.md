Ascript控制台
=============
Ascript控制台程序是Ascript脚本的控制台程序，任何as3程序都可以**通过简单的加载一个15KB的GDebug.swf**文件来内嵌Ascript脚本和Ascript控制台。Ascript控制台用于Ascript脚本输出以及动态执行脚本。

Ascript脚本语言是一种解释型语言，和AS3几乎无缝结合，可以允许开发者在开发过程中**动态调用主程序自定义的接口和ActionScript的接口**，与Lua相比，它的特点之一就是支持类。Ascript一个典型案例就是用于ios项目的热更新。

[**点我了解Ascript脚本语言**](https://github.com/softplat/ascript)

装载控制台
=============
下载bin-release目录下的GDebug.swf文件，在主程序中加载GDebug.swf，可以参考以下方式：

    loader=new Loader();
	//Debug/GDebug.swf为GDebug.swf所在的目录，请替换成GDebug.swf的真正的路径
    loader.load(new URLRequest("Debug/GDebug.swf?v="+Math.random()));
    loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDebugComplete);
    loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);

在加载完成的回调函数（在上面的代码中是onLoadDebugComplete函数）里初始化GDebug模块，参考代码：

    var debug:Object=loader.content;
    //Init接受文档类的实例作为参数，也可以传递任何sprite作为参数，控制台的界面将会加载到这个sprite上
    debug.Init(rootDocument);



在主程序运行的过程中默认可以通过Ctrl+F2呼出控制台。

也可以屏蔽默认的打开方式，由主程序决定何时显示/隐藏Ascript控制台。

下面是一个单纯的Ascript控制台程序，您可以测试Ascript脚本和控制台。

体验Ascript控制台
=============
我们提供了一个在线的Ascript控制台地址，您可以在线体验Ascript控制台，请点击下面的连接

[**体验Ascript控制台**](http://www.softplat.com/gt/ascriptConsole/ascriptconsole.html)

Ascript控制台指令
=============

- Toggle();
- 
- 打开或关闭控制台

- Clean(type:int=0);
- 
- 清空控制台，type: 0 日志面板  1 脚本输出面板  2 所有面板

- Save();
- 
- 把日志面板的内容保存到一个文本文件，日志面板最多显示200条，而保存到文本文件后最大记录数10000条

- Load(isClass:Boolean=false);
- 
- 从外部加载一个文件，加载后自动解析文件内容，默认加载的文件不是类文件，如果想加载类文件，需要设置isClass为true
- 加载后需要手动实例化类实例。




