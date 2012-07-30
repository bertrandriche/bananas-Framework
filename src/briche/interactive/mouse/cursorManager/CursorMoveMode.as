package briche.interactive.mouse.cursorManager {
	/**
	 * ...
	 * @author etyyer
	 */
	public class CursorMoveMode {
		
		public static const FREE:String = "free";
		public static const ONLY_X:String = "onlyX";
		public static const ONLY_Y:String = "onlyY";
		public static const NONE:String = "none";
		
		public static const AUTO:String = "auto";
		
		public static var mode:String = "free";
		public static var enabled:Boolean = false;
		
		
		public static function init(moveMode:String = "free"):String {
			enabled = true;
			if (moveMode != AUTO && moveMode != FREE && moveMode != ONLY_X && moveMode != ONLY_Y && moveMode != NONE && moveMode != AUTO) {
				moveMode = AUTO;
			}
			if (moveMode == AUTO) {
				moveMode = FREE;
			}
			
			CursorMoveMode.mode = moveMode;
			
			return CursorMoveMode.mode;
		}
		
	}

}