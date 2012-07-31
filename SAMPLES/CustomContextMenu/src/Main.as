package {
	import aze.motion.eaze;
	import briche.display.ui.buttonBar.ButtonBar;
	import briche.display.ui.components.UIButton;
	import briche.interactive.mouse.contextMenu.CustomMenuManager;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author b.riché
	 */
	public class Main extends Sprite {
		
		private var _buttonBar:ButtonBar;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_buttonBar = new ButtonBar();
			addChild(_buttonBar);
			var firstButton:int = _buttonBar.addButton("Right-click me !", _voidFunction, 0, 0, 100);
			var secondButton:int = _buttonBar.addButton("Me too !", _voidFunction, 110, 0, 100);
			
			_buttonBar.x = (stage.stageWidth - _buttonBar.width) >> 1;
			_buttonBar.y = (stage.stageHeight - _buttonBar.height) >> 1;
			
			CustomMenuManager.init();
			CustomMenuManager.addMenu("menu1", _buttonBar.getButton(firstButton), _menu1OpenCallback, _menu1CloseCallback, "My first awesome menu");
			CustomMenuManager.addElementToMenu("menu1", "Other button y = 50", _item1CallBack);
			CustomMenuManager.addElementToMenu("menu1", "Other button y = 0", _item2CallBack, true);
			
			CustomMenuManager.addMenu("menu2", _buttonBar.getButton(secondButton), _menu2OpenCallback, _menu2CloseCallback);
			CustomMenuManager.addElementToMenu("menu2", "Other button y = 50", _item3CallBack, true);
			CustomMenuManager.addElementToMenu("menu2", "Other button y = 0", _item4CallBack);
			
		}
		
		
		private function _menu1CloseCallback():void {
			eaze(_buttonBar.getButtonByIndex(0)).to(0.5).tint(0x009900, 0);
		}
		
		private function _menu1OpenCallback():void {
			eaze(_buttonBar.getButtonByIndex(0)).to(0.5).tint(0x009900, 0.5);
		}
		
		private function _menu2OpenCallback():void {
			eaze(_buttonBar.getButtonByIndex(1)).to(0.5).tint(0x009900, 0.5);
		}
		
		private function _menu2CloseCallback():void {
			eaze(_buttonBar.getButtonByIndex(1)).to(0.5).tint(0x009900, 0);
		}
		
		
		
		private function _item2CallBack():void {
			eaze(_buttonBar.getButtonByIndex(1)).to(0.5, { y:0 } );
		}
		
		private function _item1CallBack():void {
			eaze(_buttonBar.getButtonByIndex(1)).to(0.5, { y:50 } );
		}
		
		private function _item4CallBack():void {
			eaze(_buttonBar.getButtonByIndex(0)).to(0.5, { y:0 } );
		}
		
		private function _item3CallBack():void {
			eaze(_buttonBar.getButtonByIndex(0)).to(0.5, { y:50 } );
		}
		
		
		private function _voidFunction():void {}
		
	}
	
}