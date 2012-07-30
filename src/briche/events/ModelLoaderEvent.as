package briche.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public class ModelLoaderEvent extends Event {
		private var _content:XML;
		private var _xmlName:String;
		
		public static const XML_LOADED:String = "xmlLoaded";
		
		public function ModelLoaderEvent(type:String, xmlName:String, xmlContent:XML, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
			_xmlName = xmlName;
			_content = xmlContent;
		} 
		
		public override function clone():Event { 
			return new ModelLoaderEvent(type, _xmlName, _content, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ModelLoaderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get content():XML { return _content; }
		
		public function get xmlName():String { return _xmlName; }
		
	}
	
}