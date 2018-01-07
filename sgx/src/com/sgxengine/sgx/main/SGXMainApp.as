package com.sgxengine.sgx.main
{
	import com.sgxengine.sgx.core.math.sgxPoint2f;
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.core.sgxlib.CCommandLine;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.filesystem.CSGXFileSystem;
	import com.sgxengine.sgx.graphics.*;
	import com.sgxengine.sgx.gui.CSGXGUI;
	import com.sgxengine.sgx.input.CSGXInputManager;
	import com.sgxengine.skeleton.skelMouseHandler;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SGXMainApp extends Sprite
	{
		private var hasGameLoaded : Boolean;
		private var frameRate : Number;
		private var commandLine : CCommandLine;
		
		private var fileCount : uint;
		
		public function SGXMainApp()
		{
			frameRate = 20/1000.0;
			hasGameLoaded = false;
			commandLine = new CCommandLine(root ? LoaderInfo(root.loaderInfo) : null);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdd, false,0,true);
		}
		
		private function onStageAdd(e:Event) : void {

			SGXPrepareOS();
			SGXMain(commandLine);
			
			fileCount = CSGXFileSystem.get().getFileLoadsInProgress(); 
			
			var stdFont : CSGXFont = CSGXFontManager.get().registerFont("std", "std/fonts/std", new CSGXFontParams());
			var surface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().createDisplaySurface(CSGXGraphicsEngine.get().getScreenWidth(), CSGXGraphicsEngine.get().getScreenHeight());	// but still ignored
			surface.setCurrentFont(stdFont);
			
			addChild(surface.getSceneObject());
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false,0,true);
			
			addEventListener(KeyboardEvent.KEY_DOWN, applyKeyDown, false, 0, true );
			addEventListener(KeyboardEvent.KEY_UP, applyKeyUp, false, 0, true );
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			addEventListener(MouseEvent.MOUSE_UP, onMouseRelease);
		}
		
		public function SGXPrepareOS() : void
		{
			
		}
		
		public function SGXMain(commands : CCommandLine) : void
		{
			SGXMainInitialize();
		}
		
		public function SGXMainInitialize() : void
		{
			
		}
		
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
		
		final private function onEnterFrame(e:Event):void						//main loop - calls engine.update(dt) - dt is time between frame updates
		{
			if (!hasGameLoaded) {

				var left : uint = CSGXFileSystem.get().getFileLoadsInProgress();

				// The AS3 version needs an addition 'isReady' because of the
				// async set-up process necessary to prepare a texture, once the
				// filesystem says it has loaded.
				if (left == 0 && CSGXTextureManager.get().isReady()) {
					SGXStartMainRunLoop();
				} else {
					SGXDrawLoadingScreen();
				}
			}
		}
		
		protected function SGXDrawLoadingScreen() : void {
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			var barHeight : uint = 40;
			var area : sgxRect2i = new sgxRect2i();
			area.left = 20;
			area.top = pSurface.getHeight() - (barHeight+20);
			area.right = pSurface.getWidth() - area.left;
			area.bottom = area.top + barHeight;
			
			SGXDrawLoadingBar(area);
		}
		
		protected function SGXDrawLoadingBar(area : sgxRect2i) : void {
			var left : uint = CSGXFileSystem.get().getFileLoadsInProgress();
			var total : uint = CSGXFileSystem.get().getFileLoadsInTotal();
			var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
			pSurface.setFillTexture(null);
			pSurface.setFillColor(sgxColorRGBA.Black);
			pSurface.fillRect(area.left, area.top, area.right-(left*area.getWidth())/total, area.bottom);
		}
		
		protected function SGXStartMainRunLoop() : void {
			hasGameLoaded = true;
			
			var myTimer:Timer = new Timer(frameRate);
			myTimer.addEventListener(TimerEvent.TIMER, gameLoop);
			myTimer.start();
		}
		
		private function gameLoop(e:Event) : void {
			var telaps : Number = frameRate;
			preUpdate(telaps);
			SGXUpdate(telaps);
			postUpdate(telaps);
			draw();
		}
		
		private function preUpdate(telaps : Number) : void {
			skelMouseHandler.preUpdateCommon();
			
			CSGXGUI.get().applyPointerPosition(skelMouseHandler.m_MousePoint);
			if (skelMouseHandler.m_bLeftDown) {
				CSGXGUI.get().applyPointerDown();
			} else {
				CSGXGUI.get().applyPointerUp();
			}
						
			CSGXGUI.get().update(telaps);
		}
		
		private function postUpdate(telaps : Number) : void {
			CSGXInputManager.get().update(telaps);
			
			skelMouseHandler.postUpdateCommon();
		}
		
		protected function SGXUpdate(telaps : Number) : void {
		}
		
		private function draw() : void {
			CSGXGraphicsEngine.get().preDraw();
			
			SGXDraw();
		}
		
		protected function SGXDraw() : void {
		}
				
	}
}