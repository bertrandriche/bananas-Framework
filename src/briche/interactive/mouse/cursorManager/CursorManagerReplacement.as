package briche.interactive.mouse.cursorManager {
	

	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 */
	 
	public class CursorManagerReplacement {
		
		public static const INSTANT:String = "instant";
		public static const NEVER:String = "never";
		public static const AFTER:String = "after";
		static public const MIXED:String = "mixed";
		
		static public const AUTO:String = "auto";
		
		public static var mode:String = "never";
		public static var enabled:Boolean = false;
		
		
		public static function init(replacementMode:String = "auto"):String {
			enabled = true;
			if (replacementMode != AUTO && replacementMode != INSTANT && replacementMode != NEVER &&  replacementMode != AFTER &&  replacementMode != MIXED) {
				replacementMode = AUTO;
			}
			if (replacementMode == AUTO) {
				replacementMode = INSTANT;
			}
			
			CursorManagerReplacement.mode = replacementMode;
			
			return CursorManagerReplacement.mode;
		}
	}
	
}

