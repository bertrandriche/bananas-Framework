package briche.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public class PercentEvent extends Event {
		
		private var _percent:int;
		private var _loadingType:String;
		private var _totalXMLToLoad:int;
		private var _loadingXMLOrder:int;
		
		public static const PROGRESS:String = "percentProgress";
		
		public function PercentEvent(type:String, loadingType:String, percent:int, loadingXMLOrder:int = 0, totalXMLToLoad:int = 0, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
			_loadingType = loadingType;
			_percent = percent;
			_loadingXMLOrder = loadingXMLOrder;
			_totalXMLToLoad = totalXMLToLoad;
			
		} 
		
		public override function clone():Event { 
			return new PercentEvent(type, _loadingType, _percent, _loadingXMLOrder, _totalXMLToLoad, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("TransitionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get percent():int { return _percent; }
		
		public function get loadingType():String { return _loadingType; }
		
		public function get totalXMLToLoad():int { return _totalXMLToLoad; }
		
		public function get loadingXMLOrder():int { return _loadingXMLOrder; }
		
	}
	
}