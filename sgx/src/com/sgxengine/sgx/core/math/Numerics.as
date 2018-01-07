package com.sgxengine.sgx.core.math
{
	public class Numerics
	{
			
		/**
		 Return the absolute value of f. That is, its value as a position number.
		 */
		public static function sgxAbs(f : Number) : Number
		{
			if (f < 0) return -f;
			return f;
		}
		
		/**
		 Is equal?
		 Returns TRUE only if both values are equal. The equality test here uses
		 a differential epsilon, so any two numbers within sgxEPSILON of each
		 other are considered equal. You can give your own episilon if necessary.
		 */
		public static function sgxEq(fValue1 : Number, fValue2 : Number, epsilon : Number=0.0001) : Boolean
		{
			return sgxAbs(fValue1 - fValue2) < epsilon;
		}
		
		/**
		 Not equal to?
		 Returns TRUE only if both values are not equal.
		 See sgxEq.
		 */
		public static function sgxNeq(fValue1 : Number, fValue2 : Number, epsilon : Number=0.0001) : Boolean
		{
			return sgxAbs(fValue1 - fValue2) >= epsilon;
		}
		
		/**
		 Calculate the square root.
		 The results of negative numbers are undefined.
		 */
		public static function sgxSqr(f : Number) : Number
		{
			return Math.sqrt(f);
		}
		
		/**
		 Raise the number @base to the power of @exponent.
		 */
		public static function sgxPower(base : Number, exponent : Number) : Number
		{
			return Math.pow(base, exponent);
		}
		
		/**
		 Returns the signed value of @f. That is, -1 for negative numbers,
		 +1 for positives, and 0 for zero. 
		 Note: Epsilon is not used.
		 */
		public static function sgxSign(f : Number) : Number
		{
			if (f < 0) {
				return -1.0;
			} else if (f > 0) {
				return 1.0;
			} else {
				return 0;
			}
		}
		
		/**
		 Round down to the nearest whole number.
		 */
		public static function sgxFloor(f : Number) : Number 
		{
			return Math.floor(f);
		}
		
		/**
		 Return the fractional component
		 */
		public static function sgxFrac(f : Number) : Number 
		{
			return f - sgxFloor(f);
		}
		
		/**
		 Return the fractional modulo, i.e. remainder
		 */
		public static function sgxFMod(num : Number, divisor : Number) : Number 
		{
			return num/divisor - sgxFloor(num/divisor);
		}
		
		
		/**
		 Return a number that is nearer to @approaching, beginning from @from.
		 The step made towards @approach will never be greater than @max_delta.
		 */
		public static function sgxApproach(from : Number, approaching : Number, max_delta : Number=0.1) : Number 
		{
			var next  : Number = from;
			
			if (next > approaching) {
				next -= max_delta;
				if (next < approaching) {
					return approaching;
				}
			} else if (next < approaching) {
				next += max_delta;
				if (next > approaching) {
					return approaching;
				}
			}
			
			return next;			
		}
		
		/**
		 Returns the fractional equivalent of @from (i.e. a number between 0 and
		 1) based on the @scale given. So if @from == @scale then 1 is returned,
		 and if @from == 0 then 0 is returned, and all other numbers are linearly
		 scaled inbetween.
		 */
		public static function sgxConvert(from : Number, scale : Number) : Number 
		{
			var val : Number = from;
			val /= scale;
			return val;
		}
		
			
		public static function sgxLerp(v1 : Number, v2 : Number, t : Number) : Number { 
				return v1+((v2-v1)*t); 
			}
		
		public static function sgxRescale(value : Number, originalFrom : Number, originalTo : Number, scaledFrom : Number, scaledTo : Number) : Number  {
			var v  : Number = SGXMathUtils.sgxRange(value, SGXMathUtils.sgxMin(originalFrom,originalTo),  SGXMathUtils.sgxMax(originalFrom,originalTo));
			
			if (originalFrom == originalTo) return originalFrom;
			
			return scaledFrom + ((v - originalFrom)*(scaledTo-scaledFrom)) / (originalTo - originalFrom);
		}
		
	}
}