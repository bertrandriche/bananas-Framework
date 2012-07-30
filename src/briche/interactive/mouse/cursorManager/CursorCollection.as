package briche.interactive.mouse.cursorManager {
	import briche.utils.ArrayUtils;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author b.riché
	 */
	[Event(name = "cursorAdded", type = "briche.interactive.mouse.CursorEvent")]
	
	[Event(name = "cursorRemoved", type = "briche.interactive.mouse.CursorEvent")]
	
	public class CursorCollection extends EventDispatcher {
		
		private var _cursors:Array/*CursorData*/;
		private var _nbCursors:int;
		
		public function CursorCollection() {
			
			_cursors = [];
			_nbCursors = 0;
			
		}
		
		/**
		 * Add a cursor to the Collection.
		 * @param	cursorDisplay			MovieClip		> item containing the cursor display
		 * @param	name					String			> name of the cursor
		 * @param 	moveMode				String			> deplacement type of the cursor. Can be one of the following 
		 * 													  values : CursorMoveMode.AUTO, CursorMoveMode.FREE, 
		 * 													  CursorMoveMode.ONLY_X, CursorMoveMode.ONLY_Y, CursorMoveMode.NONE
		 */
		public function add(cursorDisplay:Sprite, cursorName:String, moveMode:String = "auto"):CursorCollection {
			
			if (getCursorData(cursorName)) {
				var e:Error = new Error();
				e.name = "CursorCollection Error";
				e.message = "A cursor named '" + cursorName + "' already exist. Please use another name";
				throw e;
				return
			}
			
			if (moveMode == CursorMoveMode.AUTO) {
				moveMode = CursorMoveMode.mode;
			}
			
			var data:CursorData = new CursorData(cursorName, cursorDisplay, moveMode);
			
			_cursors[_nbCursors] = data;
			_nbCursors++;
			
			dispatchEvent(new CursorEvent(CursorEvent.CURSOR_ADDED, cursorName));
			
			return this;
		}
		
		/**
		 * Remove the specified cursor from the collection
		 * @param	name				String		> name of the cursor to remove.
		 */
		public function remove(cursorName:String):CursorCollection {
			
			var data:CursorData = getCursorData(cursorName);
			if (!data) {
				var e:Error = new Error();
				e.name = "CursorCollection Error";
				e.message = "No cursor named '" + cursorName + "' has been found. Maybe you've misspelled it or maybe it hasn't been registered";
				throw e;
				return;
			}
			
			dispatchEvent(new CursorEvent(CursorEvent.CURSOR_REMOVED, cursorName));
			
			ArrayUtils.deleteItem(data, _cursors);
			_nbCursors--;
			
			return this;
			
		}
		
		
		public function getCurrentCursor():CursorData {
			for (var i:int = 0; i < _nbCursors; i++) {
				if (_cursors[i].state == CursorData.CURRENT) {
					return _cursors[i];
				}
			}
			return null;
		}
		
		public function getCursorData(cursorName:String):CursorData {
			for (var i:int = 0; i < _nbCursors; i++) {
				if (_cursors[i].name == cursorName) {
					return _cursors[i];
				}
			}
			return null;
		}
		
		public function get cursors():Array/*CursorData*/ {
			return _cursors;
		}
		
		public function get nbCursors():int {
			return _nbCursors;
		}
		
	}

}