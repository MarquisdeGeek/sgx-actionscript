package com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.audio.CSGXAudioEngine;
	import com.sgxengine.sgx.graphics.CSGXTexture;
	import com.sgxengine.sgx.graphics.CSGXTextureManager;

	public class AsteroidsGame
	{
		public var m_pState : GameState;
		public var baseGfx : Array;
		
		public var obj : CSGXTexture;
		public var explode1 : CSGXTexture;
		
		public var explode : Array;
		public var gfxMissile : CSGXTexture;
		
		public var alien : Array;
		
		public var gfxScore : CSGXTexture;
		public var gfxLevel : CSGXTexture;
		public var gfxLives : CSGXTexture;
		public var gfxToofpaste : CSGXTexture;
		public var gfxBang : CSGXTexture;
		
		public static var instance : AsteroidsGame;
		
		public function AsteroidsGame()
		{
			instance = this;
			
			var str:String;
			explode = new Array(16);	//explode. CSGXTexture *[16];
			for(var i:uint=11;i<16;++i) {
				str = "gfx/explode"+i;
				explode[i-11]= CSGXTextureManager.get().loadTexture(str);
			}
			baseGfx = new Array(16);//CSGXTexture *[16];
			for(i=1;i<15;++i) {
				str = "gfx/shield"+i;
				baseGfx[i-1]= CSGXTextureManager.get().loadTexture(str);
			}

			alien = new Array(24);//new CSGXTexture *[24];
			for(i=0;i<8;++i) {
				str = "gfx/yuk0"+i;
				//sgxStringFormat(str, "gfx/yuk0%d",i);
				alien[i*3 + 0]= CSGXTextureManager.get().loadTexture(str);
				str = "gfx/muk0"+i;
				//sgxStringFormat(str, "gfx/muk0%d",i);
				alien[i*3 + 1]= CSGXTextureManager.get().loadTexture(str);
				str = "gfx/grim0"+i;
				//sgxStringFormat(str, "gfx/grim0%d",i);
				alien[i*3 + 2]= CSGXTextureManager.get().loadTexture(str);
			}
			
			//SGXTextureManager.load("xgetready.png");
			
			gfxBang = CSGXTextureManager.get().loadTexture("gfx/bang");
			CSGXTextureManager.get().loadTexture("gfx/getready");
			CSGXTextureManager.get().loadTexture("gfx/gameover");
			CSGXTextureManager.get().loadTexture("gfx/playarea");
			CSGXTextureManager.get().loadTexture("gfx/titlescreen");
			CSGXTextureManager.get().loadTexture("gfx/endwave");
			var txt: CSGXTexture = CSGXTextureManager.get().loadTexture("gfx/btn_play");
			/*
			txt.clearRegions();
			txt.addPixelRegion(0,0, 142,48);
			txt.addPixelRegion(1*142,0, 2*142,48);
			txt.addPixelRegion(2*142,0, 3*142,48);
			*/
			gfxScore = CSGXTextureManager.get().loadTexture("gfx/score");
			gfxLevel = CSGXTextureManager.get().loadTexture("gfx/level");
			gfxLives = CSGXTextureManager.get().loadTexture("gfx/lives");
			gfxToofpaste = CSGXTextureManager.get().loadTexture("gfx/toofpaste");
			
			CSGXAudioEngine.get().registerScenarioSound("sfx/failgame");
			CSGXAudioEngine.get().registerScenarioSound("sfx/gameloaded");
			CSGXAudioEngine.get().registerScenarioSound("sfx/hitteeth");
			CSGXAudioEngine.get().registerScenarioSound("sfx/kill");
			CSGXAudioEngine.get().registerScenarioSound("sfx/onclick");
			CSGXAudioEngine.get().registerScenarioSound("sfx/shoot");
			CSGXAudioEngine.get().registerScenarioSound("sfx/startlevel");
			CSGXAudioEngine.get().registerScenarioSound("sfx/winlevel");
		}
		
		public function start() : void {
			CSGXAudioEngine.get().playSound("sfx/gameloaded");

			m_pState = new GameState();
		}			

	}
}