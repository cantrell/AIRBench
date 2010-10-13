package com.adobe.airbench.model
{
	public class DeviceConfig
	{
		public static const UUID:String             = 'uuid';
		public static const TEST_INSTANCE_ID:String = 'test_instance_id';
		public static const OS_NAME:String          = 'os_name';
		public static const OS_BUILD:String         = 'os_build';
		public static const OS_VERSION:String       = 'os_version';
		public static const OS_SDK_VERSION:String   = 'os_sdk_version';
		public static const MODEL:String            = 'model';
		public static const BRAND:String            = 'brand';
		public static const NAME:String             = 'name';
		public static const CPU:String              = 'cpu';
		public static const MANUFACTURER:String     = 'manufacturer';
		public static const OPENGLES_VERSION:String = 'opengles_version';
		
		public var properties:Object;
		
		public function DeviceConfig()
		{
			this.properties = new Object();
		}
	}
}