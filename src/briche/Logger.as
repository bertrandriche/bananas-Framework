package briche {
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	import com.airlogger.AirLoggerDebug;
	 
	public final class Logger {
		
		static public const DEBUG:String = "debug";
		static public const INFO:String = "info";
		static public const WARN:String = "warn";
		static public const ERROR:String = "error";
		static public const FATAL:String = "fatal";
		
		static public var IS_DEBUG:Boolean = true;
		
		public function Logger() { }
		
		static public function trace(objet:*, type:String = "debug" ):void {
			
			if (!IS_DEBUG) { return; }
			
			switch (type) {
				case "debug":
					AirLoggerDebug.debug(objet);
					break;
				case "info":
					AirLoggerDebug.info(objet);
					break;
				case "warn":
					AirLoggerDebug.warn(objet);
					break;
				case "error":
					AirLoggerDebug.error(objet);
					break;
				case "fatal":
					AirLoggerDebug.fatal(objet);
					break;
				default:
					AirLoggerDebug.debug(objet);
					break;
			}
		}
		
		static public function debug(objet:*):void {
			if (!IS_DEBUG) { return; }
			AirLoggerDebug.debug(objet);
		}
		
		static public function info(objet:*):void {
			if (!IS_DEBUG) { return; }
			AirLoggerDebug.info(objet);
		}
		
		static public function warn(objet:*):void {
			if (!IS_DEBUG) { return; }
			AirLoggerDebug.warn(objet);
		}
		
		static public function error(objet:*):void {
			if (!IS_DEBUG) { return; }
			AirLoggerDebug.error(objet);
		}
		
		static public function fatal(objet:*):void {
			if (!IS_DEBUG) { return; }
			AirLoggerDebug.fatal(objet);
		}
		
		static private function _returnTracingString(objet:*, ... rest):String {
			var string:String = objet.toString() + " ";
			
			for(var i:uint = 0; i < rest.length; i++) {
				string += rest[i] + " ";
			}
			
			return string;
		}
		
	}
	
}