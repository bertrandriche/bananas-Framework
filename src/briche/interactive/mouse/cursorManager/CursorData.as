package briche.interactive.mouse.cursorManager {
	
	import flash.display.Sprite;
	/**
	 * ...
	 * @author b.riché
	 */
	public class CursorData {
		
		public static const HIDDEN:int = 0;
		public static const ON_SCREEN:int = 1;
		public static const FADING:int = 2;
		public static const CURRENT:int = 3;
		
		public var display:Sprite;
		public var name:String;
		public var moveMode:String;
		
		public var state:int = 0;
		public var onScreen:Boolean = false;;
		
		public function CursorData(cursorName:String, cursorDisplay:Sprite, cursorMoveMode:String) {
			name = cursorName;
			display = cursorDisplay;
			moveMode = cursorMoveMode;
		}
		
	}

}