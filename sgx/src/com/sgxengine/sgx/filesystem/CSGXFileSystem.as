package com.sgxengine.sgx.filesystem
{
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class CSGXFileSystem
	{
		private static var instance_ : CSGXFileSystem = null;
		private var fileLoadsInProgress : Object;
		
		private var fileSet : Array;
		private var serverList : Array;	// of ResourceServer
		private var pathList : Array;
		private var fileSetLoaded:Boolean;
		
		public var tempRootPath : String;
		
		{
			get();
		}

		public static function get() : CSGXFileSystem 
		{
			if (instance_ == null) {
				instance_ = new CSGXFileSystem();
			}
			return instance_;
		}
		
		public function CSGXFileSystem()  {
			if (instance_) {
				//"Attempting to re-instance the ResourceManager singleton.");
				return;
			}
			
			fileLoadsInProgress = new Object();
			
			tempRootPath = "./";
			
			fileSet = new Array();
			serverList = new Array();
			pathList = new Array();
			
		}
		
		public static function get instance() : CSGXFileSystem
		{
			return instance_;
		}
		
		public function mount(localRoot : String, rootPath : String) : void
		{
			tempRootPath = rootPath;	
		}
		
		public function getFileEntry(path : String) : CSGXFileEntry {
			return new CSGXFileEntry(tempRootPath + path);
		}

		public function getFileLoadsInProgress() : uint
		{
			var c : uint = 0;
			for each(var fileRef : CSGXFile in fileLoadsInProgress) {
				if (fileRef) {
					++c;
				}
			}
			return c;
		}
		
		public function getFileLoadsInTotal() : uint
		{
			var c : uint = 0;
			for each(var fileRef : CSGXFile in fileLoadsInProgress) {
				++c;
			}
			return c;
		}
		
		public function importFile(file : *) : CSGXFile
		{
			var fileRef : CSGXFile;
			
			if (file is String) {
				fileRef = getFile(file);
			} else {
				fileRef = file;
			}
			//
			return loadFile(fileRef);
		}
		
		public function getFile(filename : String) : CSGXFile
		{
			var fileRef : CSGXFile = new CSGXFile(filename);
			return fileRef;
		}			
		
		public function loadFile(fileRef : CSGXFile) : CSGXFile
		{
			//var fileRef : CSGXFile = getFile(filename);
			var filename : String = fileRef.filename;
			
			fileLoadsInProgress[filename] = fileRef;
			
			fileRef.addEventListener(SGXFileSystemEvent.FILE_LOADED,function(e:SGXFileSystemEvent):void{
				fileLoadsInProgress[filename] = null;
			});
			
			fileRef.addEventListener(SGXFileSystemEvent.FILE_FAILED,function(e:SGXFileSystemEvent):void{
				fileLoadsInProgress[filename] = null;
			});
			return fileRef.load();
		}

	}
}