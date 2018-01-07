package com.sgxengine.sgx.core.sgxlib
{
	public class Random
	{
		public static function sgxRand(f:int=0,t:int=1) : int {
			return Math.random()*(t-f) + f;
		}
		

	}
}