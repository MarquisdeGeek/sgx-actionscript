package com.sgxengine.sgx.core.math
{
	public class sgxPoint2i
	{
		public var x : int;
		public var y : int;
		
	
		public function sgxPoint2i(x_ : int = 0, y_ : int = 0)
		{
			x = x_;
			y = y_;
		}
		
		public function neg() : sgxPoint2i
		{
			x = -x;
			y = -y;
			return this;
		}
		
		public function add(x_ : int, y_ : int) : sgxPoint2i
		{
			x += x_;
			y += y_;
			return this;
		}
		
		public function sub(x_ : int, y_ : int) : sgxPoint2i
		{
			x -= x_;
			y -= y_;
			return this;
		}
		
		public function mul(scalar : int) : sgxPoint2i
		{
			x *= scalar;
			y *= scalar;
			return this;
		}
		
		public function div(scalar : int) : sgxPoint2i
		{
			x /= scalar;
			y /= scalar;
			return this;
		}
		
		public function eq(pt : sgxPoint2i) : Boolean {
			return x == pt.x && y == pt.y;
		}
		
		public function neq(pt : sgxPoint2i) : Boolean {
			return x != pt.x || y != pt.y;
		}
		
		public function set(pt : sgxPoint2i) : void
		{
			x = pt.x;
			y = pt.y;
		}
	}
}