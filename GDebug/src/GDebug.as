package
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.filters.GlowFilter;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    import flash.ui.Keyboard;
    
    import parser.Script;
    
	/**
	 * Ascript控制台程序 
	 * @author green_tea
	 * 
	 */
    public class GDebug extends Sprite
    {
        private var contentTf:TextField;
        private var inputTf:TextField;
        private var contentArr:Array=[];
        private var scriptArr:Array=[];
        public static var groot:Sprite;
        /**
         * 默认的打开方式 ctrl+f2 
         */
        public static const OPEN_MOTHOD_DEFAULT:String="DEFAULT";
        private var _openMethod:String=OPEN_MOTHOD_DEFAULT;
        private var scriptTf:TextField;
        private var saveFile:FileReference;
        private var loadFile:FileReference;
        /**
         * 最大记录条数 
         */
        private const MAX_LENGTH:uint=10000;
        /**
         * 加载类型 0普通文件 1类文件 
         */
        private var loadFlag:int=0;
        public function GDebug()
        {
        }
        /**
         * 弹出一个窗口，用户选择保存日志文件，可以将debug输出面板保存成一个txt文件，文件以\n分割
         * 
         */
        public function SaveLog():void{
            if(!saveFile){
                saveFile=new FileReference;
            }
            var content:String="";
            for(var i:int=0;i<contentArr.length;i++){
                content+=contentArr[i].toString()+"\n";
            }
            saveFile.cancel();
            saveFile.save(content,"clientLog.log");
            saveFile.addEventListener(Event.COMPLETE,onComplete);
        }
        /**
         * 弹出一个框，用户可选择一个ascript类文件加载，脚本解释器将试图解释执行此文件内的脚本类，加载进来需要在脚本环境中手动new出来 
         * 
         */
        public function LoadClass():void{
            if(!loadFile){
                loadFile=new FileReference;
            }
            try{
                loadFile.cancel();
                loadFlag=1;
                loadFile.browse([new FileFilter("ascript类文件","*.as;*.txt")]);
                loadFile.addEventListener(Event.SELECT,onSelect);
            }catch(e:Error){
                Log(e.message);
            }
        }
        /**
         * 弹出一个框，用户可选择一个ascript文件加载，脚本解释器将试图解释执行此文件内的脚本，此文件不能是类，只是函数和变量的定义 
         * 
         */
        public function Load():void{
            if(!loadFile){
                loadFile=new FileReference;
            }
            try{
                loadFile.cancel();
                loadFlag=0;
                loadFile.browse([new FileFilter("ascript文件","*.as;*.txt")]);
                loadFile.addEventListener(Event.SELECT,onSelect);
            }catch(e:Error){
                Log("<font color='#bb2222'>"+e.message+"</font>");
            }
        }
        protected function onSelect(event:Event):void
        {
            loadFile.load();
            loadFile.addEventListener(Event.COMPLETE,onComplete);
        }
        protected function onComplete(event:Event):void
        {
            (event.currentTarget as FileReference).removeEventListener(Event.COMPLETE,onComplete);
            switch(event.currentTarget)
            {
                case saveFile:
                {
                    Log("log文件已保存");
                    break;
                }
                case loadFile:
                {
                    Log("成功加载文件："+loadFile.name);
                    if(loadFlag==1){
                        Script.LoadFromString(loadFile.data.toString());
                    }else{
                        Execute(loadFile.data.toString());
                    }
                    break;
                }
            }
        }
		/**
		 * 初始化控制台程序 
		 * @param _root 文档类
		 * 
		 */
        public function Init(_root:Sprite):void{
            groot=_root;
            if(!groot.stage){
                groot.addEventListener(Event.ADDED_TO_STAGE,onAddRoottoStage);
            }else{
                Setup();
            }
        }
		/**
		 * 在控制台输出一段文字，支持html 
		 * @param content
		 * 
		 */
        public function Log(content:String):void{
            if(!content || content=="")return;
            contentArr.push(content);
            if(contentArr.length>MAX_LENGTH){
                contentArr.shift();
            }
            if(stage){
                contentTf.htmlText+=content+"<br>";
                contentTf.scrollV=contentTf.maxScrollV;
            }
        }
		/**
		 * 在控制台输出脚本输出，支持html 
		 * @param content
		 * 
		 */
        public function LogScript(content:String):void{
            if(!content || content=="")return;
            scriptArr.push(content);
            if(scriptArr.length>MAX_LENGTH){
                scriptArr.shift();
            }
            if(stage){
                scriptTf.htmlText+=content+"<br>";
                scriptTf.scrollV=scriptTf.maxScrollV;
            }
        }
        public function Execute(s:String):void{
            try{
                LogScript("<font color='#bbee22'>执行脚本：\n"+s+"</font>");
                Script.execute(s);
            }catch(e:Error){
                LogScript("<font color='#bb2222'>"+e.message+"</font>");
            }
        }
        protected function onAddRoottoStage(event:Event):void
        {
            groot.removeEventListener(Event.ADDED_TO_STAGE,onAddRoottoStage);
            Setup();
        }
        
        private function Setup():void
        {
            tabEnabled=false;
            tabChildren=false;
            Script.init(groot);
            Script.output=LogScript;
            
            contentTf=new TextField;
            contentTf.textColor=0xffffff;
            contentTf.width=groot.stage.stageWidth/2;
            contentTf.height=groot.stage.stageHeight*.75;
            contentTf.multiline=true;
            contentTf.filters=[new GlowFilter(0x000000,1,2,2,100)];
            
            scriptTf=new TextField;
            scriptTf.textColor=0xffffff;
            scriptTf.width=groot.stage.stageWidth/2;
            scriptTf.x=groot.stage.stageWidth/2;
            scriptTf.height=groot.stage.stageHeight*.75;
            scriptTf.multiline=true;
            scriptTf.filters=[new GlowFilter(0x000000,1,2,2,100)];
            
            inputTf=new TextField;
            inputTf.textColor=0xffffff;
            inputTf.type=TextFieldType.INPUT;
            inputTf.width=groot.stage.stageWidth;
            inputTf.filters=[new GlowFilter(0x000000,1,2,2,100)];
            inputTf.y=contentTf.height+contentTf.y;
            inputTf.multiline=true;
            inputTf.height=groot.stage.stageHeight*.25;
            
            var contentBg:Shape=new Shape;
            contentBg.graphics.beginFill(0x666666,.6);
            contentBg.graphics.drawRect(0,0,groot.stage.stageWidth,contentTf.height);
            
            var inputBg:Shape=new Shape;
            inputBg.graphics.beginFill(0xeeee,.6);
            inputBg.graphics.drawRect(0,0,inputTf.width,inputTf.height);
            inputBg.x=inputTf.x;
            inputBg.y=inputTf.y;
            
            addChild(contentBg);
            addChild(inputBg);
            addChild(contentTf);
            addChild(inputTf);
            addChild(scriptTf);
            
            
            groot.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,1000);
            addEventListener(Event.ADDED_TO_STAGE,onAddtoStage);
        }
		
        protected function onAddtoStage(event:Event):void
        {
            var content:String="";
            var script:String="";
            for(var i:int=Math.max(0,contentArr.length-200);i<contentArr.length;i++){
                content+=contentArr[i].toString()+"<br>";
            }
            for(var j:int=Math.max(0,scriptArr.length-200);j<scriptArr.length;j++){
                script+=scriptArr[j].toString()+"<br>";
            }
            contentTf.htmlText=content;
            contentTf.scrollV=contentTf.maxScrollV;
            scriptTf.htmlText=script;
            scriptTf.scrollV=scriptTf.maxScrollV;
        }
        protected function onKeyDown(event:KeyboardEvent):void
        {
            if(event.ctrlKey && event.keyCode==Keyboard.F2){
                if(openMethod==OPEN_MOTHOD_DEFAULT){
                    Toggle();
                }
            }
            if(event.ctrlKey && event.keyCode==Keyboard.ENTER){
                inputTf.text+="\n";
                inputTf.setSelection(inputTf.length-1,inputTf.length-1);
            }
            if(!event.ctrlKey && event.keyCode==Keyboard.ENTER && stage && stage.focus==inputTf){
                Execute(inputTf.text);
                inputTf.text="";
            }
            if(event.keyCode==Keyboard.TAB && stage && stage.focus==inputTf){
                event.stopImmediatePropagation();
            }
        }
		/**
		 * 打开/关闭控制台程序 
		 * 
		 */
        public function Toggle():void
        {
            if(stage && parent==groot){
                groot.removeChild(this);
            }else{
                groot.addChild(this);
                groot.stage.focus=inputTf;
            }
        }
        /**
         * 清空debug面板，type: 0 日志面板  1 脚本输出面板  2 所有面板
         * @param type
         * 
         */
        public function Clean(type:int=0):void{
            switch(type)
            {
                case 0:
                    contentTf.htmlText="";
                    break;
                case 1:
                    scriptTf.htmlText="";
                    break;
                case 2:
                    contentTf.htmlText="";
                    scriptTf.htmlText="";
                    break;
            }
        }
        
        /**
         * 打开方式 
         */
        public function get openMethod():String
        {
            return _openMethod;
        }
        
        /**
         * @private
         */
		/**
		 * 设置打开方式，可选值OPEN_MOTHOD_DEFAULT为默认打开方式（ctrl+f12），除此之外的任何值将无法自动打开面板，可以在主程序手动addChild控制台来打开控制台
		 * @param value
		 * 
		 */
        public function set openMethod(value:String):void
        {
            _openMethod = value;
        }
        
    }
}