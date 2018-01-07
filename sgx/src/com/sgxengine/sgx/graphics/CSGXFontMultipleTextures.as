package com.sgxengine.sgx.graphics
{
	public class CSGXFontMultipleTextures extends CSGXFont
	{
		protected var textureList : Array;

		public function CSGXFontMultipleTextures()
		{
			super();
			
			this.textureList = new Array(128);
		}
		
		public static function load(filepath:String) : CSGXFont
		{
			var font : CSGXFontMultipleTextures = new CSGXFontMultipleTextures();
			
			font.loadFont(filepath);
			
			return font;
		}
		
		private function loadFont(filepath:String) : void {
			for(var i:uint='0'.charCodeAt(0);i<='9'.charCodeAt(0);++i) {
				this.textureList[i] = CSGXTextureManager.get().loadTexture(filepath+"/"+String.fromCharCode(i));
			}	
		}
		
		public override function getHeight() : uint {
			// This method is necessarily implemented in this way, because loadTexture is async
			// so the bitmap may not be available to compute the height during the ctor
			if (this.height == 0) {
				var tmp : uint;
				for(var i:uint='0'.charCodeAt(0);i<='9'.charCodeAt(0);++i) {
					if (this.textureList[i] != undefined) {
						tmp = this.textureList[i].getHeight();
						this.height = tmp;
						break;
					}
				}
			}
			return this.height;
		}
		
		public override function getCharacterWidth(character : uint) : uint {
			if (this.textureList[character] == undefined) {
				return 0;
			}
			return this.textureList[character].getWidth();
		}
		
		public override function drawCharacter(pSurface : CSGXDrawSurface, character : uint, x : int, y : int, format : CSGXFontFormatting) : uint {
			var previousTexture : CSGXTexture = pSurface.getFillTexture();
			
			var w : uint = this.getCharacterWidth(character);
			var h : uint = this.getHeight();
			
			pSurface.setFillTexture(this.textureList[character]);
			pSurface.fillRect(x, y, x+w, y+h)
			pSurface.setFillTexture(previousTexture);
			return w + m_CharacterSpacing;
		}
		
				
	}
}