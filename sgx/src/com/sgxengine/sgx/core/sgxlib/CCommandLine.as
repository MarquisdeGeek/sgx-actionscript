package com.sgxengine.sgx.core.sgxlib
{
	import flash.display.LoaderInfo;

	public class CCommandLine
	{
		private var options : Object;
		
		public function CCommandLine(loaderInfo : LoaderInfo)
		{
			options = new Object();
			
			if (loaderInfo) {			
				for (var p : * in loaderInfo.parameters) {
					options[p as String] = loaderInfo.parameters[p];
				}
			}
		}
		
		public function getOption(unused_result : String, opt : String, defaultValue : String = "") : String {
			if (options[opt] == null) {
				return defaultValue;
			}
			return options[opt];
		}
		
	}
}