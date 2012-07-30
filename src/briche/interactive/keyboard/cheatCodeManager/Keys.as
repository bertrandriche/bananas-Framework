package briche.interactive.keyboard.cheatCodeManager {
	
	import briche.Logger;
	
	public class Keys {
	
		public static const A : uint = 65;
		public static const B : uint = 66;
		public static const C : uint = 67;
		public static const D : uint = 68;
		public static const E : uint = 69;
		public static const F : uint = 70;
		public static const G : uint = 71;
		public static const H : uint = 72;
		public static const I : uint = 73;
		public static const J : uint = 74;
		public static const K : uint = 75;
		public static const L : uint = 76;
		public static const M : uint = 77;
		public static const N : uint = 78;
		public static const O : uint = 79;
		public static const P : uint = 80;
		public static const Q : uint = 81;
		public static const R : uint = 82;
		public static const S : uint = 83;
		public static const T : uint = 84;
		public static const U : uint = 85;
		public static const V : uint = 86;
		public static const W : uint = 87;
		public static const X : uint = 88;
		public static const Y : uint = 89;
		public static const Z : uint = 90;
		
		public static const ZERO 	: uint = 48;
		public static const ONE 	: uint = 49;
		public static const TWO 	: uint = 50;			 
		public static const THREE 	: uint = 51;
		public static const FOUR 	: uint = 52;
		public static const FIVE 	: uint = 53;
		public static const SIX 	: uint = 54;
		public static const SEVEN 	: uint = 55;
		public static const EIGHT 	: uint = 56;
		public static const NINE 	: uint = 57;
		
		public static const LEFT 	: uint = 37; 
		public static const UP 		: uint = 38;
		public static const RIGHT 	: uint = 39;
		public static const DOWN 	: uint = 40;
		
		public static const SPACE : uint = 32; 
		
		
		
		private static const CODE:Array = [A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,
												ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, SPACE];
		private static var _numCode:int = 37;
		
		private static const CHAR:Array = "abcdefghijklmnopqrstuvwxyz0123456789 ".split("");
		private static var _numChar:int = 37;
		
		public static const KONAMI:Array = [UP,UP,DOWN,DOWN,LEFT,RIGHT,LEFT,RIGHT,B,A];
		
		
		public static function getKeyChar(code:int):String {
			for (var i:int = 0; i < _numCode; i++) {
				if (code == CODE[i]) {
					var char:String = CHAR[i]
					
					return char;
				}
			}
			return "";
		}
		
		public static function getKeyChars(codes:Array):String {
			
			var chars:String = "";
			
			var total:int = codes.length;
			
			for (var i:int = 0; i < total; i++) {
				var curCode:String = codes[i];
				for (var j:int = 0; j < _numChar; j++) {
					if (curCode == CODE[j]) {
						chars += CHAR[j];
					} 
				} 
			}
			return chars;
		}
		
		public static function getKeyCode(char:String):int {
			
			for (var i:int = 0; i < _numChar; i++) {
				if (char == CHAR[i]) {
					var code:int = CODE[i]
					
					return code;
				}
			}
			return -1;
		}
		
		public static function getKeyCodes(str:String):Array {
			
			var chars:Array = str.toLowerCase().split("");
			var codes:Array = [];	
			
			var total:int = chars.length;
			
			for (var i:int = 0; i < total; i++) {
				var curChar:String = chars[i];
				for (var j:int = 0; j < _numChar; j++) {
					if(curChar == CHAR[j]){
						codes.push(CODE[j]);
					} 
				} 
			}
			return codes;
		}
		
	}

}
