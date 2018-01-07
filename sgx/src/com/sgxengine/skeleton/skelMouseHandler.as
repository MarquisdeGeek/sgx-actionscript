package com.sgxengine.skeleton
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.input.CSGXInputManager;

	public class skelMouseHandler
	{

		public static var m_bLeftDown : Boolean;
		public static var m_bLeftPressed : Boolean;
		public static var m_bLeftReleased : Boolean;
		public static var m_bRightDown : Boolean;
		public static var m_bRightPressed : Boolean;
		public static var m_bRightReleased : Boolean;
		public static var m_fRollOrientation : Number;
		//
		public static var m_MouseDX : int;
		public static var m_MouseDY : int;
		public static var m_MouseMoveDX : int;
		public static var m_MouseMoveDY : int;
		public static var m_MousePreviousX : int;
		public static var m_MousePreviousY : int;
		//
		public static var m_MouseX : int;
		public static var m_MouseY : int;
		public static var m_MouseDraggedX : int;
		public static var m_MouseDraggedY : int;
		public static var m_MouseClickedX : int;
		public static var m_MouseClickedY : int;
		public static var m_MousePoint : sgxPoint2i;
		public static var m_MousePreviousPoint : sgxPoint2i;
		public static var m_bAnyButtonPressed : Boolean;
		public static var m_bAnyButtonDown : Boolean;
		
		public static var bMouseDragged : Boolean;
		public static var bMouseLeftButton: Boolean;
		public static var iMouseMoveX : int;
		public static var iMouseMoveY : int;

		// AS3-ONLY : We need an explicitly called function for this to build in Flash Builder. Without it
		// there are internal build errors. (No doubt caused by the singleton.)
		public static function init() : void {
			m_MousePoint = new sgxPoint2i();
			m_MousePreviousPoint = new sgxPoint2i();

			iMouseMoveX = CSGXInputManager.get().getMouseX();
			iMouseMoveY = CSGXInputManager.get().getMouseY();

			m_MouseX = m_MouseY = 0;
		}
		
		public static function preUpdateCommon() : void {
			m_MousePreviousX = m_MouseX;
			m_MousePreviousY = m_MouseY;
			//
			m_MouseX = m_MouseY = 0;
			m_bLeftDown = m_bLeftPressed = m_bLeftReleased = false;
			m_bRightDown = m_bRightPressed = m_bRightReleased = false;
			m_fRollOrientation = 0;
			m_bAnyButtonPressed = false;
			m_bAnyButtonDown = false;
			//
			// Use the standard input abstractions where provided. If the platform doesn't
			// use these in the same way (e.g. pointer is controlled by a joypad, which is not 
			// consider as the mouse - i.e. primary pointing input device)
			// then you need to override these in update()
			//
			
			m_bLeftDown = CSGXInputManager.get().isMouseButtonDown(CSGXInputManager.eMouseButtonLeft);
			m_bLeftPressed = CSGXInputManager.get().isMouseButtonPressed(CSGXInputManager.eMouseButtonLeft);
			m_bLeftReleased = CSGXInputManager.get().isMouseButtonReleased(CSGXInputManager.eMouseButtonLeft);
			m_bRightDown = CSGXInputManager.get().isMouseButtonDown(CSGXInputManager.eMouseButtonRight);
			m_bRightPressed = CSGXInputManager.get().isMouseButtonPressed(CSGXInputManager.eMouseButtonRight);
			m_bRightReleased= CSGXInputManager.get().isMouseButtonReleased(CSGXInputManager.eMouseButtonRight);
			//
			m_MouseX = CSGXInputManager.get().getMouseX();
			m_MouseY = CSGXInputManager.get().getMouseY();
		}
		
		public static function postUpdateCommon() : void {
			
			m_MousePoint.x = m_MouseX;
			m_MousePoint.y = m_MouseY;
			
			m_MousePreviousPoint.x = m_MousePreviousX;
			m_MousePreviousPoint.y = m_MousePreviousY;
			
			if (CSGXInputManager.get().isMouseButtonPressed(CSGXInputManager.eMouseButtonLeft)) {
				bMouseDragged = true;
				bMouseLeftButton = true;
				iMouseMoveX = m_MouseClickedX = m_MouseX;
				iMouseMoveY = m_MouseClickedY = m_MouseY;
			} else if (CSGXInputManager.get().isMouseButtonPressed(CSGXInputManager.eMouseButtonRight)) {
				bMouseDragged = true;
				bMouseLeftButton = false;
				iMouseMoveX = m_MouseClickedX = m_MouseX;
				iMouseMoveY = m_MouseClickedY = m_MouseY;
			} else if (CSGXInputManager.get().isMouseButtonReleased(CSGXInputManager.eMouseButtonLeft)) {
				bMouseDragged = false;
			}
			
			m_MouseMoveDX = m_MouseX - m_MousePreviousX;
			m_MouseMoveDY = m_MouseY - m_MousePreviousY;
			
			if (bMouseDragged) {
				m_MouseDX = m_MouseX - iMouseMoveX;
				m_MouseDY = m_MouseY - iMouseMoveY;
				
				m_MouseDraggedX = m_MouseX - m_MouseClickedX;
				m_MouseDraggedY = m_MouseY - m_MouseClickedY;
				
				iMouseMoveX = m_MouseX;
				iMouseMoveY = m_MouseY;
			}
			
			if (m_bLeftPressed || m_bRightPressed) {
				m_bAnyButtonPressed = true;
			}
			if (m_bLeftDown || m_bRightDown) {
				m_bAnyButtonDown = true;
			}
		}
		
	}
		
}