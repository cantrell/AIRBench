package com.adobe.airbench.model
{
	import com.adobe.airbench.navigation.NavigationManager;
	import com.adobe.airbench.tests.TestManager;
	
	import flash.events.EventDispatcher;
	
	public class ModelLocator extends EventDispatcher
	{
		private static var inst:ModelLocator;
		
		public static const SO_KEY:String = "com.adobe.airbench";
		public static const UUID_KEY:String = "uuid";
		
		// Public properties
		public var navigationManager:NavigationManager;
		public var testManager:TestManager;
		public var uuid:String;
		
		public function ModelLocator()
		{
		}
		
		public static function getInstance():ModelLocator
		{
			if (inst == null)
			{
				inst = new ModelLocator();
			}
			return inst;
		}
	}
}