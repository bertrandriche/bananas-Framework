package briche.display.ui.popinForm {
	import aze.motion.eaze;
	import briche.display.ui.components.UILabel;
	import briche.utils.ArrayUtils;
	import briche.utils.TextUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import siteXou.events.TransitionEvent;
	
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class PopInForm extends Sprite {
		private var _darkBG:Sprite;
		private var _formContainer:Sprite;
		private var _formContent:Sprite;
		
		private const CONTENT_PADDING:int = 15;
		private var _formBG:Sprite;
		
		public var fieldsVerticalSpacing:int = 10;
		public var defaultErrorColor:uint = 0xFF0000;
		public var defaultFieldHeight:int = 20;
		public var defaultFieldWidth:int = 100;
		public var defaultFieldBGColor:uint = 0xFFFFFF;
		public var defaultLabelColor:uint = 0x666666;
		public var defaultContentColor:uint = 0x000000;
		public var defaultdefaultContentColor:uint = 0xAAAAAA;
		
		private var _fields:Array/*FormField*/;
		private var _fieldsNames:Array;
		private var _numFields:int;
		private var _buttonsContainer:Sprite;
		private var _sending:UILabel;
		
		public function PopInForm() {
			
			this.visible = false;
			
			_darkBG = new Sprite();
			_darkBG.graphics.beginFill(0);
			_darkBG.graphics.drawRect(0, 0, 100, 100);
			_darkBG.alpha = 0;
			_darkBG.addEventListener(MouseEvent.CLICK, _onBGClick);
			addChild(_darkBG);
			
			_formContainer = new Sprite();
			addChild(_formContainer);
			
			_formBG = new Sprite();
			_formBG.graphics.beginFill(0xFFFFFF);
			_formBG.graphics.drawRect(0, 0, 100, 100);
			_formBG.filters = [new GlowFilter(0, 0.5) ];
			_formContainer.addChild(_formBG);
			
			_formContent = new Sprite();
			_formContainer.addChild(_formContent);
			_formContent.alpha = 0;
			_formContent.x = CONTENT_PADDING;
			_formContent.y = CONTENT_PADDING;
			
			_fieldsNames = [];
			_fields = [];
			_numFields = 0;
			
			var formatSending:TextFormat = new TextFormat();
			formatSending.color = 0xDC0C1C;
			_sending = new UILabel("Sending");
			_sending.textFormat = formatSending;
			_formContent.addChild(_sending);
			_sending.visible = false;
			
			_addButtons();
			
			addEventListener(Event.ADDED_TO_STAGE, _init);
			
		}
		
		
		public function addField(fieldName:String, fieldLabel:String, fieldDefaultContent:String, fieldWidth:int = -1, fieldHeight:int = -1, isMultiline:Boolean = false):void {
			
			if (ArrayUtils.isInArray(fieldName, _fieldsNames, false)) {
				return;
			}
			
			var newField:FormField = new FormField(fieldName, fieldLabel, fieldDefaultContent);
			newField.multiline = isMultiline;
			
			newField.drawBG(defaultFieldBGColor);
			if (fieldWidth != -1) {
				newField.width = fieldWidth;
			} else {
				newField.width = defaultFieldWidth;
			}
			if (fieldHeight != -1) {
				newField.height = fieldHeight;
			} else {
				newField.height = defaultFieldHeight;
			}
			_formContent.addChild(newField);
			
			newField.drawContent(defaultdefaultContentColor, defaultContentColor, defaultLabelColor);
			
			_fieldsNames[_numFields] = fieldName;
			_fields[_numFields] = newField;
			_numFields++;
			
			_positionFields();
			
		}
		
		private function _positionFields():void {
			var field:FormField;
			var offsetY:int = 0;
			
			for (var i:int = 0; i < _numFields; i++) {
				field = _fields[i];
				
				field.y = offsetY;
				offsetY += field.height + fieldsVerticalSpacing;
			}
			
			
			_buttonsContainer.y = offsetY;
			_buttonsContainer.x = _formContent.width - _buttonsContainer.width;
			
			_sending.y = offsetY;
			_sending.x = 10;
		}
		
		public function removeField(fieldName:String):void {
			var tempField:FormField;
			for (var i:int = 0; i < _numFields; i++) {
				if (_fields[i].name == fieldName) {
					tempField = _fields[i];
					_formContainer.removeChild(tempField);
					tempField.destroy();
					tempField = null;
					break;
				}
			}
		}
		
		public function getField(fieldName:String):FormField {
			for (var i:int = 0; i < _numFields; i++) {
				if (_fields[i].name == fieldName) {
					return _fields[i];
				}
			}
			return null;
		}
		
		private function _onBGClick(evt:MouseEvent):void {
			hide();
		}
		
		private function _init(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			resize();
		}
		
		public function reset():void {
			for (var i:int = 0; i < _numFields; i++) {
				_fields[i].reset();
			}
		}
		
		public function exportData():Object {
			var datas:Object = { };
			
			for (var i:int = 0; i < _numFields; i++) {
				datas[_fields[i].name] = _fields[i].content;
			}
			
			return datas;
		}
		
		
		public function show():void {
			this.visible = true;
			_sending.alpha = 0;
			
			eaze(_darkBG).to(0.4, { alpha:0.4 } );
			
			_formBG.width = 10;
			_formBG.height = 0;
			_formBG.x = _formContent.width * 0.5 + CONTENT_PADDING;
			_formBG.y = _formContent.height * 0.5 + CONTENT_PADDING;
			
			eaze(_formBG).to(0.2, { height:_formContent.height + CONTENT_PADDING * 2, y:0 } ).to(0.3, { width:_formContent.width + CONTENT_PADDING * 2, x:0 } );
			eaze(_formContent).delay(0.5).to(0.2, { alpha: 1} );
		}
		
		
		public function hide():void {
			eaze(_formContent).to(0.2, { alpha:0 } );
			
			eaze(_formBG).delay(0.2).to(0.2, { height:5, y:_formContent.height * 0.5 + CONTENT_PADDING } ).to(0.3, { width:0, x: _formContent.width * 0.5 + CONTENT_PADDING } ).onComplete(_hideEnd);
			
			eaze(_darkBG).delay(0.7).to(0.4, { alpha:0 } );
		}
		
		private function _hideEnd():void {
			dispatchEvent(new TransitionEvent(TransitionEvent.HIDE_END));
			this.visible = false;
		}
		
		
		public function resize():void {
			
			_formContainer.x = (stage.stageWidth - _formContainer.width) >> 1;
			_formContainer.y = (stage.stageHeight - _formContainer.height) >> 1;
			
			_darkBG.width = stage.stageWidth;
			_darkBG.height = stage.stageHeight;
			
		}
		
		private function _addButtons():void {
			_buttonsContainer = new Sprite();
			_formContent.addChild(_buttonsContainer);
			
			var validate:Sprite = new Sprite();
			var label:UILabel = new UILabel("Send !");
			validate.addChild(label);
			validate.addEventListener(MouseEvent.CLICK, _onValidateClick);
			
			validate.graphics.beginFill(0xdedede);
			validate.graphics.drawRect(0, 0, label.width + 10, label.height + 6);
			label.x = 5;
			label.y = 2;
			validate.buttonMode = true;
			validate.mouseChildren = false;
			
			_buttonsContainer.addChild(validate);
		}
		
		private function _onValidateClick(evt:MouseEvent):void {
			if (_validated()) {
				dispatchEvent(new Event(Event.COMPLETE));
				eaze(_sending).to(0.3, { alpha:1 } );
			}
		}
		
		private function _validated():Boolean {
			for (var i:int = 0; i < _numFields; i++) {
				if (_fields[i].contentType != FormField.CONTENT_NONE) {
					if (!_validateField(_fields[i])) {
						_fields[i].showError(defaultErrorColor);
						return false;
					}
				}
			}
			return true;
		}
		
		private function _validateField(field:FormField):Boolean {
			switch(field.contentType) {
				case FormField.CONTENT_MAIL:
					return TextUtils.validateEmail(field.content);
				case FormField.CONTENT_REQUIRED:
					return field.content != field.defaultContent;
			}
			
			return true;
		}
		
	}

}