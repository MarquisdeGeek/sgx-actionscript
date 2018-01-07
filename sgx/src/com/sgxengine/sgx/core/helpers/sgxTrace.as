package com.sgxengine.sgx.core.helpers
{
	public class sgxTrace
	{

		public static function SID_FATAL(str : String) : void
		{
			CGlobalTrace.get().outputTrace(CTraceModule.SGX_ERR_FATAL, str);
		}
		
		public static function SID_ERROR(str : String) : void
		{
			CGlobalTrace.get().outputTrace(CTraceModule.SGX_ERR_ERROR, str);
		}
		
		public static function SID_WARNING(str : String) : void
		{
			CGlobalTrace.get().outputTrace(CTraceModule.SGX_ERR_WARNING, str);
		}
		
		public static function SID_MESSAGE(str : String) : void
		{
			CGlobalTrace.get().outputTrace(CTraceModule.SGX_ERR_MESSAGE, str);
		}
		
		public static function SID_INFO(str : String) : void
		{
			CGlobalTrace.get().outputTrace(CTraceModule.SGX_ERR_INFO, str);
		}
	}
}