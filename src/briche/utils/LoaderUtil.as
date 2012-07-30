package briche.utils {
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	/**
	 * Loader util class [static]
	 */
	public class LoaderUtil
	{
		/**
		 * Creates an exact copy of a Loader; copies the entire Loader object's content
		 * (no matter graphics/swf animation).
		 *
		 * @param	source:LoaderInfo	the source LoaderInfo of the target Loader to be copied.
		 * @return	Loader				the exact copy of the source loader
		 *
		 * @example
		 *
		 * var myLoader:Loader = new Loader();
		 * myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, dataLoaded);
		 * myLoader.load(new URLRequest("http://www.google.com/intl/en_ALL/images/logo.gif"));
		 * addChild(myLoader);
		 *
		 * function dataLoaded(event:Event):void
		 * {
		 * var copyLoader:Loader = LoaderUtil.copy(event.target as LoaderInfo);
		 * copyLoader.y = 200;
		 * addChild(copyLoader);
		 * }
		 */
		public static function copy(source:LoaderInfo):Loader
		{
			var sourceBytes:ByteArray;
			var copyLoader:Loader;
			
			sourceBytes = source.bytes;

			if(sourceBytes.bytesAvailable == 0)
			{
				throw new Error("LoaderUtil.copy("+source+") doesn't appear to have any bytes available");
				return null;
			}
			
			copyLoader = new Loader();
			copyLoader.loadBytes(sourceBytes);
			return copyLoader;
		}
	}
}