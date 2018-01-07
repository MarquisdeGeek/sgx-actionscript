package com.sgxengine.sgx.core
{
	//
	// C++ vector mimic
	//
	public class SGXVector //extends Array
	{
		public var array : Array;
		
		public function SGXVector()
		{
			array = new Array();
		}
		
		public function push_back(item : *) : *
		{
			array.push(item);
		}
		
		public function size() : uint
		{
			return array.length;
		}
		
		public function get(index : uint) : *
		{
			if (array.length < index) {
				return null;
			}
			return array[index];
		}
		
		
		
		
		// Helpers
		public function removeItem(item : *) : void {
			SGXArray.remove(item, array);
		}
	}
}