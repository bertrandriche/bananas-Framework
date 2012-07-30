package briche.display.ui.preloader {
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Bertrand Riché
	 * @mail bertrand.riche@gmail.com
	 */
	public interface IPreloader {
		
		function show():void;
		function hide():void;
		
		function update(percent:int):void;
		
		function get loader():DisplayObject;
		function set loader(value:DisplayObject):void;
		
	}
	
}