package com.sgxengine.examples.teethdefender
{
	import com.sgxengine.sgx.audio.CSGXAudioEngine;
	import com.sgxengine.sgx.core.gamecode.CGameObject;
	import com.sgxengine.sgx.core.math.Numerics;
	import com.sgxengine.sgx.core.math.sgxPoint2f;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.core.sgxlib.Random;
	
	public class Attacker extends CGameObjectAsterBase
	{
		public static const STATE_INITIALIZE : uint = 0;
		public static const STATE_SPAWNING : uint = 1;
		public static const STATE_DROPPING : uint = 2;
		public static const STATE_EXPLODING : uint = 3;
		public static const STATE_DEAD : uint = 4;
		
		
		public var timecum : Number;	
		public var state : int;
		public var stateParam : Number;
		public var startPosition : sgxPoint2f;
		public var endPosition : sgxPoint2f;
		public var obj : CGameObjectAsterBase ;
		//
		public var character : uint;
		public var	animFrame : Number;
		public var	animSpeed : Number;
		
		public var	velocity : Number;
		public var	explosionRate : Number;
		
		
		//
		
		//Attacker.prototype.obj;
		public function Attacker() {
			super(null);
			
			// Only show one missle for now
			obj = new CGameObjectAsterBase();	// a sneaky way of avoiding derived classes
			
			setState(Attacker.STATE_DEAD);
			
		}
		
		
		public function  setState( s:uint, param:uint=0) : void{
			state = s;
			stateParam = param;
			
			// onStateEnter
			switch(s) {
				case Attacker.STATE_INITIALIZE:
					character = Random.sgxRand(0,3);
					animFrame = 0;
					animSpeed = Random.sgxRand(3,5);
					obj.hide();
					setState(Attacker.STATE_SPAWNING, Random.sgxRand(0,5));
					break;
				
				case Attacker.STATE_SPAWNING:
				case Attacker.STATE_DEAD:
					obj.hide();
					break;
				
				case Attacker.STATE_DROPPING:
					startPosition = new sgxPoint2f(Random.sgxRand(0,GameSettings.SURFACE_WIDTH), 0);
					endPosition = new sgxPoint2f(Random.sgxRand(0,GameSettings.SURFACE_WIDTH), GameSettings.SURFACE_HEIGHT-20);
					
					startPosition = new sgxPoint2f(0, 50+Random.sgxRand(0,300));
					endPosition = new sgxPoint2f(GameSettings.SURFACE_WIDTH,50+Random.sgxRand(0,300));
					
					// C++ MANUAL HACK - gives the 
					obj.setImage(AsteroidsGame.instance.alien[0]);
					
					var quad : int= Random.sgxRand(0,4); 
					quad = Numerics.sgxFloor(quad);	// TODO: SGXMath!
					switch(quad) {
						case 0://top right
							startPosition.x = GameSettings.SURFACE_WIDTH - Random.sgxRand(0,00);
							startPosition.y = -Random.sgxRand() + Random.sgxRand(0,100);
							endPosition.x = 100+Random.sgxRand(0,320);
							endPosition.y = GameSettings.SURFACE_HEIGHT;
							break;
						case 1://bottom right
							startPosition.x = GameSettings.SURFACE_WIDTH - Random.sgxRand(0,00);
							startPosition.y = GameSettings.SURFACE_HEIGHT- Random.sgxRand(0,100);
							endPosition.x = 00+Random.sgxRand(0,320);
							endPosition.y = -40;
							break;
						case 2://top left
							startPosition.x = -getWidth() + Random.sgxRand(0,0);
							startPosition.y = -getHeight() + Random.sgxRand(0,100);
							endPosition.x = 320+Random.sgxRand(0,320);
							endPosition.y = GameSettings.SURFACE_HEIGHT;
							break;
						default:// bottom left
							startPosition.x = -getWidth() + Random.sgxRand(0,00);
							startPosition.y = GameSettings.SURFACE_HEIGHT - (30+Random.sgxRand(0,100));
							endPosition.x = 320+Random.sgxRand(0,320);
							endPosition.y = -getHeight();
							break;
					}
					/*			
					if (Random.sgxRand(0,10) < 5) {
					startPosition.x = 640;
					endPosition.x = 0;
					}
					
					if (startPosition.y < 200) {	// start in top half, must end in bottom
					endPosition.y = 200 + Random.sgxRand(200);
					} else {
					endPosition.y = Random.sgxRand(200);
					}
					*/
					timecum = 0;
					velocity = Random.sgxRand(2,4+2*GameState.instance.level) * 0.1;
					velocity *= 200 / startPosition.getDistance(endPosition);
					explosionRate = 1.5;
					update(0);
					obj.show();
					break;
			}
		}
		
		public override function  getRect() : sgxRect2i {
			return obj.getRect();
		}
		
		public override function  getWidth() :int{
			return obj.getWidth();
		}
		
		public override function  getHeight() : int{
			return obj.getHeight();
		}
		
		public override function  draw() :void {
			if (obj) {
				obj.draw();
			}
		}
		
		public override function  hide() : void{
			obj.hide();
		}
		
		public override function  update(telaps : Number) :void{
			
			switch(state) {
				case Attacker.STATE_SPAWNING:
					stateParam -= telaps;
					if (stateParam < 0) {
						setState(Attacker.STATE_DROPPING);
					}
					break;
				
				case Attacker.STATE_DROPPING:
					
					animFrame += animSpeed * telaps;
					if (animFrame >= 8) {
						animFrame = 0;
					}
					
					obj.setImage(AsteroidsGame.instance.alien[uint(character + 3 * Numerics.sgxFloor(animFrame))]);
					
					timecum += velocity * telaps;
				{
					var pos : sgxPoint2f;
					pos = sgxPoint2f.sgxLerp(startPosition, endPosition, timecum);
					obj.setPosition(pos.x, pos.y);
				}
					
					
					
					for (var idx : uint=0;idx<GameState.MISSILE_COUNT;++idx) {
						if (GameState.instance.missileList[idx].active) {
							var area2 : sgxRect2i = getRect();
							var rc : sgxRect2i = GameState.instance.missileList[idx].getRect();							
							
							if (rc.intersects(area2)) {
								CSGXAudioEngine.get().playSound("sfx/kill");

								GameState.instance.score += 500 - Numerics.sgxFloor(obj.y);
								GameState.instance.refreshGUI();
								setState(Attacker.STATE_EXPLODING);
								return;
							}
						}
					}		
					for (idx=0;idx<GameSettings.BASE_COUNT;++idx) {
						var rc : sgxRect2i = GameState.instance.baseObject[idx].getRect();
						var area2 : sgxRect2i = getRect();
						
						if (rc.intersects(area2) && GameState.instance.baseObject[idx].condition < GameSettings.BASE_LAST_STATE) {
							CSGXAudioEngine.get().playSound("sfx/hitteeth");

							setState(Attacker.STATE_EXPLODING);
							
							GameState.instance.setBaseCondition(idx, GameState.instance.baseObject[idx].condition+1);
							if (GameState.instance.baseObject[idx].condition == GameSettings.BASE_LAST_STATE) {
								--GameState.instance.basesLeft;
							}
							return;
						}
					}
					
					if (timecum >= 1.0) {
						setState(Attacker.STATE_EXPLODING);
					}
					
					break;
				
				case Attacker.STATE_EXPLODING:{
					var frame : int = Numerics.sgxFloor(stateParam * 5);
					obj.setImage(AsteroidsGame.instance.explode[frame]);
					stateParam += explosionRate * telaps;
					if (stateParam >= 1.0) {
						setState(Attacker.STATE_DEAD);
					}
				}break;
			}
		}

		
		
	}
}