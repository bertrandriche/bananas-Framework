package briche.display.ui.notificationSystem {
	import briche.display.bitmap.BitmapResizer;
	import briche.display.ui.notificationSystem.abstract.Notification;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class BasicNotification extends Notification {
		
		
		
		
		// BACKGROUND
		protected var _background:DisplayObject;
		
		
		public function BasicNotification(background:DisplayObject, text:String, title:String = "", width:int = 150, innerspace:int = 5, duration:int = 0) {
			
			super(text, title, width, innerspace, duration);
			
			_background = background;
			_backgroundContainer.addChild(_background);
			
			_checkDimensions();
			_replaceElements();
			
		}
		
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * CHECKING FUNCTIONS
		 * ********************************************************************
		 * *******************************************************************/
		
		protected override function _checkDimensions():void {
			
			// WIDTH
			var minWidth:int = 0;
			if (_hasTitle) {
				minWidth += _titleField.width + _innerspace * 2;
			}
			
			if (minWidth > _width) {
				_width = minWidth;
			}
			_textfield.width = _width - _innerspace * 2;
			_textfield.height = _textfield.height;
			
			// HEIGHT
			var minHeight:int = 0;
			for (var i:int = 0; i < _textfield.numLines ; i++) {
				minHeight += _textfield.getLineMetrics(i).height;
			}
			_textfield.height = minHeight;
			
			if (_hasTitle) {
				minHeight += _titleField.getLineMetrics(0).height;
				minHeight += _innerspace;
			}
			minHeight += _innerspace * 3;
			_height = minHeight;
			
		}
		
		protected override function _replaceElements():void {
			var posX:int = _innerspace;
			var posY:int = _innerspace;
			
			_textfield.x = posX;
			
			if (_hasTitle) {
				_titleField.x = posX;
				_titleField.y = posY;
				_titleField.width = _width - _innerspace * 2;
				posY += _titleField.height + _innerspace;
			}
			
			_textfield.y = posY;
			_textfield.width = _width - _innerspace * 2;
			
			_background.width = _width;
			_background.height = _height;
			
		}
		
		
		
		
		
		
		
		
	}

}