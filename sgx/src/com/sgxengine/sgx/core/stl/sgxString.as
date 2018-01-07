package com.sgxengine.sgx.core.stl
{
	public class sgxString
	{
		public static const npos : uint =  0xffffffff;

	
		public static function sgxStrFindLastOf(str : String, ch : *) : uint {
			var character : String;
			
			if (ch is String) {
				character = ch;
			} else {
				character = String.fromCharCode(ch);
			}
				
			return str.lastIndexOf(character);
		}
		
		public static function sgxStrSubstr(str : String, first : uint, count : uint) : String {
			return str.substr(first, count);
		}
		
	}
}