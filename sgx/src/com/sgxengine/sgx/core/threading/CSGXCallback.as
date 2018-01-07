package com.sgxengine.sgx.core.threading
{
	public class CSGXCallback
	{
		public var m_pFunction : Function; 
		public var m_Data : uint; 
		public var m_UserData : *; 
		public var m_pCPU : sgxCPU; 
	
		public function CSGXCallback(ptr : Function, data:uint=0, userdata:*=0, cpu : sgxCPU= null) {
			m_pFunction = ptr;
			m_Data = data;
			m_UserData = userdata;
			m_pCPU = cpu;	
		}
		
		public function call(resultData : uint=0) : uint{
			if (m_pFunction != null) {
				// TODO: handle m_pCPU correctly.
				return (m_pFunction)(this, resultData);
			}
			return 0;
		}
		
	}
}