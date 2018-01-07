package com.sgxengine.sgx.core.gamecode
{
	public class CSGXEngine extends CSGXBaseEngine
	{
		public function CSGXEngine() {
		}
		
		public override function initialize() : void {
		}
		
		public override function release() : void {
		}
		
		public override function registerScenarioObject(ptr : CGameHandler) : Boolean {
			super.registerScenarioObject(ptr);
			
			// *All* engine objects are added to the management engine's master list
			//CSGXManagementEngine::get()->registerScenarioObject(ptr);

			return true;
		}
		
		public override function unregisterScenarioObject(ptr : CGameHandler) : Boolean{
			return super.unregisterScenarioObject(ptr);
		}
		

	}
}