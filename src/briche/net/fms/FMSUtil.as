package briche.net.fms {
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public class FMSUtil {
		
		private static var _tabUserNames:Array = [];
		private static var _userNamesCount:int = 0;
		private static var _maxUserNames:int = 10;
		
		public static function getRandomUserName(length:int = 10):String {
			
			var name:String = "User" + int(Math.random() * length);
			
			_tabUserNames[_userNamesCount] = { nom:name, random:true };
			_userNamesCount ++;
			
			return name;
		}
		
		
		public static function getUniqueUserName(incremental:Boolean = false, checkWidthRandoms:Boolean = false):String {
			
			while (_userNamesCount >= _maxUserNames) {
				_maxUserNames *= 10;
			}
			
			var name:String;
			
			if (incremental) {
				name = _getNextUniqueName(checkWidthRandoms);
				return name;
			}
			
			
			var same:Boolean = true;
			
			while (same) {
				same = false;
				
				name = "User" + int(Math.random() * _maxUserNames);
				
				boucleNames: for (var i:int = 0; i < _userNamesCount; i++) {
					if (name == _tabUserNames[i].nom) {
						if (checkWidthRandoms || !_tabUserNames[i].random) {
							same = true;
							break boucleNames;
						}
					}
				}
			}
			
			_tabUserNames[_userNamesCount] = { nom:name, random:false };
			_userNamesCount ++;
			
			return name;
		}
		
		private static function _getNextUniqueName(checkWidthRandoms:Boolean):String {
			var name:String;
			
			var same:Boolean = true;
			var tempIndex:int = 0;
			
			while (same) {
				same = false;
				
				boucleNames: for (var i:int = 0; i < _userNamesCount; i++) {
					if ("User" + tempIndex == _tabUserNames[i].nom) {
						if (checkWidthRandoms || !_tabUserNames[i].random) {
							same = true;
							tempIndex ++;
							break boucleNames;
						}
					}
				}
			}
			
			name = "User" + tempIndex;
			
			_tabUserNames[_userNamesCount] = { nom:name, random:false };
			_userNamesCount ++;
			
			return name;
		}
		
		
		public static function getLastUserName():String {
			return _tabUserNames[_userNamesCount - 1].nom;
		}
		
	}

}