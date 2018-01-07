package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.gamecode.CGameHandler;
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.core.threading.CSGXCallback;
	import com.sgxengine.sgx.graphics.*;

	public class sgxWidget extends CGameHandler
	{
		public static const eAll : uint = 0;
		public static const eFunctioningWidgets : uint = 1;
		public static const eEnabledWidgets : uint = 2;
		public static const eAllFromTop : uint = 3;

		public static const eTriggerOnDown : uint = 1;
		public static const eTriggerAutoUpLeave : uint = 2;
		public static const eTriggerAutoUpAlways : uint = 4;
		public static const eTriggerAutoDownEnter : uint = 8;
		public static const eTriggerAutoDownHover : uint = 16;

		protected var m_X : int;
		protected var m_Y : int;
		protected var m_Type : int;
		protected var m_iFlags : uint;
		protected var m_UserData : *;

		protected var m_bEnabled : Boolean;
		protected var m_bVisible : Boolean;
		
		protected var m_isOver : Boolean;
		protected var m_DirectedState : Boolean;
		
		protected var m_pFont : CSGXFont;
		
		
		protected var m_pSelectCallback : CSGXCallback;
		protected var m_pCallbackHandler : *;
		protected var m_Children : Array;

		public function sgxWidget(x : int, y : int, type : int)
		{
			m_X = x;
			m_Y = y;
			m_Type = type;
			
			m_bEnabled = true;
			m_bVisible = true;
			
			m_iFlags = 0;
			
			m_Children = new Array();
			
			m_pCallbackHandler = null;
			m_pSelectCallback = null;

		}
		
		public function setCallback(cb : CSGXCallback) : void {
			m_pSelectCallback = cb;
		}
		
		public function setPosition(x : int, y : int) : void {
			m_X = x;
			m_Y = y;
		}
		
		public function getPosition(pt : sgxPoint2i) : void {
			pt.x = m_X;
			pt.y = m_Y;
		}
		
		public function getX() : int {
			return m_X;
		}
		
		public function getY()  : int {
			return m_Y;
		}
		
		
		public function setText(s : String)  : Boolean {
			return true;
		}
		
		
		// Handlers
		public function onPressed(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetPressed(this, position)) {
					return false;
				}
			}
			
			m_DirectedState = true;
			if (m_iFlags & eTriggerOnDown) {
				onSelect(position);
			}
			
			CSGXGUI.get().setFocus(this);
			CSGXGUI.get().setActive(this);
			
			if (m_iFlags & eTriggerAutoUpAlways) {
				CSGXGUI.get().clearFocus();
				CSGXGUI.get().clearActive();
			}
			return true;
		}
		
		public function onCursorDragged(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetCursorDragged(this)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function onRelease(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetRelease(this, position)) {
					return false;
				}
			}
			if (m_DirectedState && !(m_iFlags & eTriggerOnDown)) {
				onSelect(position);
			}
			m_DirectedState = false;
			
			return true;
		}
		
		public function onLeaveArea(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetLeaveArea(this, position)) {
					return false;
				}
			}
			
			if (m_iFlags & eTriggerAutoUpLeave) {
				CSGXGUI.get().clearFocus();
				CSGXGUI.get().clearActive();
			}
			
			m_DirectedState = false;
			
			return true;
		}
		
		public function onCursorDraggedOutside(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetCursorDraggedOutside(this)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function onReenterArea(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetReenterArea(this)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function onKeyDown(key : uint) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetKeyDown(key)) {
					return false;
				}
			}
			
			for each(var c : sgxWidget in m_Children) {
				if (!c.onKeyDown(key)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function onKeyUp(key : uint) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetKeyUp(this)) {
					return false;
				}
			}
			
			for each(var c : sgxWidget in m_Children) {
				if (!c.onKeyUp(key)) {
					return false;
				}
			}
						
			return true;
		}
		
		public function onHoverEnter(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetHoverEnter(this)) {
					return false;
				}
			}
			
			if (m_iFlags & eTriggerAutoDownHover) {
				onPressed(position);
			}
			
			m_isOver = true;			
			return true;
		}
		
		public function onHoverLeave(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetHoverLeave(this)) {
					return false;
				}
			}
			//
			if (isFocused()) {
				CSGXGUI.get().clearFocus();
			}
			
			m_isOver = false;
		
			return true;
		}
		
		
		public function onFocusGain() : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetFocusGain(this)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function onFocusLose() : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetFocusLose(this)) {
					return false;
				}
			}
			
			m_isOver = false;
			return true;
		}
			
		public function onActiveGain() : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetActiveGain(this)) {
					return false;
				}
			}
			
			return true;
		}	
		
		public function onActiveLose() : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetActiveLose(this)) {
					return false;
				}
			}
			
			m_isOver = false;
			return true;
		}
				
		public function onSelect(position : sgxPoint2i) : Boolean {
			if (m_pCallbackHandler) {
				if (!m_pCallbackHandler.onGUIWidgetSelect(this, position)) {
					return false;
				}
			}
			
			if (m_pSelectCallback) {
				m_pSelectCallback.call(0);
			}
			CSGXGUI.get().clearFocus();
			CSGXGUI.get().clearActive();
			return true;
		}

			
		public function isFocused() : Boolean {
			return CSGXGUI.get().getFocusWidget() == this;
		}
		
		public function isActive() : Boolean {
			return CSGXGUI.get().getActiveWidget() == this;
		}
		
		public function isEnabled() : Boolean {
			return m_bEnabled;
		}
		
		
		public function isPointInside(position : sgxPoint2i) : Boolean {
			var rc : sgxRect2i = new sgxRect2i();
			getArea(rc);
			return rc.isInside(position.x, position.y);
		}

		public function getArea(rc : sgxRect2i) : void {
			rc.left = m_X;
			rc.top = m_Y;
		}
		
		public function getWidth() : uint {
			var rc : sgxRect2i = new sgxRect2i();
			getArea(rc);
			return rc.right - rc.left;
		}
		
		public function getHeight() : uint {
			var rc : sgxRect2i = new sgxRect2i();
			getArea(rc);
			return rc.bottom - rc.top;
		}

		public function addChildWidget(child : sgxWidget) : void {
			m_Children.push(child);
		}
		
		public function getWidgetAt(position : sgxPoint2i, fromSet : uint = eEnabledWidgets) : sgxWidget {
			switch(fromSet) {
				case eFunctioningWidgets:
					switch(m_Type) {
						case CGUIDesignScreen.widgetImage:
						case CGUIDesignScreen.widgetText:
						case CGUIDesignScreen.widgetAnimatedImage:
							return null;
						default:
							break;
					}
					//
					if (!m_bEnabled) {
						return null;
					}
					break;
				
				case eEnabledWidgets:
					if (!m_bEnabled) {
						return null;
					}
					break;
				
				case eAll:
				case eAllFromTop:
					break;
			}
			// Ignore container widgets (i.e. frame)
			if (m_Type != CGUIDesignScreen.widgetFrame && isPointInside(position)) {
				return this;
			}
			
			var pos : sgxPoint2i = new sgxPoint2i(position.x, position.y);
			pos.x -= m_X;
			pos.y -= m_Y;
	
			if (false && fromSet == sgxWidget.eAllFromTop) {
				// TODO: Backward its
			} else {
				for each(var c : sgxWidget in m_Children) {
					var pFound : sgxWidget = c.getWidgetAt(pos, fromSet);
					if (pFound) {
						return pFound;
					}
				}
			}
		
			return null;
		}
		
		
		
		public override function draw() : void {
			drawWidget(CSGXDrawSurfaceManager.get().getDisplaySurface(), 0, 0);
		}
		
		public function drawOn(pSurface : CSGXDrawSurface = null) : void {
			drawWidget(pSurface ? pSurface : CSGXDrawSurfaceManager.get().getDisplaySurface(), 0, 0);
		}
		
		protected function drawWidget(pSurface : CSGXDrawSurface, offsetX : int, offsetY : int) : Boolean {
			if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetDraw(this, pSurface, offsetX, offsetY)) {
				return false;
			}
			
			var rt : Boolean = true;
			
			if (!m_bVisible) {
				return false;
			}
			
			for each(var c : sgxWidget in m_Children) {
				if (c.m_bVisible) {
					if (!c.drawWidget(pSurface, offsetX, offsetY)) {
						rt = false;
					}
				}
			}
			
			return rt;
		}
		
		public function getUserData() : uint {
			return m_UserData;
		}
		
		public function setUserData(id : uint) : uint {
			var old : uint = m_UserData;
			m_UserData = id;
			return old;
		}
		
		public function isFlagSet(flag : uint) : Boolean {
			return m_iFlags & flag ? true : false;
		}
		
		public function setFlags(flag : uint, state : Boolean = true) : uint {
			var old : uint = m_iFlags;
			if (state) {
				m_iFlags |= flag;
			} else {
				m_iFlags &= ~flag;
			}
			return old;
		}
		
	}
}