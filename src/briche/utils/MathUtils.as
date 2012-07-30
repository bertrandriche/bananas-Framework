package briche.utils {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	public class MathUtils {
		
		/**
		 * Defines if a number is odd or not.
		 * @param	value				int			> the value to determine
		 * @return						Boolean
		 */
		static public function isOdd (value:int):Boolean {
			return value % 2 == 1;
		}
		
		/**
		 * Defines if a number is between the min & max values.
		 * @param	value				Number
		 * @param	min					Number
		 * @param	max					Number
		 * @return						Boolean
		 */
		static public function isBetween (value:Number, min:Number, max:Number):Boolean {
			return (value > min && value < max);
		}
		
		static public function getSign(value1:Number, value2:Number):int {
			if (value1 - value2 > 0) return 1;
			return -1;
		}
		
		
		
		/**
		 * Check if a number is divisible by the other
		 * @param	base	Base Number
		 * @param	divided	Divided number
		 * @return	Boolean instance
		*/
		public static function isDivisible(base : Number, divided : Number) : Boolean {
			return (String (base / divided).indexOf(".") == -1);
		}
		
		
		
		
		
		
		/**
		 * Get distance
		 * @param	delta_x		Difference between X positions of both points
		 * @param	delta_y		Difference between Y positions of both points
		 * @return
		 */
		public static function getDistance(delta_x:Number, delta_y:Number):Number {
			return Math.sqrt((delta_x * delta_x) + (delta_y * delta_y));
		}
		
		
		/**
		 * Get radians
		 * @param	delta_x
		 * @param	delta_y
		 * @return
		 */
		public static function getRadians(delta_x:Number, delta_y:Number):Number {
			var r:Number = Math.atan2(delta_y, delta_x);
			if (delta_y < 0)
			{
				r += (2 * Math.PI);
			}
			return r;
		}
		
		/**
		 * Get degrees
		 * @param	radians
		 * @return
		 */
		public static function getDegrees(radians:Number):Number {
			return Math.floor(radians / (Math.PI / 180));
		}
		
		public static function findAngle(point1:Point, point2:Point):Number {
			var dx:Number = point2.x - point1.x;
			var dy:Number = point2.y - point1.y;
			return Math.atan2(dy, dx) * (180 / Math.PI);
		}
		
	}

}