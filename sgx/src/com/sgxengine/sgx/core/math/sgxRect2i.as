package com.sgxengine.sgx.core.math
{
	public class sgxRect2i
	{
		public var left : int; 
		public var right : int;
		public var top : int;
		public var bottom : int;
		
		public function sgxRect2i(x1 : uint = 0, y1 : uint = 0, x2 : uint = 0, y2 : uint = 0)
		{
			left = x1;
			right = x2;
			top = y1;
			bottom = y2;
		}
		
		public function centre() : sgxPoint2i {
			return new sgxPoint2i((right-left)/2 + left, (bottom-top)/2 + top);
		}
		
		public function topLeft() : sgxPoint2i {
			return new sgxPoint2i(left, top);
		}
		
		public function topRight() : sgxPoint2i {
			return new sgxPoint2i(right, top);
		}
		
		public function bottomLeft() : sgxPoint2i {
			return new sgxPoint2i(left, bottom);
		}
		
		public function bottomRight() : sgxPoint2i {
			return new sgxPoint2i(right, bottom);
		}
		
		public function getWidth() : int {
			return right - left;
		}
		
		public function getHeight() : int {
			return bottom - top;
		}
		
		
		public function isInside(x : uint, y : uint ) : Boolean {
			if (x < left || x >= right || y < top || y >= bottom) {
				return false;
			} else {
				return true;
			}
		}
				
		public function intersects(target : sgxRect2i) : Boolean {
			if (isInside(target.left, target.top) != isInside(target.right, target.top)) {
				return true;
			}
			if (isInside(target.right, target.top) != isInside(target.right, target.bottom)) {
				return true;
			}
			if (isInside(target.right, target.bottom) != isInside(target.left, target.bottom)) {
				return true;
			}
			if (isInside(target.left, target.bottom) != isInside(target.left, target.top)) {
				return true;
			}
			return false;
		}

	}
}