package com.sgxengine.sgx.graphics
{
	import com.sgxengine.sgx.core.math.sgxRect2i;

	public class CSGXFontFormatting
	{
		public static const eJustifyHorizontalLeft : uint = 0;
		public static const eJustifyHorizontalCenter : uint = 1;
		public static const eJustifyHorizontalRight : uint = 2;
		public static const eJustifyHorizontalCentre : uint = 1;
		
		public static const eJustifyVerticalTop : uint = 0;
		public static const eJustifyVerticallMiddle : uint = 1;
		public static const eJustifyVerticalMiddleXHeight : uint = 2;
		public static const eJustifyVerticalOnBaseline : uint = 3;
		public static const eJustifyVerticallBottom : uint = 4;
		
		public var m_iHorizontal : uint;
		public var m_iVertical : uint;
		
		public var m_bForceToRenderArea : Boolean;
		
		public var m_RenderArea : sgxRect2i;
		
		public static const AlignLeftTop : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalLeft,eJustifyVerticalTop);
		public static const AlignCenterTop : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalCenter,eJustifyVerticalTop);
		public static const AlignRightTop : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalRight,eJustifyVerticalTop);
		public static const AlignLeftMiddle : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalLeft,eJustifyVerticallMiddle);
		public static const AlignMiddle : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalCenter,eJustifyVerticallMiddle);
		public static const AlignRightMiddle : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalRight,eJustifyVerticallMiddle);
		public static const AlignLeftBottom : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalLeft,eJustifyVerticallBottom);
		public static const AlignCenterBottom : CSGXFontFormatting = new CSGXFontFormatting(eJustifyHorizontalCenter,eJustifyVerticallBottom);
	
		public function CSGXFontFormatting(horizontal : uint = eJustifyHorizontalLeft, vertical : uint = eJustifyVerticalTop) {
			m_iHorizontal = horizontal;
			m_iVertical = vertical;
			m_bForceToRenderArea = false;
		}
	
		public function setRenderArea(rc : sgxRect2i) :void {
			m_RenderArea = new sgxRect2i(rc.left,rc.top,rc.right,rc.bottom);
			m_bForceToRenderArea = true;
		}	
		
	}
}