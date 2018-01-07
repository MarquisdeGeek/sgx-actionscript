package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxRect2i;

	public class sgxGUIFrame extends sgxWidget
	{
		protected var m_SetupParams : sgxGUIFrameParams;
		
		public function sgxGUIFrame(x:int, y:int, params:sgxGUIFrameParams)
		{
			super(x, y, CGUIDesignScreen.widgetFrame);
			m_SetupParams = params;
		}
		
		public override function getArea(rc : sgxRect2i) : void {
			rc.left = m_X;
			rc.top = m_Y;
			rc.right = rc.left + m_SetupParams.m_Width;
			rc.bottom = rc.top + m_SetupParams.m_Height;			
		}

	}
}