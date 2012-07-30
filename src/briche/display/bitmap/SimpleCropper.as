/**
 * Copyright © 2009 briche - Bertrand Riché
 * @link http://www.bertrandriche.fr
 * @mail bertrand.riche@gmail.com
 * @version 1.0
 */

package briche.display.bitmap {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	public class SimpleCropper {
		
		/**
		 * Crop a image on the stage or in a movieclip
		 * 
		 * @param		target				DisplayObject > object on the display list
		 * @param		width				int		> width of the desired cropped image
		 * @param		height				int 	> height of the desired cropped image
		 * @param		x					int		> left starting point in pixels
		 * @param		y					int		> top starting point in pixels
		 * @param		scale               Number 	> the desired scale of the final bitmap 
		 * @return		croppedBitmap		Bitmap 	> the cropped Bitmap
		 */
		public static function crop( target:DisplayObject, width:int = 550, height:int = 400, x:int = 0, y:int = 0, scale:Number = 1):Bitmap {
			if (!target) { 
				throw new Error('SimpleCropper.crop > needs a something on the display list'); return null;
			}
			var cropArea:Rectangle = new Rectangle( 0, 0, width * scale, height * scale);
			var croppedBitmap:Bitmap = new Bitmap( new BitmapData( width * scale, height * scale), PixelSnapping.ALWAYS, true );
			croppedBitmap.bitmapData.draw( target, new Matrix(scale, 0, 0, scale, -x, -y), null, null, cropArea, true );
			return croppedBitmap;
		}
		
		/*
		private function crop(_x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap {
            var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
            var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height ), PixelSnapping.ALWAYS, true );
            croppedBitmap.bitmapData.draw( (displayObject!=null) ? displayObject : stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
            return croppedBitmap;
        }
		*/
		
	}

}