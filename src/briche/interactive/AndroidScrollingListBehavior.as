package briche.interactive {
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author B.Riché
	* bertrand.riche@gmail.com
	 */
	public class AndroidScrollingListBehavior {
		
		private const MIN_DRAGGING_WIDTH:int = 20;
		private const EASE_FACTOR:Number = 0.1;
		
		static public const VERTICAL:String = "y";
		static public const HORIZONTAL:String = "x";
		
		private var _target:DisplayObjectContainer;
		private var _direction:String;
		private var _totalSize:int;
		private var _sidesMargin:int;
		
		private var _usedDimension:int;
		
		/// Dragging movement with inertia
		private var _hasDragged:Boolean = false;
		private var inertia:Number;
		private var _startingPosition:int;
		private var _listStartingPosition:int;
		private var minPos:int;
		private var maxPos:int;
		private var totalPos:int;
		private var diffPos:int;
		private var lastPos:int;
		
		
		public function AndroidScrollingListBehavior(target:DisplayObjectContainer, direction:String, totalSize:int, sidesMargin:int) {
			_target = target;
			_direction = direction;
			_totalSize = totalSize;
			_sidesMargin = sidesMargin;
			
			_usedDimension = _direction == HORIZONTAL ? _target.width : _target.height;
		}
		
		public function toggleActivation(active:Boolean = true):void {
			if (active && !_target.hasEventListener(MouseEvent.MOUSE_DOWN)) _target.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			else _target.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown)
		}
		
		private function _onMouseDown(evt:MouseEvent):void {
			_hasDragged = false;
			
			inertia = 0;
			_startingPosition = _direction == HORIZONTAL ? _target.parent.mouseX : _target.parent.mouseY;
			//_listStartingPosition = _direction == HORIZONTAL ? _target.x : _target.y;
			_listStartingPosition = _target[_direction];
			minPos = Math.min(-_listStartingPosition - _sidesMargin, - _usedDimension + _totalSize - _listStartingPosition - _sidesMargin);
			maxPos = -_listStartingPosition + _sidesMargin;
			
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, _stopDragging);
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, _panPreview);
		}
		
		private function _panPreview(evt:MouseEvent):void {
			
			var currentMousePos:int = (_direction == HORIZONTAL ? _target.parent.mouseX : _target.parent.mouseY);
			
			totalPos = currentMousePos - _startingPosition;
			if(Math.abs(totalPos) > MIN_DRAGGING_WIDTH) _hasDragged = true;
			if(_hasDragged) {
				diffPos = currentMousePos - lastPos;	
				lastPos = currentMousePos;
				if (totalPos < minPos) totalPos = minPos - Math.sqrt(minPos - totalPos);
				if (totalPos > maxPos) totalPos = maxPos + Math.sqrt(totalPos - maxPos);
				//if (_direction == HORIZONTAL) _target.x = _listStartingPosition + totalPos;
				//else _target.y = _listStartingPosition + totalPos;
				_target[_direction] = _listStartingPosition + totalPos;
				
			}
			
		}
		
		private function _stopDragging(evt:MouseEvent):void {
			if(_hasDragged) {
				inertia = diffPos;
				_target.stage.addEventListener(Event.ENTER_FRAME, _replace);
			}
			
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, _stopDragging);
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _panPreview);
		}
		
		
		private function _replace(evt:Event):void {
			var diff:Number;
			
			//var currentPos:int = (_direction == HORIZONTAL ? _target.x : _target.y);
			var currentPos:int =_target[_direction];
			
			if (currentPos > _sidesMargin) {
				inertia = 0;
				
				diff = _sidesMargin - currentPos;
				if (diff < -1) {
					diff *= EASE_FACTOR;
					//if (_direction == HORIZONTAL) _target.x += diff;
					//else _target.y += diff;
					_target[_direction] += diff;
				} else {
					//if (_direction == HORIZONTAL) _target.x = _sidesMargin;
					//else _target.y = _sidesMargin;
					_target[_direction] = _sidesMargin;
					_hasDragged = false;
					_target.stage.removeEventListener(Event.ENTER_FRAME, _replace);
				}
					
			} else if(_usedDimension >= _totalSize && currentPos < _totalSize - _usedDimension - _sidesMargin) {
				inertia = 0;
				
				diff = (_totalSize - _usedDimension - _sidesMargin) - currentPos;
				if (diff > 1) {
					diff *= EASE_FACTOR;
					//if (_direction == HORIZONTAL) _target.x += diff;
					//else _target.y += diff;
					_target[_direction] += diff;
				} else {
					//if (_direction == HORIZONTAL) _target.x = (_totalSize - _usedDimension - _sidesMargin);
					//else _target.y = (_totalSize - _usedDimension - _sidesMargin);
					_target[_direction] = (_totalSize - _usedDimension - _sidesMargin);
					_hasDragged = false;
					_target.stage.removeEventListener(Event.ENTER_FRAME, _replace);
				}
			}
			
			if ( Math.abs(inertia) > 1) {
				//if (_direction == HORIZONTAL) _target.x += inertia;
				//else _target.y += inertia;
				_target[_direction] +=  inertia;
				inertia *= 0.9;
			} else {
				inertia = 0;
			}
			
		}
		
		public function get hasDragged():Boolean { return _hasDragged; }
		public function set hasDragged(value:Boolean):void { _hasDragged = value; }
		
	}

}