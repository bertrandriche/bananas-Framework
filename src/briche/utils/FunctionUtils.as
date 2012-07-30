package briche.utils {
	
	import flash.events.TimerEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class FunctionUtils {
		
		/**
		 * Make a delayed call to a specified function
		 * @param	duree			Number		> delay in seconds
		 * @param	func			Function	> the function to call
		 * @param	params			Array		> an Array of parameters to pass to the function
		 */
		static public function delayedCall(duree:Number, func:Function, params:Array = null):void {
			var timer:Timer = new Timer(duree * 1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,
				function(evt:TimerEvent):void {
					evt.target.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
					func.apply(null, params);
				} , false, 0, false);
			timer.start();
		}
		
		
	}

}