package com.adobe.airbench.tests
{
	public class Test
	{
		public var testId:String;
		public var testVersion:Number;
		public var displayName:String;
		public var message:String;
		public var complete:Boolean;
		public var viewClassName:String;
		
		public function Test(testId:String, displayName:String, version:Number):void
		{
			this.testId = testId;
			this.displayName = displayName;
			this.testVersion = version;
		}
	}
}