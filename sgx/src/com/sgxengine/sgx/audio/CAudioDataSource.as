package com.sgxengine.sgx.audio
{
	import com.sgxengine.sgx.filesystem.CSGXFileSystem;
	import com.sgxengine.sgx.filesystem.CSGXFile;
	import com.sgxengine.sgx.filesystem.SGXFileSystemEvent;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.as3wavsound.WavSound;

	public class CAudioDataSource
	{
		private var baseName : String;

		private var firstSound : Sound;
		private var tts:WavSound;
		
		public function CAudioDataSource(name : String)
		{
			baseName = name;
			
			var file : CSGXFile = CSGXFileSystem.get().importFile(baseName + ".mp3");
			file.addEventListener(SGXFileSystemEvent.FILE_LOADED, function(e:SGXFileSystemEvent) :void {
				firstSound = new Sound(e.target.urlRequest);
				onLoadSucceed();
			});
			file.addEventListener(SGXFileSystemEvent.FILE_FAILED, function(e:SGXFileSystemEvent) :void {
				onLoadMP3Failed();
			});

		}
		
		private function onLoadMP3Failed() : void {
			// Destroy previous object, to indicate we've failed
			firstSound = null;
			
			// Try alternate
			var file : CSGXFile = CSGXFileSystem.get().importFile(baseName + ".wav");
			file.addEventListener(SGXFileSystemEvent.FILE_LOADED, function(e:SGXFileSystemEvent) :void {
				tts = new WavSound(e.target.data as ByteArray);  
				onLoadSucceed();
			});
			file.addEventListener(SGXFileSystemEvent.FILE_FAILED, function(e:SGXFileSystemEvent) :void {
				onLoadFailed();
			});

		}
		
		private function onLoadSucceed() : void {
		}
		
		private function onLoadFailed() : void {
		}
		
		public function play(channel : CLogicalChannel) : void {
			if (firstSound) {
				firstSound.play();
			}
			if (tts) {
				tts.play();
			}
		}
		
	}
}