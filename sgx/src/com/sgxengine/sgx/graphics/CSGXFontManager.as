package com.sgxengine.sgx.graphics
{
	import com.sgxengine.sgx.filesystem.CSGXFileSystem;

	public class CSGXFontManager
	{
		private static var ms_pSingleton : CSGXFontManager;
		protected var fontList : Object;

		public static function get() : CSGXFontManager
		{
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXFontManager();
			}
			return ms_pSingleton;
		}
		
		public function CSGXFontManager()
		{
			fontList = new Object();
		}
		
		public function registerFont(name : String, filename : String, params : CSGXFontParams) : CSGXFont {
			var font : CSGXFont = null;
			
			switch(params.m_iFontType) {
				case	CSGXFontParams.eFontTypeMultipleTexture:
				{
					font = CSGXFontMultipleTextures.load(filename);
					return font?fontList[name] = font:null;
				}
				case	CSGXFontParams.eFontTypeRegionedTexture:
				{
					font = CSGXFontRegionedTexture.load(filename);
					return font?fontList[name] = font:null;
				}
				default:
					break;
			}
			
			return null;
		}
		
		public function getFont(fontname : String) : CSGXFont {
			return this.fontList[fontname];
		}

			
	}
}