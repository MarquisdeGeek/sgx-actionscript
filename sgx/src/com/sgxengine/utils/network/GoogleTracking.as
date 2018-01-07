package com.sgxengine.utils.network
{
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class GoogleTracking
	{
		private static var uaCode : String = UA_CODE_PRODUCTION;
		private static const UA_CODE_PRODUCTION : String = "UA-12127318-14";
		private static const UA_CODE_STAGING : String = "UA-12127318-14";
		
		private static var instance_ : GoogleTracking;
		private static var sceneObject : DisplayObject;

		private var tracker : AnalyticsTracker;
		private var category : String;
		private var action : String;
		
		
		public static function create(obj : DisplayObject, gameID : String) : GoogleTracking
		{
			instance_ = new GoogleTracking(obj, gameID);
			return instance_;
		} 
		
		public static function get() : GoogleTracking
		{
			if (!instance_) {
				return create(null,"unknown");
			}
			return instance_;
		}
		
		public function GoogleTracking(obj : DisplayObject, gameID : String) 
		{
			sceneObject = obj;
			//
			tracker = new GATracker( sceneObject, uaCode, "AS3", false );
			category = gameID;
			action = "play";
		}
		
		public function setCategory(cat : String) : void
		{
			category = cat;
		}
		
		public function setAction(action_ : String) : void
		{
			action = action_;
		}
		
		public function trackEvent(label : String, value : uint = 0) : void
		{
			tracker.trackEvent(category,action,label,value);
		}

	}
}