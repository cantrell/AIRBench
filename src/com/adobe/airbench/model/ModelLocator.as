package com.adobe.airbench.model
{
	import com.adobe.airbench.navigation.NavigationManager;
	import com.adobe.airbench.tests.TestManager;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModelLocator extends EventDispatcher
	{
		private static var inst:ModelLocator;
		
		// Assets
		[Bindable] [Embed(source="assets/home_icon.png")]         public var HomeIconClass:Class;
		[Bindable] [Embed(source="assets/report_icon.png")]       public var ReportIconClass:Class;
		[Bindable] [Embed(source="assets/perf_test_icon.png")]    public var PerfTestIconClass:Class;
		[Bindable] [Embed(source="assets/test_failed_icon.png")]  public var TestFailedIconClass:Class;
		[Bindable] [Embed(source="assets/test_passed_icon.png")]  public var TestPassedIconClass:Class;
		[Bindable] [Embed(source="assets/test_not_run_icon.png")] public var TestNotRunIconClass:Class;
		
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