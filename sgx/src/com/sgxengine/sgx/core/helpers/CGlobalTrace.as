package com.sgxengine.sgx.core.helpers
{
	public class CGlobalTrace extends CTraceModule
	{
		protected static var ms_pSingleton : CGlobalTrace; 
		public function CGlobalTrace()
		{
			super();
		}
		
		public static function create() : CGlobalTrace
		{
			if (ms_pSingleton) {
				sgxTrace.SID_WARNING(("Attempting to re-create the singleton, CSGXTextureManager"));
			}
			return new CGlobalTrace();
		}
		
		public static function get() : CGlobalTrace
		{
			if (!ms_pSingleton) {
				ms_pSingleton = create();
			}
			return ms_pSingleton;
		}

	}
}