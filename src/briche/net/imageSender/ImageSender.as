package briche.net.imageSender {
	
	import com.adobe.images.JPGEncoder;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import mx.utils.Base64Encoder;
	
	/**
	 * ...
	 * @author BRiché
	 */
	
	public class ImageSender extends EventDispatcher {
		
		private var _jpg:JPGEncoder;
		private var _b64:Base64Encoder;
		
		private var _loader:URLLoader;
		
		public function ImageSender() {
			
			_jpg = new JPGEncoder(80);
			_b64 = new Base64Encoder();
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, _onLoadComplete);
			_loader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onLoadError);
		}
		
		
		
		/**
		 * Encode the specified image in JPG and send it to the distant specified server script
		 */
		public function encodeAndSend(image:BitmapData, variables:Object = null):void {
			
			
			var data:ByteArray = _jpg.encode(image);
			_b64.encodeBytes(data, 0, data.length);
			var baseImg:String = _b64.flush();
			
			var sendVariables:URLVariables = new URLVariables();
			sendVariables.img = baseImg;
			if (variables) {
				for (var name:String in variables) {
					sendVariables[name] = variables[name];
				}
			}
			
			var req:URLRequest = new URLRequest(Model.SERVER_PATH + Model.UPLOAD_SCRIPT_NAME);
			req.method = URLRequestMethod.POST;
			req.data = sendVariables;
			
			_loader.load(req);
			
		}
		
		private function _onLoadError(evt:IOErrorEvent):void {
			trace("ImageSender >> ERROR Loading script : " + Model.SERVER_PATH + Model.UPLOAD_SCRIPT_NAME);
			
			dispatchEvent(evt);
		}
		
		private function _onLoadComplete(evt:Event):void {
			trace("ImageSender >> Picture sent !");
			
			dispatchEvent(evt);
		}
		
		private function _onLoadProgress(evt:ProgressEvent):void {
			trace("ImageSender >> Picture upload progress : " + int((evt.bytesLoaded / evt.bytesTotal) * 100));
			
			dispatchEvent(evt);
		}
		
	}

}