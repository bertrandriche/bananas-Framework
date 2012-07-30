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
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	public class UICheckBox extends Sprite{
		
		// -- params
		private var _focus:String;
		private var _width:int;
		private var _height:int;
		private var _over:Boolean;
		private var _selected:Boolean;
		
		// -- background
		private var _background:Sprite;
		private var _backgroundMatrixGradient:Matrix;
		
		// -- check
		private var _check:Sprite;
		
		// -- value
		private var _valueTextField:TextField
		private var _valueTextFormat:TextFormat;
		
		public function UICheckBox(focus:String = "", listeners:Boolean = true) {
			_focus = focus;
			_width = 14;
			_height = 14;
			_over = false;
			_selected = false;
			
			this.mouseEnabled = false;
			
			// -- background
			
			_background = new Sprite();
			addChild(_background);
			
			// -- value
			
			//_valueTextFormat = new TextFormat();
			//_valueTextFormat.font = "Arial";
			//_valueTextFormat.size = 11;
			//_valueTextFormat.color = 0x2d2d2d;
			//_valueTextFormat.align = TextFormatAlign.LEFT;
			
			_valueTextField = new TextField();
			_valueTextField.mouseEnabled = false;
			_valueTextField.multiline = true;
			_valueTextField.wordWrap = true;
			_valueTextField.autoSize = TextFieldAutoSize.LEFT;
			_valueTextField.mouseEnabled = false;
			//_valueTextField.defaultTextFormat = _valueTextFormat;
			_valueTextField.text = _focus;
			_valueTextField.x = 18;
			_valueTextField.y = -2;
			_valueTextField.width = 100;
			_valueTextField.height = 18;
			addChild(_valueTextField);
			
			// -- check
			
			_check = new Sprite();
			_check.graphics.lineStyle(1, 0x1A6F72);
			_check.graphics.beginFill(0x55AEB1);
			_check.graphics.moveTo(0, 3);
			_check.graphics.lineTo(6, 7);
			_check.graphics.lineTo(17, -5);
			_check.graphics.lineTo(7, 15);
			_check.graphics.endFill();
			_check.visible = false;
			addChild(_check);
			
			// -- init
			
			_drawBackground();
			
			if (listeners) {
				addEventListener(MouseEvent.ROLL_OVER, over);
				addEventListener(MouseEvent.ROLL_OUT, out);
			}
		}
		
		/**
		 * ------------------------------------------------
		 * Draw background
		 * ------------------------------------------------
		 */
		
		private function _drawBackground():void {
			var ellipse:int = 12;
			var colorGradientLine1:uint = _over ? 0x1A6F72 : 0x5e5e5e;
			var colorGradientLine2:uint = _over ? 0x55AEB1 : 0xbababa;
			
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
		 * Animation over / out
		 * ------------------------------------------------
		 */
		
		public function over(e:MouseEvent = null):void {
			_over = true;
			_drawBackground();
		}
		
		public function out(e:MouseEvent = null):void {
			_over = false;
			_drawBackground();
		}
		
		/**
		 * ------------------------------------------------
		 * Animation select
		 * ------------------------------------------------
		 */
		
		public function toggleSelect(e:MouseEvent = null):void {
			selected = !_selected;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			_check.visible = _selected;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * ------------------------------------------------
		 * Getters
		 * ------------------------------------------------
		 */
		
		public function get value():Boolean {
			return _selected;
		}
		
		override public function set width(value:Number):void {
			_valueTextField.width = value;
		}
		
		public function set listeners(value:Boolean):void {
			if (value) {
				addEventListener(MouseEvent.ROLL_OVER, over);
				addEventListener(MouseEvent.ROLL_OUT, out);
			} else {
				removeEventListener(MouseEvent.ROLL_OVER, over);
				removeEventListener(MouseEvent.ROLL_OUT, out);
			}
		}
		
		public function get text():String {
			return _valueTextField.text;
		}
		
		public function set text(value:String):void {
			_valueTextField.text = value;
		}
		
	}

}