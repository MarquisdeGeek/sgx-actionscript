package com.sgxengine.sgx.core
{
	public class SGXArray
	{
	
		public static function isPresent(array : Array, item : *) : Boolean
		{
			for each(var s : * in array) {
				if (s == item) {
					return true;
				}
			}
			return false;
		}
		
		public static function remove(item : *, array : Array) : Array {
			var itemIndex:Number = getItemIndex(array, item);
			
			if (itemIndex >= 0) {
				return removeFromArrayPosition(itemIndex, array);
			} else {
				return array;	
			}
		}
		
		public static function getItemIndex(array : Array, item : *):Number {
			
			for (var i:uint=0; i<array.length; i++) {
				if (item == array[i]) {
					return i;
				}
			}
			
			return -1;
		}
		
		public static function removeFromArrayPosition(position:uint, array:Array):Array {
			
			var secondHalf:Array = array.splice(position);
			secondHalf.shift();
			array.splice(position);
			
			for each (var v:* in secondHalf) {
				array.push(v);
			}
			
			return array;
		}
		
		public static function ammountFromIndex(array:Array, index:uint, count:uint):Array {
			var outputArray:Array = new Array();
			
			//get additonal values if not getting full ammount due to near end of list
			
			for (var i:uint=index, c:uint=0; i<array.length; i++, c++) {
				if (i >= array.length) {
					continue;
				}
				if (c > count) {
					continue;
				}
				
				outputArray.push(array[i]);
			}
			
			return outputArray;
		}
	
		public static function intersection(array1 : Array, array2 : Array) : Array
		{
			var newArray : Array = new Array();
			
			if (array1) {
				for each(var element : * in array1) {
					if (isPresent(array2, element)) {
						newArray.push(element);
					}
				}
			}
			return newArray;
		}
		
		public static function appendArray(target : Array, src : Array) : void {
			for each (var element : * in src) {
				target.push(element);
			}
		}
		
		public static function appendTextString(a : Array, data : *) : void {
			var wordList : Array = data.split("\n");
			appendArray(a, wordList);
		}
		
		public static function removeNull(a : Array) : void {
			for (var index : int = 0;index < a.length;) {
				if (a[index] == null || a[index] == "") {
					a.splice(index, 1);
				} else {
					++index;
				}
			}
		}
		
		public static function removeEntry(a : Array, entry : *) : void {
			for (var index : int = 0;index < a.length;) {
				if (a[index] == entry) {
					a.splice(index, 1);
				} else {
					++index;
				}
			}
		}
		
		
		public static function toString(array:Array):String {
			var output:String = "(";
			var prepend : String = "";
			
			for each (var value:* in array) {
				if (value == null) {
					output += prepend + "(null)";
				} else {
					output += prepend + String(value);
				}
				prepend = ",";
			}
			return output+")";
		}
	
	}
	
}