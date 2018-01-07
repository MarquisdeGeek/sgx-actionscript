package com.sgxengine.sgx.graphics
{
	import com.sgxengine.domains.graphics.color.sgxColorRGBA;
	import com.sgxengine.sgx.core.math.sgxDimension2i;
	import com.sgxengine.sgx.core.math.sgxPoint2i;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	import com.sgxengine.sgx.graphics.display.SGXDisplayObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Scene;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class CSGXDrawSurface
	{
		public static const eFromCentre : uint = 0;
		public static const eFromTopLeft : uint = 1;
		public static const eFromTopRight : uint = 2;
		public static const eFromBottomLeft : uint = 3;
		public static const eFromBottomRight : uint = 4;
		
		private var bitmap : BitmapData;
		private var displayObject : SGXDisplayObject;
		
		protected var m_CurrentFillColor : sgxColorRGBA;
		protected var m_pTexture : CSGXTexture;
		protected var m_CurrentUVRegion : uint;
		protected var m_CurrentFont : CSGXFont;
		
		protected var m_CurrentFontColor : sgxColorRGBA;

		public function CSGXDrawSurface(w : uint, h : uint)
		{
			bitmap = new BitmapData(w, h, false);
			displayObject = new SGXDisplayObject(new Bitmap(bitmap));
		}
		
		public function getFillTexture() : CSGXTexture {
			return m_pTexture;
		}
		
		public function getFillTextureRegion() : uint {
			return m_CurrentUVRegion;
		}
		
		public function setFillTexture(pTexture : CSGXTexture, region : uint = 0) : void {
			m_pTexture = pTexture;
			m_CurrentUVRegion = region;
		}
		
		public function setFillTextureRegion(region : uint) : void {
			m_CurrentUVRegion = region;
		}
		
		public function  setFillColor(col : sgxColorRGBA) : sgxColorRGBA { 
			var previous : sgxColorRGBA = m_CurrentFillColor;
			m_CurrentFillColor = col;
			return previous;
		}
		
		public function  setCurrentFont(font : *) : CSGXFont { 
			if (font is String) {
				font = CSGXFontManager.get().getFont(font);
			}
			var previous : CSGXFont = m_CurrentFont;
			m_CurrentFont = font;
			return previous;
		}
		
		public function  getCurrentFont() : CSGXFont { 
			return m_CurrentFont;
		}

		public function fillPoint(x : int, y : int, fp : int = 0/*eFromCentre*/) : void {
			if (!m_pTexture) {
				return;
			}
			
			var size : sgxDimension2i = new sgxDimension2i();
			
			size.width = m_pTexture.getRegionWidth(m_CurrentUVRegion);
			size.height = m_pTexture.getRegionHeight(m_CurrentUVRegion);
			
			var width2 : uint = size.width/2;
			var height2 : uint  = size.height/2;
			
			var pt1 : sgxPoint2i = new sgxPoint2i(x,y);
			
			switch(fp) {
				case eFromCentre:
					pt1.x -= width2;
					pt1.y -= height2;
					break;
				case eFromTopLeft:
					// as given
					break;
				case eFromTopRight:
					pt1.x -= size.width;
					break;
				case eFromBottomLeft:
					pt1.y -= size.height;
					break;
				case eFromBottomRight:
					pt1.x -= size.width;
					pt1.y -= size.height;
					break;
			}
			
			fillRect(pt1.x,pt1.y,  pt1.x+size.width,pt1.y+size.height);
			
		}
		
		
		public function fillRect(x1 : int, y1 : int, x2 : int, y2 : int) : void {
// normally boils down to a fillQuad, general purpose method
			
			// should traverse into gfx, for general purpose transformed blitting
			//CSGXGraphicsEngine::get()->setTransform(m_Xform.m);
			//CSGXGraphicsEngine::get()->drawRect2D(x1, y1, x2, y2, x3, y3, x4, y4);
			
			// Currently...
			if (m_pTexture && m_pTexture.getBitmapData()) {
				var rc : sgxRect2i = new sgxRect2i();
				m_pTexture.getRegionArea(m_CurrentUVRegion,  rc);
	
				var destPoint : Point = new Point(x1, y1); 
				var sourceRect : Rectangle = new Rectangle(rc.left, rc.top, rc.right-rc.left, rc.bottom-rc.top);
				
				if (x2-x1 == rc.getWidth() && y2-y1 == rc.getHeight()) {
					bitmap.copyPixels(m_pTexture.getBitmapData(), sourceRect, destPoint);
				} else {
					var scaleX : Number = (x2-x1) / rc.getWidth(); 
					var scaleY : Number = (y2-y1) / rc.getHeight(); 
					var m : Matrix = new Matrix(scaleX,0,0,scaleY,x1,y1);
					bitmap.draw(m_pTexture.getBitmapData(), m);
				}
			} else {	// solid color
				var destRect : Rectangle = new Rectangle(x1,y1, x2-x1,y2-y1);
				bitmap.fillRect(destRect, m_CurrentFillColor.asInt());
			}
		}
		
		public function setFontColor(col : sgxColorRGBA) : sgxColorRGBA {
			var prev : sgxColorRGBA = m_CurrentFontColor;
			m_CurrentFontColor = col;
			return col;
		}

		public function drawText(s : String, x: int, y : int, fmt : CSGXFontFormatting = null) : void {
			if (m_CurrentFont) {
				m_CurrentFont.draw(this, s, x, y, fmt);
			}
		}
		
		public function  getRect(rc : sgxRect2i) : void {
			rc.left = rc.top = 0;
			rc.right = getWidth();
			rc.bottom = getHeight();
		}
		
		public function  getWidth() : uint {
			return bitmap.width;
		}
		
		public function  getHeight() : uint { 
			return bitmap.height;
		}

	
	// AS-ONLY
	public function getSceneObject() : SGXDisplayObject {
		return displayObject;
	}
/*
		const CSGXTexture *	;
		const CSGXFont *	m_pCurrentFont;
		// The current region is stored in three ways,
		// so the platform can use the most efficient form.
		// (It also saves floating point errors that occur when
		// converting between pixel regions->uv->pixel regions)
		sgxUV			m_CurrentUV;
		tUINT32			;
		sgxRect2i		m_CurrentUVPixels;
		//
		sgxRect2i		m_CurrentClipArea;
		//
		sgxColorRGBA 	m_CurrentDrawColor;
		sgxColorRGBA 	;
		sgxColorRGBA 	m_CurrentFontColor;
		tBOOL 			m_UseColorFill;
		tPOINT	 		m_fLastX, m_fLastY;
		public:
		sgxTransform2D 	m_Xform;
		
		tUINT32			m_Width;
		tUINT32			m_Height;
		*/
		
		/*
		pSurface.setFillTexture(gfx1);
		pSurface.setFillColor(sgxColorRGBA.White);
		pSurface.fillRect(xpos,0,xpos+100, 50);

		
		virtual void resize(tUINT32 w, tUINT32 h);
		virtual void setMaterial(const sgxGraphicsMaterial &material);
		virtual void setMaterial(const sgxGraphicsMaterial *pMaterial);
		
		virtual sgxColorRGB setDrawColor(const sgxColorRGB &col);
		virtual sgxColorRGB setFillColor(const sgxColorRGB &col);
		virtual sgxColorRGBA setFillColor(const sgxColorRGBA &col);
		virtual sgxColorRGBA setFillColor(const tREAL32 r, const tREAL32 g, const tREAL32 b, const tREAL32 a=1.0f);
		
		virtual void clearFillColor();
		virtual void getDrawColor(sgxColorRGB &col) const;
		virtual void getFillColor(sgxColorRGB &col) const;
		virtual tUINT32 getFillTextureRegion()const;
		virtual const CSGXTexture * getFillTexture()const;
		virtual void setFillTextureRegion(const tUINT32 region);
		virtual void setFillTextureRegion(const sgxUV &uv);
		virtual void setFillTextureRegion(const tREAL32 u1, const tREAL32 v1, const tREAL32 u2, const tREAL32 v2);
		virtual void setFillTextureRegion(const tUINT32 u1, const tUINT32 v1, const tUINT32 u2, const tUINT32 v2);
		
		virtual void setFillTexture(const CSGXTexture *pTexture, const tUINT32 region = 0);
		virtual void setFillTexture(const CSGXTexture *pTexture, const tREAL32 u1, const tREAL32 v1, const tREAL32 u2, const tREAL32 v2);
		
		virtual void clearFillTexture();
		//
		// The only retrieval method is to get the whole xform. The individual components
		// e.g. rotate X, translate Y, etc are lost since the order matters, and we are
		// not concerned with keeping a list of them.
		//
		virtual void getRenderTransform(sgxTransform2D &xform) const ;
		//
		// Explicitly setting the position of all future renders
		//
		virtual void resetRenderTransform();
		virtual void setRenderTransform(const sgxTransform2D &xform);
		virtual void setRenderTransformPosition(const sgxPoint2f &position);
		virtual void setRenderTransformScale(const tREAL32 &axisScale);
		virtual void setRenderTransformScale(const sgxPoint2f &axisScales);
		//
		// Modify the position of all future renders, by an amount
		//
		virtual void translateRenderTransform(const sgxPoint2f &offset) ;
		virtual void rotateXRenderTransform(const tREAL32 rotateXRadians);
		virtual void rotateYRenderTransform(const tREAL32 rotateYRadians);
		virtual void rotateZRenderTransform(const tREAL32 rotateZRadians);
		virtual void scaleRenderTransform(const tREAL32 &axisScale);
		virtual void scaleRenderTransform(const sgxPoint2f &axisScales);
		virtual void areaTransform(const sgxRect2i &rc);
		virtual void areaTransform(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		
		//
		// Rendering lines, drawn in the current 'draw ink' colour.
		//
		virtual void drawPoint(const sgxPoint2i &pt);
		
		virtual void drawPoint(const tPOINT x, const tPOINT y);
		virtual void setLinePoint(const tPOINT x, const tPOINT y);
		virtual void drawLine(const sgxPoint2i &ptFrom, const sgxPoint2i &ptTo);
		virtual void drawLine(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		virtual void drawLineTo(const sgxPoint2i &pt);
		virtual void drawLineTo(const tPOINT x, const tPOINT y);
		virtual void drawRectangle(const sgxPoint2i &ptFrom, const sgxPoint2i &ptTo) ;
		virtual void drawRectangle(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		virtual void drawCircle(const sgxCircle2D &circle);
		
		//
		// Font handling
		//
		virtual const CSGXFont *	setCurrentFont(const char *name);
		virtual const CSGXFont *	setCurrentFont(const sgxString &name);
		virtual const CSGXFont *	setCurrentFont(const CSGXFont *pFont);
		virtual const CSGXFont *	getCurrentFont();
		virtual sgxColorRGB			setFontColor(const sgxColorRGB &col);
		virtual void				drawText(const char *pStr, tINT32 x, tINT32 y, const CSGXFontFormatting &fmt=CSGXFontFormatting::AlignLeftTop);
		virtual void				drawText(const sgxVector<sgxString> &stringList, tINT32 x, tINT32 y, const CSGXFontFormatting &fmt=CSGXFontFormatting::AlignLeftTop);
		
		//
		// Render solid faces
		//
		typedef enum {
		eFromCentre,
		eFromTopLeft,
		eFromTopRight,
		eFromBottomLeft,
		eFromBottomRight,
		} tFocusPoint;
		
		virtual void fillPoint(const tPOINT x, const tPOINT y, const tFocusPoint &fp=eFromCentre);
		virtual void fillPoint(const sgxPoint2i &center, const tFocusPoint &fp=eFromCentre);
		virtual void fillPoint(const sgxPoint2i &center, tPOINT size);
		virtual void fillCircle(const sgxCircle2D &circle);
		virtual void fillRect();
		virtual void fillRect(const sgxRect2i &rc);
		virtual void fillRect(const sgxPoint2i &ptFrom, const sgxPoint2i &ptTo);
		virtual void fillRect(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		virtual void fillPolygon(const sgxVector<sgxPoint2i> &ptList) ;
		
		virtual void fillQuad(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2, const tPOINT x3, const tPOINT y3, const tPOINT x4, const tPOINT y4);
		
		virtual void tileRect();
		virtual void tileRect(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		virtual void tileRect(const sgxPoint2i &ptFrom, const sgxPoint2i &ptTo);
		
		virtual void surroundBox(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2, tBOOL fillCentre=TRUE);
		
		//
		// Basic clipping
		//
		virtual void clearClipRect();
		virtual void setClipRect(const tPOINT x1, const tPOINT y1, const tPOINT x2, const tPOINT y2);
		virtual void setClipRect(const sgxRect2i &rc);
		virtual void getClipRect(sgxRect2i &rc);
		*/

	}
}