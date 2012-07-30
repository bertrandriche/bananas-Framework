package briche.net.fileLoader {
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * bertrand.riche@gmail.com
	 */
	
	import briche.events.FileLoaderEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	[Event(name = "loadStart", type = "briche.events.FileLoaderEvent")]
	[Event(name = "complete", type = "briche.events.FileLoaderEvent")]
	[Event(name = "error", type = "briche.events.FileLoaderEvent")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	public class FileLoader extends EventDispatcher {
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////// D E C L A R A T I O N S //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		//...
		private var _url:String;
		private var _contenu:*;
		private var _urlRequest:URLRequest;
		
		private var loader:Loader;
		private var urlLoader:URLLoader;
		
		private var _pourcent:Number;
		// Type de fichier chargé (au format texte ou format binaire)
		private var _type:String;
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////// P U B L I C //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * CONSTRUCTEUR
		 */
		public function FileLoader(url:String, type:String = "") {
			
			_url = url;
			_urlRequest = new URLRequest(_url);
			
			_type = type;
			if (_type == "") {
				// TODO > chercher dans l'url si il y a une extension txt, php, html, etc... ou jpg, png, swf...
				_type = FileLoaderType.TYPE_BINAIRE;
			}
			
			switch(_type) {
				
				case FileLoaderType.TYPE_TEXTE:
					urlLoader = new URLLoader();
					break;
				case FileLoaderType.TYPE_BINAIRE:
					loader = new Loader();
					break;
			}
		}
		
		public function load():void {
			
			switch(_type) {
				case FileLoaderType.TYPE_TEXTE:
					urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					urlLoader.addEventListener(Event.COMPLETE, _onComplete);
					urlLoader.addEventListener(ProgressEvent.PROGRESS, _onUpdate);
					urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					urlLoader.addEventListener(ErrorEvent.ERROR, _onError);
					urlLoader.load(_urlRequest);
					break;
				case FileLoaderType.TYPE_BINAIRE:
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onComplete);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onUpdate);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, _onError);
					loader.load(_urlRequest);
					break;
			}
			
			dispatchEvent(new FileLoaderEvent(FileLoaderEvent.LOAD_START, _url ));
			
		}
		
		private function _onError(e:ErrorEvent):void {
			dispatchEvent(new FileLoaderEvent(FileLoaderEvent.ERROR, _url ));
			
			_removeListeners();
		}
		
		private function _onIOError(e:IOErrorEvent):void {
			
			dispatchEvent(new FileLoaderEvent(FileLoaderEvent.ERROR, _url ));
			
			_removeListeners();
		}
		
		private function _onUpdate(e:ProgressEvent):void {
			_pourcent = int(e.bytesLoaded / e.bytesTotal * 100);
			///dispatchEvent(new FileLoaderEvent(FileLoaderEvent.LOAD_PROGRESS, { pourcent:_pourcent, url:_url } ));
			dispatchEvent(e);
		}
		
		private function _onComplete(e:Event):void {
			
			switch(_type) {
				case FileLoaderType.TYPE_TEXTE:
					_contenu = urlLoader.data;
					break;
				case FileLoaderType.TYPE_BINAIRE:
					_contenu = loader.content as DisplayObject;
					break;
			}
			
			//dispatchEvent(new FileLoaderEvent(FileLoaderEvent.COMPLETE, { content:_content } ));
			dispatchEvent(new FileLoaderEvent(FileLoaderEvent.COMPLETE, _url, _contenu));
			
			_removeListeners();
		}
		
		public function stop():void {
			
			switch(_type) {
				case FileLoaderType.TYPE_TEXTE:
					urlLoader.close();
					break;
				case FileLoaderType.TYPE_BINAIRE:
					loader.unload();
					break;
			}
			
			_removeListeners();
			
		}
		
		
		private function _removeListeners():void {
			switch(_type) {
				case FileLoaderType.TYPE_TEXTE:
					urlLoader.removeEventListener(Event.COMPLETE, _onComplete);
					urlLoader.removeEventListener(ProgressEvent.PROGRESS, _onUpdate);
					urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					urlLoader.removeEventListener(ErrorEvent.ERROR, _onError);
					
					urlLoader = null;
					break;
				case FileLoaderType.TYPE_BINAIRE:
					loader.removeEventListener(Event.COMPLETE, _onComplete);
					loader.removeEventListener(ProgressEvent.PROGRESS, _onUpdate);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
					loader.removeEventListener(ErrorEvent.ERROR, _onError);
					
					loader = null;
					break;
			}
			_urlRequest = null;
		}
		
		public function get pourcent():Number { return _pourcent; }
		
		public function get contenu():* { return _contenu; }
		
		public function get url():String { return _url; }
		
		
	}
	
}