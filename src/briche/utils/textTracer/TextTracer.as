package briche.utils.textTracer {
	import briche.utils.ArrayUtils;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class TextTracer {
		
		static public const DEBUG:String = "debug";
		static public const INFO:String = "info";
		static public const WARN:String = "warn";
		static public const FATAL:String = "fatal";
		
		static private var _tracer:TextField;
		static private var _traceContainer:Sprite;
		static private var _debugLevels:Array = [DEBUG, INFO, WARN, FATAL];
		
		public static function init(container:DisplayObjectContainer, totalWidth:int, totalHeight:int):void {
			
			_traceContainer = new Sprite();
			container.addChild(_traceContainer);
			_traceContainer.graphics.beginFill(0x000033, 0.4);
			_traceContainer.graphics.drawRect(0, 0, totalWidth, totalHeight);
			_traceContainer.mouseEnabled = false;
			_traceContainer.mouseChildren = false;
			
			var tformat:TextFormat = new TextFormat();
			tformat.size = 10;
			tformat.leading = -2;
			tformat.font = "_sans";
			tformat.color = 0xFFFF00;
			
			
			_tracer = new TextField();
			_traceContainer.addChild(_tracer);
			_tracer.htmlText = "INIT";
			_tracer.multiline = true;
			_tracer.selectable = false;
			_tracer.wordWrap = true;
			_tracer.width = totalWidth;
			_tracer.height = totalHeight;
			_tracer.defaultTextFormat = tformat;
			_tracer.setTextFormat(tformat);
			_tracer.border = true;
			_tracer.borderColor = 0xFF0000;
			_tracer.background = false;
			_tracer.condenseWhite = true;
			
		}
		
		public static function log(...args):void {
			if (!_tracer) return;
			
			var hasDebugLevel:Boolean = false;
			var fontTag:String;
			var fontTagEnd:String = "</font>";
			
			var total:int = args.length;
			_tracer.htmlText += "\n";
			for (var i:int = 0; i < total; i++) {
				if (ArrayUtils.isInArray(args[i], _debugLevels)) {
					hasDebugLevel = true;
					_tracer.htmlText += "<font color='" + _getTypeColor(args[i]) + "'>";
				} else {
					_tracer.appendText(Object(args[i]).toString() + " ");
				}
			}
			if (hasDebugLevel) {
				_tracer.htmlText += fontTagEnd;
				_tracer.htmlText += "<font color='" + _getTypeColor(DEBUG) + "'>";
				_tracer.htmlText += fontTagEnd;
			}
			
			if (_tracer.bottomScrollV < _tracer.maxScrollV) _tracer.scrollV = _tracer.maxScrollV;
			
		}
		
		public static function _getTypeColor(type:String):String {
			if (type == INFO) return "#00FF00";
			else if (type == WARN) return "#00FFFF";
			else if (type == FATAL) return "#FF0070";
			return "#FFFF00";
		}
		
	}

}