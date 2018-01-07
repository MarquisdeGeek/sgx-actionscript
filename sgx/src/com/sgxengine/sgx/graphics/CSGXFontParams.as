package com.sgxengine.sgx.graphics
{
	public class CSGXFontParams
	{
		public static const eFontTypeDefault : uint = 7;

		public static const eFontTypeBitmap : uint = 0;		
		public static const eFontTypeOutline : uint = 1;
		public static const eFontTypeExtruded : uint = 2;
		public static const eFontTypePolygon : uint = 3;
		public static const eFontTypePixmap : uint = 4;
		public static const eFontTypeTexture : uint = 5;
		
		public static const eFontTypeRegionedTexture : uint = 6;
		public static const eFontTypeMultipleTexture : uint = 7;
	
		public var m_iTypeSize : uint;
		public var m_iTypeDepth : uint;
		public var m_iFontType : uint;
		

		public function CSGXFontParams(type : uint = eFontTypeDefault)
		{
			m_iTypeSize = 16;
			m_iTypeDepth = 32;
			m_iFontType = type;
		}
	}
}