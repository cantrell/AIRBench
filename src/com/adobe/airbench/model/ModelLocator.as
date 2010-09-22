package com.adobe.airbench.model
{
	import com.adobe.airbench.navigation.NavigationManager;
	import com.adobe.airbench.tests.TestManager;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModelLocator extends EventDispatcher
	{
		private static var inst:ModelLocator;
		
		// Public properties
		public var navigationManager:NavigationManager;
		public var testManager:TestManager;
		
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