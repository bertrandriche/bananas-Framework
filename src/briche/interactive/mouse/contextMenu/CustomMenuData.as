package briche.interactive.mouse.contextMenu {
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	/**
	 * ...
	 * @author b.riché
	 */
	public class CustomMenuData {
		
		private var _name:String;
		private var _callBack:Function;
		private var _target:InteractiveObject;
		
		private var _numItems:int;
		private var _items:Array/*CustomMenuItem*/;
		private var _menu:ContextMenu;
		private var _itemsCallBacks:Array;
		
		public function CustomMenuData(name:String, target:InteractiveObject, menuOpenCallBack:Function) {
			_target = target;
			_callBack = menuOpenCallBack;
			_name = name;
			
			_items = [];
			_numItems = 0;
			
			_menu = new ContextMenu();
			_menu.hideBuiltInItems();
			_target.contextMenu = _menu;
			_menu.addEventListener(ContextMenuEvent.MENU_SELECT, _onMenuOpen);
			
		}
		
		
		public function addElement(menuLabel:String, callBackFunction:Function, separatorBefore:Boolean):void {
			var item:CustomMenuItem = new CustomMenuItem(menuLabel, callBackFunction, separatorBefore);
			
			_menu.customItems[_numItems] = item.menuItem;
			_items[_numItems] = item;
			_numItems++;
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
				_menu.customItems.splice(0, 1);
				_items.splice(0, 1);
			}
			_items = [];
			_menu.customItems = [];
			_callBack = null;
			_numItems = 0;
			
			_target.contextMenu = null;
			_menu.removeEventListener(ContextMenuEvent.MENU_SELECT, _onMenuOpen);
		}
		
		
		private function _onMenuOpen(e:ContextMenuEvent):void {
			if (_callBack != null) _callBack();
		}
		
		public function get name():String {
			return _name;
		}
		
		public function get menu():ContextMenu {
			return _menu;
		}
		
	}

}