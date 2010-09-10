package com.adobe.airbench.navigation
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	public class NavigationManager
	{
		private var navData:Vector.<String>;
		private var navLen:uint;
		
		public function NavigationManager()
		{
		}
		
		public function setNavigationData(navData:Vector.<String>):void
		{
			this.navData = navData;
			this.navLen = this.navData.length;
		}
		
		public function getNavigationInfo(className:String):NavigationInfo
		{
			var navInfo:NavigationInfo;
			for (var i:uint = 0; i < this.navLen; ++i)
			{
				if (this.navData[i] == className)
				{
					navInfo = new NavigationInfo();
					navInfo.thisView = getDefinitionByName(this.navData[i]) as Class;
					if ((i + 1) < this.navLen)
					{
						navInfo.nextView = getDefinitionByName(this.navData[i+1]) as Class;
					}
					if ((i - 1) >= 0)
					{
						navInfo.previousView = getDefinitionByName(this.navData[i-1]) as Class;
					}
				}
			}
			return navInfo;
		}
		
		public function getStartView():Class
		{
			return getDefinitionByName(this.navData[0]) as Class;
		}
		
		public function getEndView():Class
		{
			return getDefinitionByName(this.navData[this.navLen - 1]) as Class;
		}
	}
}