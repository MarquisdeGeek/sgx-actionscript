package com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.core.gamecode.CGameObject;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.*;

	public class CGameObjectAsterBase extends CGameObject
	{
		public var bVisible : Boolean;
		public var condition : uint;
		
		public var m_pImage : CSGXTexture;
		public var x : int;
		public var y : int;
		public var w : int;
		public var h : int;

		public function CGameObjectAsterBase(pName : String = "") {
			bVisible = true;
			m_pImage = null;
			//
			x = y = w = h = 0;
			
			var name :String= "gfx/";
			name += pName;
			var p : CSGXTexture = CSGXTextureManager.get().getTexture(name);
			if (p) {
				w = p.getWidth();
				h = p.getHeight();
			}
			
		}
		
		public function  show() :void{
			bVisible = true;
		}
		
		public function  hide():void {
			bVisible = false;
		}
		
		public override function  draw() :void{
			if (bVisible) {
				var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
				
				pSurface.setFillTexture(m_pImage);
				pSurface.setFillColor(sgxColorRGBA.White);
				pSurface.fillRect(x,y,x+w,y+h);
			}
		}
		
		public override function setPosition(x_ : int, y_ : int) :void {
			x = x_;
			y = y_;
		}
		
		public function  setSize(w_ : int, h_ : int):void {
			w = w_;
			h = h_;
		}
		
		public function  getRect() :sgxRect2i {
			var rc : sgxRect2i = new sgxRect2i();
			rc.left = x;
			rc.right = x+w;
			rc.top = y;
			rc.bottom = y+h;
			return rc;
		}
		
		public function  getWidth() :int{
			return w;
		}
		
		public function  getHeight() :int {
			return h;
		}
		
		public function  setImage(pImage:CSGXTexture ) :void {
			m_pImage = pImage;
			w = pImage.getRegionWidth(0);
			h = pImage.getRegionHeight(0);
			
		}		
	
	}	
}
