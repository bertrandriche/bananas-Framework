package briche.utils {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	
	
	[Event(name = "complete", type = "flash.events.Event")]
	 
	public class FontsLoader extends EventDispatcher {
		
		private var _fontsLibs:Array;
		private var _totalLibs:int;
		private var _loadedLibs:int;
		
		private var _loading:Boolean = false;
		private var _autoLoad:Boolean;
		
		private var _loaded:Boolean = false;
		
		public function FontsLoader(autoLoad:Boolean = true) {
			
			_autoLoad = autoLoad;
			
			_fontsLibs = [];
			
		}
		
		public function addFontLibrary(libPath:String = "fontLib.swf"):void {
			
			if (libPath.indexOf(".swf") == -1) {
				return;
			}
			
			_fontsLibs[_fontsLibs.length] = libPath;
			trace("FontsLoader > ADD FONT LIBRARY >", libPath);
			
			_totalLibs ++;
			
			if (_autoLoad) {
				load();
			}
			
		}
		
		public function load():void {
			
			if (_loading) {
				return;
			}
			_loading = true;
			
			_loadedLibs = 0;
			
			var fontLoader:Loader;
			
			for (var i:int = 0; i < _totalLibs; i++) {
				fontLoader = new Loader();
				fontLoader.contentLoaderInfo.addEventListener(Event.INIT, _onFontLoaded);
				fontLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				fontLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
				fontLoader.load(new URLRequest(_fontsLibs[i]));
				trace("FontsLoader > LOAD NEW LIBRARY >", _fontsLibs[i]);
			}
			
		}
		
		private function _onLoadError(evt:IOErrorEvent):void {
			
		}
		
		private function _onLoadProgress(evt:ProgressEvent):void {
			dispatchEvent(evt);
		}
		
		private function _onFontLoaded(evt:Event):void {
			
			_loadedLibs ++;
			trace("FontsLoader > LIBRARY LOADED (", _loadedLibs, "on", _totalLibs, ")");
			
			if (_loadedLibs == _totalLibs) {
				_loaded = true;
				dispatchEvent(new Event(Event.COMPLETE));
				
				_loading = false;
			}
			
		}
		
		public function get loaded():Boolean {
			return _loaded;
		}
		
	}

}