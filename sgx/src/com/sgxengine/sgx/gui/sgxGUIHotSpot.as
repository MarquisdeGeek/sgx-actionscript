package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;

	public class sgxGUIHotSpot extends sgxWidget
	{
		protected var m_SetupParams : sgxGUIHotSpotParams;
		protected var m_InitialPressedPosition : sgxPoint2i;
	
		public static const eDraggable : uint = 0x0001;
		public static const eMovement : uint = 0x0002;
				
			
		public function sgxGUIHotSpot(x : int, y : int, params : sgxGUIHotSpotParams)
		{
			super(x,y,CGUIDesignScreen.widgetHotspot);
			
			m_SetupParams = params;
			m_InitialPressedPosition = new sgxPoint2i();
		}
		
		
		public override function getArea(rc : sgxRect2i) : void {
			rc.left = m_X;
			rc.top = m_Y;
			rc.right = m_X+m_SetupParams.m_Width;
			rc.bottom = m_Y+m_SetupParams.m_Height;
		}
		
		public override function onPressed(position : sgxPoint2i) : Boolean {
			m_InitialPressedPosition = position;
			
			if (!super.onPressed(position)) {
				return false;
			}
			
			if (m_iFlags & (eDraggable | eMovement)) {
				// NULL - we don't "select" these items, as the selection
				// process isn't over until release.
				// (It's more of a 'journey' control, than a 'destination')
			} else {
				onSelect(position);
			}
			
			return true;
		}
	
		protected override function drawWidget(pSurface : CSGXDrawSurface, offsetX : int, offsetY : int) : Boolean {
			if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetDraw(this, pSurface, offsetX, offsetY)) {
				return false;
			}
			return true;
		}
	
		
		public override function onCursorDragged(position : sgxPoint2i) : Boolean {
			if (m_iFlags & (eDraggable | eMovement)) {
				if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetCursorDragged(this, position)) {
					return false;
				}
				
				//
				if (m_iFlags & eDraggable) {
					// NULL - we've done our duty an informed the handler
				}
				//
				if (m_iFlags & eMovement) {
					m_X += position.x - m_InitialPressedPosition.x;
					m_Y += position.y - m_InitialPressedPosition.y;
					m_InitialPressedPosition = position;
				}
			}
			return true;
		}
			
		public override function onRelease(position : sgxPoint2i) : Boolean{
			if (m_iFlags & (eDraggable | eMovement)) {
				if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetRelease(this, position)) {
					return false;
				}
			}
			return true;
		}

			
	}
}