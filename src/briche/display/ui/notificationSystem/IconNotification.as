package briche.display.ui.notificationSystem {
	import briche.display.ui.notifications.abstract.Notification;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class IconNotification extends Notification {
		
		public function IconNotification() {
			
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * ICON
		 * ********************************************************************
		 * *******************************************************************/
		
		public function addIcon(icon:DisplayObject, iconWidth:int = 20, iconHeight:int = 20):IconNotification {
			
			//_hasIcon = true;
			//
			//_iconWidth = iconWidth;
			//_iconHeight = iconHeight;
			//
			//_icon = BitmapResizer.Resize(icon, _iconWidth, _iconHeight, BitmapResizer.NO_RATIO);
			//_icon.x = _innerspace;
			//_icon.y = _innerspace;
			//
			//addChild(_icon);
			//
			//
			//_checkDimensions();
			//_replaceElements();
			
			return this;
		}
		
	}

}