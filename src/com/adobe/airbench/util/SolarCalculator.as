package com.adobe.airbench.util
{
	/**
	 * All the code to calculate sunrise and sunset times is a JavaScript to
	 * ActionScript port of the NOAA Solar Calculator. The original project
	 * can be found here: http://www.esrl.noaa.gov/gmd/grad/solcalc/
	 **/

	public class SolarCalculator
	{
		public function SolarCalculator()
		{
		}
		
		public static function getSunDataByDate(d:Date, lat:Number, lng:Number):Object
		{
			return getSunData(lat, lng, d.month + 1, d.date, d.fullYear, ((d.getTimezoneOffset() / 60) * -1), d.hours, d.minutes, d.seconds);
		}
		
		public static function getSunData(lat:Number, lng:Number, month:uint, day:uint, year:uint, utcOffset:int, hours:uint = 12, minutes:uint = 0, seconds:uint = 0):Object
		{
			var jday:Number = getJD(month, day, year);
			var tl:Number = (hours * 60) + minutes + (seconds / 60);
			var tz:int = utcOffset * 60;
			var total:Number = jday + tl/1440.0 - tz/24.0;
			var T:Number = calcTimeJulianCent(total);
			var rise:String = calcSunriseSet(true, jday, lat, lng, tz);
			var set:String  = calcSunriseSet(false, jday, lat, lng, tz);
			return {"sunrise":rise, "sunset":set};
		}
		
		private static function getJD(month:uint, day:Number, year:Number):Number
		{
			if ((isLeapYear(year)) && (month == 2))
			{
				if (day > 29)
				{
					day = 29;
				} 
			}
			// TBD: Huh?
			if (month <= 2)
			{
				year -= 1;
				month += 12;
			}
			var A:Number = Math.floor(year/100);
			var B:Number = 2 - A + Math.floor(A/4);
			var JD:Number = Math.floor(365.25*(year + 4716)) + Math.floor(30.6001*(month+1)) + day + B - 1524.5;
			return JD;
		}
		
		private static function isLeapYear(yr:uint):Boolean 
		{
			return ((yr % 4 == 0 && yr % 100 != 0) || yr % 400 == 0);
		}
		
		private static function calcTimeJulianCent(jd:Number):Number
		{
			var T:Number = (jd - 2451545.0)/36525.0;
			return T;
		}
		
		private static function calcSunriseSetUTC(rise:Boolean, JD:Number, latitude:Number, longitude:Number):Number
		{
			var t:Number = calcTimeJulianCent(JD);
			var eqTime:Number = calcEquationOfTime(t);
			var solarDec:Number = calcSunDeclination(t);
			var hourAngle:Number = calcHourAngleSunrise(latitude, solarDec);
			if (!rise) hourAngle = -hourAngle;
			var delta:Number = longitude + radToDeg(hourAngle);
			var timeUTC:Number = 720 - (4.0 * delta) - eqTime;	// in minutes
			return timeUTC;
		}
		
		private static function calcSunriseSet(rise:Boolean, JD:Number, latitude:Number, longitude:Number, timezone:int):String
		{
			var timeUTC:Number = calcSunriseSetUTC(rise, JD, latitude, longitude);
			var newTimeUTC:Number = calcSunriseSetUTC(rise, JD + timeUTC/1440.0, latitude, longitude); 
			if (!isNaN((newTimeUTC)))
			{
				var timeLocal:Number = newTimeUTC + timezone;
				if ((timeLocal >= 0.0) && (timeLocal < 1440.0))
				{
					return timeString(timeLocal, 2);
				}
			}
			// There is no sunrise or sunset on this date
			return null;
		}
		
		private static function calcEquationOfTime(t:Number):Number
		{
			var epsilon:Number = calcObliquityCorrection(t);
			var l0:Number = calcGeomMeanLongSun(t);
			var e:Number = calcEccentricityEarthOrbit(t);
			var m:Number = calcGeomMeanAnomalySun(t);
			var y:Number = Math.tan(degToRad(epsilon)/2.0);
			y *= y;
			var sin2l0:Number = Math.sin(2.0 * degToRad(l0));
			var sinm:Number   = Math.sin(degToRad(m));
			var cos2l0:Number = Math.cos(2.0 * degToRad(l0));
			var sin4l0:Number = Math.sin(4.0 * degToRad(l0));
			var sin2m:Number  = Math.sin(2.0 * degToRad(m));
			var Etime:Number = y * sin2l0 - 2.0 * e * sinm + 4.0 * e * y * sinm * cos2l0 - 0.5 * y * y * sin4l0 - 1.25 * e * e * sin2m;
			return (radToDeg(Etime) * 4.0);	// in minutes of time
		}
		
		private static function calcGeomMeanLongSun(t:Number):Number
		{
			var L0:Number = 280.46646 + t * (36000.76983 + t*(0.0003032));
			while(L0 > 360.0)
			{
				L0 -= 360.0
			}
			while(L0 < 0.0)
			{
				L0 += 360.0
			}
			return L0;		// in degrees
		}
		
		private static function calcGeomMeanAnomalySun(t:Number):Number
		{
			var M:Number = 357.52911 + t * (35999.05029 - 0.0001537 * t);
			return M;		// in degrees
		}
		
		private static function calcEccentricityEarthOrbit(t:Number):Number
		{
			var e:Number = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
			return e;		// unitless
		}
		
		private static function calcObliquityCorrection(t:Number):Number
		{
			var e0:Number = calcMeanObliquityOfEcliptic(t);
			var omega:Number = 125.04 - 1934.136 * t;
			var e:Number = e0 + 0.00256 * Math.cos(degToRad(omega));
			return e;		// in degrees
		}
		
		private static function calcMeanObliquityOfEcliptic(t:Number):Number
		{
			var seconds:Number = 21.448 - t*(46.8150 + t*(0.00059 - t*(0.001813)));
			var e0:Number = 23.0 + (26.0 + (seconds/60.0))/60.0;
			return e0;		// in degrees
		}
		
		private static function calcSunDeclination(t:Number):Number
		{
			var e:Number = calcObliquityCorrection(t);
			var lambda:Number = calcSunApparentLong(t);
			var sint:Number = Math.sin(degToRad(e)) * Math.sin(degToRad(lambda));
			var theta:Number = radToDeg(Math.asin(sint));
			return theta;		// in degrees
		}
		
		private static function calcSunApparentLong(t:Number):Number
		{
			var o:Number = calcSunTrueLong(t);
			var omega:Number = 125.04 - 1934.136 * t;
			var lambda:Number = o - 0.00569 - 0.00478 * Math.sin(degToRad(omega));
			return lambda;		// in degrees
		}
		
		private static function calcSunTrueLong(t:Number):Number
		{
			var l0:Number = calcGeomMeanLongSun(t);
			var c:Number = calcSunEqOfCenter(t);
			var O:Number = l0 + c;
			return O;		// in degrees
		}
		
		private static function calcSunEqOfCenter(t:Number):Number
		{
			var m:Number = calcGeomMeanAnomalySun(t);
			var mrad:Number = degToRad(m);
			var sinm:Number = Math.sin(mrad);
			var sin2m:Number = Math.sin(mrad+mrad);
			var sin3m:Number = Math.sin(mrad+mrad+mrad);
			var C:Number = sinm * (1.914602 - t * (0.004817 + 0.000014 * t)) + sin2m * (0.019993 - 0.000101 * t) + sin3m * 0.000289;
			return C;		// in degrees
		}
		
		private static function calcHourAngleSunrise(lat:Number, solarDec:Number):Number
		{
			var latRad:Number = degToRad(lat);
			var sdRad:Number  = degToRad(solarDec);
			var HAarg:Number = (Math.cos(degToRad(90.833))/(Math.cos(latRad)*Math.cos(sdRad))-Math.tan(latRad) * Math.tan(sdRad));
			var HA:Number = Math.acos(HAarg);
			return HA;		// in radians (for sunset, use -HA)
		}
		
		// flag=2 for HH:MM, 3 for HH:MM:SS
		private static function timeString(minutes:int, flag:int):String
		{
			var output:String;
			if ( (minutes >= 0) && (minutes < 1440) )
			{
				var floatHour:Number = minutes / 60.0;
				var hour:int = Math.floor(floatHour);
				var floatMinute:Number = 60.0 * (floatHour - Math.floor(floatHour));
				var minute:int = Math.floor(floatMinute);
				var floatSec:Number = 60.0 * (floatMinute - Math.floor(floatMinute));
				var second:int = Math.floor(floatSec + 0.5);
				if (second > 59)
				{
					second = 0;
					minute += 1;
				}
				if ((flag == 2) && (second >= 30)) minute++;
				if (minute > 59)
				{
					minute = 0;
					hour += 1;
				}
				output = zeroPad(hour,2) + ":" + zeroPad(minute,2);
				if (flag > 2) output = output + ":" + zeroPad(second,2);
			}
			else
			{
				output = "error";
			}
			return output;
		}
		
		private static function zeroPad(n:Number, digits:int):String
		{
			var s:String = n.toString();
			while (s.length < digits)
			{
				s = "0" + s;
			}
			return s;
		}
		
		private static function radToDeg(angleRad:Number):Number 
		{
			return (180.0 * angleRad / Math.PI);
		}
		
		private static function degToRad(angleDeg:Number):Number 
		{
			return (Math.PI * angleDeg / 180.0);
		}
	}
}