package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.stl.sgxString;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;
	import com.sgxengine.sgx.graphics.CSGXFontFormatting;
	import com.sgxengine.sgx.graphics.CSGXTexture;

	public class sgxGUISkinnedImageButton extends sgxGUISkinnedWidget
	{
		public static const eLeft : uint = 0;
		public static const eRight : uint = 1;
		public static const eUp : uint = 2;
		public static const eDown : uint = 3;
		public static const eCustom : uint = 4;
		
		public var selected : Boolean;
		public var focused : Boolean;
		
		public var m_Type : uint;
		
		public var m_pTexture : CSGXTexture;
		public var m_iRegion : uint;
		
		public var m_OverlayText : String;
		
		public function sgxGUISkinnedImageButton()
		{
			m_OverlayText = "";
		}
		
		public override function draw(pSurface : CSGXDrawSurface) : void {
			
			var cursorOver : Boolean = cursorOver || focused;
			var useHoverGraphics : Boolean = (!selected && true /*pSkin->m_BaseSettings.m_bSupportHover*/ && cursorOver);
			
			var realButtonRight : sgxPoint2i = new sgxPoint2i(bottomright.x, bottomright.y);
			/*
			pSurface.setFillTexture(m_pTexture);
			pSurface.setFillTextureRegion( m_SetupParams.m_iCustomRegion + (selected?0:(useHoverGraphics?2:1)));
			pSurface.setFillColor(enabled?sgxColorRGBA.White:sgxColorRGBA.DkGrey);
			
			pSurface.fillRect(rc.left+offsetX,rc.top+offsetY,rc.right,rc.bottom);
			*/
			var region : uint = m_iRegion;

			realButtonRight.x = topleft.x + m_pTexture.getRegionWidth(region);
			realButtonRight.y = topleft.y + m_pTexture.getRegionHeight(region);

			pSurface.setFillTexture(m_pTexture, selected?region:(useHoverGraphics?region+2:region+1));
			pSurface.setFillColor(enabled?sgxColorRGBA.White:sgxColorRGBA.DkGrey);
			pSurface.fillRect(topleft.x, topleft.y, realButtonRight.x, realButtonRight.y);

			pSurface.drawText(m_OverlayText, (realButtonRight.x+topleft.x)/2+(selected?1:0), (realButtonRight.y+topleft.y)/2+(selected?1:0), CSGXFontFormatting.AlignMiddle);
			
			//return super.draw(pSurface, rc.left+offsetX, rc.left+offsetY);
		}
	
	}
}