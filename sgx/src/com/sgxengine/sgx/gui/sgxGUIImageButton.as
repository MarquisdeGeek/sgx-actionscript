package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;

	public class sgxGUIImageButton extends sgxWidget
	{
		protected var m_SetupParams : sgxGUIImageButtonParams;
		protected var m_pSkinParams : sgxGUISkinnedImageButton;
		
		protected var m_OverlayText : String;

		public static const DEFAULT_WIDTH : uint = 48;
		public static const DEFAULT_HEIGHT : uint = 48;
		

		public function sgxGUIImageButton(x:int, y:int, params:sgxGUIImageButtonParams)
		{
			super(x, y, CGUIDesignScreen.widgetImageButton);
			m_SetupParams = params;
			
			m_OverlayText = "";
			
			m_pSkinParams = new sgxGUISkinnedImageButton();
//			m_pSkinParams = CSGXGUI::get()->getCurrentSkin()->createSkinnedImageButton();
			
			m_pSkinParams.cursorOver = m_isOver;
			m_pSkinParams.m_Type = m_SetupParams.m_Type;
			//
			if (m_SetupParams.m_Type == sgxGUISkinnedImageButton.eCustom) {
				m_pSkinParams.m_pTexture = m_SetupParams.m_pCustomTexture;
				m_pSkinParams.m_iRegion = m_SetupParams.m_iCustomRegion;
			}
			
		}
		
		public override function setText(s : String)  : Boolean {
			m_OverlayText = s;
			return true;
		}
			
		public function setFirstRegion(region : uint) :void {
			if (m_SetupParams.m_Type == sgxGUISkinnedImageButton.eCustom) {
				m_pSkinParams.m_iRegion = region;
			}
		}	
		public override function getArea(rc : sgxRect2i) : void {
			rc.left = m_X;
			rc.top = m_Y;
			rc.right = rc.left + m_SetupParams.m_pCustomTexture.getRegionWidth(m_SetupParams.m_iCustomRegion);
			rc.bottom = rc.top + m_SetupParams.m_pCustomTexture.getRegionHeight(m_SetupParams.m_iCustomRegion);
		}
		
		protected override function drawWidget(pSurface : CSGXDrawSurface, offsetX : int, offsetY : int) : Boolean {
			if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetDraw(this, pSurface, offsetX, offsetY)) {
				return false;
			}
			
			var rc : sgxRect2i = new sgxRect2i();
			
			getArea(rc);
			m_pSkinParams.m_OverlayText = m_OverlayText;
			
			m_pSkinParams.topleft.x = rc.left+offsetX;
			m_pSkinParams.topleft.y = rc.top+offsetY;
			m_pSkinParams.bottomright.x = rc.right+DEFAULT_WIDTH;
			m_pSkinParams.bottomright.y = rc.bottom+DEFAULT_HEIGHT;
			
			m_pSkinParams.focused = isFocused();
			m_pSkinParams.selected = m_DirectedState;
			m_pSkinParams.cursorOver = m_isOver || isFocused();
			m_pSkinParams.enabled = m_bEnabled;
			
			m_pSkinParams.draw(pSurface);
			
			return super.drawWidget(pSurface, m_pSkinParams.topleft.x, m_pSkinParams.topleft.y);
		}
		

	}
}