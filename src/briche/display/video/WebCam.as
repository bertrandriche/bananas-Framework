package briche.display.video {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * ...
	 * @author B.Riché
	 */
	public class WebCam extends Sprite {
		
		// Width & height of the camera
		public static var CAM_WIDTH:int = 320;
		public static var CAM_HEIGHT:int = 240;
		
		// The video object to attach the camera to
		private var _video:Video;
		// The camera object
		private var _cam:Camera;
		
		// Bitmap of the last captured image
		private var _capturedImage:Bitmap;
		// Bitmapdata of the last captured image
		private var _lastCapture:BitmapData;
		
		// Name of the current displayed camera
		private var _cameraName:String;
		
		// Specifies wether the debug mode is on or off
		private var _debug:Boolean;
		
		// Used to display the last captured image on the camera video
		private var _lastGhostImg:Bitmap;
		
		
		
		/**
		 * CONSTRUCTOR : creates a new camera object and display it
		 * @param	width			(int) ==> the width of the video
		 * @param	height			(int) ==> the height of the video
		 * @param	framerate		(int) ==> the framerate of the video
		 * @param	debug			(Boolean) ==> specifies wether the debug mode is on (show the captured image) or off (don't)
		 * @param	name			(String) ==> name of the camera to display (use it if there is more than one camera on the computer)
		 */
		public function WebCam(width:int = 320, height:int = 240, framerate:int = 24, debug:Boolean = false, name:String = null) {
			
			_debug = debug;
			_cameraName = name;
			
			_video = new Video(width, height);
			addChild(_video);
			
			//changeCameraByName(_cameraName);
			_cam = Camera.getCamera(name);
			
			WebCam.CAM_WIDTH = width;
			WebCam.CAM_HEIGHT = height;
			
			_cam.setMode(width, height, framerate);
			_video.attachCamera(_cam);
			
			
			_lastCapture = new BitmapData(width, height, true, 0xFFFFFF);
			
			// If debug mode is on
			if (_debug) {
				_capturedImage = new Bitmap(_lastCapture);
				addChild(_capturedImage);
				_capturedImage.y = height + 10;
			}
		}
		
		/**
		 * Capture the current camera picture displayed
		 */
		public function capture():void {
			if (!_lastCapture) {
				_lastCapture = new BitmapData(WebCam.CAM_WIDTH, WebCam.CAM_HEIGHT, true, 0xFFFFFF);
			}
			
			_lastCapture.draw(_video);
		}
		
		/**
		 * Change the displayed camera
		 * @param	name		(String) ==> the name of the camera. If no camera of this name is found, the default camera is used.
		 */
		public function changeCameraByName(name:String = null):void {
			for (var camName:String in Camera.names) {
				if (camName == name) {
					if (_cameraName != camName) {
						_cam = Camera.getCamera(camName);
						_cameraName = camName;
						_video.attachCamera(_cam);
					}
					return;
				}
			}
			_cam = Camera.getCamera();
		}
		
		public function changeCameraByID(id:int = 0):void {
			if (id > Camera.names.length) {
				_cameraName = Camera.names[0];
				_cam = Camera.getCamera(_cameraName);
				_video.attachCamera(_cam);
				return;
			}
			
			_cameraName = Camera.names[id];
			_cam = Camera.getCamera(_cameraName);
			_video.attachCamera(_cam);
		}
		
		
		/**
		 * Show the specified image in front of the current camera image (in ghost mode)
		 * @param	object		(DisplayObject) ==> the object to draw
		 */
		public function showGhostMode(object:DisplayObject, alpha:Number = 0.5, x:int = 0, y:int = 0):void {
			
			if (!_debug) {
				return;
			}
			
			var bmpData:BitmapData = new BitmapData(WebCam.CAM_WIDTH, WebCam.CAM_HEIGHT, false);
			bmpData.draw(object);
			
			if (_lastGhostImg && _lastGhostImg.bitmapData) {
				_lastGhostImg.bitmapData.dispose();
				removeChild(_lastGhostImg);
				_lastGhostImg = null;
			}
			_lastGhostImg = new Bitmap(bmpData);
			addChild(_lastGhostImg);
			_lastGhostImg.x = x;
			_lastGhostImg.y = y;
			_lastGhostImg.alpha = alpha;
		}
		
		
		public function hideGhostMode():void {
			_lastGhostImg.bitmapData.dispose();
			removeChild(_lastGhostImg);
			_lastGhostImg = null;
		}
		
		public function clearLastCapture():void {
			_lastCapture.dispose();
			_lastCapture = null;
		}
		
		
		/**
		 * Return the last captured picture
		 */
		public function get lastCapture():BitmapData { return _lastCapture; }
		
		/**
		 * Used to change the position of the last captured picture bitmap
		 * @param	posX
		 * @param	posY
		 */
		public function moveCapturedImage(posX:int, posY:int):void {
			if (_capturedImage) {
				_capturedImage.x = posX;
				_capturedImage.y = posY;
			}
		}
		
	}

}