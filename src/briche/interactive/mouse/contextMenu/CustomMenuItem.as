package briche.interactive.mouse.contextMenu {
	
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author b.riché
	 */
	[Event(name = "itemSelect", type = "briche.interactive.mouse.contextMenu.CustomMenuEvent")]
	
	public class CustomMenuItem extends EventDispatcher {
		
		private var _menuItem:ContextMenuItem;
		private var _callBack:Function;
		
		public var label:String;
		
		public function CustomMenuItem(menuLabel:String, callBackFunction:Function = null, separatorBefore:Boolean = false, deactivated:Boolean = false) {
			label = menuLabel;
			
			_menuItem = new ContextMenuItem(menuLabel, separatorBefore, !deactivated);
			_menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onItemClick);
			
			_callBack = callBackFunction;
		}
		
		public function destroy():void {
			_menuItem.removeEventListener(ContextMenuEvent.MENU_ITEM_SELECT, _onItemClick);
			_callBack = null;
			_menuItem = null;
		}
		
		private function _onItemClick(e:ContextMenuEvent):void {
			dispatchEvent(new CustomMenuEvent(CustomMenuEvent.ITEM_SELECT));
			
			if (_callBack) _callBack();
		}
		
		public function get menuItem():ContextMenuItem {
			return _menuItem;
		}
		
	}

}