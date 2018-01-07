package com.sgxengine.sgx.gui
{
	public class sgxGUIFrameParams
	{
		public var m_Width : uint;
		public var m_Height : uint;

		public function sgxGUIFrameParams(w : uint = 640, h : uint=480)
		{
			m_Width = w;
			m_Height = h;
		}
	}
}