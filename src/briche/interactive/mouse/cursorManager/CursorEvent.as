package briche.interactive.mouse.cursorManager {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author b.riché
	 */
	public class CursorEvent extends Event {
		
		private var _name:String;
		
		public static const CURSOR_ADDED:String = "cursorAdded";
		public static const CURSOR_REMOVED:String = "cursorRemoved";
		
		public function CursorEvent(type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
			_name = name;
		} 
		
		public override function clone():Event { 
			return new CursorEvent(type, _name, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("CursorEvent", "_id", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get name():String {
			return _name;
		}
		
	}
	
}