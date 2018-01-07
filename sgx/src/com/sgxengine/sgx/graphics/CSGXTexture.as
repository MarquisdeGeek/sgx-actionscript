package com.sgxengine.sgx.graphics
{
	import com.sgxengine.sgx.core.SGXVector;
	import com.sgxengine.sgx.core.math.SGXMathUtils;
	import com.sgxengine.sgx.core.math.sgxRect2i;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;

	public class CSGXTexture
	{
		//[Embed(source="C:/temp/4fb/why-you-drink.gif", mimeType='image/gif')]
		//private var fontSingle:Class;

		protected var available : Boolean;
		protected var m_Region : SGXVector;
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		// TEMP
		public var originalFilename:String;
		
		public function CSGXTexture(internalBitmap : Class = null)
		{
			available = false;
			m_Region = new SGXVector();
			
			if (internalBitmap) {
				bitmap = new internalBitmap();	
				bitmapData = bitmap.bitmapData;
			} else {
				bitmap = null;//new fontSingle();	
				bitmapData = null;//bitmap.bitmapData;
			}
			
		}
		
		public function clearRegions() : void {
			m_Region = new SGXVector();
		}
		
		public function addPixelRegion(x1 : uint, y1 : uint, x2 : uint, y2 : uint) : uint {
			var rc : sgxRect2i = new sgxRect2i(x1,y1,x2,y2);
			m_Region.push_back(rc);
			return m_Region.size();
		}
		
		public function addStandardRegions(regionsOnWidth : uint, regionsOnHeight : uint) : uint {
				//	sgxAssert(regionsOnWidth && regionsOnHeight && "Must be at least one region per axis");
			var firstNewRegion:uint = this.m_Region.size();
			var tw:uint = this.getWidth();
			var th:uint = this.getHeight();
			var rw:uint = tw / regionsOnWidth;
			var rh:uint = th / regionsOnHeight;
			
			var py1:uint = 0;
			var py2:uint = rh-1;
			for(var y:uint=0;y<regionsOnHeight;++y) {
				var px1:uint = 0;
				var px2:uint = rw-1;
				for(var x:uint=0;x<regionsOnWidth;++x) {
					this.addPixelRegion(px1,py1, px2,py2);
					
					px1 += rw;
					px2 += rw;
				}
				py1 += rh;
				py2 += rh;
			}
			
			return firstNewRegion;
		}
		
		public function addRegionXML(xml : XML) : uint {
			for each(var ele : XML in xml..stdregion) {
				var w : int = ele.@width;
				var h : int = ele.@height;
				var count : int = ele.@count;
				
				if (w == 0 || h == 0) {
					continue;
				}
				
				for(var y:uint = 0;y<=getHeight()-h;y+=h) {
					for(var x:uint = 0;x<=getWidth()-w;x+=w) {
						addPixelRegion(x,y,x+w,y+h);
						if (--count == 0) {
							y = getHeight();
							break;
						}
					}					
				}
				
			}
			for each(ele in xml..region) {
				addPixelRegion(ele.uv[0].@u, ele.uv[0].@v, ele.uv[1].@u, ele.uv[1].@v);
			}
			return m_Region.size();
		}

		public function getNumRegions() : uint {
			return m_Region.size();
		}
		
		public function getRegionWidth(region : uint) : uint {
			var r : sgxRect2i = m_Region.get(region);
			
			return r ? r.right-r.left : 0;			
		}
		
		public function getRegionHeight(region : uint) : uint {
			var r : sgxRect2i = m_Region.get(region);
			
			return r ? r.bottom-r.top : 0;			
		}

		public function getRegionArea(region : uint, rc : sgxRect2i) : void {
			var r : sgxRect2i = m_Region.get(region);
			
			if (r) {
				rc.left = r.left;
				rc.top = r.top;
				rc.right = r.right;
				rc.bottom = r.bottom;
			}
		}
		
		// AS-ONLY
		public function markAsFailed() : void {
			available = true;
		}
		
		public function applyFileData(target : *) : void {
			available = true;
			
			bitmap = target.content;  
			bitmapData = bitmap.bitmapData;  
		}
		
		public function getWidth() : uint {
			return bitmap ? bitmap.width : 0;
		}
		
		public function getHeight() : uint {
			return bitmap ? bitmap.height : 0;
		}
		
		// AS-ONLY use for blitting
		public function getBitmapData() : BitmapData {
			return bitmapData;//bitmap.bitmapData;
		}
		
		public function isAvailable() : Boolean {
			return available;
		}
		
		
		/*
		
		virtual void			setRegion(const tUINT32 region);
		virtual void			setRegion(const sgxUV &uv);
		virtual void			setWrapped(const tWrapped wrapped);
		virtual void			setBlendMode(const tBlendMode mode);
		virtual tBOOL			setTextureProperty(const char *propertyName, const sgxTexturePropertyParams *pParams=NULL);
		virtual void			rebuild(void *pBitmap=NULL);
		
		virtual void			clearRegions();
		virtual tUINT32			addRegion(const sgxUV &region);
		virtual tUINT32			addPixelRegion(const tUINT32 x, const tUINT32 y, const tUINT32 x2, const tUINT32 y2);
		virtual tUINT32			addStd4Regions();
		virtual tUINT32			addStandardRegions(const tUINT32 w, const tUINT32 h);
		virtual tUINT32			addRegionSizes(const tUINT32 w, const tUINT32 h);
		
		virtual tBOOL			isTranslucent() const { return m_Translucent; }
		virtual tBOOL			isTransparent() const { return m_Transparent; }
		
		virtual tUINT32			getRegionWidth(const tUINT32 region) const;
		virtual tUINT32			getRegionWidth(const sgxUV &uv) const;
		virtual tUINT32			getRegionHeight(const tUINT32 region) const;
		virtual tUINT32			getRegionHeight(const sgxUV &uv) const;
		virtual void 			getRegionSize(const tUINT32 region, sgxDimension2i &size) const;
		virtual void			getRegionSize(const sgxUV &uv, sgxDimension2i &size) const;
		virtual void			getRegionArea(const tUINT32 region, sgxRect2i &rc) const;
		
		virtual const CSGXTexture *	getTexture(const tUINT32 region) const;

		virtual void			getRegion(const tUINT32 region, sgxUV &uv) const;
		virtual void *			getDynamicBitmap();
		virtual tBOOL			getDynamicImageData(CImageData &data) const;
*/
	}
}