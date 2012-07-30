package briche.utils.chain {
	/**
	 * ...
	 * @author ...
	 */
	final public class ChainItem {
		
		public var func:Function;
        public var delay:Number = 0;
       
        public function ChainItem(func:Function, delay:Number = 0) {
			
                this.func = func;
                this.delay = delay;
        }
		
	}

}