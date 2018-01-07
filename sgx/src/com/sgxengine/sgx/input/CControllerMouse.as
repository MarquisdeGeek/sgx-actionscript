package com.sgxengine.sgx.input
{
	import com.sgxengine.sgx.core.SGXVector;

	public class CControllerMouse
	{
		public var x : int;
		public var y : int;
		public var m_Buttons : SGXVector;	//of CControlButton		m_Buttons[SGX_MAXINP_MOUSEBUTTONS];
		
		public function CControllerMouse()
		{
			m_Buttons = new SGXVector();
			m_Buttons.push_back(new CControlButton());	//left
			m_Buttons.push_back(new CControlButton());	//right
			m_Buttons.push_back(new CControlButton());	// center
			reset();
		}
		
		public function reset() : void
		{
			x = y = 0;
			for each (var b : CControlButton in m_Buttons.array) {
				b.reset();
			}
		}
		
		public function update(telaps : Number) : void
		{
			for each (var b : CControlButton in m_Buttons.array) {
				b.update(telaps);
			}
		}
	}
}