package briche.net.modelLoader {
	
	import briche.events.ModelLoaderEvent;
	import briche.events.PercentEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	
	
	[Event(name = "xmlLoaded", type = "briche.events.ModelLoaderEvent")]
	[Event(name = "percentProgress", type = "briche.events.PercentEvent")]
	
	public class ModelLoader extends EventDispatcher {
		
		private var _xmls:Array/*XMLValueObject*/;
		private var _xmlNumLoaded:int = 0;
		private var _totalXmlNum:int = 0;
		
		private var _loadingMode:String;
		
		private var _loading:Boolean = false;
		private var _autoLoad:Boolean;
		
		public function ModelLoader(autoLoad:Boolean = true, loadMode:String = "simultaneous") {
			
			_autoLoad = autoLoad;
			_loadingMode = loadMode;
			
			_xmls = [];
			
		}
		
		public function add(name:String, path:String):void {
			
			var loader:URLLoader = new URLLoader();
			
			var vo:XMLValueObject = new XMLValueObject(name, path, loader);
			
			_totalXmlNum++;
			
			_xmls[_xmls.length] = vo;
			
			if (!_autoLoad) {
				return;
			}
			
			if (_loadingMode == ModelLoaderLoadingType.SIMULTANEOUS) {			
				loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				loader.addEventListener(Event.COMPLETE, _onLoadComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
				loader.load(new URLRequest(path));
			} else {
				if (!_loading) {
					_startNextLoading();
					//_startLoading(vo);
				}
			}
		}
		
		public function load():void {
			if (_loading) {
				return;
			}
			
			_startNextLoading();
		}
		
		//private function _startLoading(vo:XMLValueObject):void {
			//
			//
			//vo.loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			//vo.loader.addEventListener(Event.COMPLETE, _onLoadComplete);
			//vo.loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
			//vo.loader.load(new URLRequest(vo.path));
		//}
		
		private function _onLoadProgress(evt:ProgressEvent):void {
			
			if (_loadingMode == ModelLoaderLoadingType.SIMULTANEOUS) {
				var totalToLoad:int = 0;
				var totalLoaded:int = 0;
				
				for (var i:int = 0; i < _xmls.length; i++) {
					totalLoaded += _xmls[i].loader.bytesLoaded;
					totalToLoad += _xmls[i].loader.bytesTotal;
				}
				
				dispatchEvent(new PercentEvent(PercentEvent.PROGRESS, "unique", (totalLoaded / totalToLoad) * 100));
			} else {
				dispatchEvent(new PercentEvent(PercentEvent.PROGRESS, "multiple", (evt.bytesLoaded / evt.bytesTotal) * 100, _xmlNumLoaded, _xmls.length));
			}
			
		}
		
		private function _onLoadComplete(evt:Event):void {
			
			if (_loadingMode == ModelLoaderLoadingType.SIMULTANEOUS) {
				for (var i:int = 0; i < _xmls.length; i++) {
					if (_xmls[i].loader == evt.currentTarget) {
						dispatchEvent(new ModelLoaderEvent(ModelLoaderEvent.XML_LOADED, _xmls[i].name, XML(_xmls[i].loader.data)));
						_xmlNumLoaded++;
						break;
					}
					
				}
			} else {
				for (var j:int = 0; j < _xmls.length; j++) {
					if (_xmls[j].loader == evt.currentTarget) {
						dispatchEvent(new ModelLoaderEvent(ModelLoaderEvent.XML_LOADED, _xmls[j].name, XML(_xmls[j].loader.data)));
						_xmlNumLoaded++;
						_startNextLoading();
						break;
					}
					
				}
			}
			
			if (_xmlNumLoaded == _totalXmlNum) {
				dispatchEvent(new Event(Event.COMPLETE));
				_loading = false;
			}
			
		}
		
		private function _startNextLoading():void {
			
			if (_xmlNumLoaded >= _xmls.length) {
				return;
			}
			
			_loading = true;
			
			var vo:XMLValueObject = _xmls[_xmlNumLoaded];
			vo.loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			vo.loader.addEventListener(Event.COMPLETE, _onLoadComplete);
			vo.loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
			vo.loader.load(new URLRequest(vo.path));
			
		}
		
		private function _onLoadError(evt:IOErrorEvent):void {
			
		}
		
	}

}

import flash.net.URLLoader;

internal class XMLValueObject {
	
	private var _path:String;
	private var _name:String;
	private var _loader:URLLoader;
	
	public function XMLValueObject(xmlName:String, xmlPath:String, urlLoader:URLLoader):void {
		
		_name = xmlName;
		_path = xmlPath;
		
		_loader = urlLoader;
		
	}
	
	public function get path():String { return _path; }
	
	public function get name():String { return _name; }
	
	public function get loader():URLLoader { return _loader; }
	
}