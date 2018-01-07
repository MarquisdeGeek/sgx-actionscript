package com.sgxengine.sgx.graphics
{
	public class CSGXFont
	{
		protected var m_LineSpacing : uint;
		protected var m_CharacterSpacing : uint;
		
		protected var height : uint;
	
		public function CSGXFont()
		{
			m_LineSpacing = (0);
			m_CharacterSpacing = (1);
			// String.fromCharCode
			// String.charCodeAt
			this.height = 0;
		}
		
		public function getCharacterSpacing() : uint {
			return m_CharacterSpacing;
		}
		
		public function getLineSpacing() : uint {
			return m_LineSpacing;
		}
		
		public function setCharacterSpacing(spacing : uint) : void {
			m_CharacterSpacing = spacing;
		}
		
		public function setLineSpacing(spacing : uint) : void {
			m_LineSpacing = spacing;
		}
		
		public function getHeight() : uint {
			return this.height;
		}
		
		public function getBaseline() : uint {
			return 0;
		}
		
		public function getXHeight() : uint {
			return 0;
		}
		
		public function getAscender() : uint {
			return 0;
		}
		
		public function getCharacterWidth(character : uint) : uint {
			return 0;
		}
		
		public function getStringWidth(pStr : String) : uint {
			var xpos : int = 0;
			for(var i:uint=0;i<pStr.length;++i) {
				var character : uint = pStr.charCodeAt(i);
				xpos += getCharacterWidth(character);
				xpos += m_CharacterSpacing;
			}
			return xpos;
		}
		
		
		public function draw(pSurface : CSGXDrawSurface, pStr : String, x : int, y : int, format : CSGXFontFormatting) : uint {
			var xpos : int = x;
			for(var i:uint=0;i<pStr.length;++i) {
				var character : uint = pStr.charCodeAt(i);
				xpos += drawCharacter(pSurface, character, xpos, y, format);
			}
			return (xpos - x)-m_CharacterSpacing;	// 
		}
		
		public function drawCharacter(pSurface : CSGXDrawSurface, character : uint, x : int, y : int, format : CSGXFontFormatting) : uint {
			return m_CharacterSpacing;
		}
		
		
		
			//virtual void	getFormattedBlockRect(sgxRect2i &rc, const sgxVector<sgxString> &stringList) const;
			//virtual tUINT32	getFormattedBlockStrings(sgxVector<sgxString> &result, const char *pStr, const CSGXFontFormatting &formatting) const;
			
			
			
	}
}