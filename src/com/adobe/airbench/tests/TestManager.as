package com.adobe.airbench.tests
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	
	public class TestManager extends EventDispatcher
	{
		
		public static const CAPABILITY_TEST_TYPE:String  = "capability";
		public static const PERFORMANCE_TEST_TYPE:String = "performance";
		
		private var tests:Vector.<Test>;
		private var testSuiteVersion:String;
		
		public function TestManager(testSuiteVersion:String):void
		{
			this.testSuiteVersion = testSuiteVersion;
			this.tests = new Vector.<Test>();
		}
		
		public function registerTest(testId:String, displayName:String, type:String, version:Number, viewClassName:String):void
		{
			var test:Test;
			if (type == CAPABILITY_TEST_TYPE)
			{
				test = new CapabilityTest(testId, displayName, version);
			}
			else if (type == PERFORMANCE_TEST_TYPE)
			{
				test = new PerformanceTest(testId, displayName, version);
			}
			test.viewClassName = viewClassName;
			this.tests.push(test);
		}
		
		public function reportPerformanceTestResults(testId:String, time:Number, message:String):void
		{
			this.reportResult(testId, time, message);
		}

		public function reportCapabilitiesTestResults(testId:String, testPassed:Boolean, message:String):void
		{
			this.reportResult(testId, testPassed, message);
		}
		
		public function areAllTestsComplete():Boolean
		{
			for each (var test:Test in this.tests)
			{
				if (!test.complete) return false;
			}
			return true;
		}
		
		private function reportResult(testId:String, data:*, message:String):void
		{
			var allTestsComplete:Boolean = true;
			for each (var test:Test in this.tests)
			{
				if (test.testId == testId)
				{
					test.complete = true;
					test.message = message;
					if (test is PerformanceTest)
					{
						PerformanceTest(test).value = data;
					}
					else if (test is CapabilityTest)
					{
						CapabilityTest(test).passed = data;
					}
				}
				if (!test.complete)
				{
					allTestsComplete = false;
				}
			}
			if (allTestsComplete)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function getTests():Vector.<Test>
		{
			return this.tests;
		}
		
		public function getTestSuiteVersion():String
		{
			return this.testSuiteVersion;
		}
	}
}