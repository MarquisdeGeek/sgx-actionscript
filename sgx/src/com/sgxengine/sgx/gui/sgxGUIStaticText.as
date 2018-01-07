package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;
	import com.sgxengine.sgx.graphics.CSGXFont;
	import com.sgxengine.sgx.graphics.CSGXFontFormatting;

	public class sgxGUIStaticText extends sgxWidget
	{
		public var m_SetupParams : sgxGUIStaticTextParams;

		public var m_Text : String;
		public var m_BaseX : int;
		public var m_BaseY : int;
		public var m_JustifyX : int;
		public var m_JustifyY : int;
		
		private var m_StringListCache : Array;	// vector <string>
		private var m_StringListRect : sgxRect2i;

		
		public function sgxGUIStaticText(x:int, y:int, jx : uint, jy:uint, params : sgxGUIStaticTextParams)
		{
			super(x,y,CGUIDesignScreen.widgetText);
			
			m_SetupParams = params;
			m_BaseX = x;
			m_BaseY = y;
			m_JustifyX = jx;
			m_JustifyY = jy;

			m_StringListCache = new Array();
			m_StringListRect = new sgxRect2i();
			
			setText(m_SetupParams.m_Text);
		}
		
		public override function getArea(rc : sgxRect2i) : void {
			rc.left = m_X;
			rc.top = m_Y;
			rc.right = m_X;
			rc.bottom = m_Y;
			
			var pFont : CSGXFont = CSGXGUI.get().getDefaultFont();
			if (pFont) {
				if (m_SetupParams.m_bUseFormatArea) {
					rc = m_StringListRect;
					rc += new sgxPoint2i(m_X, m_Y);
					
				} else {
					rc.right += pFont.getStringWidth(m_Text);
					rc.bottom += pFont.getHeight();
				}
			}
		}
		
		public override function setText(s : String) : Boolean {
			m_Text = s;
			/*
			m_StringListCache.clear();
			//
			const CSGXFont *pFont = CSGXGUI.get().getDefaultFont();
			if (pFont) {
				CSGXFontFormatting formatting;
				
				if (m_SetupParams.m_bUseFormatArea) {
					formatting.setRenderArea(m_SetupParams.m_FormatArea);
				}
				
				pFont.getFormattedBlockStrings(m_StringListCache, m_Text.c_str(), formatting);
				pFont.getFormattedBlockRect(m_StringListRect, m_StringListCache);
			} else {
				m_StringListCache.push_back(s);
			}
			*/
			return true;
		}
		
		protected override function drawWidget(pSurface : CSGXDrawSurface, offsetX : int, offsetY : int) : Boolean {
			if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetDraw(this, pSurface, offsetX, offsetY)) {
				return false;
			}
			
			var width : uint = pSurface.getWidth();
			var height : uint = pSurface.getHeight();
			
			var fmt : CSGXFontFormatting = new CSGXFontFormatting(m_JustifyX, m_JustifyY);
			fmt.setRenderArea(new sgxRect2i(0, m_BaseY, width, height));
			
			if (m_SetupParams.m_bUseFormatArea) {
				fmt.setRenderArea(m_SetupParams.m_FormatArea);
			}
			
			var pRestoreFont : CSGXFont = null;
			if (m_pFont) {
				pRestoreFont = pSurface.getCurrentFont();
				pSurface.setCurrentFont(m_pFont);
			}
			pSurface.setFontColor(m_SetupParams.m_Color);
			pSurface.drawText(m_Text, m_BaseX+offsetX, m_BaseY+offsetY, fmt);
			//pSurface.drawText(m_StringListCache, m_BaseX+offsetX, m_BaseY+offsetY, fmt);
			
			if (m_pFont) {
				pSurface.setCurrentFont(pRestoreFont);
			}
			
			return super.drawWidget(pSurface, m_X + offsetX, m_Y + offsetY);
		}
	
	}
}