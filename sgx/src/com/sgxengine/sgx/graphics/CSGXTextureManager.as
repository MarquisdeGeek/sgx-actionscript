package com.sgxengine.sgx.graphics
{
	import com.sgxengine.domains.graphics.surface.CImageDataProcessor;
	import com.sgxengine.sgx.core.helpers.sgxTrace;
	import com.sgxengine.sgx.filesystem.CSGXFile;
	import com.sgxengine.sgx.filesystem.CSGXFileSystem;
	import com.sgxengine.sgx.filesystem.SGXByteArray;
	import com.sgxengine.sgx.filesystem.SGXFileSystemEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class CSGXTextureManager
	{
		protected static var ms_pSingleton : CSGXTextureManager; 
		private var m_TextureCache : Object;
		
		public function CSGXTextureManager()
		{
			m_TextureCache = new Object();
		}
	
		public static function create(pCopy : CSGXTextureManager = null) : CSGXTextureManager
		{
			if (ms_pSingleton) {
				sgxTrace.SID_WARNING(("Attempting to re-create the singleton, CSGXTextureManager"));
			}
			
			ms_pSingleton = ms_pSingleton ? ms_pSingleton : pCopy;
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXTextureManager();
				if (ms_pSingleton) {
					ms_pSingleton.initialize();
				}
			}
			return ms_pSingleton;
		}
		
		public static function get() : CSGXTextureManager
		{
			if (!ms_pSingleton) {
				ms_pSingleton = create(null);
			}
			return ms_pSingleton;
		}
		
		public function initialize() : void
		{
		}
		
		public function getTexture(filename : String) : CSGXTexture {
			return m_TextureCache[filename];
		}
		
		
		public function loadTexture(filename : *, pImageProcessor : CImageDataProcessor = null) : CSGXTexture
		{
			var t : CSGXTexture;
			
			// In C++, we load the data here, and construct the texture object with the
			// raw surface information
			if (filename is Class) {
				t = new CSGXTexture(filename);
				
				t.addPixelRegion(0,0,t.getWidth(),t.getHeight());
				return t;
			}
			//
			var file : CSGXFile = CSGXFileSystem.get().getFile(filename+".dat.png");

			t = new CSGXTexture();
			t.originalFilename = filename;
			m_TextureCache[filename] = t;
			//
			file.addEventListener(SGXFileSystemEvent.FILE_LOADED, function(e:SGXFileSystemEvent) :void {
				var ldr : Loader = new Loader();
				
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					
					// Now look for an XML file containing the regions
					file = CSGXFileSystem.get().getFile(filename+".dat.xml");
					file.addEventListener(SGXFileSystemEvent.FILE_LOADED, function(e:SGXFileSystemEvent) :void {
						t.applyFileData(ldr);
						var xml:XML = new XML(e.fileRef.data.readUTFBytes(e.fileRef.data.length));
						t.addRegionXML(xml);
					});
					file.addEventListener(SGXFileSystemEvent.FILE_FAILED, function(e:SGXFileSystemEvent) :void {
						// Last attempt - try the binary dat format
						/*
						file = CSGXFileSystem.get().getFile(filename+".dat");
						file.addEventListener(SGXFileSystemEvent.FILE_LOADED, function(e:SGXFileSystemEvent) :void {
							t.applyFileData(ldr);
							var ba : ByteArray = e.fileRef.data;
							if (ba.endian == "bigEndian") {
								
							}
							//ba.endian = "littleEndian";
							SGXByteArray.bSwapEndian = false;
							ba.endian = "littleEndian";
							var w : uint = SGXByteArray.readInt16(ba);
							var h : uint = SGXByteArray.readInt16(ba);
							var regions : uint = SGXByteArray.readInt16(ba);
							
							for(var r : uint=0;r<regions;++r) {
								var u1 : int = SGXByteArray.readInt32(ba);
								var v1 : int = SGXByteArray.readInt32(ba);
								var u2 : int = SGXByteArray.readInt32(ba);
								var v2 : int = SGXByteArray.readInt32(ba);

								t.addPixelRegion(u1,v1, u2,v2);
							}
							
							if (regions == 0) {
								t.addPixelRegion(0, 0, t.getWidth(),t.getHeight());
							}
						});
						file.addEventListener(SGXFileSystemEvent.FILE_FAILED, function(e:SGXFileSystemEvent) :void {
							t.applyFileData(ldr);
							t.addPixelRegion(0,0,t.getWidth(),t.getHeight());
						});
						file.load();
						*/
						t.applyFileData(ldr);
						t.addPixelRegion(0,0,t.getWidth(),t.getHeight());
						
					});	// end failed XML loader
					file.load();
					
				});
				//
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void {
					t.markAsFailed();
				});

				ldr.loadBytes(e.target.target.data);
			});
			//
			file.addEventListener(SGXFileSystemEvent.FILE_FAILED, function(e:SGXFileSystemEvent) :void {
				t.markAsFailed();	
				sgxTrace.SID_ERROR("FAILED to load : "+filename);
			});
			//
			// Perform the load operation _after_ the event listeners are set-up, otherwise
			// you may miss the events. (Happens if the file is cached, for example.)
			//
			CSGXFileSystem.get().loadFile(file);

			return t;
		}
		
		// AS-ONLY hack
		public function isReady() : Boolean {
			for each(var t : CSGXTexture in m_TextureCache) {
				if (!t.isAvailable()) {
					return false;
				}
			}
			return true;
		}

		
	}
}