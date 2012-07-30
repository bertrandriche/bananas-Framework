package briche.utils {
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	public class TextUtils {
		
		static private var _upperCase:Array;
		static private var _lowerCase:Array;
		static private var _populated:Boolean = false;
		
		
		
		
		/**
		 * Check if a number need a "0" at the first char
		 * @param	base	Base number
		 * @return	String instance
		*/
		public static function addZero(base:Number):String {
			return (base <= 9) ? "0" + base.toString() : base.toString();
		}
		
		/**
		 * Count words in a string instance 
		 * @param	str	The string to check
		 * @return	Number instance
		*/
		public static function countWords(str:String):Number {
			return str.split(" ").length;
		}
		
		/**
		 * Cut a string at a specified number of words
		 * @param	str	The string to check
		 * @param	cutIndex	Cut position
		 * @return	String instance
		 * @see #hasWords
		*/
		public static function cutAtWords(str:String, cutIndex:int = 0):String {
			var i:int = 0;
			var temp:int = 0;
			var newpos:int = 0;
			
			if (cutIndex >= countWords(str)) return str;
			
			while(i < cutIndex)	{
				temp = str.indexOf(" ", newpos);
				newpos = temp + 1;
				i++;
			}
			
			return str.substring(0, newpos);
		}
		
		
		
		static public function countOccurencesOf(searchString:String, pattern:String):int {
			var startIndex:int = 0;
			var count:int = 0;
			while (searchString.indexOf (pattern, startIndex) != -1) {
				count ++;
				startIndex = searchString.indexOf (pattern, startIndex)
			}			
			return count;
		}
		
		static public function validateEmail(mail:String):Boolean {
			var regExp:RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)++(?:[A-Z]{2}|arpa|biz|name|pro|com|info|net|org|aero|asia|cat|coop|edu|gov|int|jobs|mil|mobi|museum|travel|tel)$/i;			
			return regExp.exec(mail) != null;
		}
		
		static public function containsSpecialChars(str:String):Boolean {
			var regExp:RegExp = /^[A-Z0-9]$/i;
			return regExp.exec(str) != null;
		}
		
		static public function isPhoneValid (phone:String):Boolean {
			var regExp:RegExp = /^06[0-9]{8}$/i;
			return regExp.exec(phone) != null;
		}
		
		static public function isZipCodeValid (zipCode:String):Boolean {
			var regExp:RegExp = /^[0-9]{5}$/i;
			return regExp.exec(zipCode) != null;
		}
		
		static public function replaceSpecialChars(text:String):String {
			if (/[ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝßàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿ]/.test(text)) {
				text = text.replace(/[ÀÁÂÃÄÅ]/g, "A");
				text = text.replace(/[Æ]/g, "AE");
				text = text.replace(/[Ç]/g, "C");
				text = text.replace(/[ÈÉÊË]/g, "E");
				text = text.replace(/[ÌÍÎÏ]/g, "I");
				text = text.replace(/[Ð]/g, "D");
				text = text.replace(/[Ñ]/g, "N");
				text = text.replace(/[ÒÓÔÕÖØ]/g, "O");
				text = text.replace(/[ÙÚÛÜ]/g, "U");
				text = text.replace(/[Ý]/g, "Y");
				text = text.replace(/[ß]/g, "SS");
				text = text.replace(/[àáâãäå]/g, "a");
				text = text.replace(/[æ]/g, "ae");
				text = text.replace(/[ç]/g, "c");
				text = text.replace(/[èéêë]/g, "e");
				text = text.replace(/[ìíîï]/g, "i");
				text = text.replace(/[ñ]/g, "n");
				text = text.replace(/[òóôõöø]/g, "o");
				text = text.replace(/[ùúûü]/g, "u");
				text = text.replace(/[ýÿ]/g, "y");				
			}			
			return text;
		}
		
		static public function removePunctuation(text:String):String {
			if (/[,?;.\/!*"'(){}['\]+&=:-]/.test(text)) {
				text = text.replace(/[,?;.\/!*"'(){}['\]+&=:-]/g, "");			
			}			
			
			return text;
		}
		
		static public function formatMinutesToHours(minutes:int):String {
			var duration:String = "";
			
			var h:int = minutes / 60;
			var m:int = minutes % 60;
			
			duration += (h > 9 ? h : "0" + h) + ":" + (m > 9 ? m : "0" + m);
			
			return duration;
		}
		
		static public function formatSecondsToHours(seconds:int):String {
			var duration:String = "";
			
			var h:int = seconds / 60 / 60;
			var m:int = (seconds / 60) % 60;
			var s:int = seconds % 60;
			
			duration += (h > 9 ? h : "0" + h) + ":" + (m > 9 ? m : "0" + m) + ":" + (s > 9 ? s : "0" + s);
			
			return duration;
		}
		
		static public function putMajsOnWords(label:String):String {
			var words:Array/*String*/ = label.split(" ");
			var total:int = words.length;
			for (var i:int = 0; i < total; i++) {
				words[i] = words[i].substr(0, 1).toUpperCase() + words[i].substr(1, words[i].length - 1)
			}
			
			return words.join(" ");
		}
		
		
		static public function toUpperCase(text:String):String {
			buildSpecialTables();
			
			var lgt:int = _upperCase.length;
			for (var i:int = 0; i < lgt; i++) {
				text = text.replace(new RegExp(_lowerCase[i], "g") , _upperCase);
			}
			return text
		}
		
		static public function toLowerCase(text:String):String {
			buildSpecialTables();
			
			var lgt:int = _lowerCase.length;
			for (var i:int = 0; i < lgt; i++) {
				text = text.replace(new RegExp(_upperCase[i], "g") , _lowerCase);
			}
			return text
		}
		
		static private function buildSpecialTables():void {
			if (_populated) {
				return;
			}
			_populated = true;
			
			_upperCase = [];
			_lowerCase = [];
			addCorrespondCharacter("à", "À");
			addCorrespondCharacter("á", "Á");
			addCorrespondCharacter("â", "Â");
			addCorrespondCharacter("ã", "Ã");
			addCorrespondCharacter("ä", "Ä");
			addCorrespondCharacter("å", "Å");
			addCorrespondCharacter("æ", "Æ");
			addCorrespondCharacter("ç", "Ç");
			addCorrespondCharacter("è", "È");
			addCorrespondCharacter("é", "É");
			addCorrespondCharacter("ê", "Ê");
			addCorrespondCharacter("ë", "Ë");
			addCorrespondCharacter("ì", "Ì");
			addCorrespondCharacter("í", "Í");
			addCorrespondCharacter("î", "Î");
			addCorrespondCharacter("ï", "Ï");
			addCorrespondCharacter("d", "Ð");
			addCorrespondCharacter("ñ", "Ñ");
			addCorrespondCharacter("ò", "Ò");
			addCorrespondCharacter("ó", "Ó");
			addCorrespondCharacter("ô", "Ô");
			addCorrespondCharacter("õ", "Õ");
			addCorrespondCharacter("ö", "Ö");
			addCorrespondCharacter("ø", "Ø");
			addCorrespondCharacter("ù", "Ù");
			addCorrespondCharacter("ú", "Ú");
			addCorrespondCharacter("û", "Û");
			addCorrespondCharacter("ü", "Ü");
			addCorrespondCharacter("ý", "Ý");
			addCorrespondCharacter("ÿ", "Y");			
		}
		
		static private function addCorrespondCharacter(lc:String, uc:String):void {
			var i:int = _lowerCase.length;
			_lowerCase[i] = lc;
			_upperCase[i] = uc;
		}
		
		
	}

}