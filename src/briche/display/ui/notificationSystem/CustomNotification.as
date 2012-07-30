package briche.display.ui.notificationSystem {
	import briche.display.ui.notifications.abstract.Notification;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class CustomNotification extends Notification {
		
		public function CustomNotification() {
			
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * BACKGROUND
		 * ********************************************************************
		 * *******************************************************************/
		
		public function setBackgroundStyle(style:Object):CustomNotification {
			//_bgStyle = style;
			//
			_drawBackground();
			
			return this;
		}
		
		private function _drawBackground():void{
			//_background.graphics.clear();
			//_background.graphics.beginFill(_bgStyle.backgroundColor, _bgStyle.backgroundAlpha);
			//_background.graphics.lineStyle(_bgStyle.borderThickness, _bgStyle.borderColor, _bgStyle.borderAlpha);
			//_background.graphics.moveTo(_bgStyle.cornersRadius, 0);
			//_background.graphics.lineTo(_width - _bgStyle.cornersRadius, 0);
			//_background.graphics.curveTo(_width, 0, _width, _bgStyle.cornersRadius);
			//_background.graphics.lineTo(_width, _bgStyle.cornersRadius);
			//_background.graphics.lineTo(_width, _height - _bgStyle.cornersRadius);
			//_background.graphics.curveTo(_width, _height, _width - _bgStyle.cornersRadius, _height);
			//_background.graphics.lineTo(_width - _bgStyle.cornersRadius, _height);
			//_background.graphics.lineTo(_bgStyle.cornersRadius, _height);
			//_background.graphics.curveTo(0, _height, 0, _height - _bgStyle.cornersRadius);
			//_background.graphics.lineTo(0, _height - _bgStyle.cornersRadius);
			//_background.graphics.lineTo(0, _bgStyle.cornersRadius);
			//_background.graphics.curveTo(0, 0, _bgStyle.cornersRadius, 0);
			//_background.graphics.lineTo(_bgStyle.cornersRadius, 0);
			//_background.graphics.endFill();
			
			
		}
		
	}

}