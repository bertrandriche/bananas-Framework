package briche.utils {
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class ArrayUtils {
		
		public static function isInArray(value:*, array:Array, sub:Boolean = true):Boolean {
			
			var total:int = array.length;
			for (var i:int = 0; i < total; i++) {
				if (array[i] == value) {
					return true;
				} else {
					if (sub && array[i] is Array && array[i].length > 0) {
						if (isInArray(value, array[i])) {
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		static public function shuffle(array:Array):Array {
			
			var length:Number = array.length
			var mixed:Array = array.slice();
			var rand:int;
			var el:Object;
			for (var i:int = 0; i < length; i++) {
				el = mixed[i];
				rand = Math.random() * length;
				mixed[i] = mixed[rand];
				mixed[rand] = el;
			}
			return mixed;
		}
		
		static public function count(value:*, array:Array, sub:Boolean = true):int {
			
			var counted:int = 0;
			var total:int = array.length;
			for (var i:int = 0; i < total; i++) {
				if (array[i] == value) {
					counted++;
				} else {
					if (sub && array[i] is Array && array[i].length > 0) {
						counted += count(value, array[i]);
					}
				}
			}
			
			return counted;
		}
		
		static public function deleteItem(target:*, targetArray:Array):void {
			targetArray.splice(targetArray.indexOf(target), 1);
		}
		
		
	}

}