package briche.interactive.mouse.contextMenu {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author bertrandr@funcom.com
	 */
	public class CustomMenuEvent extends Event {
		
		public static const ITEM_SELECT:String = "itemSelect";
		
		public function CustomMenuEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new CustomMenuEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("CustomMenuEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}