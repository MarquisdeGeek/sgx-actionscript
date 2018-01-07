package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;

	public class sgxGUISkinnedWidget
	{
		public var topleft : sgxPoint2i;
		public var bottomright : sgxPoint2i;
		public var enabled : Boolean;
		public var cursorOver : Boolean;
		
		public function sgxGUISkinnedWidget()
		{
			enabled = false;
			cursorOver = true;
			
			topleft = new sgxPoint2i();
			bottomright = new sgxPoint2i();
		}
		
		public function update(telaps : Number) : void {
		}
		
		public function draw(pSurface : CSGXDrawSurface) : void {
		}
		
	}
}