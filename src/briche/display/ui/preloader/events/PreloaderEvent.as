package briche.display.ui.preloader.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public class PreloaderEvent extends Event {
		
		static public const SHOW_END:String = "showEnd";
		static public const SHOW_START:String = "showStart";
		static public const HIDE_END:String = "hideEnd";
		static public const HIDE_START:String = "hideStart";
		
		public function PreloaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new PreloaderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PreloaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}