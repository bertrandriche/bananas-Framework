package briche.utils{
	
	/**
	* Utility class to help date instance manipulation
	*/
	public class DateUtils
	{
		//-------------------------------------------------------------------------------------
		// Constants
		//-------------------------------------------------------------------------------------
		
		public static const ENGLISH : String = "en";
		public static const FRENCH : String = "fr";
		
		//-------------------------------------------------------------------------------------
		// Vars
		//-------------------------------------------------------------------------------------
		
		private static var miliPerDay : int = 86400000;
		
		//-------------------------------------------------------------------------------------
		// Public Methods
		//-------------------------------------------------------------------------------------
		
		/**
		 * Return the name of a month in a specifique language
		 * @param	month	Month number
		 * @param	language	Language ID for names
		 * @return	String instance
		*/
		public static function getMonthName(month : int, language : String = "fr") : String
		{
			var months : Object = {en:["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], fr:["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"]};
			return months[language][month];
		}
		
		/**
		 * Return the name of a day in a specifique language
		 * @param	month	Day number [0-Sunday, 1-Monday...]
		 * @param	language	Language ID for names
		 * @return	String instance
		*/
		public static function getDayName(day : int, language : String = "fr") : String
		{
			var days : Object = {en:["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], fr:["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"]};
			return days[language][day];
		}
		
		/**
		 * Count days in a specific month
		 * @param	month	Month number
		 * @param	year	Year number
		 * @return	Number instance
		 * @see #isBisextile
		 * 
		*/
		public static function getDaysInMonth(month : int, year : int) : int
		{
			var daysInMonth : Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] ;
			
			//ccheck bisextile year
			if(isBisextile(year)) daysInMonth[1] = 29;
			
			return daysInMonth[month];
		}

		/**
		 * Add days to a Date instance
		 * @param	date	Date instance
		 * @param	days	Number of days to add
		 * @return	Date instance
		*/
		public static function addDays(date : Date, days : int) : Date
		{
			var day : Number = (days * miliPerDay);
			date.setTime(date.getTime() + day);
			return date;
		}
	
		/**
		 * Check if a year is bisextile
		 * @param	year	Year Number
		 * @return	Boolean instance
		 * @see MathUtils
		*/
		public static function isBisextile(year : Number) : Boolean
		{
			return (MathUtils.isDivisible(year, 4) && !MathUtils.isDivisible(year, 100)) || (MathUtils.isDivisible(year, 400));
		}
	}
}
