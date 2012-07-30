package briche.air.splashScreen.events {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	
	import flash.events.Event;
	
	public class SplashScreenEvent extends Event {
		
		static public const SHOW_COMPLETE:String = "showComplete";
		static public const HIDE_COMPLETE:String = "hideComplete";
		
		
		public function SplashScreenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new SplashScreenEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("SplashScreenEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}