package com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.audio.CSGXAudioEngine;
	import com.sgxengine.sgx.core.math.Numerics;
	import com.sgxengine.sgx.core.math.SGXMathUtils;
	import com.sgxengine.sgx.core.sgxlib.Random;
	import com.sgxengine.sgx.core.threading.CSGXCallback;
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.graphics.*;
	import com.sgxengine.sgx.gui.*;
	import com.sgxengine.sgx.input.CSGXInputManager;
	
	public class GameState
	{

		public static const ATTACKER_COUNT : uint = 4;
		public static const BULLET_COUNT : uint = 10;
		public static const MISSILE_COUNT : uint = 16;

		public static var instance : GameState;

		
		public var panel : CGameObjectAsterBase;
		public var background : CGameObjectAsterBase;
		public var baseObject : Array;//CGameObjectAsterBase;

		public var attackerList : Array;//Attacker;
		public var missileList : Array;//Missile;
		public var bulletList : Array;//Bullet;
		
		public var timecum : Number;
		public var handler : *; //		pUpdateHandler		handler;
		
		// forgotten!?!? to declare
		public var score : int;
		public var level :int;
		public var basesLeft:int;
		
		public var attackersLeft:uint;
		public var missilesLeft:uint;
		
		public var menuFrame : sgxWidget;	//

		
		// cALLBACKS
		
		public function cb_gameGetReadyDelay(t : Number) : void {
			instance.gameGetReadyDelay(t);
		}
		
		public function cb_gameTitleScreen(t : Number) : void {
			instance.gameTitleScreen(t);
		}
		public function cb_gameEndDelay(t : Number) : void {
			instance.gameEndDelay(t);
		}
		
		
		public function cb_beginGameIntro(cb : CSGXCallback, result : uint) : uint {
			CSGXAudioEngine.get().playSound("sfx/onclick");
			
			CSGXGUI.get().setRootWidget(null);	// in JS this is done in the btnHandler
			instance.beginGameIntro();
			return 0;
		}
		
		public function cb_gamePlay(t : Number) : void {
			instance.gamePlay(t);
		}
		
		public function cb_gameOver(t : Number) : void {
			instance.gameOver(t);
		}

		public function GameState()
		{
			// TODOC: was GameState = function()
			// MANUALLY ADDED:
			instance = this;
			// END MANUALLY ADDED
			panel = new CGameObjectAsterBase();
			panel.setPosition(160,100);
			panel.hide();
			
			background = new CGameObjectAsterBase();
			background.setPosition(0,0);
			background.setImage(CSGXTextureManager.get().getTexture("gfx/titlescreen"));
			background.show();
			
			baseObject = new Array(GameSettings.BASE_COUNT);//CGameObjectAsterBase *[BASE_COUNT];
			for(var i:int=0;i<GameSettings.BASE_COUNT;++i) {
				baseObject[i] = new CGameObjectAsterBase();
				baseObject[i].setPosition(Numerics.sgxFloor(i/2)*135+150, (i&1)?10:GameSettings.SURFACE_HEIGHT-95);
				setBaseCondition(i,0);
				baseObject[i].hide();
			}
			
			
			beginGameTitle();
		}

		
		public function changeState( callbackHandlerFunction : *):void {
			this.timecum = 0;
			this.handler = callbackHandlerFunction;
		}
		
		
		public function update( telaps : Number) :void{
			/*
			if (SGXInputEngine.isKeyboardKeyPressed(65)) {
			wasPaused = !wasPaused;
			return;
			}
			*/	
			this.handler(telaps);
			
		}
		
		
		public function draw() :void {
			this.background.draw();
			
			for(var idx:uint=0;idx<GameSettings.BASE_COUNT;++idx) {
				this.baseObject[idx].draw();
			}
			
			
			if (this.handler != cb_gameTitleScreen) {
				for(idx=0;idx<ATTACKER_COUNT;++idx) {
					this.attackerList[idx].draw();
				}
				
				for(idx=0;idx<MISSILE_COUNT;++idx) {
					this.missileList[idx].draw();
				}
				
				for(idx=0;idx<BULLET_COUNT;++idx) {
					this.bulletList[idx].draw();
				}
				
				// TODO:
				var pSurface : CSGXDrawSurface = CSGXDrawSurfaceManager.get().getDisplaySurface();
				var str : String;
				
				pSurface.setFillTexture(AsteroidsGame.instance.gfxScore);
				pSurface.setFillColor(sgxColorRGBA.White);
				pSurface.fillPoint(20,10, CSGXDrawSurface.eFromTopLeft);
				str = "" + score;
				pSurface.drawText(str, 20, 35);
				
				pSurface.setFillTexture(AsteroidsGame.instance.gfxLevel);
				pSurface.fillPoint(630,10, CSGXDrawSurface.eFromTopRight);
				str = "" + level;
				pSurface.drawText(str, 600, 35);
								
				
			}
			// MANUALLY REFACTOR - SGX DRAWS IN THE ORDER GIVEN
			this.panel.draw();
			
			CSGXGUI.get().draw();
		}
		
		
		
		 
		public function restart() :void{
			this.score = 0;
			this.level = 0;
			this.basesLeft =GameSettings.BASE_COUNT;
			
			for(var i:int=0;i<GameSettings.BASE_COUNT;++i) {
				this.setBaseCondition(i, 0);
			}
			
			this.nextLevel();
		}
		
		 
		public function setBaseCondition(idx:uint, condition:uint) : void {
			this.baseObject[idx].condition = condition;
			if (this.baseObject[idx].y < 200) {
				this.baseObject[idx].setImage(AsteroidsGame.instance.baseGfx[condition+7]);
			} else {
				this.baseObject[idx].setImage(AsteroidsGame.instance.baseGfx[condition]);
			}
			this.baseObject[idx].setSize(this.baseObject[idx].getWidth(), this.baseObject[idx].getHeight());
			//
			if (this.baseObject[idx].condition >= GameSettings.BASE_LAST_STATE) {
				this.baseObject[idx].hide();
			} else {
				this.baseObject[idx].show();
			}
			
		}
		
		
		 
		public function nextLevel() : void {
			++this.level;
			this.attackersLeft = 30+this.level*2;
			this.missilesLeft =  Numerics.sgxFloor(this.attackersLeft - this.level/4);
			
			this.attackerList = new Array(ATTACKER_COUNT);//Attacker *[public function ATTACKER_COUNT];
			for(var i : uint=0;i<GameState.ATTACKER_COUNT;++i) {
				this.attackerList[i] = new Attacker();
				this.attackerList[i].hide();
			}
			
			this.missileList = new Array(MISSILE_COUNT)//Missile *[public function MISSILE_COUNT];
			for( i=0;i<GameState.MISSILE_COUNT;++i) {
				this.missileList[i] = new Missile("missile"+i);	//.push(new Missile("missile"+i));
				this.missileList[i].hide();
			}
			
			this.bulletList = new Array(BULLET_COUNT)//Bullet *[public function BULLET_COUNT];
			for(i=0;i<GameState.BULLET_COUNT;++i) {
				this.bulletList[i] = new Bullet("bullets_left_"+i);	//.push(new CGameObject("bullets_left_"+i));
				this.bulletList[i].setImage(AsteroidsGame.instance.gfxToofpaste);
				this.bulletList[i].setPosition(5,GameSettings.SURFACE_HEIGHT - ((i+1)*34 + 10));
				this.bulletList[i].show();
			}
			for(i=this.missilesLeft;i<GameSettings.MAX_VISIBLE_MISSILES;++i) {
				this.bulletList[i].hide();
			}
			
			this.refreshGUI();
			//
		}
		
		
		 
		public function refreshGUI(): void {
			
			/*
			SGXGUI.getWidgetOfUserData("missiles").setText(this.missilesLeft);
			SGXGUI.getWidgetOfUserData("score").setText(this.score);
			SGXGUI.getWidgetOfUserData("level").setText(this.level);
			//*/
		}
		/*
		typedef void (*btnCallback)();
		
		class btnHandler {
			public:
			btnHandler(btnCallback nextFunction){
				this.callback = nextFunction;
			}
			
			void onSelect() {
				CSGXGUI.get().setRootWidget(NULL);
				this.callback();
			}
			
			btnCallback callback;
		};
		
		*/
		 
		public function beginGameTitle(): void {
			this.changeState(cb_gameTitleScreen);
			
			this.menuFrame = CSGXGUI.get().createFrame(0,0, new sgxGUIFrameParams());
			
			var pBtnPlay : CSGXTexture = CSGXTextureManager.get().getTexture("gfx/btn_play");
			var widget : sgxWidget = CSGXGUI.get().createImageButton(320, 350, new sgxGUIImageButtonParams(pBtnPlay,0));
			widget.setPosition(320-widget.getWidth()/2,350);
			widget.setCallback(new CSGXCallback(cb_beginGameIntro));
			//	widget.setHandler(new btnHandler(cb_beginGameIntro));	// TODO: sgxGUIWidgetCallbackHandler
			this.menuFrame.addChildWidget(widget);
			
			CSGXGUI.get().setRootWidget(this.menuFrame);
		}
		
		
		 
		public function openAboutBox(): void {
			//alert("It's by me!");
			//change state
			CSGXGUI.get().setRootWidget(this.menuFrame);
		}
		
		
		 
		public function gameTitleScreen(telaps : Number): void {
		}
		
		
		 
		public function beginGameIntro (): void {
			this.background.setImage(CSGXTextureManager.get().getTexture("gfx/playarea"));
			this.panel.setImage(CSGXTextureManager.get().getTexture("gfx/getready"));
			this.panel.setSize(320,200);
			this.panel.show();
			
			this.restart();
			this.changeState(cb_gameGetReadyDelay);
			
			CSGXAudioEngine.get().playSound("sfx/startlevel");
		}
		// Intro state just puts up a 'get ready' box
		
		 
		public function gameGetReadyDelay ( telaps:Number): void {
			this.timecum += telaps;
			
			if (this.timecum > 3) {
				this.panel.hide();
				this.changeState(cb_gamePlay);
			}
		}
		
		
		
		 
		public function beginNextWave (): void {
			for(var i:uint=0;i<GameSettings.BASE_COUNT;++i) {
				this.score += (GameSettings.BASE_LAST_STATE - this.baseObject[i].condition) * 10;
			}
			this.score += this.missilesLeft * 20;
			
			this.panel.setImage(CSGXTextureManager.get().getTexture("gfx/endwave"));
			this.panel.setSize(320,200);
			this.panel.show();
			this.changeState(cb_gameEndDelay);
			
			CSGXAudioEngine.get().playSound("sfx/winlevel");
		}
		
		
		 
		public function gameEndDelay (telaps : Number) : void{
			
			for(var i:uint=0;i<GameState.MISSILE_COUNT;++i) {
				this.missileList[i].update(telaps);
			}
			
			this.timecum += telaps;
			
			if (this.timecum > 3) {
				CSGXAudioEngine.get().playSound("sfx/startlevel");

				this.nextLevel();
				this.panel.setImage(CSGXTextureManager.get().getTexture("gfx/getready"));
				this.panel.setSize(320,200);
				this.changeState(cb_gameGetReadyDelay);
			}
		}
		
		
		 
		public function beginGameOver() : void{
			
			CSGXAudioEngine.get().playSound("sfx/failgame");

			this.panel.setImage(CSGXTextureManager.get().getTexture("gfx/gameover"));
			this.panel.setSize(320,200);
			this.panel.show();
			
			var pBtnPlay : CSGXTexture = CSGXTextureManager.get().getTexture("gfx/btn_play");
			var widget : sgxWidget = CSGXGUI.get().createImageButton(320, 350, new sgxGUIImageButtonParams(pBtnPlay,0));
			widget.setPosition(320-widget.getWidth()/2,320);
			widget.setCallback(new CSGXCallback(cb_beginGameIntro));
			//widget.setHandler(new btnHandler(this.beginGameIntro));
			CSGXGUI.get().setRootWidget(widget);
			
			this.changeState(cb_gameOver);
		}
		
		
		 
		public function gameOver(telaps:Number): void {
			
			for(var idx:uint=0;idx<GameState.ATTACKER_COUNT;++idx) {
				this.attackerList[idx].update(telaps);
			}
			
			
		}
		
		
		// Play state continues until end game, or wave completion
		 
		public function gamePlay(telaps:Number): void {
			
			if (CSGXInputManager.get().isMouseButtonPressed(CSGXInputManager.eMouseButtonLeft) && this.missilesLeft) {
				for(var idx:uint=0;idx<GameState.MISSILE_COUNT;++idx) {
					if (!this.missileList[idx].active) {
						
						this.missileList[idx].prepare(CSGXInputManager.get().getMouseX(), CSGXInputManager.get().getMouseY());
						--this.missilesLeft;
						
						if (this.missilesLeft < GameSettings.MAX_VISIBLE_MISSILES) {
							this.bulletList[this.missilesLeft].hide();
						}
						CSGXAudioEngine.get().playSound("sfx/shoot");
						this.refreshGUI();
						break;
					}
				}
			}
			for(idx=0;idx<GameState.MISSILE_COUNT;++idx) {
				this.missileList[idx].update(telaps);
			}
			
			
			for(idx=0;idx<GameState.ATTACKER_COUNT;++idx) {
				this.attackerList[idx].update(telaps);
			}
			
			// Shall we spawn a new attacker?
			if (this.attackersLeft) {	
				for(idx=0;idx<GameState.ATTACKER_COUNT;++idx) {
					if (this.attackerList[idx].state == Attacker.STATE_DEAD && this.level > Random.sgxRand(0,10)) {
						// anywhere from 1-in-10 (at start), to all the time later on
						this.attackerList[idx].setState(Attacker.STATE_INITIALIZE);
						--this.attackersLeft;
					}
				}
			}
			
			// End game?
			if (this.basesLeft == 0) {
				this.beginGameOver();
			} else if (this.attackersLeft == 0) {
				var anyLeft : Boolean= false;
				for(idx=0;idx<GameState.ATTACKER_COUNT;++idx) {
					if (this.attackerList[idx].state != Attacker.STATE_DEAD) {
						anyLeft = true;
						break;
					}
				}
				if (!anyLeft) {
					this.beginNextWave();
				}
			} 
			
		}
		
	}
}