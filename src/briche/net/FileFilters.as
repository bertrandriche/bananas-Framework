package briche.net {
	
	import flash.net.FileFilter;
	
	/**
	 * ...
	 * @author 	 B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	 
	public class FileFilters{
		
		static public const IMAGES_PLUSGIF:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		static public const IMAGES:FileFilter = new FileFilter("Images (*.jpg, *.jpeg, *.png)", "*.jpg;*.jpeg;*.png");
		static public const TEXTS:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
		static public const DOCUMENTS:FileFilter = new FileFilter("Documents (*.pdf;*.doc;*.txt)", "*.pdf;*.doc;*.txt");
		
		public function FileFilters() { }
		
	}

}