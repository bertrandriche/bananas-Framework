/**
 * Copyright © 2009 briche - Bertrand Riché
 * @link http://www.bertrandriche.fr
 * @mail bertrand.riche@gmail.com
 * @version 1.0
 */

package briche.display.ui.components {
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	public class UILabel extends Sprite {
		
		private var _label:TextField;
		private var _format:TextFormat;
		
		public function UILabel(text:String, multiline:Boolean = false, wordwrap:Boolean = false, selectable:Boolean = false) {
			
			_format = new TextFormat();
			
			_label = new TextField();
			_label.defaultTextFormat = _format;
			_label.multiline = multiline;
			_label.wordWrap = wordwrap;
			_label.selectable = selectable;
			_label.antiAliasType = AntiAliasType.ADVANCED;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.text = text;
			addChild(_label);
			
		}
		
		public function set text(value:String):void { _label.text = value; }
		public function get text():String {	return _label.text;	}
		
		public function set htmlText(value:String):void { _label.htmlText = value; }
		public function get htmlText():String {	return _label.text;	}
		
		public function get label():TextField { return _label; }
		
		override public function set width(value:Number):void {	_label.width = value; }
		override public function get width():Number { return _label.textWidth; }
		
		override public function set height(value:Number):void { _label.height = value; }
		override public function get height():Number { return _label.textHeight; }
		
		public function get textFormat():TextFormat { return _format; }
		public function set textFormat(value:TextFormat):void {
			_format = value;
			_label.embedFonts = true;
			_label.defaultTextFormat = _format;
			_label.setTextFormat(_format);
		}
		
		public function get selectable():Boolean { return _label.selectable; };
		public function set selectable(value:Boolean):void { _label.selectable = value; };
		
		public function set align(align:String):void {
			_format.align = align;
			_label.setTextFormat(_format);
		}
		
		
	}

}