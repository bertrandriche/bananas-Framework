package briche.utils {
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class CountDown {
		
		private static const _daySec = 60 * 60 * 24;
		private static const _hourSec = 60 * 60;
		
		/**
		 * Returns the remaining time to a specified date in a format of days, hours, mins & seconds
		 * @param	year			int		> The target year
		 * @param	month			int		> The target month
		 * @param	day				int		> The target day
		 * @param	hour			int		> The target hour
		 * @param	min				int		> The target min
		 * @param	sec				int		> The target sec
		 * @return					Array	> an Array consisting of days, hours, mins & seconds to the target time
		 */
		public static function getCountDown(year:int, month:int, day:int, hour:int, min:int, sec:int):Array {
			var dateObj:Date = new Date();
			var _day:int;
			var _hour:int;
			var _min:int;
			var _sec:int;
			var eventUTC:int = Date.UTC(year, month - 1, day, hour, min, sec);
			var nowUTC:int = Date.UTC(
				dateObj.getFullYear(),
				dateObj.getMonth(),
				dateObj.getDate(),
				dateObj.getHours(),
				dateObj.getMinutes(),
				dateObj.getSeconds()
			);
			var dfUTC:int = eventUTC - nowUTC;
		
			_day = Math.floor(dfUTC / _daySec / 1000);
			dfUTC -= _day * _daySec * 1000;
			_hour = Math.floor(dfUTC / _hourSec / 1000);
			dfUTC -= _hour * _hourSec * 1000;
			_min = Math.floor(dfUTC / 60 / 1000);
			dfUTC -= _min * 60 * 1000;
			_sec = Math.floor(dfUTC / 1000);
			
			return new Array(_day, _hour, _min, _sec);
		}
		
	}

}