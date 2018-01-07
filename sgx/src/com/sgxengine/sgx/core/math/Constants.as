package com.sgxengine.sgx.core.math
{
	public class Constants
	{
		public static const SGX_NAN : uint = 0xFFC00000;
		public static const SGX_SNAN : Number = 0xFF800000;
		public static const SGX_INF : Number = 0x7F800000;
		
		public static const SGX_EPSILON : Number = 0.0001;
		public static const SGX_PI : Number = 3.1415926535897932384626433832795;
		public static const SGX_2PI : Number = 6.283185307179586476925286766559;
		public static const SGX_PI2 : Number = 1.5707963267948966192313216916398;
		public static const SGX_3PI2 : Number = 4.7123889803846898576939650749193;
		public static const SGX_E : Number = 2.7182818284590452353602874713527;

		public static const SGX_MIN_VALUE_FLOAT : Number = 1.401298464324817E-45;
		public static const SGX_MAX_VALUE_FLOAT : Number = 3.4028234663852886E38;
		public static const SGX_MIN_VALUE_REAL32 : Number = 1.401298464324817E-45;
		public static const SGX_MAX_VALUE_REAL32 : Number = 3.4028234663852886E38;
		
		public static const SGX_MIN_VALUE_INT32 : int = -2147483648;
		public static const SGX_MAX_VALUE_INT32 : int = 2147483647;
		
		public static const SGX_MIN_VALUE_UINT32 : uint = 0;
		public static const SGX_MAX_VALUE_UINT32 : uint = 4294967295;
		
		public static const SGX_MIN_VALUE_INT16 : int = -32768;
		public static const SGX_MAX_VALUE_INT16 : int = 32767;

	}
}