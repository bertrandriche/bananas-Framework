package briche.interactive.mouse.cursorManager {
	
	import aze.motion.eaze;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 * 
	 * @name : CURSOR MANAGER
	 * @version : 1.0
	 * @type : STATIC
	 * @description : Manager for personalized cursor displaying. Static class.
	 * @usage :
	 * Initialize the class with : CursorManager.init(...);
	 * Then add cursors : CursorManager.addCursor(...);
	 * And finally show the desired cursor : CursorManager.showCursor(...);
	 * 
	 * To hide a cursor : CursorManager.hideCursor(...);
	 * To remove a cursor : CursorManager.removeCursor(...);
	 * @example :
	 * CursorManager.init(stage);
	 * CursorManager.addCursor(new LibCursor(), "cursor01");
	 * CursorManager.showCursor("cursor01");
	 * 
	 * CursorManager.hideCursor("cursor01");
	 * CursorManager.removeCursor("cursor01");
	 * 
	 * @associatedClasses :
	 * CursorMoveMode to specify the deplacement mode of each cursor.
	 * CursorManagerReplacement to specify the replacement mode of cursors (for transitions when switching from one to another)
	 */
	
	 
	 
	public class CursorManager {
		
		static private var _container:DisplayObjectContainer;
		static private var _animationLength:Number;
		static private var _cursorOn:Boolean = false;
		static private var _followMouse:Boolean = false;
		static private var _replaceMouse:Boolean = false;
		
		static private var _collection:CursorCollection;
		
		/**
		 * Initialization of the CursorManager class.
		 * @param	cursorsContainer		Sprite			> container in which the added cursors will be addChilded
		 * @param	doesReplaceMouse		Boolean			> specifies if showing a cursor must hide the mouse or not.
		 * @param	doesFollowMouse			Boolean			> specifies wether the class automates the cursors 
		 * 													  movements or if the render function must be called manually.
		 * @param	animationLength			Number			> duration of the animations whel replacing visible cursor
		 */
		static public function init(cursorsContainer:DisplayObjectContainer, doesReplaceMouse:Boolean = true, doesFollowMouse:Boolean = true, animationLength:Number = 0.3):void {
			_container = cursorsContainer;
			_container.mouseChildren = false;
			_container.mouseEnabled = false;
			
			_animationLength = animationLength;
			_followMouse = doesFollowMouse;
			_replaceMouse = doesReplaceMouse;
			
			_collection = new CursorCollection();
			_collection.addEventListener(CursorEvent.CURSOR_ADDED, _onNewCursorRegistered);
			_collection.addEventListener(CursorEvent.CURSOR_REMOVED, _onCursorDeleted);
			
		}
		
		/**
		 * Add a cursor to the manager.
		 * @param	cursorDisplay			MovieClip		> item containing the cursor display
		 * @param	name					String			> name of the cursor
		 * @param 	moveMode				String			> deplacement type of the cursor. Can be one of the following 
		 * 													  values : CursorMoveMode.AUTO, CursorMoveMode.FREE, 
		 * 													  CursorMoveMode.ONLY_X, CursorMoveMode.ONLY_Y, CursorMoveMode.NONE
		 */
		static public function addCursor(cursorDisplay:Sprite, cursorName:String, moveMode:String = "auto"):void {
			_collection.add(cursorDisplay, cursorName, moveMode);
		}
		
		/**
		 * Remove the specified cursor from the manager
		 * @param	name				String		> name of the cursor to remove.
		 */
		static public function removeCursor(cursorName:String):void {
			_collection.remove(cursorName);
		}
		
		
		/**
		 * Show the specified cursor.
		 * @param	name				String 		> name of the cursor to show
		 * @param	instant				Boolean		> used to overwrite the apparition animation specified in 
		 * 											  CursorManagerReplacement. If true, all animations will be skipped and the 
		 * 											  cursor will just replace the current one (if existing)
		 * @param	params				Object		> additionals & optional parameters. Can be one of the following parameters: x or y for starting position, replace for overwriting default replacement behavior (see CursorManagerReplacement for valid values)
		 */
		static public function showCursor(cursorName:String, instant:Boolean = false, params:Object = null):void {
			
			var newCursor:CursorData = _collection.getCursorData(cursorName);
			if (!newCursor) {
				var e:Error = new Error();
				e.name = "CursorManager Error";
				e.message = "No cursor named '" + cursorName + "' has been found. Maybe you've misspelled, hasn't been registered or already removed from the _collection.";
				throw e;
			}
			if (newCursor.onScreen) return;
			
			if (!params) {
				params = { };
			}
			
			_cursorOn = true;
			var oldCursor:CursorData = _collection.getCurrentCursor();
			
			var mode:String;
			// Si un curseur est déjà affiché, on choisit ce qu'on va faire selon le replacement mode choisi
			if (oldCursor) {
				if (!params.replace && !CursorManagerReplacement.enabled) {
					return;
				} else if (params.replace) {
					if (params.replace == CursorManagerReplacement.NEVER) {
						return;
					} else if (params.replace == CursorManagerReplacement.INSTANT || params.replace == CursorManagerReplacement.AFTER || params.replace == CursorManagerReplacement.MIXED) {
						mode = params.replace;
					}
				} else {
					if (CursorManagerReplacement.enabled) {
						if (CursorManagerReplacement.mode == CursorManagerReplacement.NEVER) {
							return;
						} else if (CursorManagerReplacement.mode == CursorManagerReplacement.INSTANT || CursorManagerReplacement.mode == CursorManagerReplacement.AFTER || CursorManagerReplacement.mode == CursorManagerReplacement.MIXED) {
							mode = CursorManagerReplacement.mode;
						}
					}
				}
			}
			
			var delay:Number = 0;
			if (mode == CursorManagerReplacement.INSTANT || instant) {
				_removeFromScreen(oldCursor);
			} else if (mode == CursorManagerReplacement.AFTER || mode == CursorManagerReplacement.MIXED) {
				if (mode == CursorManagerReplacement.AFTER) {
					delay = _animationLength;
				} else {
					delay = 0;
				}
				oldCursor.state = CursorData.FADING;
				eaze(oldCursor.display).to(_animationLength, { alpha:0 } ).onComplete(_removeFromScreen, oldCursor);
			}
			
			if (newCursor) {
				newCursor.state = CursorData.CURRENT;
				newCursor.onScreen = true;
				
				if (params.x) {
					newCursor.display.x = params.x;
				} else {
					newCursor.display.x = _container.mouseX;
				}
				if (params.y) {
					newCursor.display.y = params.y;
				} else {
					newCursor.display.y = _container.mouseY;
				}
				if (instant) {
					newCursor.display.visible = true;
					newCursor.display.alpha = 1;
				} else {
					eaze(newCursor.display).delay(delay).to(_animationLength, { alpha:1 } );
				}
				
				if (_followMouse) {
					_container.addEventListener(Event.ENTER_FRAME, _followCursor);
				}
				
			}
			
			if (_replaceMouse) Mouse.hide();
		}
		
		/**
		 * Hide the specified cursor
		 * @param	name					String		> the name of the target cursor to hide
		 * @param	instant					Boolean		> used to overwrite the disparition animation. If true, any hiding 
		 * 												  animation will be skipped.
		 * @param	mouse					Boolean		> specifies if the mouse must be shown after the cursor have been hidden.
		 */
		static public function hideCursor(cursorName:String, instant:Boolean = false, mouse:Boolean = false):void {
			
			var data:CursorData = _collection.getCursorData(cursorName);
			
			if (!data) {
				var e:Error = new Error();
				e.name = "CursorManager Error";
				e.message = "No cursor named '" + cursorName + "' has been found. Maybe you've misspelled, hasn't been registered or already removed from the _collection.";
				throw e;
				return;
			}
			if (!_collection.getCurrentCursor()) return;
			
			data.state = CursorData.FADING;
			
			var mode:String;
			if (instant) {
				mode = CursorManagerReplacement.INSTANT;
			} else {
				if (CursorManagerReplacement.mode == CursorManagerReplacement.AFTER || CursorManagerReplacement.mode == CursorManagerReplacement.MIXED) {
					mode = CursorManagerReplacement.mode;
				} else {
					mode = CursorManagerReplacement.INSTANT;
				}
			}
			
			if (mode == CursorManagerReplacement.INSTANT) {
				_removeFromScreen(data);
				if (_replaceMouse && mouse) Mouse.show();
			} else {
				eaze(data.display).to(_animationLength, { alpha:0 } ).onComplete(_removeFromScreen, data);
			}
			
		}
		
		/**
		 * Hides all cursors
		 * @param	instant					Boolean		> used to overwrite the disparition animation. If true, any hiding 
		 * 												  animation will be skipped.
		 * @param	mouse					Boolean		> specifies if the mouse must be shown after the cursor have been hidden.
		 */
		static public function hideAllCursors(instant:Boolean = true, mouse:Boolean = false):void {
			_cursorOn = false;
			
			var mode:String;
			if (instant) {
				mode = CursorManagerReplacement.INSTANT;
			} else {
				if (CursorManagerReplacement.mode == CursorManagerReplacement.AFTER || CursorManagerReplacement.mode == CursorManagerReplacement.MIXED) {
					mode = CursorManagerReplacement.mode;
				} else {
					mode = CursorManagerReplacement.INSTANT;
				}
			}
			
			for each (var data:CursorData in _collection.cursors) {
				if (data.onScreen) {
					data.state = CursorData.FADING;
					if (mode == CursorManagerReplacement.INSTANT) {
						_removeFromScreen(data);
					} else {
						eaze(data.display).to(_animationLength, { alpha:0 } ).onComplete(_removeFromScreen, data);
					}
				}
			}
			if (_replaceMouse && instant && mouse) Mouse.show();
		}
		
		/**
		 * Made to manually render the on-screen cursors positions. Must be called each time you want the positions to refresh 
		 * if the doesFollowMouse parameter is set to false. 
		 */
		static public function render():void {
			_followCursor();
		}
		
		/**
		 * Indicates if a cursor is on screen or not.
		 */
		static public function get hasCursorOn():Boolean { return _cursorOn; }
		
		/**
		 * Returns the current cursor name.
		 */
		static public function get currentCursorName():String { 
			var data:CursorData = _collection.getCurrentCursor();
			if (data) return data.name;
			return ""; 
		}
		
		/**
		 * Indicates if the cursors automatically follow the mouse position or if the render function must be call manually.
		 */
		static public function get followMouse():Boolean {
			return _followMouse;
		}
		
		/**
		 * Sets the position of the specified cursor to the specified x and y values.
		 * @param	name			String 		> name of the cursor to move
		 * @param	x				int 		> x value to position the cursor
		 * @param	y				int 		> y value to position the cursor
		 */
		static public function moveCursor(name:String, x:int, y:int):void {
			var data:CursorData = _collection.getCursorData(name);
			if (!data) return;
			
			data.display.x = x;
			data.display.y = y;
		}
		
		
		
		
		/**
		 * For the cursors auto-mouse following, in case of the CursorManager.followMouse is enabled
		 * @param	evt
		 */
		static private function _followCursor(evt:Event = null):void {
			
			for each (var data:CursorData in _collection.cursors) {
				if (data.onScreen) {
					if (data.moveMode == CursorMoveMode.NONE) {
						return;
					} else if (data.moveMode == CursorMoveMode.ONLY_X) {
						data.display.x += (_container.mouseX - data.display.x) * 0.5;
						return;
					} else if (data.moveMode == CursorMoveMode.ONLY_Y) {
						data.display.y += (_container.mouseY - data.display.y) * 0.5;
						return;
					}
					
					data.display.x += (_container.mouseX - data.display.x) * 0.5;
					data.display.y += (_container.mouseY - data.display.y) * 0.5;
				}
			}
			
		}
		
		
		static private function _removeFromScreen(data:CursorData):void {
			if (!data) return;
			
			data.onScreen = false;
			data.state = CursorData.HIDDEN;
			data.display.visible = false;
			if (_cursorOn) {
				return;
			}
			
			if (_followMouse) _container.removeEventListener(Event.ENTER_FRAME, _followCursor);
			if (_replaceMouse) Mouse.show();
		}
		
		/**********************************************************************
		 ********************** COLLECTION MANAGEMENT *************************
		 *********************************************************************/
		
		static private function _onNewCursorRegistered(e:CursorEvent):void {
			_registerNewCursor(e.name);
		}
		
		static private function _registerNewCursor(cursorName:String):void {
			var data:CursorData = _collection.getCursorData(cursorName);
			
			_container.addChild(data.display);
			data.display.mouseEnabled = false;
			data.display.mouseChildren = false;
			data.display.visible = false;
			data.display.alpha = 0;
		}
		
		static private function _onCursorDeleted(e:CursorEvent):void {
			var data:CursorData = _collection.getCursorData(e.name);
			if (data.onScreen) {
				hideAllCursors(true, true);
			}
		}
		
	}
	
}