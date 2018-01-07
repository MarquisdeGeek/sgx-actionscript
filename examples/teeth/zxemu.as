package 
{
	import com.sgxengine.core.math.sgxPoint2f;
	import com.sgxengine.core.math.sgxPoint2i;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.graphics.*;
	import com.sgxengine.gui.CSGXGUI;
	import com.sgxengine.input.CSGXInputManager;
	import com.sgxengine.skeleton.skelMouseHandler;
	
	import es.ulat.em.framework.EmulatorSettings;
	import es.ulat.em.machines.jupiterace.JupiterAceEmulator;
	import es.ulat.em.machines.zx80.ZX80Emulator;
	import es.ulat.em.machines.zx81.ZX81Emulator;
	import es.ulat.em.machines.zxspectrum.SpectrumEmulator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import teeth.AsteroidsGame;

	[SWF(width="640", height="400", backgroundColor='#FFFFFF', frameRate='60')]
//	[SWF(width="256", height="192", backgroundColor='#FFFFFF', frameRate='60')]
	public class zxemu extends Sprite//ZX81Emulator	//Sprite	//ZX81Emulator
	{
		public function zxemu()
		{
			var settings : EmulatorSettings = new EmulatorSettings();
			
			if (false){
				settings.displayScale = 2;
				settings.autoStart = true;
			}
			settings.autoStart = false;
			
			//super(settings);

			// TEMP
			var gfxSettings : CSGXGraphicsEngineSettings = new CSGXGraphicsEngineSettings();
			gfxSettings.m_szAppName = "SGX: The Engine";
			gfxSettings.m_iScreenWidth = 640;//getWidth();
			gfxSettings.m_iScreenHeight = 400;//getHeight();
			CSGXGraphicsEngine.create(gfxSettings);
			
			var stdFont : CSGXFont = SGXFontManager.get().registerFont("std");
			//SGXGraphicsEngine.
			
			CSGXInputManager.create();
			
			skelMouseHandler.init();
			
			var surface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().createDisplaySurface(gfxSettings.m_iScreenWidth, gfxSettings.m_iScreenHeight);	// but still ignored
			surface.setCurrentFont(stdFont);
			
			addChild(surface.getSceneObject());

			//gfx1 = CSGXTextureManager.get().loadTexture("c:/temp/4fb/Reason for careers fairs.JPG");
			//gfx1.addPixelRegion(0,0,64,64);
			addEventListener(Event.ENTER_FRAME, 		SGXUpdate,				false,0,true);

			addEventListener(KeyboardEvent.KEY_DOWN, applyKeyDown, false, 0, true );
			addEventListener(KeyboardEvent.KEY_UP, applyKeyUp, false, 0, true );
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
			
			//
			hasGameLoaded = false;
			theGame = new AsteroidsGame();

		}
		var theGame : AsteroidsGame;
		var hasGameLoaded : Boolean;
		
		private function onMouseClick(ev:MouseEvent) : void {
			CSGXInputManager.get().applyMouseButton(0, ev.buttonDown);
		}
		
		private function onMouseRelease(ev:MouseEvent) : void {
			CSGXInputManager.get().applyMouseButton(0, false);
		}
		
		private function onMouseMove(ev:MouseEvent) : void {
			CSGXInputManager.get().applyMousePosition(ev.localX, ev.localY);
		}
	
		private function applyKeyUp(ev:KeyboardEvent) : void {
			CSGXInputManager.get().applyKeyboardPressed(ev.keyCode);
		}
		
		private function applyKeyDown(ev:KeyboardEvent) : void {
			CSGXInputManager.get().applyKeyboardReleased(ev.keyCode);
		}
			
		final private function SGXUpdate(e:Event):void						//main loop - calls engine.update(dt) - dt is time between frame updates
		{
			if (!hasGameLoaded) {
				if (CSGXTextureManager.get().isReady()) {
					hasGameLoaded = true;
					theGame.start();
					
					var myTimer:Timer = new Timer(30/1000); // 30 fps
					myTimer.addEventListener(TimerEvent.TIMER, gameLoop);
					myTimer.start();
				}
			}
		}
		
		private function gameLoop(e:Event) : void {
			
			skelMouseHandler.preUpdateCommon();
			
			var telaps : Number = 30/1000.0;
					
			var pos : sgxPoint2i = new sgxPoint2i(CSGXInputManager.get().getMouseX(), CSGXInputManager.get().getMouseY());
			CSGXGUI.get().applyPointerPosition(skelMouseHandler.m_MousePoint);
			if (skelMouseHandler.m_bLeftDown) {
				CSGXGUI.get().applyPointerDown();
			} else {
				CSGXGUI.get().applyPointerUp();
			}

			
			CSGXGUI.get().update(telaps);
			if (hasGameLoaded) {
				theGame.m_pState.update(telaps);
			}
			
			
			CSGXInputManager.get().update(telaps);
		
			skelMouseHandler.postUpdateCommon();
				//calculate difference in time
				//var currentTime:Number = getTimer();
				//var dt:Number = (currentTime - lastUpdateTime) / 1000;
		
				//update(dt);
				draw();
				++xpos;
		}
		var xpos : int;
		private function draw() : void {
			CSGXGraphicsEngine.get().preDraw();
			
			if (hasGameLoaded) {
				theGame.m_pState.draw();
			}
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			/*
			pSurface.setFillTexture(gfx1);
			pSurface.setFillColor(sgxColorRGBA.White);
			pSurface.fillRect(xpos,0,xpos+100, 50);
			
			if (CSGXInputManager.get().isMouseButtonDown(0)) {
				var x : int = CSGXInputManager.get().getMouseX();
				var y : int = CSGXInputManager.get().getMouseY();
				pSurface.fillRect(x, y,xpos+100, 50);
			}

	*/
		}
		
	}
}