package briche.events {
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * bertrand.riche@gmail.com
	 */
	
	import flash.events.Event;
	 
	public class FileLoaderEvent extends Event {
	
		public static const LOAD_START:String = "loadStart";
		public static const COMPLETE:String = "complete";
		//public static const LOAD_PROGRESS:String = "loadProgress";
		public static const ERROR:String = "error";
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////// D E C L A R A T I O N S //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		//...
		private var _path:String;
		private var _content:*;
		
		////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////// P U B L I C //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * CONSTRUCTEUR
		 */
		public function FileLoaderEvent(type:String, path:String, content:* = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_path = path;
			_content = content;
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////// P R I V A T E //
		//////////////////////////////////////////////////////////////////////////////////////////
		
		//...
		
		// la méthode clone doit être surchargée
		public override function clone ():Event {
			return new FileLoaderEvent ( type, _path, _content, bubbles, cancelable )
		}
		
		// la méthode toString doit être surchargée
		public override function toString ():String
		{
			return formatToString("FileLoaderEvent", "type", "_path", "_content", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get path():String { return _path; }
		
		public function get content():* {
			return _content;
		}
		
	}
	
}