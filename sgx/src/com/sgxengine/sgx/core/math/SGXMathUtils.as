package com.sgxengine.sgx.core.math
{
	public class SGXMathUtils
	{
	
		public static function sgxMin(v1 : Number, v2 : Number) : Number
		{
			if (v1 < v2) {
				return v1;
			} else {
				return v2;
			}
		}
		
		public static function sgxMax(v1 : Number, v2 : Number) : Number
		{
			if (v1 > v2) {
				return v1;
			} else {
				return v2;
			}
		}
		
		
		public static function sgxRange(val : Number, minv : Number, maxv : Number) : Number
		{
			if (val < minv) {
				return minv;
			} else if (val > maxv) {
				return maxv;
			} else {
				return val;
			}
		}
		
		
		public static function sgxSwap(val1 : uint, val2 : uint) : void
		{
			// todo asset
		}
		
		public static function sgxRoundUpToPower2(v : uint) : uint
		{
			for(var i : uint = 4*8;--i;) {
				// Find first used bit
				if (v & (1<<i)) {
					if (v == 1<<i) { // no other bits set, therefore it's already rounded
						return v;
					}
					// Other bits set, therefore next highest power is the 'next' one
					return (uint)( 1<<(i+1) );
				}
			}
			// Catch the last two cases, where v==0 or v==1
			return 1;
		}
		/*
		public static function sgxBaseConvert(tINT32 &result, const char *sourceValue, const tUINT32 sourceValueBase=10) : Number {
			return 0;
		}
		public static function sgxBaseConvert(sgxString &result, const tUINT32 targetBase, const char *sourceValue, const tUINT32 sourceValueBase=10) : Number {
			return 0;
		}
*/
	
	}
}