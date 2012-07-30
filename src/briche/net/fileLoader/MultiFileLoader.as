package briche.net.fileLoader {
	
	import briche.events.FileLoaderEvent;
	import briche.net.fileLoader.FileLoader;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	/**
	 * ...
	 * @author BRiché
	 */
	
	[Event(name = "loadStart", type = "briche.events.FileLoaderEvent")]
	[Event(name = "complete", type = "briche.events.FileLoaderEvent")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "error", type = "briche.events.FileLoaderEvent")]
	 
	public class MultiFileLoader extends EventDispatcher {
		
		private var _tabLoadings:Array;
		
		private var _loading:Boolean = false;
		
		private var _lastID:int = -1;
		
		private var _currentLoadingID:int;
		
		
		public function MultiFileLoader() {
			_tabLoadings = [];
		}
		
		public function addLoading(path:String, type:String):int {
			var loader:FileLoader = new FileLoader(path, type);
			loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			loader.addEventListener(FileLoaderEvent.COMPLETE, _onLoadEnd);
			loader.addEventListener(FileLoaderEvent.LOAD_START, _onLoadStart);
			loader.addEventListener(FileLoaderEvent.ERROR, _onLoadError);
			
			_lastID ++;
			_tabLoadings[_tabLoadings.length] = { id:_lastID, loader:loader };
			
			if (!_loading) {
				_tabLoadings[0].loader.load();
			}
			
			return _lastID;
		}
		
		public function stopAllLoadings():void {
			
			var loader:FileLoader;
			
			var total:int = _tabLoadings.length;
			for (var i:int = 0; i < total; i++) {
				loader = _tabLoadings[i].loader;
				
				loader.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				loader.removeEventListener(FileLoaderEvent.COMPLETE, _onLoadEnd);
				loader.removeEventListener(FileLoaderEvent.LOAD_START, _onLoadStart);
				loader.removeEventListener(FileLoaderEvent.ERROR, _onLoadError);
				loader.stop();
				loader = null;
			}
			
		}
		
		private function _onLoadError(evt:FileLoaderEvent):void {
			var loader:FileLoader = FileLoader(evt.target);
			_deleteListeners(loader);
			
			evt.stopPropagation();
			dispatchEvent(evt);
			
			_startNewLoading();
		}
		
		private function _onLoadStart(evt:FileLoaderEvent):void {
			_loading = true;
			
			_currentLoadingID = _getCurrentID(FileLoader(evt.target));
			
			dispatchEvent(evt);
		}
		
		private function _onLoadProgress(evt:ProgressEvent):void {
			evt.stopPropagation();
			dispatchEvent(evt);
		}
		
		private function _onLoadEnd(evt:FileLoaderEvent):void {
			var loader:FileLoader = FileLoader(evt.target);
			_deleteListeners(loader);
			
			evt.stopPropagation();
			dispatchEvent(evt);
			
			_startNewLoading();
		}
		
		private function _getCurrentID(loader:FileLoader):int {
			for (var i:int = 0; i < _tabLoadings.length; i++) {
				if (loader == _tabLoadings[i].loader) {
					return _tabLoadings[i].id;
					break;
				}
			}
			
			return -1;
		}
		
		private function _startNewLoading():void {
			_loading = false;
			
			_tabLoadings.shift();
			
			if (_tabLoadings.length) {
				_tabLoadings[0].loader.load();
			}
		}
		
		private function _deleteListeners(loader:FileLoader):void{
			loader.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			loader.removeEventListener(FileLoaderEvent.COMPLETE, _onLoadEnd);
			loader.removeEventListener(FileLoaderEvent.LOAD_START, _onLoadStart);
		}
		
		public function get loading():Boolean { return _loading; }
		
		public function get currentLoadingID():int { return _currentLoadingID; }
		
		public function get lastID():int { return _lastID; }
		
	}
}