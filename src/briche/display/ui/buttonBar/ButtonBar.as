package briche.display.ui.buttonBar {
	import briche.display.ui.components.UIButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author bertrandr@funcom.com
	 */
	public class ButtonBar extends Sprite {
		
		private var _buttonsUID:int;
		private var _buttons:Array/*ButtonBarEntry*/;
		private var _numButtons:int;
		
		public function ButtonBar():void {
			
			_buttons = [];
			_numButtons = 0;
			_buttonsUID = -1;
			
		}
		
	/**
	 * Adds a new button to the bar.
	 * @param	buttonLabel			String		> the label to display of the button
	 * @param	buttonCallBack			Function	> the callback function to call when the button is clicked
	 * @param	xPos					int			> the X position of the button in pixels
	 * @param	yPos					int			> the Y position of the button in pixels
	 * @param	width					int			> the width of the button.
	 * @return				int						> the unique ID of the button for a later user
	 */
	public function addButton(buttonLabel:String, buttonCallBack:Function, xPos:int, yPos:int, width:int):int {
		
		_buttonsUID++;
		
		var newButton:UIButton = new UIButton(buttonLabel);
		addChild(newButton);
		
		_buttons[_numButtons] = new ButtonBarEntry(_buttonsUID, newButton, buttonCallBack);
		_numButtons++;
		newButton.x = xPos;
		newButton.y = yPos;
		newButton.width = width;
		
		newButton.addEventListener(MouseEvent.CLICK, _onButtonClicked);
		
		return _buttonsUID;
		
	}
	
	private function _onButtonClicked(e:MouseEvent):void {
		_getButtonData(UIButton(e.currentTarget)).callback();
	}
	
	private function _getButtonData(button:UIButton):ButtonBarEntry {
		for (var i:int = 0; i < _numButtons; i++) {
			if (_buttons[i].button == button) return _buttons[i];
		}
		return null;
	}
	
	
	/**
	 * Retrieves a specific registered button
	 * @param	buttonUID				int		> the unique ID of the button
	 * @return
	 */
	public function getButton(buttonUID:int):UIButton {
		for (var i:int = 0; i < _numButtons; i++) {
			if (_buttons[i].uid == buttonUID) return _buttons[i].button;
		}
		return null;
	}
	
	/**
	 * Retrieves a specific registered button
	 * @param	index				int		> the index of the button in the Array of buttons
	 * @return
	 */
	public function getButtonByIndex(index:int):UIButton {
		return _buttons[index].button;
	}
	
	/**
	 * Removes all the buttons of the bar
	 */
	public function clear():void {
		var oldButton:UIButton;
		
		for (var i:int = 0; i < _numButtons; i++) {
			oldButton = _buttons[0].button;
			oldButton.removeEventListener(MouseEvent.CLICK, _onButtonClicked);
			removeChild(oldButton);
			_buttons.splice(0, 1);
			oldButton = null;
		}
		_buttons = [];
		_numButtons = 0;
	}
		
	}

}