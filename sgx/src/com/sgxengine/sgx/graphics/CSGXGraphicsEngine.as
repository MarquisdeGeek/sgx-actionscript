package com.sgxengine.sgx.graphics
{
	import com.sgxengine.sgx.core.gamecode.CSGXEngine;
	import com.sgxengine.sgx.core.helpers.sgxTrace;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;

	public class CSGXGraphicsEngine extends CSGXEngine
	{
		private static var ms_pSingleton : CSGXGraphicsEngine;
		private var m_Settings : CSGXGraphicsEngineSettings;
		
		public function CSGXGraphicsEngine(settings : CSGXGraphicsEngineSettings)
		{
			m_Settings = settings;
		}
		
		public static function create(settings : CSGXGraphicsEngineSettings) : CSGXGraphicsEngine {
			if (ms_pSingleton) {
				sgxTrace.SID_WARNING(("Attempting to re-create the singleton, CSGXGraphicsEngine"));
			}
			
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXGraphicsEngine(settings);
				ms_pSingleton.initialize();
			}
			return ms_pSingleton;
		}

		public static function get() : CSGXGraphicsEngine
		{
			if (ms_pSingleton) {
				return ms_pSingleton;
			}
			sgxTrace.SID_WARNING(("The 'CSGXGraphicsEngine' singleton is being created implicitly from a get()."));
			return create(new CSGXGraphicsEngineSettings());
		}
		
		public override function initialize() : void {
			
		}
		
		public override function preDraw() : void {
			// Clear screen, basically!
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			pSurface.setFillColor(sgxColorRGBA.White);
			pSurface.setFillTexture(null);
			pSurface.fillRect(0,0,pSurface.getWidth(),pSurface.getHeight());
		}

		public function getScreenWidth() : uint {
			return m_Settings.m_iScreenWidth;
		}
		
		public function getScreenHeight() : uint {
			return m_Settings.m_iScreenHeight;
		}
		
	}
}