package com.sgxengine.sgx.core.math
{
	import flashx.textLayout.formats.Float;

	public class sgxPoint3f
	{
		public static const UnitX : sgxPoint3f = new sgxPoint3f(1,0,0);
		public static const UnitY : sgxPoint3f = new sgxPoint3f(0,1,0);
		public static const UnitZ : sgxPoint3f = new sgxPoint3f(0,0,1);
		
		public var x : Number;
		public var y : Number;
		public var z : Number;
		
		
		/**
		 * @constructor
		 * @param {sgxPoint3f|number=} pt
		 * @param {number=} y
		 * @param {number=} z
		 */
		public function sgxPoint3f(x_ : Number = 0, y_ : Number = 0, z_ : Number = 0) {
			x = x_;
			y = y_;
			z = z_;
		}
		
		public function dot(v : sgxPoint3f) : Number {
			return x*v.x + y*v.y + z*v.z;
		}
		
		public function cross(v : sgxPoint3f) : sgxPoint3f {
			return new sgxPoint3f(y*v.z-z*v.y, z*v.z-x*v.z, x*v.y-y*v.x);
		}
		
		public function eq(rhs : sgxPoint3f) : Boolean { 
			return x == rhs.x && y == rhs.y && z == z;
		}
		
		/**
		 * @param {sgxPoint3f|number} x
		 * @param {number=} y
		 * @param {number=} z
		 */
		public function set(x : *, y : Number=0, z : Number=0) : sgxPoint3f { 
			if (x is sgxPoint3f) {
				x = x.x;
				y = x.y;
				z = x.z;
			} else {
				x = x;
				y = y;
				z = z;
			}
			return this;
		}
		
		/**
		 * @param {sgxPoint3f|number} x
		 * @param {number=} y
		 * @param {number=} z
		 */
		public function add(x : * , y : Number = 0, z : Number = 0) : sgxPoint3f { 
			if (x is sgxPoint3f) {
				x += x.x;
				y += x.y;
				z += x.z;
			} else {
				x += x;
				y += y;
				z += z;
			}
			return this;
		}
		
		/**
		 * @param {sgxPoint3f|number} x
		 * @param {number=} y
		 * @param {number=} z
		 */
		public function sub(x : *, y :* = null,z : * = null) : sgxPoint3f { 
			if (x is sgxPoint3f) {
				x -= x.x;
				y -= x.y;
				z -= x.z;
			} else {
				x -= x;
				y -= y;
				z -= z;
			}
			return this;
		}
				
		public function mul(f : Number) : sgxPoint3f { 
			x *= f;
			y *= f;
			z *= f;
			return this;
		}
		
		public function div(f : Number) : sgxPoint3f { 
			x /= f;
			y /= f;
			z /= f;
			return this;
		}
		
		
	
		
		
	}
}