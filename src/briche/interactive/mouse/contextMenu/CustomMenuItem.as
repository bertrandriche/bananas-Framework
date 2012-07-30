package briche.interactive.mouse.contextMenu {
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author b.riché
	 */
	public class CustomMenuItem {
		
		private var _menuItem:ContextMenuItem;
		private var _callBack:Function;
		
		public var label:String;
		
		public function CustomMenuItem(menuLabel:String, callBackFunction:Function, separatorBefore:Boolean) {
			label = menuLabel;
			
			_menuItem = new ContextMenuItem(menuLabel, separatorBefore);
			_menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onItemClick);
			
			_callBack = callBackFunction;
		}
		
		public function destroy():void {
			_menuItem.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onItemClick);
			_callBack = null;
			_menuItem = null;
		}
		
		private function _onItemClick(e:ContextMenuEvent):void {
			_callBack();
		}
		
		public function get menuItem():ContextMenuItem {
			return _menuItem;
		}
		
	}

}