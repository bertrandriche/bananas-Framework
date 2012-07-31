package briche.display.ui.buttonBar {
	import briche.display.ui.components.UIButton;
	/**
	 * ...
	 * @author bertrandr@funcom.com
	 */
	public class ButtonBarEntry {
		
		private var _uid:int;
		private var _button:UIButton;
		private var _callback:Function;
		
		public function ButtonBarEntry(id:int, button:UIButton, callback:Function) {
			_uid = id;
			_button = button;
			_callback = callback;
		}
		
		public function get uid():int { return _uid; }
		
		public function get button():UIButton { return _button; }
		
		public function get callback():Function { return _callback; }
		
	}

}