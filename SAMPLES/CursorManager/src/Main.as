package {
	import briche.display.ui.components.UILabel;
	import briche.interactive.mouse.cursorManager.CursorManager;
	import briche.interactive.mouse.cursorManager.CursorManagerReplacement;
	import briche.interactive.mouse.cursorManager.CursorMoveMode;
	import com.bit101.components.Label;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author b.riché
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var lab:Label = new Label(this, 50, 50, "Click to change the cursor type");
			
			var cursorsContainer:Sprite = new Sprite();
			addChild(cursorsContainer);
			
			var cursor1:Sprite = new Sprite();
			cursor1.graphics.lineStyle(3, 0xFF0000);
			cursor1.graphics.moveTo(-10, -10);
			cursor1.graphics.lineTo(-10, 10);
			cursor1.graphics.moveTo(-20, 0);
			cursor1.graphics.lineTo(0, 0);
			cursor1.graphics.endFill();
			
			var cursor2:Sprite = new Sprite();
			cursor2.graphics.lineStyle(3, 0x00FF00);
			cursor2.graphics.moveTo(10, -10);
			cursor2.graphics.lineTo(10, 10);
			cursor2.graphics.moveTo(0, 0);
			cursor2.graphics.lineTo(20, 0);
			cursor2.graphics.endFill();
			
			CursorManager.init(cursorsContainer);
			CursorMoveMode.init(CursorMoveMode.FREE);
			CursorManagerReplacement.init(CursorManagerReplacement.MIXED);
			
			CursorManager.addCursor(cursor1, "cursor1");
			CursorManager.addCursor(cursor2, "cursor2", CursorMoveMode.ONLY_X);
			
			stage.addEventListener(MouseEvent.CLICK, _changeCursor);
			
		}
		
		private function _changeCursor(e:MouseEvent):void {
			if (CursorManager.currentCursorName == "cursor1") {
				CursorManager.showCursor("cursor2");
			} else if (CursorManager.currentCursorName == "cursor2") {
				CursorManager.hideAllCursors(false, true);
			} else {
				CursorManager.showCursor("cursor1");
			}
		}
		
	}
	
}