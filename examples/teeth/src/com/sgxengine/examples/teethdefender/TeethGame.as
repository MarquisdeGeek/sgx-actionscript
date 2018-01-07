package  com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.core.math.sgxPoint2f;
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.sgxlib.CCommandLine;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.filesystem.CSGXFileSystem;
	import com.sgxengine.sgx.graphics.*;
	import com.sgxengine.sgx.gui.CSGXGUI;
	import com.sgxengine.sgx.input.CSGXInputManager;
	import com.sgxengine.sgx.main.SGXMainApp;
	import com.sgxengine.skeleton.skelMouseHandler;

	public class TeethGame extends SGXMainApp
	{
		[Embed(source="C:/projects/sgxdev/contrib/html5/examples/teeth/gfx/loading.dat.png", mimeType='image/png')]
		private var loadingScreen:Class;

		private var theGame : AsteroidsGame;
		private var loadingBitmap : CSGXTexture;
		
		public function TeethGame()
		{
			super();
		}
		
		public override function SGXPrepareOS() : void
		{
			super.SGXPrepareOS();
			
			var gfxSettings : CSGXGraphicsEngineSettings = new CSGXGraphicsEngineSettings();
			gfxSettings.m_szAppName = "SGX: The Engine";
			
			gfxSettings.m_iScreenWidth = 640;
			gfxSettings.m_iScreenHeight = 426;
			
			CSGXGraphicsEngine.create(gfxSettings);
					
			CSGXInputManager.create();
			
			skelMouseHandler.init();
			
			loadingBitmap = CSGXTextureManager.get().loadTexture(loadingScreen);
		}
	
		public override function SGXMain(commands : CCommandLine) : void
		{
			super.SGXMain(commands);
			
			var rootPath : String = commands.getOption(null, "mount", "http://sgxengine.com/examples/teethdefender/html5/");
			CSGXFileSystem.get().mount("/", rootPath);

			theGame = new AsteroidsGame();
		}
		
		protected override function SGXDrawLoadingScreen() : void {
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			pSurface.setFillTexture(loadingBitmap);
			pSurface.setFillColor(sgxColorRGBA.White);
			pSurface.fillPoint(pSurface.getWidth()/2,pSurface.getHeight()/2, CSGXDrawSurface.eFromCentre);
		
			super.SGXDrawLoadingScreen();	// call this if you want the standard loading bar
		}
		
		protected override function SGXStartMainRunLoop() : void {
			super.SGXStartMainRunLoop();
			theGame.start();
		}

		
		protected override function SGXUpdate(telaps : Number) : void {
			super.SGXUpdate(telaps);
			theGame.m_pState.update(telaps);
		}
		
		
		protected override function SGXDraw() : void {
			theGame.m_pState.draw();
		}


	}
}