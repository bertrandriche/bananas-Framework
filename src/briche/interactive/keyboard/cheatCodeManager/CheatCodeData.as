package briche.interactive.keyboard.cheatCodeManager {
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class CheatCodeData {
		
		public var sequence:String;
		public var code:Array;
		public var enabled:Boolean;
		
		public function CheatCodeData(letters:String, lettersCode:Array) {
			
			sequence = letters;
			code = lettersCode;
			enabled = true;
		}
		
	}

}