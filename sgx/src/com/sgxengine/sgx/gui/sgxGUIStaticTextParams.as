package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;

	public class sgxGUIStaticTextParams
	{
		public var m_Text : String;
		public var m_Color : sgxColorRGBA;
		public var m_bUseFormatArea : Boolean;
		public var m_FormatArea : sgxRect2i;
	
		public function sgxGUIStaticTextParams(text : String, color : sgxColorRGBA, formatArea : sgxRect2i = null)
		{
			m_Text = text;
			m_Color = color;
			
			if (formatArea) {
				m_bUseFormatArea = formatArea ? true : false;
				m_FormatArea = new sgxRect2i();
			} else {
				m_bUseFormatArea = formatArea ? true : false;
				m_FormatArea = new sgxRect2i(formatArea.left, formatArea.top, formatArea.right, formatArea.bottom);
			}
		}
	}
}