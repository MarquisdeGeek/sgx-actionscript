package com.sgxengine.sgx.core.math
{
	public class sgxMatrix43f
	{
		public var right : sgxVector3f;
		public var up : sgxVector3f;
		public var at : sgxVector3f;
		public var pos : sgxVector3f;
		
		public static const Null : sgxMatrix43f = new sgxMatrix43f();
		public static const Identity : sgxMatrix43f = new sgxMatrix43f();
		
		public function sgxMatrix43f()
		{
			right = new sgxVector3f(1,0,0);
			up = new sgxVector3f(0,1,0);
			at = new sgxVector3f(0,0,1);
			pos = new sgxVector3f(0,0,0);
		}
		
		public function set(m43 : sgxMatrix43f) : void {
			right.set(m43.right);
			up.set(m43.up);
			at.set(m43.at);
			pos.set(m43.pos);
		}
		
		
		public function eq(rhs : sgxMatrix43f) : Boolean { 
			return right.eq(rhs.right) && up.eq(rhs.up) && at.eq(rhs.at) && pos.eq(rhs.pos);
		}
		
		/*
		sgxPoint2f  operator*(const sgxPoint2f &v2) const;
		sgxPoint3f  operator*(const sgxPoint3f &v3) const;
		sgxMatrix43f operator*(const sgxMatrix43f &m) const;
		
		template<typename T> sgxMatrix43f  
		operator*(const T &scalar) const {
		sgxMatrix43f r(*this);
		r.scale(scalar);
		return r;
		
		}
		
		template<typename T> sgxPoint2<T>  
		operator*(const sgxPoint2<T> &v2) const {
		sgxPoint2<T> r(
		right.x*v2.x + up.x*v2.y + pos.x,	// x
		right.y*v2.x + up.y*v2.y + pos.y	// y
		);
		return r;
		}
		
		template<typename T> sgxPoint3<T>  
		operator*(const sgxPoint3<T> &v3) const {
		sgxPoint3<T> r(
		right.x*v3.x + up.x*v3.y + at.x*v3.z + pos.x,	// x
		right.y*v3.x + up.y*v3.y + at.y*v3.z + pos.y,	// y
		right.z*v3.x + up.z*v3.y + at.z*v3.z + pos.z	// z
		);
		return r;
		}
		
		// to return the transformed point, use v2 = m * v, above
		template<typename PT> void
		transform(sgxPoint3<PT> &pt) const {
		sgxPoint3<PT> v;
		
		v.x = pt.x*right.x + pt.y*up.x + pt.z*at.x + pos.x;
		v.y = pt.x*right.y + pt.y*up.y + pt.z*at.y + pos.y;
		v.z = pt.x*right.z + pt.y*up.z + pt.z*at.z + pos.z;
		
		pt.x = v.x;
		pt.y = v.y;
		pt.z = v.z;
		}
		
		//	template<typename T> sgxPoint3<T>  operator*(const sgxPoint3<T> &v2);
		
		
		sgxPoint2f  mul(const tREAL32 x, const tREAL32 y) const ;
		sgxPoint2f  mul(const tINT32 x, const tINT32 y) const ;
		
		SGX_INLINE	void identity() { right=sgxPoint3f(1,0,0); up=sgxPoint3f(0,1,0);
		at=sgxPoint3f(0,0,1); pos=sgxPoint3f(0,0,0); }
		
		SGX_INLINE  void setPosition(const sgxPoint2f &offset) { pos.x = offset.x; pos.y = offset.y; }
		SGX_INLINE	void setPosition(const sgxPoint3f &vpos) { pos = vpos; }
		SGX_INLINE	void setPosition(const sgxPoint4f &vpos) { pos.x=vpos.x; pos.y=vpos.y; pos.z=vpos.z;}
		*/
		
		/**
		 * @param {sgxVector3f|number} vpos
		 * @param {number=} py
		 * @param {number=} pz
		 */	
		public function setPosition(vpos : *, py : Number = 0, pz : Number = 0) : void { 
			if (vpos is sgxVector3f) {
				pos.x = vpos.x;
				pos.y = vpos.y;
				pos.z = vpos.z;
			} else {
				pos.x = vpos;
				pos.y = py;
				pos.z = pz;
			}
		}
		
		public function identity() : void { 
			right.set(1,0,0);
			up.set(0,1,0);
			at.set(0,0,1);
			pos.set(0,0,0);
		}
		
		public function getPosition(vpos : sgxPoint3f) : sgxPoint3f { 
			vpos.x = pos.x;
			vpos.y = pos.y;
			vpos.z = pos.z;
			return vpos;
		}
		
		public function setRotateAxis(theta : Number, axis : sgxVector3f) : void {
			var ct : Number = Trigonometry.sgxCos(theta);
			var st : Number = Trigonometry.sgxSin(theta);
			var xx : Number = axis.x * axis.x;
			var xy : Number = axis.x * axis.y;
			var xz : Number = axis.x * axis.z;
			var yy : Number = axis.y * axis.y;
			var yz : Number = axis.y * axis.z;
			var zz : Number = axis.z * axis.z;
			
			/* R = uu' + cos(theta)*(I-uu') + sin(theta)*S
			*
			* S =  0  -z   y    u' = (x, y, z)
			*	    z   0  -x
			*	   -y   x   0
			*/
			right.x = xx + ct*(1-xx);
			up.x = xy + ct*(0-xy) - st*axis.z;
			at.x = xz + ct*(0-xz) + st*axis.y;
			
			right.y = xy + ct*(0-xy) + st*axis.z;
			up.y = yy + ct*(1-yy);
			at.y = yz + ct*(0-yz) - st*axis.x;
			
			right.z = xz + ct*(0-xz) - st*axis.y;
			up.z = yz + ct*(0-yz) + st*axis.x;
			at.z = zz + ct*(1-zz);
		}
		
		public function setRotateX(theta : Number) : void {
			var s : Number=Trigonometry.sgxSin(theta);
			var c : Number=Trigonometry.sgxCos(theta);
			
			right.set(sgxVector3f.UnitX);
			up.x = 0; up.y = c; up.z = s;
			at.x = 0; at.y = -s; at.z = c;
		}
		
		public function setRotateY(theta : Number) : void {
			var s : Number=Trigonometry.sgxSin(theta);
			var c : Number=Trigonometry.sgxCos(theta);
			
			right.x = c; right.y = 0; right.z = -s; 
			up.set(sgxVector3f.UnitY);
			at.x = s; at.y = 0; at.z =  c;
		}
		
		public function setRotateZ(theta : Number) : void {
			var s : Number=Trigonometry.sgxSin(theta);
			var c : Number=Trigonometry.sgxCos(theta);
			
			right.x = c; right.y = s; right.z = 0;
			up.x = -s; up.y = c; up.z = 0;
			at.set(sgxVector3f.UnitZ);
		}
		
		/**
		 * @param {sgxVector3f|number=} sy
		 * @param {number=} sz
		 */
		public function scale(scale : *, sy : Number=0, sz : Number=0) : void {
			if (sy is sgxVector3f) {
				right.x *= scale.x;
				up.y *= scale.y;
				at.z *= scale.z;
			} else {
				right.x *= scale;
				up.y *= sy;
				at.z *= sz;
			}
		}
		
		/**
		 * @param {number=} ty
		 * @param {number=} tz
		 */
		public function translate(tx:*, ty : Number=0, tz : Number=0) : void {
			if (tx is sgxVector3f) {
				pos.x += tx.x;
				pos.y += tx.y;
				pos.z += tx.z;
			} else {
				pos.x += tx;
				pos.y += ty;
				pos.z += tz;
			}
		}
		
		public function determinant() : Number {
			var a0 : Number = right.x*up.y - up.x*right.y;
			var a1 : Number = right.x*at.y - at.x*right.y;
			var a3 : Number = up.x*at.y - at.x*up.y;
			
			return a0*at.z - a1*up.z + a3*right.z;
		}
		
		
		public function inverse(result : sgxMatrix43f) : Boolean {
			// Use the temporary, pre-compute, idea from:
			// http://www.geometrictools.com/LibFoundation/Mathematics/Wm4Matrix4.inl
			
			var a0 : Number = right.x*up.y - up.x*right.y;
			var a1 : Number = right.x*at.y - at.x*right.y;
			var a2 : Number = right.x*pos.y - pos.x*right.y;
			var a3 : Number = up.x*at.y - at.x*up.y;
			var a4 : Number = up.x*pos.y - pos.x*up.y;
			var a5 : Number = at.x*pos.y - pos.x*at.y;
			
			// we still have 0 0 0 1 in pseudo-bottom line of the matrix
			//tREAL32 b0 = 0;
			//tREAL32 b1 = 0;
			var b2 : Number = right.z;
			//tREAL32 b3 = 0;
			var b4 : Number = up.z;
			var b5 : Number = at.z;
			
			var det : Number = a0*b5 - a1*b4 + a3*b2;
			if (det == 0) {
				return false;
			}
			var invDet : Number = 1.0 / det;
			
			result.right.x = up.y*b5 - at.y*b4;
			result.right.y = -right.y*b5 + at.y*b2;
			result.right.z = right.y*b4 - up.y*b2;
			
			result.up.x = -up.x*b5 + at.x*b4;
			result.up.y = right.x*b5 - at.x*b2;
			result.up.z = -right.x*b4 + up.x*b2;
			
			result.at.x = a3;		// reduced from  up.w*a5 - at.w*a4 + pos.w*a3;
			result.at.y = -a1;		// reduced from -right.w*a5 + at.w*a2 - pos.w*a1;
			result.at.z = a0;		// reduced from right.w*a4 - up.w*a2 + pos.w*a0;
			
			result.pos.x = -up.z*a5 + at.z*a4 - pos.z*a3;
			result.pos.y = right.z*a5 - at.z*a2 + pos.z*a1;
			result.pos.z = -right.z*a4 + up.z*a2 - pos.z*a0;
			
			result.right.mul(invDet);
			result.up.mul(invDet);
			result.at.mul(invDet);
			result.pos.mul(invDet);
			
			return true;
		}
		
		public function normalize() : void {
			var d : Number=1.0/determinant(); 
			
			right.mul(d);
			up.mul(d);
			at.mul(d);
		}
		
		public function isIdentity() : Boolean {
			return pos.x==0 && pos.y==0 && pos.z==0 && isIdentityTransform();
		}
		
		public function isIdentityTransform() : Boolean {
			return right.x==1 && up.y==1 && at.z==1 && right.y==0 && right.z==0 && up.x==0 && up.z==0 && at.x==0 && at.y==0;
		}
			
			

			
	}
}