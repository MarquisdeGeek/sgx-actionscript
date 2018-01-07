package com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.core.gamecode.CGameObject;
	import com.sgxengine.sgx.core.math.sgxPoint2f;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.graphics.*;
	
	public class Missile extends CGameObjectAsterBase
	{
		public var maxsize : uint;
		public var timecum : Number;
		public var size : Number;
		public var active : Boolean;
		public var obj : CGameObjectAsterBase;
		public var centre : sgxPoint2f;
		
		
		public function Missile(name:String="")
		{
			super(name);
		

			maxsize = 80;
			active = false;
			obj = new CGameObjectAsterBase();	
			obj.setImage(AsteroidsGame.instance.gfxBang);
		}
		
		public override function getRect() : sgxRect2i{
			return obj.getRect();
		}
		
		 public function  prepare(x : Number, y : Number) : void{
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			var rc : sgxRect2i = new sgxRect2i();
			pSurface.getRect(rc);
			
			if (!active && rc.isInside(x,y)) {
				timecum = 0;
				centre = new sgxPoint2f(x,y);
				obj.setPosition(x,y);
				obj.show();
				active = true;
			}
		}
		
		
		 public override function  draw() :void {
			if (active) {
				obj.draw();
			}
		}
		
		 public override function  update(telaps  : Number) : void {
			super.update(telaps);	// the JS version didn't do this.
			
			if (active) {
				timecum += telaps;
				size = timecum < 1 ? timecum * maxsize : (2-timecum) * maxsize;
				obj.setPosition(centre.x - size/2, centre.y - size/2);
				obj.setSize(size,size);
				
				if (timecum > 2) {
					active = false;
					obj.hide();
				}
			}
		}
		
		
	}
}