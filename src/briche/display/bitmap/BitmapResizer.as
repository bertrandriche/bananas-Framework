package briche.display.bitmap {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 * 
	 * BITMAP RESIZER CLASS
	 * @version : 1.0
	 * @type : STATIC
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class BitmapResizer {
		
		public static var RATIO_SMALLEST:String = "ratioSmallest";
		public static var RATIO_BIGEST:String = "ratioBigest";
		public static var RATIO_WIDTH:String = "ratioBigest";
		public static var RATIO_HEIGHT:String = "ratioBigest";
		public static var NO_RATIO:String = "noRatio";
		
		public function BitmapResizer() { }
		
		/**
		 * Resizes the element to the specified dimensions. The target is drawn in a Bitmap instance.
		 * @param	target			DisplayObject > the target of the process
		 * @param	width			int > the desired width of the resize process
		 * @param	height			int > the desired height of the resize process
		 * @param	ratio			String > specifies wether the ratio must be preserved (RATIO / NO_RATIO), 
		 * 											and which dimension must be kept (the smallest RATIO_SMALLEST, 
		 * 											the bigest RATIO_BIGEST, width RATIO_WIDTH, or height RATIO_HEIGHT)
		 * @param	smoothed		Boolean > specifies wether the resulting bitmap must be smoothed or not
		 * 
		 * @return					Bitmap > the resized Bitmap
		 */
		static public function Resize(target:DisplayObject, width:int, height:int, ratio:String = "ratioSmallest", smoothed:Boolean = true):Bitmap {
			
			if (ratio != NO_RATIO && ratio != RATIO_BIGEST && ratio != RATIO_HEIGHT && ratio != RATIO_SMALLEST && ratio != RATIO_WIDTH) {
				throw new Error("ratio must be one of the following : NO_RATIO, RATIO_BIGEST, RATIO_HEIGHT, RATIO_SMALLEST or RATIO_WIDTH");
			}
			
			var tempSprite:Sprite = new Sprite();
			tempSprite.addChild(target);
			
			var bmpData:BitmapData;
			var matrix:Matrix = new Matrix();
			
			var scaleRatio:Number;
			if (ratio == NO_RATIO) {
				var scaleRatioX:Number = width / tempSprite.width;
				var scaleRatioY:Number = height / tempSprite.height;
				matrix.scale(scaleRatioX, scaleRatioY);
				bmpData = new BitmapData(tempSprite.width * scaleRatioX, tempSprite.height * scaleRatioY);
			} else {
				if (ratio == RATIO_SMALLEST) {
					scaleRatio = (tempSprite.width / width > tempSprite.height / height) ? width / tempSprite.width : height / tempSprite.height;
				} else if (ratio == RATIO_BIGEST) {
					scaleRatio = (tempSprite.height / height > tempSprite.width / width) ? width / tempSprite.width : height / tempSprite.height;
				} else if (ratio == RATIO_WIDTH) {
					scaleRatio = width / tempSprite.width;
				} else if (ratio == RATIO_HEIGHT) {
					scaleRatio = height / tempSprite.height;
				}
				matrix.scale(scaleRatio, scaleRatio);
				bmpData = new BitmapData(tempSprite.width * scaleRatio, tempSprite.height * scaleRatio);
			}
			
			bmpData.draw(tempSprite, matrix, null, null, null, smoothed);
			var bmp:Bitmap = new Bitmap(bmpData, "auto", smoothed);
			
			tempSprite.removeChild(target);
			target = null;
			tempSprite = null;
			
			return bmp;
			
		}
		
		
		/**
		 * Changes the scale of the specified object to match the specified sizes. Only changes the scale values without redrawing the element.
		 * @param	target			DisplayObject > the target of the process
		 * @param	width			int > the desired width of the resize process
		 * @param	height			int > the desired height of the resize process
		 * @param	ratio			String > specifies wether the ratio must be preserved (RATIO / NO_RATIO), 
		 * 											and which dimension must be kept (the smallest RATIO_SMALLEST, 
		 * 											the bigest RATIO_BIGEST, width RATIO_WIDTH, or height RATIO_HEIGHT)
		 */
		static public function Rescale(target:DisplayObject, width:int, height:int, ratio:String = "ratioSmallest"):void {
			
			var scaleRatio:Number;
			if (ratio == NO_RATIO) {
				target.width = width;
				target.height = height;
			} else {
				if (ratio == RATIO_SMALLEST) {
					scaleRatio = (target.width / width > target.height / height) ? width / target.width : height / target.height;
				} else if (ratio == RATIO_BIGEST) {
					scaleRatio = (target.height / height > target.width / width) ? width / target.width : height / target.height;
				} else if (ratio == RATIO_WIDTH) {
					scaleRatio = width / target.width;
				} else if (ratio == RATIO_HEIGHT) {
					scaleRatio = height / target.height;
				}
				
				target.scaleY = target.scaleX *= scaleRatio;
			}
		}
		
		
		/**
		 * Used to gets the new ratio of the specified DisplayObject to match the specified dimensions.
		 * @param	target			DisplayObject > the target of the process
		 * @param	width			int > the desired width of the resize process
		 * @param	height			int > the desired height of the resize process
		 * @param	ratio			String > specifies wether the ratio must be preserved (RATIO / NO_RATIO), 
		 * 											and which dimension must be kept (the smallest RATIO_SMALLEST, 
		 * 											the bigest RATIO_BIGEST, width RATIO_WIDTH, or height RATIO_HEIGHT)
		 * 
		 * @return					Number > the ratio at which the target must be resized to match the defined sizes
		 */
		static public function checkNewScale(target:DisplayObject, width:int, height:int, ratio:String = "ratioSmallest"):Number {
			var scaleRatio:Number;
			if (ratio == NO_RATIO) {
				return 1;
			} else {
				if (ratio == RATIO_SMALLEST) {
					scaleRatio = (target.width / width > target.height / height) ? width / target.width : height / target.height;
				} else if (ratio == RATIO_BIGEST) {
					scaleRatio = (target.height / height > target.width / width) ? width / target.width : height / target.height;
				} else if (ratio == RATIO_WIDTH) {
					scaleRatio = width / target.width;
				} else if (ratio == RATIO_HEIGHT) {
					scaleRatio = height / target.height;
				}
			}
			
			return scaleRatio;
		}
		
		
		
	}
	
}