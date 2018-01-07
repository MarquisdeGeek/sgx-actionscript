package com.sgxengine.sgx.gui
{
	import com.sgxengine.sgx.graphics.CSGXDrawSurface;

	public class sgxGUISkinnedStaticImage extends sgxGUISkinnedWidget
	{
		protected var m_Params : sgxGUIStaticImageParams;
		
		public function sgxGUISkinnedStaticImage(params : sgxGUIStaticImageParams)
		{
			m_Params = params;
		}
		
		public override function draw(pSurface : CSGXDrawSurface) : void {
			pSurface.setFillTexture(m_Params.m_pTexture);
			pSurface.setFillTextureRegion(m_Params.m_Region);
			pSurface.setFillColor(m_Params.m_Color);	
			
			switch(m_Params.m_Style) {
				case sgxGUIStaticImageParams.eImage:
					pSurface.fillRect(topleft.x,topleft.y, bottomright.x,bottomright.y);
					break;
				case sgxGUIStaticImageParams.eTileArea:
					//pSurface.tileBox(topleft, bottomright);
					break;
				case sgxGUIStaticImageParams.eSurroundArea:
					//pSurface.surroundBox(topleft.x, topleft.y, bottomright.x,bottomright.y, true);
					break;
				case sgxGUIStaticImageParams.eHollowSurround:
					//pSurface.surroundBox(topleft.x, topleft.y, bottomright.x,bottomright.y, false);
					break;
			}

		}
	}
}