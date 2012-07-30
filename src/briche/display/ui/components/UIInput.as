/**
 * Copyright © 2009 briche - Bertrand Riché
 * @link http://www.bertrandriche.fr
 * @mail bertrand.riche@gmail.com
 * @version 1.0
 */

package briche.display.ui.components {
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	public class UIInput extends Sprite {
		
		public static var baseWidth:int = 100;
		
		// -- params
		private var _focus:String;
		private var _width:int;
		private var _height:int;
		private var _selected:Boolean;
		
		// -- background
		private var _background:Sprite;
		private var _backgroundMatrixGradient:Matrix;
		
		// -- value
		private var _valueTextField:TextField
		private var _valueTextFormat:TextFormat;
		
		public function UIInput(focus:String = "", autosize:Boolean = false, displayAsPassword:Boolean = false) {
			_focus = focus;
			_height = 20;
			_selected = false;
			
			// -- background
			
			_background = new Sprite();
			addChild(_background);
			
			// -- value
			
			_valueTextFormat = new TextFormat();
			_valueTextFormat.font = "Arial";
			_valueTextFormat.size = 11;
			_valueTextFormat.color = 0xb9b9b9;
			_valueTextFormat.align = TextFormatAlign.LEFT;
			
			_valueTextField = new TextField();
			_valueTextField.defaultTextFormat = _valueTextFormat;
			_valueTextField.type = TextFieldType.INPUT;
			_valueTextField.text = _focus ? _focus : "";
			_valueTextField.x = 2;
			_valueTextField.y = 1;
			_valueTextField.displayAsPassword = displayAsPassword;
			_valueTextField.antiAliasType = AntiAliasType.ADVANCED;
			_valueTextField.autoSize = autosize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			_valueTextField.width = autosize ? _valueTextField.textWidth : baseWidth;
			_valueTextField.height = 18;
			_valueTextField.addEventListener(FocusEvent.FOCUS_IN, _selectEvent);
			_valueTextField.addEventListener(FocusEvent.FOCUS_OUT, _unselectEvent);
			_valueTextField.addEventListener(TextEvent.TEXT_INPUT, _textInputEvent);
			addChild(_valueTextField);
			
			width = autosize ? _valueTextField.textWidth + 10 : baseWidth;
			
			// -- init
			
			_drawBackground();
		}
		
		override public function set tabIndex(index:int):void {
			_valueTextField.tabIndex = index;
		}
		
		public function set align(align:String):void {
			_valueTextFormat.align = align;
		}
		
		public function set type(type:String):void {
			_valueTextField.type = type;
			if (type == TextFieldType.DYNAMIC) {
				_valueTextField.selectable = false;
			} else {
				_valueTextField.selectable = true;
			}
		}
		
		
		private function _textInputEvent(evt:TextEvent):void {
			dispatchEvent(evt);
		}
		
		/**
		 * ------------------------------------------------
		 * Draw background
		 * ------------------------------------------------
		 */
		
		private function _drawBackground():void {
			var ellipse:int = 12;
			var colorGradientLine1:uint = _selected ? 0x1A6F72 : 0x5e5e5e;
			var colorGradientLine2:uint = _selected ? 0x55AEB1 : 0xbababa;
			
			_backgroundMatrixGradient = new Matrix();
			_backgroundMatrixGradient.createGradientBox(_width, _height, 90 * Math.PI / 180);
			
			_background.graphics.clear();
			_background.graphics.lineStyle(1, 0, 1, false);
			_background.graphics.lineGradientStyle(GradientType.LINEAR, [colorGradientLine1, colorGradientLine2], [1, 1], [0, 255], _backgroundMatrixGradient, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			_background.graphics.beginFill(0xffffff);
			_background.graphics.drawRect(0, 0, _width, _height);
			_background.graphics.endFill();
		}
		
		/**
		 * ------------------------------------------------
		 * Override width / height setter
		 * ------------------------------------------------
		 */
		
		public override function set width(value:Number):void {
			_width = value;
			_drawBackground();
			
			_valueTextField.width = _width - 2;
		}
		
		public override function set height(value:Number):void {
			_height = value;
			_valueTextField.height = _height;
			if (_valueTextField.height > 18) {
				_valueTextField.multiline = true;
				_valueTextField.wordWrap = true;
			} else {
				_valueTextField.multiline = false;
				_valueTextField.wordWrap = false;
			}
			_drawBackground();
		}
		
		/**
		 * ------------------------------------------------
		 * Animation select
		 * ------------------------------------------------
		 */
		
		private function _selectEvent(e:FocusEvent):void {
			selected = true;
		}
		
		private function _unselectEvent(e:FocusEvent):void  {
			selected = false;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			
			if (_selected) {
				if (_valueTextField.text == _focus) {
					_valueTextFormat.color = 0x2d2d2d;
					
					_valueTextField.defaultTextFormat = _valueTextFormat;
					_valueTextField.text = "";
				}
			} else {
				if (_valueTextField.text == "") {
					_valueTextFormat.color = 0xb9b9b9;
					
					_valueTextField.defaultTextFormat = _valueTextFormat;
					_valueTextField.text = _focus ? _focus : "";
				}
			}
			
			_drawBackground();
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function reset():void {
			_valueTextFormat.color = 0xb9b9b9;
					
			_valueTextField.defaultTextFormat = _valueTextFormat;
			_valueTextField.text = _focus ? _focus : "";
		}
		
		/**
		 * ------------------------------------------------
		 * Getters
		 * ------------------------------------------------
		 */
		
		public function get text():String {
			return _valueTextField.text != _focus ? _valueTextField.text : "";
		}
		
		public function set text(text:String):void {
			_valueTextField.text = text != "" ? text : _focus;
		}
		
	}

}