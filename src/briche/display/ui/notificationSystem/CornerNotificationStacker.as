package briche.display.ui.notificationSystem {
	
	import briche.display.ui.notificationSystem.abstract.Notification;
	import briche.display.ui.notificationSystem.events.NotificationEvent;
	import com.airlogger.AirLoggerDebug;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand@grouek.com
	 */
	public class CornerNotificationStacker extends EventDispatcher {
		
		static private var _instance:CornerNotificationStacker;
		
		private var _initialized:Boolean = false;
		
		private var _stackArray:Array/*Array*/;
		
		private var _container:DisplayObjectContainer;
		private var _containerBaseHeight:int;
		
		private var _verticalPosition:String;
		private var _horizontalPosition:String;
		
		private var _padding:int;
		private var _currentStackCount:int;
		private var _currentRowsCount:int;
		
		private var _maxPreviousWidth:int;
		private var _maxPreviousHeight:int;
		private var _notificationsCount:int;
		
		public function CornerNotificationStacker(blocker:SingletonBlocker) {
			if(blocker == null){
                trace("Error : Instantiation failed ! Use MultiFileLoader.getInstance() instead of new.");
            }
		}
		
		public static function getInstance():CornerNotificationStacker {
			if (!_instance) {
				_instance = new CornerNotificationStacker(new SingletonBlocker());
			}
			
			return _instance;
		}
		
		public function init(container:DisplayObjectContainer, horizontalPosition:String = "right", verticalPosition:String = "bottom", notificationsPadding:int = 5):void {
			if (_initialized) {
				return;
			}
			
			_initialized = true;
			
			// CHECKING RIGHT POSITION TYPES
			if (horizontalPosition != NotificationStackerModel.STACK_POSITION_LEFT && horizontalPosition != NotificationStackerModel.STACK_POSITION_RIGHT) {
				horizontalPosition = NotificationStackerModel.STACK_POSITION_RIGHT;
			}
			_horizontalPosition = horizontalPosition;
			if (verticalPosition != NotificationStackerModel.STACK_POSITION_BOTTOM && verticalPosition != NotificationStackerModel.STACK_POSITION_TOP) {
				verticalPosition = NotificationStackerModel.STACK_POSITION_BOTTOM;
			}
			_verticalPosition = verticalPosition;
			
			_container = container;
			_containerBaseHeight = _container.height;
			_padding = notificationsPadding;
			
			_notificationsCount = 0;
			
			_stackArray = [];
			_stackArray[0] = [];
			_currentStackCount = 0;
			_currentRowsCount = 0;
			
			_maxPreviousWidth = _padding;
			_maxPreviousHeight = 0;
			
		}
		
		/* ********************************************************************
		 * ********************************************************************
		 * ADDING
		 * ********************************************************************
		 * *******************************************************************/
		
		public function addNotification(note:Notification):void {
			if (!_initialized) {
				return;
			}
			
			_container.addChild(note);
			note.addEventListener(NotificationEvent.NOTIFICATION_CLOSE, _onNoteClose);
			
			_notificationsCount ++;
			
			var freespace:Array = _checkFreeSpace();
			var col:int = freespace[0];
			var line:int = freespace[1];
			
			var positions:Point = _getPosition(col, line);
			
			if (positions.y + note.height + _padding > _containerBaseHeight) {
				col += 1;
				_stackArray[col] = [];
				line = 0
				positions = _getPosition(col, line)
			}
			_stackArray[col][line] = note;
			
			trace(positions.x, positions.y);
			
			//if (_maxPreviousHeight + note.height + _padding > _containerBaseHeight) {
				//_maxPreviousHeight = 0;
				//_currentStackCount = 0;
				//_currentRowsCount++;
				//_stackArray[_currentRowsCount] = [];
				//
				//_maxPreviousWidth = 0;
				//for (var i:int = 0; i < _stackArray.length; i++) {
					//var rowWidth:int = 0;
					//for (var j:int = 0; j < _stackArray[i].length; j++) {
						//if (_stackArray[i][j].width > rowWidth) {
							//rowWidth = _stackArray[i][j].width;
						//}
					//}
					//_maxPreviousWidth += rowWidth + _padding;
				//}
			//}
			//
			//_stackArray[_currentRowsCount][_currentStackCount] = note;
			//_currentStackCount ++;
			//
			//var yPosition:int;
			//var xPosition:int;
			
			var yPosition:int = positions.y;
			var xPosition:int = positions.x;
			
			switch (_verticalPosition) {
				case NotificationStackerModel.STACK_POSITION_BOTTOM:
					//note.y = _containerBaseHeight + _padding - _maxPreviousHeight;
					note.y = _containerBaseHeight + _padding - positions.y;
					//yPosition = _containerBaseHeight - _maxPreviousHeight - note.height - _padding;
					yPosition = _containerBaseHeight - positions.y - note.height - _padding;
					break;
				case NotificationStackerModel.STACK_POSITION_TOP:
					note.y = - note.height - _padding;
					//yPosition = _maxPreviousHeight + _padding;
					yPosition = positions.y + _padding;
					break;
			}
			
			switch (_horizontalPosition) {
				case NotificationStackerModel.STACK_POSITION_LEFT:
					//note.x = xPosition = _maxPreviousWidth;
					note.x = xPosition = positions.x;
					break;
				case NotificationStackerModel.STACK_POSITION_RIGHT:
					//note.x = xPosition = _container.width - note.width - _maxPreviousWidth;
					note.x = xPosition = _container.width - note.width - positions.x;
					break;
			}
			
			note.alpha = 0;
			
			TweenLite.to(note, NotificationStackerModel.ANIMATION_TIME, { alpha:1, x:xPosition, y:yPosition } );
			
			_maxPreviousHeight += note.height + _padding;
			
		}
		
		private function _getPosition(col:int, row:int):Point{
			var width:int = _padding;
			var height:int = 0;
			
			for (var i:int = 0; i < col; i++) {
				var tempWidth:int = 0;
				for (var j:int = 0; j < _stackArray[i].length; j++) {
					if (_stackArray[i][j].width > tempWidth) {
						tempWidth = _stackArray[i][j].width;
					}
				}
				width += tempWidth + _padding;
			}
			
			for (i = 0; i < row; i++) {
				height += _stackArray[col][i].height + _padding;
			}
			
			//trace("WIDTH ==> " + width);
			
			return new Point(width, height);
		}
		
		private function _checkFreeSpace():Array {
			
			boucleCols: for (var i:int = 0; i < _stackArray.length; i++) {
				for (var j:int = 0; j < _stackArray[i].length; j++) {
					if (_stackArray[i][j] == null) {
						return [i, j];
					}
				}
			}
			
			return [_stackArray.length - 1, _stackArray[_stackArray.length - 1].length];
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * DELETING
		 * ********************************************************************
		 * *******************************************************************/
		
		private function _onNoteClose(evt:NotificationEvent):void {
			var note:Notification = Notification(evt.target);
			
			trace("NOTE CLOSE");
			
			boucleCols: for (var i:int = 0; i < _stackArray.length; i++) {
				for (var j:int = 0; j < _stackArray[i].length; j++) {
					if (_stackArray[i][j] == note) {
						if (_verticalPosition == NotificationStackerModel.STACK_POSITION_TOP) {
							TweenLite.to(note, NotificationStackerModel.ANIMATION_TIME, { alpha:0, y:note.y - note.height - _padding, onComplete:_deleteNote, onCompleteParams:[note]  } );
						} else if (_verticalPosition == NotificationStackerModel.STACK_POSITION_BOTTOM) {
							TweenLite.to(note, NotificationStackerModel.ANIMATION_TIME, { alpha:0, y:note.y + note.height + _padding, onComplete:_deleteNote, onCompleteParams:[note]  } );
						}
						
						_stackArray[i][j] = null;
						break boucleCols;
					}
				}
			}
			
			_notificationsCount --;
			if (_notificationsCount <= 0) {
				_resetStack();
			}
			
		}
		
		private function _deleteNote(note:Notification):void {
			note.deleteListeners();
			
			/*/
			_notificationsCount --;
			
			boucleCols: for (var i:int = 0; i < _stackArray.length; i++) {
				boucleLine: for (var j:int = 0; j < _stackArray[i].length; j++) {
					if (_stackArray[i][j] == note) {
						//_stackArray[i].splice(i, 1);
						_stackArray[i][j] = null;
						break boucleLine;
					}
				}
				//if (_stackArray[i].length <= 0) {
					//
				//}
			}
			/*/
			
			_container.removeChild(note);
			note = null;
			
			/*/
			if (_notificationsCount <= 0) {
				_resetStack();
			}
			/*/
		}
		
		
		/* ********************************************************************
		 * ********************************************************************
		 * RESETTING
		 * ********************************************************************
		 * *******************************************************************/
		
		private function _resetStack():void {
			_stackArray = [];
			_stackArray[0] = [];
			_currentStackCount = 0;
			_currentRowsCount = 0;
			
			_maxPreviousWidth = _padding;
			_maxPreviousHeight = 0;
			
			_notificationsCount = 0;
			
		}
		
		
	}

}

internal class SingletonBlocker {
	public function SingletonBlocker():void {
		
	}
}