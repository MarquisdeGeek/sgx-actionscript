package com.sgxengine.sgx.input
{
	import com.sgxengine.sgx.core.SGXVector;

	public class CControllerKeyboard
	{
		public var m_Key : Array;// of CKeyboardKey

		public function CControllerKeyboard()
		{
			m_Key = new Array();
			for(var i:uint=0;i<256;++i) {
				m_Key.push(new CKeyboardKey());
			}
		}
		
		public function update(telaps : Number) : void {
			for each(var k : CKeyboardKey in m_Key.array) {
				k.update(telaps);
			}
		}
		
	}
}