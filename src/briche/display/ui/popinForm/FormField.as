package briche.display.ui.popinForm {
	import aze.motion.eaze;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class FormField extends Sprite {
		
		public static const CONTENT_MAIL:String = "mail";
		static public const CONTENT_NONE:String = "none";
		static public const CONTENT_REQUIRED:String = "required";
		
		private var _content:TextField;
		private var _bg:Sprite;
		
		private var _width:int = 10;
		private var _height:int = 10;
		private var _name:String;
		private var _label:TextField;
		private var _defaultContent:String;
		
		private var _permanentDefaultContent:Boolean = false;
		public var contentType:String;
		
		private var _labelFormat:TextFormat;
		private var _focusOutColor:uint;
		private var _focusInColor:uint;
		private var _contentFormat:TextFormat;
		private var _errored:Boolean = false;
		
		public function FormField(fieldName:String, fieldLabel:String, fieldDefaultContent:String) {
			
			_name = fieldName;
			_defaultContent = fieldDefaultContent;
			
			contentType = CONTENT_NONE;
			
			_bg = new Sprite();
			addChild(_bg);
			_bg.filters = [new GlowFilter(0, 0.5) ];
			
			_labelFormat = new TextFormat();
			_labelFormat.color = 0xFF0000;
			_label = new TextField();
			addChild(_label);
			_label.defaultTextFormat = _labelFormat;
			_label.text = fieldLabel;
			_label.selectable = false;
			
			_contentFormat = new TextFormat();
			_content = new TextField();
			addChild(_content);
			_content.defaultTextFormat = _contentFormat;
			_content.text = _defaultContent;
			_content.type = TextFieldType.INPUT;
			_content.addEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
			_content.addEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
			_content.addEventListener(Event.CHANGE, _onChange);
			
			_content.x = _label.width + 5;
			
		}
		
		private function _onChange(evt:Event):void {
			if (_errored) {
				hideError();
			}
		}
		
		public function hideError():void {
			_errored = false;
			eaze(_bg).to(0.3).filter(GlowFilter, { color:0xFFFFFF, alpha:0 } );
		}
		
		private function _onFocusOut(evt:FocusEvent):void {
			if (!_permanentDefaultContent && _content.text == "") {
				_content.text = _defaultContent;
				_contentFormat.color = _focusOutColor;
				_content.setTextFormat(_contentFormat);
			}
		}
		
		private function _onFocusIn(evt:FocusEvent):void {
			if (!_permanentDefaultContent && _content.text == _defaultContent) {
				_contentFormat.color = _focusInColor;
				_content.setTextFormat(_contentFormat);
				_content.text = "";
			}
			if (_errored) {
				hideError();
			}
		}
		
		public function drawContent(defaultdefaultContentColor:uint, defaultContentColor:uint, defaultLabelColor:uint):void {
			_focusOutColor = defaultdefaultContentColor;
			_focusInColor = defaultContentColor;
			_setContentColors();
			
			_labelFormat.color = defaultLabelColor;
			_label.setTextFormat(_labelFormat);
		}
		
		public function reset():void {
			_content.text = _defaultContent;
			_bg.filters = [];
			_setContentColors();
		}
		
		public function drawBG(defaultBGColor:uint):void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(defaultBGColor);
			_bg.graphics.drawRect(0, 0, _width, _height);
			
		}
		
		public function showError(errorColor:uint):void {
			_errored = true;
			eaze(_bg).to(0.3).filter(GlowFilter, { color:errorColor, alpha:0.7 } );
		}
		
		public function destroy():void {
			_content.removeEventListener(FocusEvent.FOCUS_IN, _onFocusIn);
			_content.removeEventListener(FocusEvent.FOCUS_OUT, _onFocusOut);
			
			removeChild(_content);
			_content = null;
			removeChild(_label);
			_label = null;
			removeChild(_bg);
			_bg = null;
		}
		
		public function get content():String {
			return _content.text;
		}
		
		public function set multiline(value:Boolean):void {
			_content.multiline = value;
			_content.wordWrap = value;
		}
		
		public override function set width(value:Number):void {
			var oldValue:int = _width;
			_width = value;
			
			if (_width != oldValue) {
				_resize();
			}
		}
		
		public override function set height(value:Number):void {
			var oldValue:int = _height;
			_height = value;
			
			if (_height != oldValue) {
				_resize();
			}
		}
		
		public override function get height():Number {
			return _bg.height;
		}
		
		public function get label():TextField {
			return _label;
		}
		
		public function get defaultContent():String {
			return _defaultContent;
		}
		
		public function set defaultContent(value:String):void {
			_defaultContent = value;
			_content.text = _defaultContent;
		}
		
		public function get permanentDefaultContent():Boolean {
			return _permanentDefaultContent;
		}
		
		public function set permanentDefaultContent(value:Boolean):void {
			_permanentDefaultContent = value;
			_setContentColors();
		}
		
		private function _setContentColors():void {
			if (!_permanentDefaultContent) {
				_contentFormat.color = _focusOutColor;
			} else {
				_contentFormat.color = _focusInColor;
			}
			_content.setTextFormat(_contentFormat);
		}
		
		public override function get name():String {
			return _name;
		}
		
		private function _resize():void {
			_content.width = _width;
			_content.height = _height;
			
			_bg.width = _width;
			_bg.height = _height;
			
			_bg.x = _label.width + 5
		}
		
	}

}