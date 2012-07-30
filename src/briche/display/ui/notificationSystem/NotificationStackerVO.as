package briche.display.ui.notificationSystem {
	import briche.display.ui.notifications.abstract.Notification;
	import flash.geom.Point;
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class NotificationStackerVO{
		
		public var notification:Notification;
		public var uniqueID:int;
		public var startPosition:Point;
		public var endPosition:Point;
		
		public function NotificationStackerVO(note:Notification, noteId:int) {
			uniqueID = noteId;
			notification = note;
		}
		
	}

}