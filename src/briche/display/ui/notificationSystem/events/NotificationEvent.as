package briche.display.ui.notificationSystem.events {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	
	import flash.events.Event;
	
	public class NotificationEvent extends Event {
		
		public static const NOTIFICATION_CLOSE:String = "notificationClose";
		
		public function NotificationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new NotificationEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("NotificationEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}