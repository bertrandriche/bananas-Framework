package briche.events {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	import flash.events.Event;
	
	public class FMSConnectionManagerEvent extends Event {
		
		static public const FMS_CONNEXION_DONE:String = "fmsConnexionDone";
		static public const FMS_CONNEXION_LOST:String = "fmsConnexionLost";
		
		static public const CLIENT_CONNECT:String = "clientConnect";
		static public const CLIENT_LEAVE:String = "clientLeave";
		
		static public const SO_CONNEXION_DONE:String = "soConnexionDone";
		static public const SO_CHANGE:String = "soChange";
		static public const SO_MODIFICATION_SUCCESS:String = "soModificationSuccess";
		static public const SO_MODIFICATION_FAIL:String = "soModificationFail";
		private var _code:String;
		
		public function FMSConnectionManagerEvent(type:String, code:String) { 
			super(type);
			
			_code = code;
			
		} 
		
		public override function clone():Event { 
			return new FMSConnectionManagerEvent(type, _code);
		} 
		
		public override function toString():String { 
			return formatToString("FMSConnectionManagerEvent", "type", "_code"); 
		}
		
		public function get code():String { return _code; }
		
	}
	
}