package com.sgxengine.sgx.input
{
	public class CSGXInputManager
	{
		// enums
		public static var eMouseButtonLeft : uint = 0;
		public static var eMouseButtonRight : uint = 1;
		public static var eMouseButtonMiddle : uint = 2;
		
		public var m_Mouse : CControllerMouse;
		public var m_Keyboard : CControllerKeyboard;
		
		private var m_pDeviceMouse : CControllerMouse;
		private var m_pDeviceKeyboard : CControllerKeyboard;
		
		private static var ms_pSingleton : CSGXInputManager;
		
		public function CSGXInputManager()
		{
			m_pDeviceKeyboard = new CControllerKeyboard();
			m_pDeviceMouse = new CControllerMouse();
			
			update(0);
		}
		
		
		public static function create() : CSGXInputManager
		{
			if (ms_pSingleton) {
				//sgxTrace(SID_WARNING("Attempting to re-create the singleton, CSGXInputManager"));
			}
			
			//ms_pSingleton = ms_pSingleton ? ms_pSingleton : pCopy;
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXInputManager();
				ms_pSingleton.initialize();
			}
			return ms_pSingleton;
		}
		
		public static function get() : CSGXInputManager
		{
			if (!ms_pSingleton) {
//				sgxTrace(SID_WARNING("The 'CSGXInputManager' singleton is being created implicitly from a get()."));
				return create();
			}
			return ms_pSingleton;
		}

		
		public function initialize() : void {
			
		}
		
		
		public function update(telaps : Number) : void {
			m_Keyboard = m_pDeviceKeyboard;
			m_Keyboard.update(telaps);
			
			m_Mouse = m_pDeviceMouse;
			m_Mouse.update(telaps);
			
			
			/*
				if (!m_bEnabled) {
					return;
				}
				
				// We update the buffered input, and
				// write the results back to the cross-platform version
				for(tMEM_SIZE i=0;i<getMaxControllers();i++) {
					if (m_pDeviceController[i]) {
						m_pDeviceController[i]->update(telaps, *m_pController[i]);
					}
				}
				
				if (m_pDeviceKeyboard) {
					m_pDeviceKeyboard->update(telaps, m_Keyboard);
				}
				
				if (m_pDeviceMouse) {
					m_pDeviceMouse->update(telaps, m_Mouse);
				}
				*/
			}
		
		public function applyKeyboardKeyUp(key : uint) : void {
			m_pDeviceKeyboard.m_Key[key].applyButtonDown();
		}
		
		public function applyKeyboardKeyDown(key : uint) : void {
			m_pDeviceKeyboard.m_Key[key].applyButtonUp();
		}
		
		public function applyKeyboardPressed(key : uint) : void {
			m_pDeviceKeyboard.m_Key[key].applyButtonPressed();
		}
		
		public function applyKeyboardReleased(key : uint) : void {
			m_pDeviceKeyboard.m_Key[key].applyButtonReleased();
		}
		
		public function applyKeyboardState(unused : *) : void {
			// TODO
		}
		
		public function applyMouseButton(b : int, bState : Boolean) : void {
			
			if (bState) {
				m_pDeviceMouse.m_Buttons.array[b].applyButtonDown();
			} else {
				m_pDeviceMouse.m_Buttons.array[b].applyButtonUp();
			}
		}
		
		public function applyMousePosition(x : int, y : int) : void {
			m_pDeviceMouse.x = x;
			m_pDeviceMouse.y = y;
		}
		
		
		public function isKeyboardKeyDown(key : int) : Boolean {
			return m_Keyboard.m_Key[key].m_bIsDown;
		}
		
		public function isKeyboardKeyUp(key : int) : Boolean {
			return m_Keyboard.m_Key[key].m_bIsUp;
		}
		
		public function isKeyboardKeyPressed(key : int) : Boolean {
			return m_Keyboard.m_Key[key].m_bPressed;
		}
		
		public function isKeyboardKeyReleased(key : int) : Boolean {
			return m_Keyboard.m_Key[key].m_bReleased;
		}
		
		public function getKeyboardState(unused : *) : Boolean {
			return false;
		}
		
		
		public function isMouseButtonDown(b : uint) : Boolean {
			return m_Mouse.m_Buttons.array[b].m_bIsDown;
		}
		
		public function isMouseButtonUp(b : uint) : Boolean {
			return m_Mouse.m_Buttons.array[b].m_bIsUp;
		}
		
		public function isMouseButtonPressed(b : uint) : Boolean {
			return m_Mouse.m_Buttons.array[b].m_bPressed;
		}
		
		public function isMouseButtonReleased(b : uint) : Boolean {
			return m_Mouse.m_Buttons.array[b].m_bReleased;
		}
		
		public function getMouseX() : int {
			return m_Mouse.x;
		}
		
		public function getMouseY() : int {
			return m_Mouse.y;
		}
		
		
		
		
	}
}