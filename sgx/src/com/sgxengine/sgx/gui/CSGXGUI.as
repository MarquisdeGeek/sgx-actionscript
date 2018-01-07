package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.core.threading.CSGXCallback;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.*;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class CSGXGUI
	{
		public static const eVisibleAlways : uint = 0;
		public static const eVisibleWhenValid : uint = 1;
		public static const eVisibleWhenPressed : uint = 2;
		public static const eHideOnKeyPress : uint = 3;
		public static const eOff : uint = 4;
		public static const eManual : uint = 5;

		protected static var ms_pSingleton : CSGXGUI; 
		
		protected var m_pCurrentSurface : CSGXDrawSurface;
		protected var m_pDefaultFont : CSGXFont;
	
		protected var m_vPosition : sgxPoint2i;
		protected var m_vLastPosition : sgxPoint2i;
		protected var m_bWasPointerDown : Boolean;
		protected var m_bPointerIsDown : Boolean;
		protected var m_bPointerValid : Boolean;
		protected var m_PointerVisibility : uint;

		protected var m_bHideOnKeyVisibility : Boolean;
		protected var m_bPointerVisible : Boolean;

		protected var m_pPointerTexture : CSGXTexture;
		protected var m_iPointerRegionIn : uint;
		protected var m_iPointerRegionOut : uint;
		protected var m_iPointerImageSize : uint;
		protected var m_vPointerHotspot : sgxPoint2i;

		protected var m_pRootWidget : sgxWidget;

		protected var m_pActive : sgxWidget;
		protected var m_pFocus : sgxWidget;
		
		protected var m_pCurrentSkin : CSGXGUISkin;
		
		public function CSGXGUI()
		{
			m_pRootWidget = null;
			m_pCurrentSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			m_pDefaultFont = null;
			m_vPosition = new sgxPoint2i();
			m_vLastPosition = new sgxPoint2i();
			m_vPointerHotspot = new sgxPoint2i();
			
			m_pCurrentSkin = new CSGXGUISkin();		
			
		}
		
		public static function create(pCopy : CSGXGUI = null) : CSGXGUI
		{
			if (ms_pSingleton) {
				//sgxTrace(SID_WARNING("Attempting to re-create the singleton, CSGXTextureManager"));
			}
			
			ms_pSingleton = ms_pSingleton ? ms_pSingleton : pCopy;
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXGUI();
				if (ms_pSingleton) {
					ms_pSingleton.initialize();
				}
			}
			return ms_pSingleton;
		}
		
		public static function get() : CSGXGUI
		{
			if (!ms_pSingleton) {
				ms_pSingleton = create(null);
			}
			return ms_pSingleton;
		}
		
		public function initialize() : void
		{
		}
		
		public function setRootWidget(root : sgxWidget) : void
		{
			m_pRootWidget = root;
		}
		
		public function getRootWidget() : sgxWidget
		{
			return m_pRootWidget;
		}
		
		public function registerWidget(root : sgxWidget) : void
		{
			
		}
		
		public function getDefaultFont() : CSGXFont
		{
			return null;
		}
		
		
		public function getCurrentSkin() : CSGXGUISkin {
			return m_pCurrentSkin;
		}
			
		
		public function createFrame(x : int, y : int, params : sgxGUIFrameParams, registerWithGUI : Boolean = true) : sgxWidget{
			var ptr : sgxWidget = new sgxGUIFrame(x,y,params);
			registerWithGUI && registerWidget(ptr);
			return ptr;
		}
		
		public function createImageButton(x : int, y : int, params : sgxGUIImageButtonParams, cb : CSGXCallback=null, param:uint = 0, registerWithGUI : Boolean = true) : sgxWidget{
			var ptr : sgxWidget = new sgxGUIImageButton(x,y,params);
			registerWithGUI && registerWidget(ptr);
			return ptr;
		}
		
		public function createHotSpot(x : int, y : int, params : sgxGUIHotSpotParams, cb : CSGXCallback=null, userdata:uint = 0, registerWithGUI : Boolean = true) : sgxWidget{
			var ptr : sgxWidget = new sgxGUIHotSpot(x,y,params);
			ptr.setUserData(userdata);
			ptr.setCallback(cb);
			registerWithGUI && registerWidget(ptr);
			return ptr;
		}
		
		public function createStaticImage(x : int, y : int, params : sgxGUIStaticImageParams, registerWithGUI : Boolean = true) : sgxWidget{
			var ptr : sgxWidget = new sgxGUIStaticImage(x,y,params);
			registerWithGUI && registerWidget(ptr);
			return ptr;
		}
		
		public function createStaticText(x : int, y : int, justifyHorizontal : uint, justifyVertical : uint, params : sgxGUIStaticTextParams, registerWithGUI : Boolean = true) : sgxWidget{
			var ptr : sgxWidget = new sgxGUIStaticText(x,y,justifyHorizontal,justifyVertical,params);
			registerWithGUI && registerWidget(ptr);
			return ptr;
		}
		
		public function draw() : void {
			drawScreens(m_pRootWidget);
			drawCursor();
		}
	
		public function drawScreens(pFrame : sgxWidget) : void {
			
			var pPopFont : CSGXFont = null;
			if (!m_pCurrentSurface) {
				return;
			}
			
			if (m_pDefaultFont) {
				pPopFont = m_pCurrentSurface.getCurrentFont();
				m_pCurrentSurface.setCurrentFont(m_pDefaultFont);
			}
			
			if (pFrame) {
				pFrame.draw();
			}
			
			//
			if (m_pDefaultFont) {
				m_pCurrentSurface.setCurrentFont(pPopFont);
			}
		}
		
		public function drawCursor(pSurface : CSGXDrawSurface = null) : void {
		
			var pUseSurface : CSGXDrawSurface = pSurface;
			
			if (pSurface == null) {
				pUseSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			} else {
				pUseSurface = m_pCurrentSurface;
			}
			//
			if (m_pCurrentSurface && isPointerVisible()) {
				//CSGXGraphicsEngine::get().set2DMode();
				
				//		pUseSurface.resetRenderTransform();
				pUseSurface.setFillTexture(m_pPointerTexture);
				pUseSurface.setFillTextureRegion(m_bPointerIsDown?m_iPointerRegionIn:m_iPointerRegionOut);
				pUseSurface.setFillColor(sgxColorRGBA.White);
				pUseSurface.fillRect(m_vPosition.x, m_vPosition.y, m_vPosition.x+m_iPointerImageSize, m_vPosition.y+m_iPointerImageSize);
			}
			
		}
		
		public function applyPointerPosition(pos : sgxPoint2i) : void {
			var lastPos : sgxPoint2i = m_vPosition;
			
			m_vPosition = pos;
			m_vPosition.x -= m_vPointerHotspot.x;
			m_vPosition.y -= m_vPointerHotspot.y;
			
			if (m_vPosition.x != lastPos. x && m_vPosition.y != lastPos.y) {
				m_bHideOnKeyVisibility = false;
			}
		}
			
		public function applyPointerUp() : void{
			m_bPointerIsDown = false;
		}
		
		public function applyPointerDown() : void {
			m_bPointerIsDown = true;
		}
		/*
		void
		CSGXGUI::applyKeyboardUp(const tUINT32 key) {
			m_isKeyDown[key/32] &= ~(1<<(key&31));
		}
			
			void
			CSGXGUI::applyKeyboardDown(const tUINT32 key) {
				m_isKeyDown[key/32] |= (1<<(key&31));
				m_bHideOnKeyVisibility = TRUE;
			}
			
			void
			CSGXGUI::applyKeyboardState(const tUINT32 key, const tBOOL state) {
				if (state) {
					applyKeyboardDown(key);
				} else {
					applyKeyboardUp(key);
				}
			}
			
			tUINT32
		CSGXGUI::applyKeyboardState(const tUINT32 *bitStates) {
			for(tUINT32 i=0;i<8;++i) {
				m_isKeyDown[i] = bitStates[i];
				
			}
			return 1;
		}
*/
		public function setPointerAs(visible : uint) : void {
			m_PointerVisibility = visible;
		}
					
		public function setPointerImage(pTexture : CSGXTexture, regionIn : uint, regionOut : uint, size: uint) : void{
			m_pPointerTexture = pTexture;
			m_iPointerRegionIn = regionIn;
			m_iPointerRegionOut = regionOut;
			m_iPointerImageSize = size;
		}
		
		public function setPointerHotspot(vHotspot : sgxPoint2i) : void{
			m_vPointerHotspot = vHotspot;
		}
			
		public function isPointerVisible() : Boolean{
			switch(m_PointerVisibility) {
				case eVisibleAlways:
					return true;
				case eVisibleWhenValid:
					return m_bPointerValid;
				case eVisibleWhenPressed:
					return m_bPointerIsDown;
				case eOff:
					return false;
				case eManual:
					return m_bPointerVisible;
				case eHideOnKeyPress:
					return !m_bHideOnKeyVisibility;
			}
			
			return false;
		}
	
		public function setValidPointer(valid : Boolean) : void{
			m_bPointerValid = valid;
		}
			
		public function showPointer(visible : Boolean) : void {
			m_bPointerVisible = visible;
			setPointerAs(eManual);
		}
		
		public function hidePointer() : void{
			showPointer(false);
		}

		
		public function update(telaps : Number) : void{
			updateFrame(m_pRootWidget, telaps);
		}
		
		protected function updateFrame(pRoot : sgxWidget, telaps : Number) : void {
			var pWidget : sgxWidget = null;
			
			if (pRoot) {
				// If an object is active, then give it priority over
				// the others. i.e. find a c&d hotspot if it's being dragged
				
				if (m_pActive) {
					var targetArea : sgxRect2i = new sgxRect2i();
					
					m_pActive.getArea(targetArea);
					
					if (targetArea.isInside(m_vPosition.x, m_vPosition.y)) {
						pWidget = m_pActive;
					}
				}
				
				// otherwise find the first one that exists
				if (!pWidget) {
					pWidget = pRoot.getWidgetAt(m_vPosition, sgxWidget.eFunctioningWidgets);
				}
				
				pRoot.update(telaps);
			}
			
			// onClick
			if (m_bPointerIsDown && !m_bWasPointerDown) {
				if (pWidget) {
					if (pWidget.isEnabled()) {
						pWidget.onPressed(m_vPosition);
					}
				} else {
					clearFocus();
				}
			}
			
			// on release
			if (m_bWasPointerDown && !m_bPointerIsDown) {
				if (m_pActive) {
					m_pActive.onRelease(m_vPosition);
				}
				clearActive();
			}
			
			// on normal moving
			if (m_bWasPointerDown == m_bPointerIsDown && m_vPosition.neq(m_vLastPosition)) {
				var pLastPositionWidget : sgxWidget = getWidgetAt(m_vLastPosition, sgxWidget.eFunctioningWidgets);
				var pCurrentPositionWidget : sgxWidget = getWidgetAt(m_vPosition, sgxWidget.eFunctioningWidgets);
				
				// TODO: if we're dragging an item, we don't want to handle any
				// of the enter/leaving code.
				if (m_pActive) {
					
					if (pCurrentPositionWidget == m_pActive) {
						m_pActive.onCursorDragged(m_vPosition);
					} else {
						m_pActive.onCursorDraggedOutside(m_vPosition);
					}
					
					// handle the moving onto, and off from, the current widget
					if (pCurrentPositionWidget == m_pActive && pLastPositionWidget != m_pActive) {
						m_pActive.onReenterArea(m_vPosition);
					}
					if (pLastPositionWidget == m_pActive && pCurrentPositionWidget != m_pActive) {
						m_pActive.onLeaveArea(m_vPosition);
					}
					//
					if (m_pActive != pCurrentPositionWidget && pCurrentPositionWidget) {
						if (pCurrentPositionWidget.isFlagSet(sgxWidget.eTriggerAutoDownEnter)) {
							m_pActive && m_pActive.onRelease(m_vPosition);
							pCurrentPositionWidget.onPressed(m_vPosition);
						}
					}
					
				} else {	// nothing active, just do hovers
					if (pLastPositionWidget != pCurrentPositionWidget) {
						if (pLastPositionWidget) {
							pLastPositionWidget.onHoverLeave(m_vLastPosition);
						}
						if (pCurrentPositionWidget) {
							pCurrentPositionWidget.onHoverEnter(m_vPosition);
						}
						//
						if (m_bPointerIsDown && pCurrentPositionWidget) {
							if (pCurrentPositionWidget.isFlagSet(sgxWidget.eTriggerAutoDownEnter)) {
								pCurrentPositionWidget.onPressed(m_vPosition);
							}
						}
					}
				}
			}
			
			// onKeyDown - iterate all keys with changed states, and process the first.]
/*
			var pTargetWidget : sgxWidget = m_pFocus;
			if (pTargetWidget && pTargetWidget.isEnabled()) {
				for(var i:uint=0;i<256;++i) {
					if (wasKeyPressed(i)) {
						pTargetWidget.onKeyDown(i);
					} else if (wasKeyReleased(i)) {
						pTargetWidget.onKeyUp(i);
					}
				}
			} else if (m_pCallbackHandler) {
				for(i=0;i<256;++i) {
					if (wasKeyPressed(i)) {
						m_pCallbackHandler.onGUIManagerKeyDown(i);
					} else if (wasKeyReleased(i)) {
						m_pCallbackHandler.onGUIManagerKeyUp(i);
					}
				}
			}
			*/
			
			if (pWidget && pWidget.isEnabled() && !(pWidget is sgxGUIFrame)) {
				Mouse.cursor = MouseCursor.HAND;
			} else {
				Mouse.cursor = MouseCursor.ARROW;
			}
			
			// Now update the lasts...
			m_bWasPointerDown = m_bPointerIsDown;
			m_vLastPosition.set(m_vPosition);
			/*
			for(i=0;i<8;++i) {
				m_wasKeyDown[i] = m_isKeyDown[i];
			}
			*/
		}

		
		/*
		tBOOL
		CSGXGUI::isKeyDown(const tUINT32 key) const {
			return (m_isKeyDown[key/32] & (1<<(key&31)));
		}
		
		tBOOL
		CSGXGUI::isKeyUp(const tUINT32 key) const {
			return !isKeyDown(key);
		}
		
		tBOOL
		CSGXGUI::wasKeyPressed(const tUINT32 key) const {
			tBOOL wasDown = (m_wasKeyDown[key/32] & (1<<(key&31)));
			tBOOL isDown = (m_isKeyDown[key/32] & (1<<(key&31)));
			
			return (!wasDown && isDown);
		}
		
		tBOOL
		CSGXGUI::wasKeyReleased(const tUINT32 key) const {
			tBOOL wasDown = (m_wasKeyDown[key/32] & (1<<(key&31)));
			tBOOL isDown = (m_isKeyDown[key/32] & (1<<(key&31)));
			
			return wasDown && !isDown;
		}
		*/
		//
		// Internal processing
		//
		public function setFocus(pWidget : sgxWidget) : void{
			m_pFocus = pWidget;
			if (m_pFocus) {
				m_pFocus.onFocusGain();
			}
		}
		
		public function setActive(pWidget : sgxWidget) : void{
			m_pActive = pWidget;
			if (m_pActive) {
				m_pActive.onActiveGain();
			}
		}
		
		
		public function getActiveWidget() : sgxWidget {
			return m_pActive;
		}
		
		public function getFocusWidget() : sgxWidget {
			return m_pFocus;
		}
		
		public function clearFocus() : void {
			if (m_pFocus) {
				m_pFocus.onFocusLose();
			}
			m_pFocus = null;
		}
		
		public function clearActive() : void{
			if (m_pActive) {
				m_pActive.onActiveLose();
			}
			m_pActive = null;
		}
		
		public function getWidgetAt(position : sgxPoint2i, fromSet : uint) : sgxWidget{
			if (m_pRootWidget) {
				return m_pRootWidget.getWidgetAt(position, fromSet);
			}
			return null;
		}
		/*
		sgxWidget *CSGXGUI::getWidgetOfUserData(const tCHAR c, const tUINT32 idx) {
			if (m_pRootWidget) {
				return m_pRootWidget->getWidgetOfUserData(c, idx);
			}
			return NULL;
		}
		
		sgxWidget *CSGXGUI::getWidgetOfUserData(const char *str) {
			tUINT32 userdata = sgxGetCRC32(str);
			return getWidgetOfUserData(userdata);
		}
		
		sgxWidget *CSGXGUI::getWidgetOfUserData(const sgxString &str) {
			return getWidgetOfUserData(str.c_str());
		}
		
		sgxWidget *CSGXGUI::getWidgetOfUserData(const tUINT32 userdata) {
			if (m_pRootWidget) {
				return m_pRootWidget->getWidgetOfUserData(userdata);
			}
			return NULL;
		}
		
		sgxWidget *CSGXGUI::getWidgetWithKeyShortcut(const tUINT32 key) {
			if (m_pRootWidget) {
				return m_pRootWidget->getWidgetWithKeyShortcut(key);
			}
			return NULL;
		}
*/
		
		
	}
}