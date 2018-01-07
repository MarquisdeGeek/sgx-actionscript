package com.sgxengine.sgx.core.helpers
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import no.doomsday.console.ConsoleUtil;
	
	public class DebugConsole extends Sprite 
	{
		public function DebugConsole():void 
		{
			if (stage) {
				init();	
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(ConsoleUtil.instance);
			ConsoleUtil.show();
		}
		
		public static function show() : void {
			ConsoleUtil.show();	
		}
		
		public static function hide() : void {
			ConsoleUtil.hide();	
		}
		
		public static function isOpen() : Boolean {
			return ConsoleUtil.instance.visible;
		}	
		
		public static function toggle() : void {

			if (ConsoleUtil.instance.visible) {
				hide();	
			} else {
				show();	
			}
		}
		
		public static function createCommand(commandName : String, functionName : Function, category : String=null, helpText : String=null) : void {
			ConsoleUtil.createCommand(commandName, functionName);	
		}
		
		public static function 	log(level : int, msg : String) : void {
			ConsoleUtil.trace(msg);
		}
	
	}       
}
