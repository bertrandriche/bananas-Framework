package briche.display.ui.notificationSystem.abstract {
	
	import briche.display.ui.notificationSystem.events.NotificationEvent;
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
	
	[Event(name="notificationClose", type="briche.display.ui.notifications.events.NotificationEvent")]
	 
	public class Notification extends Sprite{
		
		protected var _hasTitle:Boolean = false;
		
		// Text & title
		protected var _text:String;
		protected var _textfield:TextField;
		protected var _title:String;
		protected var _titleField:TextField;
		
		// Properties
		protected var _width:int;
		protected var _height:int;
		protected var _duration:int;
		protected var _innerspace:int;
		
		protected var _fadingTimer:Timer;
		
		// BACKGROUND
		protected var _backgroundContainer:Sprite;
		
		public function Notification(text:String, title:String = "", width:int = 150, innerspace:int = 5, duration:int = 5) {
			_title = title;
			_width = width;
			_duration = duration;
			_text = text;
			_innerspace = innerspace;
			
			_backgroundContainer = new Sprite();
			addChild(_backgroundContainer);
			
			_createText();
			if (_title != "") {
				_createTitle();
			}
			
			addEventListener(Event.ADDED_TO_STAGE, _init);
		}
		
		protected function _init(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			addEventListener(MouseEvent.ROLL_OVER, _stopTimer);
			addEventListener(MouseEvent.ROLL_OUT, _closeNotification);
			addEventListener(MouseEvent.CLICK, _closeNotification);
			
			_startTimer();
		}
		
		/* ********************************************************************
		 * ********************************************************************
		 * TEXT
		 * ********************************************************************
		 * *******************************************************************/
		
		protected function _createText():void {
			
			_textfield = new TextField();
			_textfield.multiline = true;
			_textfield.wordWrap = true;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.x = _innerspace;
			_textfield.y = _innerspace;
			_textfield.height = 10;
			_textfield.text = _text;
			addChild(_textfield);
		}
		
		public function setTextStyle(format:TextFormat):Notification {
			
			if (format.font) {
				_textfield.embedFonts = true;
			}
			_textfield.defaultTextFormat = format;
			_textfield.setTextFormat(format);
			
			return this;
		}
		
		/* ********************************************************************
		 * ********************************************************************
		 * TITLE
		 * ********************************************************************
		 * *******************************************************************/
		
		protected function _createTitle():void {
			_hasTitle = true;
			
			var format:TextFormat = new TextFormat();
			format.bold = true;
			format.size = 16;
			
			_titleField = new TextField();
			_titleField.multiline = false;
			_titleField.wordWrap = false;
			_titleField.selectable = false;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			_titleField.height = 10;
			_titleField.defaultTextFormat = format;
			_titleField.text = _title;
			_titleField.setTextFormat(format);
			addChild(_titleField);
		}
		
		public function setTitleStyle(format:TextFormat):Notification {
			
			if (format.font) {
				_titleField.embedFonts = true;
			}
			_titleField.defaultTextFormat = format;
			_titleField.setTextFormat(format);
			
			return this;
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * CHECKING FUNCTIONS
		 * ********************************************************************
		 * *******************************************************************/
		
		protected function _checkDimensions():void {
			
		}
		
		protected function _replaceElements():void {
			
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * TIMER
		 * ********************************************************************
		 * *******************************************************************/
		
		protected function _startTimer():void {
			_fadingTimer = new Timer(_duration * 1000, 1);
			_fadingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onFadingTimerDone);
			_fadingTimer.start();
		}
		
		protected function _stopTimer(evt:MouseEvent):void {
			
			if (!_fadingTimer) {
				return;
			}
			
			_fadingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onFadingTimerDone);
			if (_fadingTimer.running) {
				_fadingTimer.stop();
			}
		}
		
		protected function _onFadingTimerDone(evt:TimerEvent):void {
			_fadingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onFadingTimerDone);
			_fadingTimer = null;
			
			dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFICATION_CLOSE));
		}
		
		/* ********************************************************************
		 * ********************************************************************
		 * CLOSING
		 * ********************************************************************
		 * *******************************************************************/
		
		protected function _closeNotification(evt:MouseEvent = null):void {
			dispatchEvent(new NotificationEvent(NotificationEvent.NOTIFICATION_CLOSE));
		}
		
		public function deleteListeners():void {
			removeEventListener(MouseEvent.ROLL_OVER, _stopTimer);
			removeEventListener(MouseEvent.ROLL_OUT, _closeNotification);
			removeEventListener(MouseEvent.CLICK, _closeNotification);
			
			if (_fadingTimer) {
				_fadingTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onFadingTimerDone);
			}
		}
	}

}