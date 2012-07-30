package briche.display.ui.preloader {
	
	import briche.display.ui.preloader.abstract.Preloader;
	import briche.display.ui.preloader.events.PreloaderEvent;
	
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	 
	public class BarPreloader extends Preloader implements IPreloader {
		
		private var _bar:DisplayObject;
		
		private var _maxDimension:int;
		private var _direction:String;
		
		public function BarPreloader(preloader:DisplayObject, bar:DisplayObject, direction:String = "horizontal", maxDimension:int = 0) {
			
			_loader = preloader;
			_bar = bar;
			_direction = direction;
			_loader.alpha = 0;
			
			if (_direction == PreloaderDirection.HORIZONTAL) {
				if (maxDimension == 0) {
					_maxDimension = bar.width;
				} else {
					_maxDimension = maxDimension > 0 ? maxDimension : - maxDimension;
				}
				bar.width = 0;
			} else if (_direction == PreloaderDirection.VERTICAL) {
				if (maxDimension == 0) {
					_maxDimension = bar.height;
				} else {
					_maxDimension = maxDimension > 0 ? maxDimension : - maxDimension;
				}
				bar.height = 0;
			}
			
			addChild(_loader);
			
			
		}
		
		override protected function _show():void {
			TweenLite.to(_loader, 0.5, { alpha:1, onComplete:_dispatchShowEnd } );
		}
		
		private function _dispatchShowEnd():void{
			dispatchEvent(new PreloaderEvent(PreloaderEvent.SHOW_END));
		}
		
		override protected function _hide():void {
			TweenLite.to(_loader, 0.5, { alpha:0, onComplete:_dispatchHideEnd } );
		}
		
		private function _dispatchHideEnd():void{
			dispatchEvent(new PreloaderEvent(PreloaderEvent.HIDE_END));
		}
		
		override protected function _update():void {
			
			if (_direction == PreloaderDirection.HORIZONTAL) {
				_bar.width = _currentPercent * (_maxDimension / 100);
			} else if (_direction == PreloaderDirection.VERTICAL) {
				_bar.height = _currentPercent * (_maxDimension / 100);
			}
			
			
		}
		
	}

}