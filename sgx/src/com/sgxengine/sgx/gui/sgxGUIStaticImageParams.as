package com.sgxengine.sgx.gui
{
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.CSGXTexture;

	public class sgxGUIStaticImageParams
	{
		public static const eImage : uint = 0;
		public static const eTileArea : uint = 1;
		public static const eSurroundArea : uint = 2;
		public static const eHollowSurround : uint = 3;
		
		
		public var m_pTexture : CSGXTexture;
		public var m_Region : uint;
		public var m_Style : uint;
		public var m_Width : uint;
		public var m_Height : uint;
		public var m_Color : sgxColorRGBA;

		// sgxGraphicsMaterial *pMaterial, const tStyle style, const tUINT32 w, const tUINT32 h
		public function sgxGUIStaticImageParams(pTexture : CSGXTexture=null, region : uint=0, style : uint=sgxGUIStaticImageParams.eImage, color : sgxColorRGBA=null, w : uint=0, h : uint=0)
		{
			m_pTexture = pTexture;
			m_Region = region;
			m_Style = style;
			m_Width = w;
			m_Height = h;
			m_Color = color;
			
			// AS HACK because Flex doesn't accept sgxColorRGBA.White as a default arg
			// (it claims to be a non-compile time const) 
			if (m_Color == null) {	
				m_Color = sgxColorRGBA.White;
			}
		}
	}
}