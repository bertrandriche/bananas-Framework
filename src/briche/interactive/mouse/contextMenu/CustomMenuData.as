package briche.interactive.mouse.contextMenu {
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author b.riché
	 */
	public class CustomMenuData {
		
		private var _name:String;
		private var _openCallBack:Function;
		private var _target:InteractiveObject;
		
		private var _numItems:int;
		private var _items:Array/*CustomMenuItem*/;
		private var _menu:ContextMenu;
		private var _itemsCallBacks:Array;
		private var _closeCallBack:Function;
		private var _menuOpen:Boolean = false;
		
		public function CustomMenuData(name:String, target:InteractiveObject, menuOpenCallBack:Function = null, menuCloseCallBack:Function = null) {
			_target = target;
			_openCallBack = menuOpenCallBack;
			_closeCallBack = menuCloseCallBack;
			_name = name;
			
			_items = [];
			_numItems = 0;
			
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			_target.contextMenu = _menu;
			_menu.addEventListener(ContextMenuEvent.MENU_SELECT, _onMenuOpen);
			
		}
		
		
		public function addElement(menuLabel:String, callBackFunction:Function = null, separatorBefore:Boolean = false, deactivated:Boolean = false):void {
			var item:CustomMenuItem = new CustomMenuItem(menuLabel, callBackFunction, separatorBefore, deactivated);
			
			item.addEventListener(CustomMenuEvent.ITEM_SELECT, _onMenuClose);
			
			_menu.customItems[_numItems] = item.menuItem;
			_items[_numItems] = item;
			_numItems++;
		}
		
		private function _onMenuClose(e:CustomMenuEvent = null):void {
			if (_closeCallBack) _closeCallBack();
			
			_menuOpen = false;
		}
		
		public function removeElement(targetElement:String):void {
			
			var foundElements:Array = [];
			var found:Boolean = false;
			
			var item:CustomMenuItem = _getItem(targetElement);
			if (!item) {
				var e:Error = new Error();
				e.name = "CustomContextMenuManager Error";
				e.message = "No element named \"" + targetElement + "\" have been found. Please check the name of the searched element.";
				throw e;
				return;
			} else {
				item.destroy();
				
				for (var i:int = 0; i < _numItems; i++) {
					if (_items[i].label == targetElement) {
						_items[i].removeEventListener(CustomMenuEvent.ITEM_SELECT, _onMenuClose);
						_menu.customItems.splice(i, 1);
						_items.splice(i, 1);
						_numItems--;
						return;
					}
				}
				
			}
			
		}
		
		private function _getItem(itemName:String):CustomMenuItem {
			for (var i:int = 0; i < _numItems; i++) {
				if (_items[i].label == itemName) {
					return _items[i];
				}
			}
			return null;
		}
		
		
		public function destroy():void {
			for (var i:int = 0; i < _numItems; i++) {
				_items[0].destroy();
				_items[0].removeEventListener(CustomMenuEvent.ITEM_SELECT, _onMenuClose);
				_menu.customItems.splice(0, 1);
				_items.splice(0, 1);
			}
			_items = [];
			_menu.customItems = [];
			_openCallBack = null;
			_numItems = 0;
			
			_target.contextMenu = null;
			_menu.removeEventListener(ContextMenuEvent.MENU_SELECT, _onMenuOpen);
		}
		
		
		private function _onMenuOpen(e:ContextMenuEvent):void {
			_menuOpen = true;
			
			if (_openCallBack != null) _openCallBack();
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get menu():ContextMenu {
			return _menu;
		}
		
	}

}