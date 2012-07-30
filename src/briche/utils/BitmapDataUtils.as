package briche.utils {
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Bertrand Riché
	 */
	public class BitmapDataUtils {
		
		/**
		 * Gets a luminance value from a specified color 
		 * @param	myRGB
		 * @return	a luminance value between 0 and 255
		 */
		public static function luminance(myRGB:int):int {
			var R:int = (myRGB / 65536) % 256;
			var G:int = (myRGB / 256) % 256;
			var B:int = myRGB % 256;
			return ((0.3 * R) + (0.59 * G) + (0.11 * B));
		}
		
		/**
		 * Gets a luminance value of a pixel from a target BitmapData
		 * @param	target
		 * @param	x
		 * @param	y
		 * @return
		 */
		static public function getPixelLuminance(target:BitmapData, x:int, y:int):Number {
			return (target.getPixel(x, y) >> 16) / 255;
		}
		
	}

}