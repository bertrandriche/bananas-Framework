package briche.net.fms {
	
	
	import briche.Logger;
	import briche.net.fms.events.FMSConnectionManagerEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 */
	
	[Event(name = "fmsConnexionDone", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "fmsConnexionLost", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "clientConnect", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "clientLeave", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "fmsConnexionDone", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "soConnexionDone", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "soChange", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	[Event(name = "soModificationSuccess", type = "briche.net.fms.events.FMSConnectionManagerEvent")]
	 
	public class FMSConnexionManager extends EventDispatcher{
		
		public static const RMTP_BASE_ADDRESS:String = "rtmp:/";
		
		public static const FMS_CONNECT:String = "fmsConnect";
		public static const FMS_DISCONNECT:String = "fmsDisConnect";
		
		public static const CLIENT_CONNECT:String = "clear";
		public static const SO_CHANGE:String = "change";
		public static const SO_MODIFICATION_SUCCESS:String = "success";
		public static const SO_MODIFICATION_FAIL:String = "reject";
		public static const CLIENT_DISCONNECT:String = "delete";
		
		private static var _instance:FMSConnexionManager;
		
		private var _netConnection:NetConnection;
		private var _soClients:SharedObject;
		
		public const SO_CLIENTS_NAME:String = "so_clients";
		private var _soConnected:Boolean = false;
		
		private var _RTMP:String;
		
		
		
		
		public static function getInstance():FMSConnexionManager {
			
			if (!FMSConnexionManager._instance) {
				_instance = new FMSConnexionManager(new SingletonBlocker());
			}
			
			return _instance;
		}
		
		
		public function init(client:DisplayObjectContainer, rtmpAddress:String):void {
			
			Logger.info("FMSConnexionManager :: INIT >> " + rtmpAddress);
			
			_netConnection.client = client;
			_RTMP = rtmpAddress;
		}
		
		public function FMSConnexionManager(blocker:SingletonBlocker):void {
			
			if (!blocker) {
				throw new Error("Do not instantiate FMSConnexionManager, use getInstance() instead");
			}
			
			// -- net connection
			_netConnection = new NetConnection();
			_netConnection.objectEncoding = ObjectEncoding.AMF0;
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, _onNetStatusEvent);
			_netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, _onNetStatusError);
			
		}
		
		public function connect(nom:String):void {
			Logger.info("CONNEXION AU SERVEUR");
			
			_netConnection.connect(_RTMP, { name:nom } );
		}
		
		private function _onNetStatusEvent(e:NetStatusEvent):void {
			
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
					Logger.trace("FMS >> CONNEXION AU SERVEUR EFFECTUEE");
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.FMS_CONNEXION_DONE, FMS_CONNECT));
					break;
				
				case "NetConnection.Connect.AppShutdown":
					Logger.fatal("FMS >> SERVER SHUT DOWN");
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.FMS_CONNEXION_LOST, FMS_DISCONNECT));
					break;
			}
		}
		
		private function _onNetStatusError(evt:AsyncErrorEvent):void {
			Logger.trace("ERROR ==> " + evt.error.message);
		}
		
		
		public function getRemoteSo(client:DisplayObject):void {
			Logger.trace("FMS >> CONNEXION AU SHARED OBJECT '" + SO_CLIENTS_NAME + "'", "info");
			
			_soClients = SharedObject.getRemote(SO_CLIENTS_NAME, _netConnection.uri);
			///_soClients.client = _netConnection.client;
			_soClients.client = client;
			_soClients.addEventListener(SyncEvent.SYNC, _soClientsSyncEvent);
			_soClients.connect(_netConnection);
			
		}
		
		
	
		private function _soClientsSyncEvent(e:SyncEvent):void {
			var _soClientsTemp:SharedObject = SharedObject(e.target);
			
			/*/
			Logger.trace("SYNC --- " + e.changeList[0].code + " :: " + _soClients.objectEncoding);
			//*/
			
			switch(e.changeList[0].code) {
				case "clear":
					Logger.warn("FMS >> SHARED OBJECT SYNC ==> Connection Success");
					
					// Première connexion : c'est ce client qui vient de se connecter au sharedObject avec succès
					if (!_soConnected) {
						_soConnected = true;
						dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.SO_CONNEXION_DONE, CLIENT_CONNECT));
						
					// Autres connexions : c'est un autre client qui vient de se connecter au sharedObject avec succès
					} else {
						dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.CLIENT_CONNECT, CLIENT_CONNECT));
					}
					
				break;
				
				case "success":
					/*/ La modification du shared object par ce client a réussie
					Logger.info("FMS >> SHARED OBJECT SYNC ==> SO modification OK");
					//*/
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.SO_MODIFICATION_SUCCESS, SO_MODIFICATION_SUCCESS));
				break;
				
				case "reject":
					/*/ La modification du shared object par ce client a échoué
					Logger.fatal("FMS >> SHARED OBJECT SYNC ==> SO modification FAIL");
					//*/
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.SO_MODIFICATION_FAIL, SO_MODIFICATION_FAIL));
				break;
				
				case "change":
					/*/ Un client a modifié le shared object
					Logger.debug("FMS >> SHARED OBJECT SYNC ==> SO changed");
					//*/
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.SO_CHANGE, SO_CHANGE));
				break;
				
				case "delete":
					// Un élément a été supprimé du Shared object ==> un client s'est déconnecté
					Logger.fatal("FMS >> SHARED OBJECT SYNC ==> DELETE CLIENT");
					dispatchEvent(new FMSConnectionManagerEvent(FMSConnectionManagerEvent.CLIENT_LEAVE, CLIENT_DISCONNECT));
				break;
			}
			
		}
		
		
		
		public function get soClients():SharedObject { return _soClients; }
		
		public function set soClients(value:SharedObject):void {
			_soClients = value;
		}
		
		public function get netConnection():NetConnection { return _netConnection; }
		
		public function set netConnection(value:NetConnection):void {
			_netConnection = value;
		}
		
		
	}
	
}

internal class SingletonBlocker {
	public function SingletonBlocker():void {
		
	}
}