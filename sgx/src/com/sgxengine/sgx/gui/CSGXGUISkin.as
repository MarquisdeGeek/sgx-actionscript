package com.sgxengine.sgx.gui
{
	public class CSGXGUISkin
	{
		public function CSGXGUISkin()
		{
		}
		/*
		public function createSkinnedHotSpot() : sgxGUISkinnedHotSpot
		{
			return new sgxGUISkinnedHotSpot();
		}
		*/
		public function createSkinnedStaticImage(params : sgxGUIStaticImageParams) : sgxGUISkinnedStaticImage
		{
			return new sgxGUISkinnedStaticImage(params);
		}
		
		public function createSkinnedImageButton() : sgxGUISkinnedImageButton
		{
			return new sgxGUISkinnedImageButton();
		}
		
	}
}