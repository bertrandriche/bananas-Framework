package briche.interactive.keyboard.cheatCodeManager {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	
	import flash.events.Event;
	
	public class CheatCodeManagerEvent extends Event {
		
		static public const CODE_PERFORM:String = "codePerform";
		private var _code:String;
		
		public function CheatCodeManagerEvent(type:String, code:String) { 
			super(type);
			
			_code = code;
			
		} 
		
		public override function clone():Event { 
			return new CheatCodeManagerEvent(type, _code);
		} 
		
		public override function toString():String { 
			return formatToString("CheatCodeManagerEvent", "type", "_code"); 
		}
		
		public function get code():String { return _code; }
		
	}
	
}