package briche.display.ui.preloader {
	
	import briche.display.ui.preloader.abstract.Preloader;
	import briche.display.ui.preloader.events.PreloaderEvent;
	import briche.display.uiComponents.preloader.IPreloader;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public class TextPreloader extends Preloader implements IPreloader{
		
		private var _loader:DisplayObject;
		private var _text:TextField;
		
		public function TextPreloader(preloader:DisplayObject, text:TextField) {
			
			_loader = preloader;
			_text = text;
			
			
			_loader.alpha = 0;
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
			
			_text.text = _currentPercent;
			
			
		}
		
	}

}