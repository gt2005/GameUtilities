package manager
{
    import com.hurlant.math.BigInteger;
    
    import flash.utils.Dictionary;
    
    import ui.AbsWindow;

    /**
     * window管理类 处理window的共存 互斥关系
     * @author green_tea
     * 
     */
    public class WindowManager
    {
        private static var groupNum:uint;
        private static var uidNum:uint=1;
        private static var ignoreDic:Dictionary=new Dictionary;
        private static var panelDic:Dictionary=new Dictionary;
        private static var uidDic:Dictionary=new Dictionary;
        private static var power:BigInteger=BigInteger.nbv(2);
        
        private static var arr:Array=[];
        public function WindowManager()
        {
        }
        /**
         * 注册某个面板到某个组，同组面板可以共存
         * @param panel 要注册的面板
         * @param groupId 组id，为2的n次方，请用BigInteger类型，可通过WindowGroups取得已经定义好的组id，也可使用GetNewGrounpId获得新的组id
         * @param togethers 可以共存的组,内容为String类型的组id
         * @param exclusions 互斥的组，内容为String类型的组id
         * 
         */
        public static function Reg(panel:AbsWindow,groupId:BigInteger,togethers:Vector.<BigInteger>=null,exclusions:Vector.<BigInteger>=null):void{
            panel.groupId=groupId;
            var mask:BigInteger=new BigInteger;
            mask=mask.or(panel.groupId);
            for each(var together:BigInteger in togethers){
                mask=mask.or(together);
            }
            var exclusion_mask:BigInteger=new BigInteger;
            for each(var exclusion:BigInteger in exclusions){
                exclusion_mask=exclusion_mask.or(exclusion);
            }
            mask=mask.andNot(exclusion_mask);
            panel.maskId=mask;
            exclusion_mask.dispose();
        }
        /**
         * 解除注册，恢复默认，注意此方法不会移除通过together和exclude方法设置的特殊的互斥共存关系
         * @param panel
         * 
         */
        public static function Unreg(panel:AbsWindow):void{
            panel.groupId=0;
            panel.maskId=0;
        }
        /**
         * 和某个组共存 
         * @param panel
         * @param together
         * 
         */
        public static function TogetherwithGroup(panel:AbsWindow,groupId:BigInteger):void{
            panel.maskId=panel.maskId.or(groupId);
        }
        /**
         * 和某个组互斥 
         * @param panel
         * @param exclusion
         * 
         */
        public static function ExcludewithGroup(panel:AbsWindow,groupId:BigInteger):void{
            panel.maskId=panel.maskId.andNot(groupId);
        }
        /**
         * 某几个面板可以共存，优先级高于groupId和mask  
         * @param panel
         * @param together
         * 
         */
        public static function Together(vect:Vector.<AbsWindow>):void{
            arr.length=0;
            for(var i:int=0;i<vect.length;i++){
                if(!uidDic[vect[i]]){
                    var uid:int=GetNewUid();
                    panelDic[uid]=vect[i];
                    uidDic[vect[i]]=uid;
                }
                var uid:int=uidDic[vect[i]];
                arr.push(uid);
            }
            arr.sort();
            ignoreDic[arr.join("_")]=true;
            
        }
        /**
         * 某几个面板不可共存，优先级高于groupId和mask 
         * @param panel
         * @param exclusion
         * 
         */
        public static function Exclude(vect:Vector.<AbsWindow>):void{
            arr.length=0;
            for(var i:int=0;i<vect.length;i++){
                if(!uidDic[vect[i]]){
                    var uid:int=GetNewUid();
                    panelDic[uid]=vect[i];
                    uidDic[vect[i]]=uid;
                }
                var uid:int=uidDic[vect[i]];
                arr.push(uid);
            }
            arr.sort();
            ignoreDic[arr.join("_")]=false;
        }
        /**
         * 解除面板间共存互斥关系，注意groupId和mask设定的关系仍然会起效 
         * @param panel
         * @param exclusion
         * 
         */
        public static function Delink(vect:Vector.<AbsWindow>):void{
            arr.length=0;
            for(var i:int=0;i<vect.length;i++){
                var uid:int=uidDic[vect[i]];
                if(uid){
                    arr.push(uid);
                }else{
                    //uid不存在，说明不存在指定的面板间的互斥共存关系
                    return;
                }
            }
            arr.sort();
            var s:String=arr.join("_");
            if(ignoreDic[s]!=null){
                ignoreDic[s]=null;
                delete ignoreDic[s];
            }
        }
        /**
         * 两个面板是否可以共存 
         * @param panel1
         * @param panel2
         * @return 
         * 
         */
        public static function IfTogether(panel1:AbsWindow,panel2:AbsWindow):Boolean{
            var b:Boolean=false;
            if(parseInt(panel1.groupId.and(panel2.maskId).toString(),16)!=0 && parseInt(panel2.groupId.and(panel1.maskId).toString(),16)!=0){
                b=true;
            }
            var uid1:int=uidDic[panel1];
            var uid2:int=uidDic[panel2];
            if(uid1!=0 && uid2!=0){
                arr.length=0;
                arr.push(uid1,uid2);
                arr.sort();
                var s:String=arr.join("_");
                if(ignoreDic[s]!=null){
                    b=ignoreDic[s];
                }
            }
            return b;
        }
        /**
         * 获取新的组id 
         * @return 
         * 
         */
        public static function GetNewGrounpId():BigInteger{
            groupNum++;
            return power.pow(groupNum);
        }
        private static function GetNewUid():int
        {
            return uidNum++;
        }
    }
}