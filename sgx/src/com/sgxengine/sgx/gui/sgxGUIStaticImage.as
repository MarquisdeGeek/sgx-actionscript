package com.sgxengine.sgx.gui
{
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;
	import com.sgxengine.sgx.graphics.CSGXTexture;

	public class sgxGUIStaticImage extends sgxWidget
	{
		protected var m_SetupParams : sgxGUIStaticImageParams;
		protected var m_pSkinParams : sgxGUISkinnedStaticImage;

		public function sgxGUIStaticImage(x : int, y : int, params : sgxGUIStaticImageParams)
		{
			super(x,y,CGUIDesignScreen.widgetImage);
			m_SetupParams = params;
			m_pSkinParams = CSGXGUI.get().getCurrentSkin().createSkinnedStaticImage(params);
		}
		
		public function getTexture() : CSGXTexture {
				return m_SetupParams.m_pTexture;
			}
		
		public function getTextureRegion() : uint {
			return m_SetupParams.m_Region;
		}
		
		public function setTextureRegion(region : uint) :void {
			m_SetupParams.m_Region = region;
		}
		
		public function setFillColor(color : sgxColorRGBA) :void {
			m_SetupParams.m_Color = color;
		}
			
		public override function getArea(rc : sgxRect2i) : void{
				rc.left = rc.right = m_X;
				rc.top = rc.bottom = m_Y;
				
				rc.right += m_SetupParams.m_pTexture && m_SetupParams.m_Width == 0 ? m_SetupParams.m_pTexture.getRegionWidth(m_SetupParams.m_Region) : m_SetupParams.m_Width;
				rc.bottom += m_SetupParams.m_pTexture && m_SetupParams.m_Height == 0 ? m_SetupParams.m_pTexture.getRegionHeight(m_SetupParams.m_Region) : m_SetupParams.m_Height;
			}
		
		
		public function setSize(w : uint, h : uint) : void {
			m_SetupParams.m_Width = w;
			m_SetupParams.m_Height = h;
		}
			
		protected override function drawWidget(pSurface : CSGXDrawSurface, offsetX : int, offsetY : int) : Boolean {
				if (m_pCallbackHandler && !m_pCallbackHandler.onGUIWidgetDraw(this, pSurface, offsetX, offsetY)) {
					return false;
				}
				
				var rc : sgxRect2i = new sgxRect2i();
				getArea(rc);
				
				m_pSkinParams.topleft.x = rc.left+offsetX;
				m_pSkinParams.topleft.y = rc.top+offsetY;
				m_pSkinParams.bottomright.x = rc.right+offsetX;
				m_pSkinParams.bottomright.y = rc.bottom+offsetY;
				
				
				m_pSkinParams.enabled = m_bEnabled;
				m_pSkinParams.cursorOver = m_isOver;
				
				m_pSkinParams.draw(pSurface);
				
				return super.drawWidget(pSurface, m_pSkinParams.topleft.x, m_pSkinParams.topleft.y);
			}
		
	}
}