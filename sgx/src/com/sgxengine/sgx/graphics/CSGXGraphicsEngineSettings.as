package com.sgxengine.sgx.graphics
{
	public class CSGXGraphicsEngineSettings
	{
		
		public var 		m_szAppName : String;
		public var		m_iScreenWidth : uint;
		public var		m_iScreenHeight : uint;
		public var		m_iSizeFrameMemoryBuffer : uint;
		public var		m_iSizeAlphaFaceBuffer : uint;
		
		public var		m_bProfileEngineStats : uint;

		public function CSGXGraphicsEngineSettings()
		{
			m_szAppName = "SGX Engine";
			m_iScreenWidth = 640;
			m_iScreenHeight = 480;
			//
			m_bProfileEngineStats = m_iSizeAlphaFaceBuffer = 0;
			m_bProfileEngineStats = 0;
		}
	}
}