package com.sgxengine.sgx.graphics
{
	public class CSGXFontRegionedTexture extends CSGXFont
	{
		protected var texture : CSGXTexture;
		protected var firstCharacter : uint;
	
		public function CSGXFontRegionedTexture() {
			firstCharacter = 32;
		}
		
		public static function load(filepath:String) : CSGXFont
		{
			var font : CSGXFontRegionedTexture = new CSGXFontRegionedTexture();
			
			font.loadFont(filepath);
			
			return font;
		}
		
		private function loadFont(filepath:String) : void {
			this.texture = CSGXTextureManager.get().loadTexture(filepath);
		}
		
		public function prepareRegions(xStart:uint, yStart:uint, w:uint, h:uint, firstChar:uint=0) : void {
			if (texture) {
				texture.clearRegions();
				
				for(var y:uint = yStart;y<texture.getHeight();y+=h) {
					for(var x:uint = xStart;x<texture.getWidth();x+=w) {
						texture.addPixelRegion(x,y,x+w,y+h);
					}					
				}
				
				if (firstChar) {
					firstCharacter = firstChar;
				}
				
			}
		}
		
		public override function getHeight() : uint {
			if (texture) {
				return texture.getRegionHeight(0);
			}
			return 0;
		}
		
		public override function getCharacterWidth(character : uint) : uint {
			if (texture.isAvailable() && texture.getNumRegions() == 1) {
				prepareRegions(0,0,8,8);	// TODO: Find better defaults? But unnecessary once regions are read from .dat
			}

			if (texture && texture.isAvailable()) {
				if (texture.getNumRegions()) {
					return texture.getRegionWidth(character-firstCharacter);
				}
				return 8;
			}
	
			return 0;
		}
		
		public override function drawCharacter(pSurface : CSGXDrawSurface, character : uint, x : int, y : int, format : CSGXFontFormatting) : uint {
			var previousTexture : CSGXTexture = pSurface.getFillTexture();
			
			var w : uint = this.getCharacterWidth(character);
			var h : uint = this.getHeight();
			
			pSurface.setFillTexture(texture, character-firstCharacter);
			pSurface.fillRect(x, y, x+w, y+h)
			pSurface.setFillTexture(previousTexture);
			return w + m_CharacterSpacing;
		}
		
				
	}
}