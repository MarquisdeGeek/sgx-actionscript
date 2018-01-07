package com.sgxengine.domains.filesystem
{
	import com.sgxengine.sgx.core.stl.sgxString;

	public class sgxFilename
	{
		public static function splitPathAndFilename(path : Object, filename : Object, filepath : String) : Boolean {
			
			var pos : uint = sgxString.sgxStrFindLastOf(filepath, "/");
			
			if (pos == sgxString.npos) {
				path = "";
				filename = filepath;
			} else {
				path.out = sgxString.sgxStrSubstr(filepath, 0, pos);
				filename.out = sgxString.sgxStrSubstr(filepath, pos+1, sgxString.npos);
			}
			return true;
		}
		
	}
}