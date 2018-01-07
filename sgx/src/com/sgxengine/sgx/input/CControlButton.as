package com.sgxengine.sgx.input
{
	public class CControlButton
	{
		public var m_bPressed : Boolean;
		public var m_bReleased : Boolean;
		public var m_bIsDown : Boolean;
		public var m_bIsUp : Boolean;
		
		public var m_fIntialTime : Number;
		public var m_fRepeatTime : Number;
		
		protected var m_bFirstAutoRepeat : Boolean;
		protected var m_fTimeSincePressed : Number;

		
		public function CControlButton()
		{
			reset();
			m_fIntialTime = m_fRepeatTime = 0;
		}
		
		public function reset() : void {
			m_bPressed = false;
			m_bReleased = false;
			m_bIsUp = true;
			m_bIsDown = false;
		}
		
		public function update(telaps : Number) : void {
			m_bPressed = false;
			m_bReleased = false;
			
			// Auto-repeat this key?
			if (m_bIsDown && m_fIntialTime && m_fRepeatTime) {
				m_fTimeSincePressed += telaps;
				if (m_bFirstAutoRepeat) {
					if (m_fTimeSincePressed > m_fIntialTime) {
						m_bPressed = true;
						m_fTimeSincePressed = 0;
					}
				} else { // 2nd and subsequent 
					if (m_fTimeSincePressed > m_fRepeatTime) {
						m_bPressed = true;
						m_fTimeSincePressed = 0;
					}
				}
			}
		}
		
		
		public function applyButton(down : Boolean) : void {
			if (down) {
				applyButtonDown(); 
			} else {
				applyButtonUp(); 
			}
		}
		
		public function applyButtonDown() : void {
			// Infer: Key is now down, but was up.
			m_bPressed = m_bIsUp;
			m_bReleased = false;
			
			m_bIsUp = false;
			m_bIsDown = true;
			
			m_fTimeSincePressed = 0;
			m_bFirstAutoRepeat = m_bPressed;
		}
		
		public function applyButtonUp() : void {
			// Infer: Key is now up, but was down.
			m_bReleased = m_bIsDown;
			m_bPressed = false;
			
			m_bIsUp = true;
			m_bIsDown = false;
		}
		
		public function applyButtonPressed() : void {
			m_bPressed = true;
			m_bReleased = false;
			
			m_bIsUp = false;
			m_bIsDown = true;
			
			m_fTimeSincePressed = 0;
			m_bFirstAutoRepeat = m_bPressed;
		}
		
		public function applyButtonReleased() : void {
			m_bPressed = false;
			m_bReleased = true;
			
			m_bIsUp = true;
			m_bIsDown = false;
		}
		
		
		public function clearAutoRepeat() : void {
			m_fIntialTime = 0;
			m_fRepeatTime = 0;
		}
		
		public function setAutoRepeat(intialTime : Number, repeatTime : Number) : void {
			m_fIntialTime = intialTime;
			m_fRepeatTime = repeatTime;
		}
		
		
		public function wasPressed(params : CCommandHandlerParameters = null) : Boolean {
			return m_bPressed;
		}
		
		public function wasReleased(params : CCommandHandlerParameters = null) : Boolean {
			return m_bReleased;
		}
		
		public function getState(params : CCommandHandlerParameters = null) : Boolean {
			return m_bIsDown;
		}
		
		public function getPosition(params : CCommandHandlerParameters) : Number {
			return params.prepareRange(m_bIsDown ? 1.0 : 0);
		}

	}
}