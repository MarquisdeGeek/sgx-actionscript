package com.sgxengine.sgx.filesystem
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	public class CSGXFile extends EventDispatcher
	{
		public var filename : String;
		
		public var data : *;
		public var target : *;
		public var urlRequest : *;
		public var loader : *;
		public var fileEntry : CSGXFileEntry;
			
		public function CSGXFile(fname : String)
		{
			filename = fname;
			fileEntry = CSGXFileSystem.get().getFileEntry(fname); 
		}
		
		public function load() : CSGXFile
		{
			return loadFromLoader(new URLLoader());			
		}

		protected function loadFromLoader(assetLoader : URLLoader) : CSGXFile
		{
			loader = assetLoader;
			
			assetLoader.dataFormat = URLLoaderDataFormat.BINARY;

			assetLoader.addEventListener(Event.COMPLETE,loadComplete);
			assetLoader.addEventListener(IOErrorEvent.IO_ERROR,loadError);
			assetLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,loadError);

			try
			{
				urlRequest = new URLRequest(fileEntry.url);
				assetLoader.load(urlRequest);
			}
			catch (error : Error)
			{
				//Debug.error(ResourceManager.DEBUG_STREAM, "Unable to load " + filename + " - " + error.toString());
				return null;
			}
			
			return this;
		}

		protected function loadComplete(e:Event):void
		{
			target = e.target;
			data = e.target.data;
			
			onLoadComplete();
		}
		
		protected function loadError(e:Event):void
		{
			//Debug.warning(ResourceManager.DEBUG_STREAM, "Loading error found with "+filename+" ("+e.toString()+")");
			dispatchEvent(new SGXFileSystemEvent(SGXFileSystemEvent.FILE_FAILED, false, false, this));
		}
		
		protected function onLoadComplete():void
		{
			//Debug.message(ResourceManager.DEBUG_STREAM, "Load complete, of "+filename);
			dispatchEvent(new SGXFileSystemEvent(SGXFileSystemEvent.FILE_LOADED, false, false, this));
		}
		
		public function exists(callbackHandler : Function) : void
		{
			var urlStream:URLStream = new URLStream();
			urlStream.addEventListener(Event.OPEN, function(e:Event):void {
				urlStream.close();
				callbackHandler(filename, true);
			});
			urlStream.addEventListener(IOErrorEvent.IO_ERROR,  function(e:Event):void {
				urlStream.close();
				callbackHandler(filename, false);
			});
			urlStream.load(new URLRequest(filename));
		}

	}
}