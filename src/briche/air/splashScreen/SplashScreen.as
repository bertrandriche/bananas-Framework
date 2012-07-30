package briche.air.splashScreen {
	
	import aze.motion.eaze;
	import briche.air.splashScreen.events.SplashScreenEvent;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	
	 [Event(name="showComplete", type="briche.air.splashScreen.events.SplashScreenEvent")]
	[Event(name="hideComplete", type="briche.air.splashScreen.events.SplashScreenEvent")]
	 
	public class SplashScreen extends NativeWindow {
		
		private const SPLASH_ANIMATION_DURATION:int = 5;
		
		private var _splashLib:DisplayObject;
		private var _splashContainer:Sprite;
		
		
		private var _type:String;
		private var timerHide:Timer;
		private var _duration:Number;
		
		/**
		 * CONSTRUCTEUR ==> crée un écran d'accueil pour l'application
		 * @param	content				DisplayObject > the content to display
		 * @param	type				String > type of the splashscreen (AUTO / MANUAL / USER DRIVER)
		 * @param	dureeApparition		Number > apparition duration of the splash scrren, only for an SplashScreenType.AUTO type
		 */
		public function SplashScreen(content:DisplayObject, type:String = "auto", dureeApparition:Number = 5) {
			
			if (type == SplashScreenType.AUTO || type == SplashScreenType.MANUAL || type == SplashScreenType.USER_DRIVEN) {
				_type = type;
			} else {
				_type = SplashScreenType.AUTO;
			}
			_duration = dureeApparition;
			
			var splashWindowinitOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			splashWindowinitOptions.transparent = true;
			splashWindowinitOptions.systemChrome = NativeWindowSystemChrome.NONE;
			splashWindowinitOptions.type = NativeWindowType.UTILITY;
			
			super(splashWindowinitOptions);
			this.alwaysInFront = true;
			
			_splashLib = content;
			
		 
			_splashContainer = new Sprite();
			_splashContainer.addChild(_splashLib);
			_splashContainer.x = _splashLib.width >> 1;
			_splashContainer.y = _splashLib.height >> 1;
			_splashContainer.alpha = 0;
			
			_splashLib.x = - _splashLib.width >> 1;
			_splashLib.y = - _splashLib.height >> 1;
			
			this.stage.scaleMode = 'noScale';
			this.stage.align = 'topLeft';
			
			switch(_type) {
				case SplashScreenType.AUTO:
					_splashContainer.scaleX = 0.95;
					_splashContainer.scaleY = 0.95;
					break;
				case SplashScreenType.MANUAL:
					break;
				case SplashScreenType.USER_DRIVEN:
					break;
			}
			
			this.x = (Screen.mainScreen.visibleBounds.width - _splashContainer.width) >> 1;
			this.y = (Screen.mainScreen.visibleBounds.height - _splashContainer.height) >> 1;
			this.activate();
			
		}
		
		/**
		 * Show the splash screen
		 */
		public function show():void {
			
			if (_type == SplashScreenType.AUTO) {
				eaze(_splashContainer).to(SPLASH_ANIMATION_DURATION, { alpha:1 } ).onComplete(_onOpenComplete);
				eaze(_splashContainer).to(SPLASH_ANIMATION_DURATION * 2 + _duration, { scale:1 }, false);
			} else {
				eaze(_splashContainer).to(SPLASH_ANIMATION_DURATION, { alpha:1 } ).onComplete(_onOpenComplete);
			}
			this.stage.addChild(_splashContainer);
		}
		
		private function _onOpenComplete():void {
			dispatchEvent(new SplashScreenEvent(SplashScreenEvent.SHOW_COMPLETE));
			
			switch(_type) {
				case SplashScreenType.AUTO:
					timerHide = new Timer(_duration * 1000, 1);
					timerHide.addEventListener(TimerEvent.TIMER_COMPLETE, _endTimerHide);
					timerHide.start();
					break;
				case SplashScreenType.MANUAL:
					break;
				case SplashScreenType.USER_DRIVEN:
					_splashLib.addEventListener(MouseEvent.CLICK, _onSplashClick);
					break;
			}
		}
		
		private function _onSplashClick(evt:MouseEvent):void {
			hide();
		}
		
		/**
		 * For the AUTO mode, this method is called when the TIMER_END event is fired.
		 * @param	evt
		 */
		private function _endTimerHide(evt:TimerEvent):void {
			timerHide.removeEventListener(TimerEvent.TIMER_COMPLETE, _endTimerHide);
			hide();
		}
		
		/**
		 * Hides the splash screen
		 */
		public function hide():void {
			eaze(_splashContainer).to(SPLASH_ANIMATION_DURATION, { alpha:0 }, false ).onComplete(_onHideComplete);
		}
		
		private function _onHideComplete():void{
			dispatchEvent(new SplashScreenEvent(SplashScreenEvent.HIDE_COMPLETE));
			
			this.close();
		}
		
	}
	
}