package com.sgxengine.sgx.core.gamecode
{
	import com.sgxengine.sgx.core.SGXArray;
	import com.sgxengine.sgx.core.SGXVector;

	public class CSGXBaseEngine extends CGameObject
	{
		protected var m_ScenarioObjects : SGXVector;
		protected var m_GlobalObjects : SGXVector;

		protected var m_SuspendCount : uint;
		
		public function CSGXBaseEngine()
		{
			m_ScenarioObjects = new SGXVector();
			m_GlobalObjects = new SGXVector();
			m_SuspendCount = 0;
		}
	
		public function registerScenarioObject(ptr : CGameHandler) : Boolean {
			m_ScenarioObjects.push_back(ptr);
			return true;
		}
		
		public function unregisterScenarioObject(ptr : CGameHandler) : Boolean{
			m_ScenarioObjects.removeItem(ptr);
			return true;
		}
		
	}
}