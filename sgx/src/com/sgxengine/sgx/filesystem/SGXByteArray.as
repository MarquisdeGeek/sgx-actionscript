package com.sgxengine.sgx.filesystem
{
	import flash.utils.ByteArray;

	public class SGXByteArray
	{
		public static var bSwapEndian : Boolean = false;
		
		public function SGXByteArray()
		{
		}
		
		public static function readInt16(ba : ByteArray) : uint {
			var result : uint = ba.readShort();
			
			if (bSwapEndian) {
				result = ((((result)&0xff)<<8) | ( ((result)>>8)&0xff));
			}
			
			return result;
		}
		
		public static function readInt32(ba : ByteArray) : uint {
			var result : uint = ba.readInt();
			
			if (bSwapEndian) {
				result = ((((result)&0xff)<<24) | ((((result)>>8)&0xff)<<16) |
					((((result)>>16)&0xff)<<8) | ((((result)>>24)&0xff)) );
			}
			
			return result;
		}
	}
}