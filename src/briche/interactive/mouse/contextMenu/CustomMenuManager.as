package briche.interactive.mouse.contextMenu {
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	
	/// TODO > will be obsolete with the support of the right-click in Flash Player with version 11.2
	/// TODO > redo to have real custom menu with version 11.2 of Flash Player
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 *
	 * @name : CUSTOM CONTEXT MENU MANAGER
	 * @version : 1.0
	 * @type : STATIC
	 * @description : Manager pour la création et la gestion de menu contextuels personnalisés. Classe statique, utilisable dans l'ensemble d'un projet.
	 * @usage :
	 * Initialiser le manager avec :
	 * 								CustomMenuManager.init();
	 * Puis ajouter des menus :
	 * 								CustomMenuManager.addMenu(<NOM DU MENU>, <CIBLE>, <CALLBACK FUNCTION ON OPENING>);
	 * Puis ajouter des éléments :
	 * 								CustomMenuManager.addElementToMenu(<NOM MENU>, <LABEL ELEMENT>, <CALLBACK FOR ELEMENT>, <SEPARATOR>);
	 * Pour retirer des éléments d'un menu :
	 * 								CustomMenuManager.removeElementFromMenu(<LABEL ELEMENT>, <NOM MENU>, <MULTIPLES REMOVAL>);
	 * Pour supprimer un menu :
	 * 								CustomMenuManager.removeMenu(<NOM MENU>);
	 * Pour supprimer tous les menus :
	 * 								CustomMenuManager.clearMenus();
	 * @example :
	 * CustomMenuManager.init();
	 * CustomMenuManager.addMenu("nomMenu", displayObjectCible, callbackFunction);
	 * CustomMenuManager.addElementToMenu("nomMenu", "labelElement", callbackFunctionForElement, true);
	 *
	 * CustomMenuManager.removeElementFromMenu("labelElement", "nomMenu", false);
	 * CustomMenuManager.removeMenu("nomMenu");
	 *
	 */
	 
	 
	public class CustomMenuManager extends EventDispatcher {
		
		private static var _menus:Array/*CustomMenuData*/;
		static private var _numMenus:int;
		static private var _willHaveSeparatorBefore:Boolean;
		static private var _container:Sprite;
		
		/**
		 * INITIALISATION DU CUSTOM CONTEXT MENU MANAGER
		 */
		public static function init():void {
			_menus = [];
			_numMenus = 0;
		}
		
		/**
		 * AJOUT D'UN MENU
		 * @param	nom					String				> Menu desired name
		 * @param	cible				InteractiveObject	> DisplayObject target for the menu
		 * @param	menuOpenCallBack	Function			> Function to execute when opening the menu (can be null)
		 */
		public static function addMenu(name:String, target:InteractiveObject, menuOpenCallBack:Function = null, menuCloseCallBack:Function = null, label:String = ""):void {
			
			var data:CustomMenuData = new CustomMenuData(name, target, menuOpenCallBack, menuCloseCallBack);
			
			_menus[_numMenus] = data;
			_numMenus++;
			
			if (label != "") {
				addElementToMenu(name, label, null, false, true);
				_willHaveSeparatorBefore = true;
			}
			
		}
		
		/**
		 * ADD ELEMENT TO SPECIFIED MENU
		 * @param	nomMenu				String		> Name of the menu to add the specified element
		 * @param	menuLabel				String		> Label of the element to add
		 * @param	callBackFunction		Function	> Callback function for the element
		 * @param	separatorBefore		Boolean	> Specifies wether a separator must be added before the element or not
		 * @param	deactivated			Boolean	> If the element must be deactivated or not
		 */
		public static function addElementToMenu(menuName:String, menuLabel:String, callBackFunction:Function = null, separatorBefore:Boolean = false, deactivated:Boolean = false):void {
			
			var data:CustomMenuData = _getMenuData(menuName);
			if (!data) {
				var err:Error = new Error();
				err.name = "CustomMenuManager Error";
				err.message = "There is no ContextMenu named \"" + menuName + "\". Please check the CustomContextMenu names.";
				throw err;
				return;
			}
			
			if (_willHaveSeparatorBefore) {
				separatorBefore = true;
				_willHaveSeparatorBefore = false;
			}
			
			data.addElement(menuLabel, callBackFunction, separatorBefore, deactivated);
			
		}
		
		static private function _getMenuData(menuName:String):CustomMenuData {
			for (var i:int = 0; i < _numMenus; i++) {
				if (_menus[i].name == menuName) {
					return _menus[i];
				}
			}
			return null;
		}
		
		/**
		 * REMOVE ELEMENT FROM A SPECIFIED MENU
		 * @param	element				String	> Label of the element to remove
		 * @param	menuLabel			String	> Name of the menu to search for the specified label. If null, search is
		 * 										  performed in all the registered menus.
		 */
		public static function removeElementFromMenu(targetElement:String, menuLabel:String = null):void {
			var foundElements:Array = [];
			var found:Boolean = false;
			
			if (menuLabel) {
				var data:CustomMenuData = _getMenuData(menuLabel);
				if (!data) return;
				data.removeElement(targetElement);
			} else {
				for each (var item:CustomMenuData in _menus) {
					item.removeElement(targetElement);
				}
			}
			
		
		}
		
		/**
		 * REMOVES A SPECIFIED MENU
		 * @param	menuName			String	> Name of the menu to delete
		 */
		public static function removeMenu(menuName:String):void {
			
			var data:CustomMenuData = _getMenuData(menuName);
			if (!data) {
				var e:Error = new Error();
				e.name = "CustomMenuManager Error";
				e.message = "There is no ContextMenu named \"" + menuName + "\". Please check the CustomContextMenu names.";
				throw e;
				return;
			}
			
			for (var i:int = 0; i < _numMenus; i++) {
				if (_menus[i].name == menuName) {
					data = _menus[i];
					data.destroy();
					_menus.splice(i, 1);
					data = null;
					break;
				}
			}
			
			_numMenus--;
			
		}
		
		/**
		 * CLEARS & DELETE ALL MENUS
		 */
		public static function clearMenus():void {
			
			while (_numMenus > 1) {
				removeMenu(_menus[0].name);
			}
			
		}
	
	}

}