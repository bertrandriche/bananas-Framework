package briche.net.phpLoader {
	
	/**
	* ...
	* @author Bertrand Riché
	* bertrand.riche@gmail.com
	*/
	
	/* ------------------------------------------------- IMPORTS ------------------------------------------------- */
	// IMPORT CONNEXION \\
	import briche.events.PHPLoaderEvent;
	import briche.Logger;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	
	// IMPORT EVENTS \\
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	
	[Event(name = "loaded", type = "briche.net.phpLoader.PHPLoaderEvent")]
	[Event(name = "onProgress", type = "briche.net.phpLoader.PHPLoaderEvent")]
	[Event(name = "errorLoading", type = "briche.net.phpLoader.PHPLoaderEvent")]
	
	public class PHPLoader extends EventDispatcher {
		
		/* ------------------------------------------------- PROPRIETES ------------------------------------------------- */
		
		// ENVOI ET RECEPTION DONNEES
		private var connexion:URLLoader;
		private var varEnvoi:URLVariables;
		private var requete:URLRequest;
		
		//
		private var _resultatRequete:URLVariables;
		
		private var _pourcentProgression:Number = 0;
		
		/* ------------------------------------------------ CONSTRUCTEUR ------------------------------------------------ */
		/**
		 * CONSTRUCTEUR
		 * @param	variables		(Object) : objet contenant les variables à envoyer au php sous forme de paires nom/valeur
		 * @param	chemin			(String) : chemin du php à appeler
		 */
		public function PHPLoader (variables:Object, chemin:String):void {
			
			connexion = new URLLoader();
			connexion.dataFormat = URLLoaderDataFormat.VARIABLES;
			
			varEnvoi = new URLVariables();
			
			for (var name:String in variables) {
				varEnvoi[name.toString()] = variables[name.toString()];
				
			}
			
			Logger.trace(varEnvoi, "fatal");
			
			requete = new URLRequest(chemin);
			requete.method = URLRequestMethod.POST;
			requete.data = varEnvoi;
			
			connexion.addEventListener (Event.OPEN, lancementChargement);
			
			connexion.addEventListener (Event.COMPLETE, receptionDonnees);
			connexion.addEventListener (ProgressEvent.PROGRESS, progressionChargement);
			connexion.addEventListener (IOErrorEvent.IO_ERROR, erreurChargement );
			connexion.addEventListener (HTTPStatusEvent.HTTP_STATUS, statutHTTP );
			connexion.addEventListener (SecurityErrorEvent.SECURITY_ERROR, errorSecurity);
			
		}
		
		private function errorSecurity(evt:SecurityErrorEvent):void {
			Logger.trace("PHPLOADER ==> " + requete.url + " SECURITY ERROR !", "fatal");
		}
		
		/**
		 * 
		 */
		public function load():void {
			//_pourcentProgression = 0;
			
			connexion.load(requete);
		}
		
		/* ------------------------------------------------- ECOUTEURS ------------------------------------------------- */
		/**
		 * 
		 * @param	evt
		 */
		private function lancementChargement(evt:Event):void {
			_pourcentProgression = 0;
			
			Logger.trace("PHPLOADER ==> chargement de " + requete.url);
			
		}
		
		/**
		 * 
		 * @param	evt
		 */
		private function progressionChargement(evt:ProgressEvent):void {
			
			_pourcentProgression = int((evt.bytesLoaded / evt.bytesTotal) * 100);
			
			Logger.trace("PHPLOADER ==> loading " + requete.url + " : " + _pourcentProgression + "% (" + evt.bytesLoaded + " / " + evt.bytesTotal + ")");
			
			dispatchEvent(new PHPLoaderEvent(PHPLoaderEvent.PROGRESS, { pourcent:_pourcentProgression } ));
		}
		
		/**
		 * 
		 * @param	evt
		 */
		private function receptionDonnees(evt:Event):void {
			
			_pourcentProgression = 100;
			
			_onLoadingDone(evt.target.data);
		}
		
		private function _onLoadingDone(data:*):void {
			Logger.trace("PHPLOADER ==> " + requete.url + " LOADED !", "info");
			
			var variables:URLVariables = new URLVariables( data );
			Logger.trace("VARIABLES PARSED");
			
			_resultatRequete = variables;
			Logger.trace("VARIABLES PUT IN RESULTAT REQUETE");
			
			Logger.trace("TRACING DATA");
			//Logger.trace(_resultatRequete);
			
			Logger.trace("DISPATCHING EVENT");
			dispatchEvent(new PHPLoaderEvent(PHPLoaderEvent.LOADED, { resultat:_resultatRequete } ));
			
			Logger.trace("REMOVING LISTENERS");
			_removeListeners();
		}
		
		/**
		 * 
		 * @param	evt
		 */
		private function statutHTTP ( evt:HTTPStatusEvent ):void {
			Logger.info( "Code HTTP : " + evt.status );
			
			//_onLoadingDone(connexion.data);
			
		}
		
		/**
		 * 
		 * @param	evt
		 */
		private function erreurChargement ( evt:IOErrorEvent ):void {
			
			Logger.trace("PHPLOADER ==> " + requete.url + " FAILED !", "fatal");
			
			dispatchEvent(new PHPLoaderEvent(PHPLoaderEvent.ERROR_LOADING, evt.text));
			
			_removeListeners();
		}
		
		/**
		 * REMOVE ALL LISTENERS FROM THE URL LOADER
		 */
		private function _removeListeners():void {
			connexion.removeEventListener (Event.OPEN, lancementChargement);
			
			connexion.removeEventListener (Event.COMPLETE, receptionDonnees);
			connexion.removeEventListener (ProgressEvent.PROGRESS, progressionChargement);
			connexion.removeEventListener (IOErrorEvent.IO_ERROR,erreurChargement );
			connexion.removeEventListener (HTTPStatusEvent.HTTP_STATUS, statutHTTP );
			connexion.removeEventListener (SecurityErrorEvent.SECURITY_ERROR, errorSecurity);
			
			varEnvoi = null;
			requete = null;
			connexion = null;
		}
		
		/* ------------------------------------------------- GETTERS ------------------------------------------------- */
		
		public function get pourcent():Number {
			return _pourcentProgression;
		}
		
		public function get contenu():URLVariables { 
			return _resultatRequete;
		}
		
	}

}