package com.sgxengine.sgx.core.helpers
{
	import com.sgxengine.sgx.core.math.SGXMathUtils;

	public class CTraceModule
	{
		public static const SGX_ERR_REPORT_NONE : uint = 6;
		public static const SGX_ERR_REPORT_ALL : uint  = 0;
		
		public static const SGX_ERR_FATAL : uint  = 5;
		public static const SGX_ERR_ERROR : uint  = 4;
		public static const SGX_ERR_WARNING : uint  = 3;
		public static const SGX_ERR_MESSAGE : uint  = 2;
		public static const SGX_ERR_INFO : uint  = 1;

		public var m_iTraceLevel : uint = 0;

		public function CTraceModule(iDefaultLevel : int = SGX_ERR_REPORT_ALL)
		{
			setTraceLevel(iDefaultLevel);
		}
		
		public function setTraceLevel(iLevel : int) : void
		{
			m_iTraceLevel = SGXMathUtils.sgxRange(iLevel, SGX_ERR_REPORT_ALL, SGX_ERR_REPORT_NONE);
		}
		
		public function getTraceLevel() : int
		{
			return m_iTraceLevel;
		}
		
		public function outputTrace(idx : int, pMessage : *) : Boolean
		{
			
			if (idx < m_iTraceLevel || pMessage == null) {
				return false;
			}

			trace(pMessage);
			return true;
		}
		
		public function outputError(pMessage : *) : Boolean {
			outputTrace(SGX_ERR_FATAL, pMessage);
			
			sgxHalt();
			return true;
		}
		
		public function sgxHalt() : void {
			var bHalted : Boolean =true;
			while(bHalted) {
				// NOP
				bHalted = bHalted;
			}
		}
	}
}