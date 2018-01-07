package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.graphics.CSGXTexture;

	public class sgxGUIImageButtonParams
	{
		public var m_Type : uint;

		public var m_pCustomTexture : CSGXTexture;
		public var m_iCustomRegion : uint;

		public function sgxGUIImageButtonParams(texture : CSGXTexture, region : uint)
		{
			m_pCustomTexture = texture;
			m_iCustomRegion = region;
			
			m_Type = sgxGUISkinnedImageButton.eCustom;
		}
	}
}