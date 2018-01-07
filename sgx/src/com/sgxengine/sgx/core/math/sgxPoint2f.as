package com.sgxengine.sgx.core.math
{
	public class sgxPoint2f
	{
		public var x : Number;
		public var y : Number;
		
		public function sgxPoint2f(x_ : Number = 0, y_ : Number = 0)
		{
			x = x_;
			y = y_;
		}
		
		public function zero() : void
		{
			x = y = 0;
		}
		
		public function set(x_ : Number, y_ : Number) : void
		{
			x = x_;
			y = y_;
		}
		
		public function neg() : sgxPoint2f
		{
			x = -x;
			y = -y;
			return this;
		}
		
		public function add(x_ : Number, y_ : Number) : sgxPoint2f
		{
			x += x_;
			y += y_;
			return this;
		}
		
		public function sub(x_ : Number, y_ : Number) : sgxPoint2f
		{
			x -= x_;
			y -= y_;
			return this;
		}
		
		public function mul(scalar : Number) : sgxPoint2f
		{
			x *= scalar;
			y *= scalar;
			return this;
		}
		
		public function div(scalar : Number) : sgxPoint2f
		{
			x /= scalar;
			y /= scalar;
			return this;
		}
		
		public function getDistanceSquared(x_ : Number, y_ : Number) : Number
		{
			return (x-x_)*(x-x_) + (y-y_)*(y-y_);
		}
		
		public function getMagnitude() : Number
		{
			return Numerics.sgxSqr(x*x+y*y);
		}
		
		public function getDistance(pos : sgxPoint2f) : Number
		{
			return Numerics.sgxSqr(getDistanceSquared(pos.x, pos.y));
		}
		
		public function normalise() : void
		{
			var d : Number = getMagnitude();
			x /= d;
			y /= d;
		}
		
		public static function sgxLerp(v1 : sgxPoint2f, v2 : sgxPoint2f, t : Number) : sgxPoint2f
		{
			var result : sgxPoint2f = new sgxPoint2f();
			result.x = Numerics.sgxLerp(v1.x, v2.x, t);
			result.y = Numerics.sgxLerp(v1.y, v2.y, t);
			return result;
		}
		
		
	}
}