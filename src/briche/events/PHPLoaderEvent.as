package briche.events {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	import flash.events.Event;
	
	public class PHPLoaderEvent extends Event {
		
		static public var LOADED:String = "loaded";
		static public var PROGRESS:String = "progress";
		static public var ERROR_LOADING:String = "errorLoading";
		private var _params:Object;
		
		public function PHPLoaderEvent(type:String, params:Object = null, bubbles:Boolean = false, cancelable:Boolean = false):void { 
			super(type, bubbles, cancelable);
			
			_params = params;
		} 
		
		public override function clone():Event { 
			return new PHPLoaderEvent(type, params, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("PHPLoaderEvent", "type", "_params", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get params():Object { return _params; }
		
	}
	
}