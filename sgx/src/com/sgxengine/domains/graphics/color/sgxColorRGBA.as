package com.sgxengine.domains.graphics.color
{
	public class sgxColorRGBA
	{
		public static const White : sgxColorRGBA = new sgxColorRGBA(1,1,1,1);
		public static const LtGrey : sgxColorRGBA = new sgxColorRGBA(0.8,0.8,0.8);
		public static const DkGrey : sgxColorRGBA = new sgxColorRGBA(0.4,0.4,0.4);
		public static const Black : sgxColorRGBA = new sgxColorRGBA(0,0,0,1);
		public static const Red : sgxColorRGBA = new sgxColorRGBA(1,0,0);
		public static const Green : sgxColorRGBA = new sgxColorRGBA(0,1,0);
		public static const Blue : sgxColorRGBA = new sgxColorRGBA(0,0,1);
		public static const Yellow : sgxColorRGBA = new sgxColorRGBA(1,1,0);
		public static const Magenta : sgxColorRGBA = new sgxColorRGBA(1,0,1);
		public static const Cyan : sgxColorRGBA = new sgxColorRGBA(0,1,1);
		
		public var r : Number;
		public var g : Number;
		public var b : Number;
		public var a : Number;
		
		public function sgxColorRGBA(r : Number, g : Number, b : Number, a : Number = 1)
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		public function asInt() : uint {
			var col : uint= 0;
			
			col |= (uint)(255 * r) << 16;
			col |= (uint)(255 * g) << 8;
			col |= (uint)(255 * b) << 0;
			
			return col;
		}
	}
}