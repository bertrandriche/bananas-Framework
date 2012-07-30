package briche.utils.chain {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
   
	/**
	 * Delayed function-call helper class
	*/
   
	// Dispatched when the chain finishes playing / reaches last item
	[Event(name="complete", type="flash.events.Event")]
	 
	final public class Chain extends EventDispatcher {
		
		private const _list:/*ChainItem*/Array = [];
		private var _currentIndex:int = 0;
		private var _currentRepeatIndex:int = 0;
		private var _repeatCount:int = 0;
		private var _reversed:Boolean = false;
		private var _isPlaying:Boolean = false;
		private var _timer:Timer;
	   
		
		//---------------------------------------------------------------------
		//----------------------------- PUBLIC --------------------------------
		//---------------------------------------------------------------------
	   
		/**
		 * CONSTRUCTOR
		 */
		public function Chain() {
			_timer = new Timer(0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
	   
		/**
		 * Add a function at a specified interval
		 * @param func		(Function) ==> Function to call
		 * @param delay		(Number) ==> The delay before calling the function, in milliseconds
		 * @return	this		(Chain) ==> this
		 */
		public function add(func:Function, delay:Number = 0):Chain {
			_list.push(new ChainItem(func, delay));
		   
			return this;
		}
		
		/**
		 * Removes a specified function
		 * @param func		Function	> Function to remove
		 * @param all		Boolean		> Specifies if all occurences of the function must be removed (true) or just the first one (false)
		 * @return	this	Chain		> this
		 */
		public function remove(func:Function, all:Boolean = false):Chain {
			for (var i:int = 0; i < _list.length; i++) {
				if (func == _list[i].func) {
					var obj:ChainItem = _list[i];
					_list.splice(i, 1);
					obj = null;
					if (!all) {
						break;
					}
				}
			}
		   
			return this;
		}
		
		/**
		 * Start playing the sequence
		 * @param	repeatCount		int		> The number of repetitions of the sequence
		 */
		public function play(repeatCount:int = 1):void {
			_reversed = false;
			_repeatCount = repeatCount;
		   
			if (_list.length > 0) {
				reset();
			   
				_isPlaying = true;
				_timer.delay = _list[0].delay;
				_timer.repeatCount = 0;
				_timer.start();
			}
		}
	    
		/**
		 * Start playing the sequence reversed
		 * @param	repeatCount		int		> The number of repetitions of the sequence
		 */
		public function playReversed(repeatCount:int = 1):void {
			_reversed = true;
			_repeatCount = repeatCount;
		   
			if (_list.length > 0) {
				reset();
			   
				_isPlaying = true;
				_timer.delay = _list[_list.length - 1].delay;
				_timer.repeatCount = 0;
				_timer.start();
			}
		}
	   
		/**
		 * Stop playing the chain. Use doContinue to play the next function from the current point
		 */
		public function stop():void {
			_timer.stop();
			_isPlaying = false;
		}
	    
		/**
		 * Continue playing after a stop
		 * @return	this		Chain	> this
		 */
		public function doContinue():Chain {
			if (!_isPlaying) {
				_timer.start();
				_isPlaying = true;
			}
			return this;
		}
	   
		/**
		 * Reset indexes
		 */
		public function reset():void {
			if (!_reversed) {
				_currentIndex = 0;
			} else {
				_currentIndex = _list.length - 1;
			}
			
			_currentRepeatIndex = 0;
		}
		
		/**
		 * Clears sequence list. Data will be removed
		 * @return	this		Chain	> this
		 */
		public function clear():Chain {
			var i:int = 0;
		   
			for (i = 0; i < _list.length; ++i) {
				var obj:ChainItem = _list[i];
				obj = null;
			}
		   
			_list.splice(0);
		   
			reset();
			
			return this;
		}
	   
		/**
		 * Returns the string representation of the Chain private vars
		 * @return	retval		String	> Representation of the Chain private vars
		 */
		public override function toString():String {
			var retval:String = "_currentRepeatIndex:" + _currentRepeatIndex + ", _currentIndex:" + _currentIndex + ", _reversed:" + _reversed + ", _repeatCount:" + _repeatCount + ", loop length:" + _list.length;
			return retval;
		}
		
		/**
		 * Return if chain is playing, stopped or completed
		 */
		public function get isPlaying():Boolean { return _isPlaying }
		
		
		//---------------------------------------------------------------------
		//---------------------------- PRIVATE --------------------------------
		//---------------------------------------------------------------------
		
		/**
		 * Execute the current function
		 * @param index			int		> the index of the item to call
		 */
		protected function execute(index:int):void {
			_timer.stop();
            
			var obj:ChainItem = _list[index];
			if (obj.func != null) {
				obj.func();
			}
		}
	    
		/**
		 * Launch the delay timer for the next item
		 * @param	index		int		> the index of the next element
		 */
		protected function launchNewTimer(index:int):void {
			var obj:ChainItem = _list[index];
			if (_isPlaying) {
				_timer.delay = obj.delay;
				_timer.repeatCount = 0;
				_timer.start();
			}
		}
		
		/**
		 * End of the chain, dispatching a COMPLETE event
		 */
		protected function dispatchComplete():void {
			_isPlaying = false;
			dispatchEvent( new Event( Event.COMPLETE, false, false) );
		}
	   
		/**
		 * End of the timer, check if there is a function to call after or if the chain must be restarted
		 * @param	e
		 */
		protected function onTimer(e:TimerEvent):void {
			
			_timer.stop();
			
			execute(_currentIndex);
			
			if (!_reversed) {
				_currentIndex ++;
				if (_currentIndex >= _list.length) {
					if (_currentRepeatIndex < _repeatCount - 1) {
						_currentRepeatIndex++;
						_currentIndex = 0;
						launchNewTimer(_currentIndex);
					} else {
						dispatchComplete();
					}
				} else {
					launchNewTimer(_currentIndex);
				}
			} else {
				_currentIndex --;
				if (_currentIndex < 0) {
					if (_currentRepeatIndex < _repeatCount - 1) {
						_currentRepeatIndex++;
						_currentIndex = _list.length - 1;
						launchNewTimer(_currentIndex);
					} else {
						dispatchComplete();
					}
				} else {
					launchNewTimer(_currentIndex);
				}
			}
		}

	}

}
