package com.sgxengine.sgx.core.gamecode
{
	import com.sgxengine.sgx.core.math.*;

	public class CGameObject extends CGameHandler
	{
		protected var m_pParent : CGameObject;
		protected var m_Transform : sgxMatrix43f;

		public function CGameObject(parent : CGameObject = null)
		{
			super();
			m_pParent = parent;
		}
		
		public function getParent() : CGameObject {
			return m_pParent;
		}
		
		public function setTransform(xform : sgxMatrix43f) : void {
			m_Transform = xform;
		}
		
		/*
		public function setPosition(pos : sgxPoint2f) : void {
		}
		public function setPosition(pos : sgxPoint3f) : void {
		}
		
		*/
		public function setPosition(x : int, y : int) : void {
		}
		public function getPosition(pos : sgxPoint3f) : void {
		}

	}
}