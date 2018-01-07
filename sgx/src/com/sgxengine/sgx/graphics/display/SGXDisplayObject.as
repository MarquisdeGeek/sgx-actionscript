package com.sgxengine.sgx.graphics.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class SGXDisplayObject extends MovieClip
	{
		protected var displayObject : DisplayObject;		

		public function SGXDisplayObject(clipId:*)	{
			
			if (clipId == "" || clipId == null){
				//no clip id specified for Clip");
				return;
			}
			
			addClip(clipId);
		}
		
		
		public function addClip(clipId:*):void {
			if (clipId == "" || clipId == null){
				//"no clip id specified for Clip when attempting to addClip");
				return;
			} else {
				displayObject = clipId as DisplayObject;
			}

			addChild(displayObject);
			
		}
		
		public function removeClip():void {
			if (displayObject != null){
				try{
					removeChild(displayObject);
					displayObject = null;
				} catch (e:Error) {
				}
			}
		}
			}
}