package com.sgxengine.sgx.filesystem
{
	import flash.events.Event;
	
	public class SGXFileSystemEvent extends Event
	{
		public static const FILE_LOADED : String = "SGX.file.loaded";
		public static const FILE_FAILED : String = "SGX.file.failed";
				
		public var fileRef : CSGXFile;
		
		public function SGXFileSystemEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false, fileref : CSGXFile = null)
		{
			super(type, bubbles, cancelable);
			
			fileRef = fileref;
		}
	}
}