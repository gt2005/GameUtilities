package ui
{
	import com.hurlant.math.BigInteger;

	public class AbsWindow
	{
		private var _groupId:BigInteger=BigInteger.nbv(0);
		private var _maskId:BigInteger=BigInteger.nbv(0);
		public function AbsWindow()
		{
		}
		/**
		 * 组id 同组的面板默认共存 
		 */
		public function get groupId():BigInteger
		{
			return _groupId;
		}
		
		/**
		 * @private
		 */
		public function set groupId(value:*):void
		{
			if(value is BigInteger){
				_groupId=value;
			}else{
				_groupId=new BigInteger(value);
			}
		}
		
		/**
		 * 面板根据mask决定是和某一组的面板共存 还是排斥
		 */
		public function get maskId():BigInteger
		{
			return _maskId;
		}
		
		/**
		 * @private
		 */
		public function set maskId(value:*):void
		{
			if(value is BigInteger){
				_maskId=value as BigInteger;
			}else{
				_maskId=new BigInteger(value);
			}
		}
	}
}