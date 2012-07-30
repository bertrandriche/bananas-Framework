package briche.utils {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class DisplayUtils {
		
		public static const BOTTOM:String = "B";
		public static const BOTTOM_LEFT:String = "BL";
		public static const BOTTOM_RIGHT:String = "BR";
		public static const LEFT:String = "L";
		public static const MIDDLE:String = "C";
		public static const RIGHT:String = "R";
		public static const TOP:String = "T";
		public static const TOP_LEFT:String = "TL";
		public static const TOP_RIGHT:String = "TR";
		
		
		/**
		 * Fits a DisplayObject into a rectangular area.
		 * @param	target					DisplayObject 	> the target DisplayObject to apply the transformation
		 * @param	rectangle				Rectangle		> the rectangle defining the zone to fit into
		 * @param	fillRect				Boolean			> wether the target should fill the entire Rectangle and be cropped to fit or if it must be entirely shown
		 * @param	align					String			> the alignement of the target within the zone rectangle if it doesn't fill the entire area
		 * @param	applyTransform			BOolean			> wether to apply the generated transformation to the DisplayObject or just return the generated Matrix for the transformation.
		 * @return
		 */
		public static function fitIntoRect(target:DisplayObject, rectangle:Rectangle, fillRect:Boolean = true, align:String = "C", applyTransform:Boolean = true):Matrix {
			
			var matrix:Matrix = new Matrix();
			
			var wD:Number = target.width / target.scaleX;
			var hD:Number = target.height / target.scaleY;
			
			var wR:Number = rectangle.width;
			var hR:Number = rectangle.height;
			
			var sX:Number = wR / wD;
			var sY:Number = hR / hD;
			
			var rD:Number = wD / hD;
			var rR:Number = wR / hR;
			
			var sH:Number = fillRect ? sY : sX;
			var sV:Number = fillRect ? sX : sY;
			
			var s:Number = rD >= rR ? sH : sV;
			var w:Number = wD * s;
			var h:Number = hD * s;
			
			var tX:Number = 0.0;
			var tY:Number = 0.0;
			
			switch(align) {
				case LEFT:
				case TOP_LEFT:
				case BOTTOM_LEFT:
					tX = 0.0;
					break;
					
				case RIGHT:
				case TOP_RIGHT:
				case BOTTOM_RIGHT:
					tX = w - wR;
					break;
					
				default:					
					tX = 0.5 * (w - wR);
			}
			
			switch(align) {
				case TOP:
				case TOP_LEFT:
				case TOP_RIGHT:
					tY = 0.0;
					break;
					
				case BOTTOM:
				case BOTTOM_LEFT:
				case BOTTOM_RIGHT:
					tY = h - hR;
					break;
					
				default:					
					tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);
			
			if (applyTransform) {
				target.transform.matrix = matrix;
			}
			
			return matrix;
		}
		
		
		 /**
		  * Creates a thumbnail of a specified BitmapData. The original image will be proportionally scaled and cropped if necessary.
		  * @param	image					BitmapData		> the target image to create a thumbnail from
		  * @param	width					int				> the width of the thumbnail
		  * @param	height					int				> the height of the thumbnail
		  * @param	align					String			> the alignement of the target within the zone rectangle if it doesn't fill the entire area
		  * @param	smooth					Boolean			> if the thumbnail must be smoothed or not
		  * @return
		  */
		public static function createThumb(image:BitmapData, width:int, height:int, align:String = "C", smooth:Boolean = true):Bitmap {
			var source:Bitmap = new Bitmap(image);
			var thumbnail:BitmapData = new BitmapData(width, height, false, 0x0);
			
			thumbnail.draw(image, fitIntoRect(source, thumbnail.rect, true, align, false), null, null, null, smooth);
			source = null;
			
			return new Bitmap(thumbnail, PixelSnapping.AUTO, smooth);
		}
		
		
		public static function createOrigin(target:DisplayObjectContainer):String {
			
			if (target.getChildByName("origin")) {
				return "";
			}
			var origin:Sprite = new Sprite();
			target.addChild(origin);
			origin.name = "origin";
			
			origin.graphics.lineStyle(3, 0x990000, 0.8);
			origin.graphics.moveTo( 0, -10);
			origin.graphics.lineTo( 0, 10);
			origin.graphics.moveTo( -10, 0);
			origin.graphics.lineTo( 10, 0);
			
			return "origin";
		}
		
	}

}