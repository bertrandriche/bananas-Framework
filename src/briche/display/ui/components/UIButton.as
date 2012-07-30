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
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	public class UIButton extends Sprite {
		
		public static var baseWidth:int = 100;
		
		// -- params
		private var _label:String;
		private var _width:int;
		private var _height:int;
		private var _up:Boolean;
		private var _over:Boolean;
		private var _selected:Boolean;
		
		// -- background
		private var _background:Sprite;
		private var _backgroundMatrixGradient:Matrix;
		
		// -- label
		private var _labelTextField:TextField
		private var _labelTextFormat:TextFormat;
		
		public function UIButton(label:String, autosize:Boolean = true, listeners:Boolean = true):void {
			_label = "";
			_width = baseWidth;
			_height = 25;
			_up = true;
			_over = false;
			_selected = false;
			
			
			// -- background
			
			_background = new Sprite();
			addChild(_background);
			
			// -- label
			
			_labelTextFormat = new TextFormat();
			_labelTextFormat.font = "Arial";
			_labelTextFormat.size = 11;
			_labelTextFormat.color = 0x2d2d2d;
			_labelTextFormat.align = TextFormatAlign.CENTER;
			_labelTextFormat.bold = true;
			
			_labelTextField = new TextField();
			_labelTextField.mouseEnabled = false;
			_labelTextField.defaultTextFormat = _labelTextFormat;
			_labelTextField.height = 18;
			addChild(_labelTextField);
			
			// -- init
			
			this.label = label;
			width = autosize ? _labelTextField.textWidth + 20 : baseWidth;
			_drawBackground();
			
			if (listeners) {
				addEventListener(MouseEvent.ROLL_OVER, over);
				addEventListener(MouseEvent.ROLL_OUT, out);
				addEventListener(MouseEvent.MOUSE_DOWN, down);
				addEventListener(MouseEvent.MOUSE_UP, up);
			}
			
		}
		
		/**
		 * ------------------------------------------------
		 * Draw background
		 * ------------------------------------------------
		 */
		
		private function _drawBackground():void {
			var ellipse:int = 12;
			var colorGradientLine1:uint = _over || _selected ? 0x55AEB1 : 0xbababa;
			var colorGradientLine2:uint = _over || _selected ? 0x1A6F72 : 0x5e5e5e;
			var colorGradientbegin1:uint = _up ? 0xffffff : 0xc9c9c9;
			var colorGradientbegin2:uint = _up ? 0xc9c9c9 : 0xffffff;
			
			_backgroundMatrixGradient = new Matrix();
			_backgroundMatrixGradient.createGradientBox(_width, _height, 90 * Math.PI / 180);
			
			_background.graphics.clear();
			_background.graphics.lineStyle(1, 0, 1, true);
			_background.graphics.lineGradientStyle(GradientType.LINEAR, [colorGradientLine1, colorGradientLine2], [1, 1], [0, 255], _backgroundMatrixGradient, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			_background.graphics.beginGradientFill(GradientType.LINEAR, [colorGradientbegin1, colorGradientbegin2], [1, 1], [0, 255], _backgroundMatrixGradient, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			_background.graphics.drawRoundRect(0, 0, _width, _height, ellipse, ellipse);
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
			
			label = _label;
		}
		
		public override function set height(value:Number):void {
			_height = value;
			_drawBackground();
			
			label = _label;
		}
		
		/**
		 * ------------------------------------------------
		 * Label setters 
		 * ------------------------------------------------
		 */
		
		public function set label(value:String):void {
			_label = value;
			_labelTextField.width = _width;
			_labelTextField.text = _label;
			_labelTextField.y = ((_height - _labelTextField.textHeight) >> 1) - 1;
		}
		
		public function get label():String {
			return _label;
		}
		
		/**
		 * ------------------------------------------------
		 * Animation down / up
		 * ------------------------------------------------
		 */
		
		public function down(e:MouseEvent = null):void {
			_up = false;
			_drawBackground();
		}
		
		public function up(e:MouseEvent = null):void {
			_up = true;
			_drawBackground();
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
		
		public function select(e:MouseEvent):void {
			selected = !_selected;
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			_drawBackground();
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set listeners(value:Boolean):void {
			if (value) {
				addEventListener(MouseEvent.ROLL_OVER, over);
				addEventListener(MouseEvent.ROLL_OUT, out);
				addEventListener(MouseEvent.MOUSE_DOWN, down);
				addEventListener(MouseEvent.MOUSE_UP, up);
			} else {
				removeEventListener(MouseEvent.ROLL_OVER, over);
				removeEventListener(MouseEvent.ROLL_OUT, out);
				removeEventListener(MouseEvent.MOUSE_DOWN, down);
				removeEventListener(MouseEvent.MOUSE_UP, up);
			}
		}
		
	}

}