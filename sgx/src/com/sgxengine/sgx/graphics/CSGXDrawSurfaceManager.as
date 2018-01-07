package com.sgxengine.sgx.graphics
{

	public class CSGXDrawSurfaceManager
	{
		private var m_pDisplay : CSGXDrawSurface;
		private static var ms_pSingleton : CSGXDrawSurfaceManager;
		
		public function CSGXDrawSurfaceManager()
		{
		}
		
		public static function get() : CSGXDrawSurfaceManager
		{
			if (!ms_pSingleton) {
				ms_pSingleton = new CSGXDrawSurfaceManager();
			}
			return ms_pSingleton;
		}
		
		public function createDisplaySurface(w : uint, h : uint) : CSGXDrawSurface {
			// TODO: global sgxAssert
			return m_pDisplay = new CSGXDrawSurface(w, h);
		}
		
		public function createSurface(w : uint, h : uint) : CSGXDrawSurface {
			return new CSGXDrawSurface(w, h);
		}
		
		public function getDisplaySurface() : CSGXDrawSurface {
			return m_pDisplay;
		}

	}
}