package briche.display.ui.preloader.abstract {
	
	import briche.display.ui.preloader.events.PreloaderEvent;
	import briche.display.ui.preloader.IPreloader;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	
	[Event(name = "showStart", type = "briche.display.ui.preloader.events.PreloaderEvent")]
	[Event(name = "showEnd", type = "briche.display.ui.preloader.events.PreloaderEvent")]
	[Event(name = "hideStart", type = "briche.display.ui.preloader.events.PreloaderEvent")]
	[Event(name = "hideEnd", type = "briche.display.ui.preloader.events.PreloaderEvent")]
	 
	public class Preloader extends Sprite implements IPreloader {
		
		protected var _loader:DisplayObject;
		protected var _currentPercent:int;
		
		public function Preloader() {
			//throw new Error("Preloader is an abstract class, don't try to instantiate it. Use one of the subclasses for that.");
		}
		
		/* INTERFACE preloader.IPreloader */
		
		public function show():void {
			dispatchEvent(new PreloaderEvent(PreloaderEvent.SHOW_START));
			_show();
		}
		
		protected function _show():void { }
		
		public function hide():void {
			dispatchEvent(new PreloaderEvent(PreloaderEvent.HIDE_START));
			_hide();
		}
		
		protected function _hide():void { }
		
		public function update(percent:int):void{
			_currentPercent = percent;
			
			_update();
		}
		
		protected function _update():void { }
		
		/* INTERFACE briche.display.ui.preloader.IPreloader */
		
		public function get loader():DisplayObject{
			return _loader;
		}
		
		public function set loader(value:DisplayObject):void{
			_loader = value;
		}
		
		public function get currentPercent():int { return _currentPercent; }
		
	}

}