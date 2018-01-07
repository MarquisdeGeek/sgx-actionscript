package com.sgxengine.sgx.audio
{
	import com.sgxengine.domains.filesystem.sgxFilename;
	
	import flash.media.SoundChannel;

	public class CSGXAudioEngine
	{
		private static var ms_pSingleton : CSGXAudioEngine;
		private var soundCacheList : Object;
				
		public static function get() : CSGXAudioEngine
		{
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXAudioEngine();
			}
			return ms_pSingleton;
		}
		
		public function CSGXAudioEngine()
		{
			soundCacheList = new Object();
		}
		
		public function addSampleData(filename : String, pSample : CAudioDataSource) : void  
		{
			var pathname : Object = new Object();
			var basename : Object = new Object();
			sgxFilename.splitPathAndFilename(pathname, basename, filename);

			soundCacheList[basename.out] = pSample;
			soundCacheList[filename] = pSample;
		}
			
		public function registerScenarioSound(name : String) : uint  
		{
			var audioSource : CAudioDataSource = new CAudioDataSource(name); 
			
			addSampleData(name, audioSource);
			return 0;
		}
		
		public function getSound(name : String) : CAudioDataSource  
		{
			return soundCacheList[name];
		}
		
		public function playSound(pSound : *) : CLogicalChannel  
		{
			if (pSound is String) {
				pSound = CSGXAudioEngine.get().getSound(pSound);
			}
			
			var pChannel : CLogicalChannel = getFreeChannel();
			pChannel.m_pSampleData = pSound;
			//pChannel.m_pDeviceChannel = 
			//var mySoundChannel:SoundChannel = new SoundChannel();
			//mySoundChannel = pSound.firstSound.play();
			//mySoundChannel.
			pSound.play(pChannel);
			
			return pChannel;
		}
		
		protected function getFreeChannel() : CLogicalChannel  
		{
			return new CLogicalChannel();
		}
		
	}
}