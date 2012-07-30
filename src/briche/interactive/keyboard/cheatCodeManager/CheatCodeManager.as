package briche.interactive.keyboard.cheatCodeManager {	
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	 /**
	 * ...
	 * @author B.Riché
	 * bertrand.riche@gmail.com
	 * 
	 * @name : CHEAT CODE MANAGER
	 * @version : 1.0
	 * @type : SINGLETON
	 * @description : Manager pour la création et l'utilisation de cheat codes (cf : Konami Code) par l'intermédiaire d'une série de caractères tapés au clavier. Classe singleton, utilisable dans l'ensemble d'un projet.
	 * @usage :
	 * Initialiser le manager avec : CheatCodeManager.init(<STAGE>, <TIMER ENABLED>, <LIMITE DE TEMPS>);
	 * Puis ajouter des codes : CheatCodeManager.addCode(<SEQUENCE DE CARACTERES>);
	 * @example :
	 * CheatCodeManager.init(stage, true, 5);
	 * CheatCodeManager.addCode("konami");
	 * 
	 */
	 
	 [Event(name="codePerform", type="briche.interactive.keyboard.cheatCodeManager.CheatCodeManagerEvent")]
	
	public class CheatCodeManager extends EventDispatcher {
		
		private static var _instance:CheatCodeManager;
		
		private var _initialized:Boolean = false;
		
		private var _codes:Dictionary;
		private var _nbCodes:int = 0;
		
		private var _lastSequence:Array;
		private var count:int;
		
		private var _typedLetters:Array;
		private var _possibilities:Array/*CheatCodeData*/;
		
		private var _cheatTimer:Timer;
		private var _timeLimit:Number;
		private var _timeLimitEnabled:Boolean;
		
		public function CheatCodeManager (blocker:SingletonBlocker) { 
			if(blocker == null){
                trace("Error : Instantiation failed ! Use CheatCodeManager.getInstance() instead of new.");
            }
		}
		
		public static function getInstance():CheatCodeManager {
			if (!_instance) {
				_instance = new CheatCodeManager(new SingletonBlocker());
			}
			
			return _instance;
		}
		
		/**
		 * INITIALISATION DU CHEAT CODE MANAGER
		 * @param	stage						(Stage) ==> référence au Stage pour l'écouteur du keyboard
		 * @param	timeLimitEnabled			(Boolean) ==> indique si les codes doivent être terminés avant un certain temps
		 * @param	timeLimit					(Number) ==> durée durant laquelle les codes doivent être terminés
		 */
		public function init(stage:Stage, timeLimitEnabled:Boolean = false, timeLimit:Number = 5):void {
			
			if (_initialized) {
				return;
			}
			_initialized = true;
			
			_timeLimitEnabled = timeLimitEnabled;
			_timeLimit = timeLimit;
			
			_typedLetters = [];
			_possibilities = [];
			_codes = new Dictionary();
			
			count = 0;
			
			stage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);
		}
		
		/**
		 * AJOUT D'UN CODE
		 * @param	sequence		(String) ==> séquence de caractères correspondant au code
		 */
		public function addCode(sequence:String = null):void {
			
			if (!_initialized) {
				throw new CheatCodeManagerError("CheatCodeManager have not been inited ! Call init() before adding any code !");
				return;
			}
			
			// Checking if a similar code have already been registered
			if (_codes[sequence]) {
				throw new CheatCodeManagerError("A cheatcode like '" + sequence + "' is already registered. Please change the sequence letters.");
				return;
			}
			
			
			// CHECKING FOR SIMILAR CODES (same letters but shorter or longer)
			var codeToAdd:Array;
			
			if (sequence == null) {
				codeToAdd = Keys.KONAMI;
			} else {
				codeToAdd = Keys.getKeyCodes(sequence);
			}
			
			if (_nbCodes > 0) {
				var isSame:Boolean = false;
				
				var startCode:Array;
				boucleCodes: for (var name:String in _codes) {
					
					if (codeToAdd.length < _codes[name].code.length) {
						startCode = _codes[name].code.slice(0, codeToAdd.length);
						if (Keys.getKeyChars(codeToAdd) == Keys.getKeyChars(startCode)) {
							isSame = true;
							break boucleCodes;
						}
					} else {
						startCode = codeToAdd.slice(0, _codes[name].code.length);
						if (Keys.getKeyChars(startCode) == Keys.getKeyChars(_codes[name].code)) {
							isSame = true;
							break boucleCodes;
						}
					}
				}
				
				if (isSame) {
					throw new CheatCodeManagerError("A cheatcode like '" + sequence + "' is already registered. Please change the sequence letters.");
					//Logger.trace("KONAMI ==> CODE DEJA EXISTANT !!", "fatal");
					return;
				}
			}
			
			_codes[sequence] = new CheatCodeData(sequence, codeToAdd);
			_nbCodes++;
			
		}
		
		
		/**
		 * SUPPRESSION D'UN CODE
		 * @param	sequence		String	> séquence de caractères correspondant au code
		 */
		public function removeCode(sequence:String):void {
			
			if (_codes[sequence]) {
				delete _codes[sequence];
				_nbCodes --;
			} else {
				throw new CheatCodeManagerError("There is no '" + sequence + "' cheatcode. Please verify the sequence letters.");
			}
			
		}
		
		/**
		 * SUPPRESSION DE TOUS LES CODES
		 */
		public function removeAllCodes():void {
			_possibilities = [];
			
			for (var name:String in _codes) {
				delete _codes[name];
			}
			
			_nbCodes = 0;
		}
		
		
		/**
		 * ACTIVATION / DESACTIVATION D'UN CODE
		 * @param	sequence		String		> séquence de caractères correspondant au code
		 * @param	bool			Boolean		> indique si le code doit être actif (true) ou inactif (false)
		 */
		public function toggleCodeActivation(sequence:String, bool:Boolean = true):void {
			
			if (_codes[sequence]) {
				_codes[sequence].enabled = bool;
			} else {
				throw new CheatCodeManagerError("There is no '" + sequence + "' cheatcode. Please verify the sequence letters.");
			}
		}
		
		
		/**
		 * ACTIVATION DE TOUS LES CODES
		 */
		public function activateAllCodes():void {
			
			for (var name:String in _codes) {
				_codes[name].enabled = true;
			}
		}
		
		
		/**
		 * DESACTIVATION DE TOUS LES CODES
		 */
		public function desactivateAllCodes():void {
			
			for (var name:String in _codes) {
				_codes[name].enabled = false;
			}
		}
		
		
		/**
		 * ECOUTEUR CLAVIER
		 * @param	evt
		 */
		private function _onKeyUp(evt:KeyboardEvent) : void {
			
			if (_timeLimitEnabled) {
				if (count == 0) {
					_cheatTimer = new Timer(_timeLimit * 1000, 1);
					_cheatTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onEndTimer);
					_cheatTimer.start();
				}
			}
			
			_possibilities = [];
			_typedLetters[_typedLetters.length] = evt.keyCode;
			var numTypedLetters:int = _typedLetters.length;
			
			var found:Boolean = false;
			
			boucleCodes: for (var name:String in _codes) {
				
				var ok:Boolean = true;
				
				boucleLettres: for (var j:int = 0; j < numTypedLetters; j++) {
					if (_typedLetters[j] != _codes[name].code[j]) {
						ok = false;
						break boucleLettres;
					}
				}
				if (ok) {
					_possibilities.push(_codes[name]);
					found = true;
				}
			} 
			
			
			
			if (!found) {
				count = 1;
				_typedLetters = [];
				_typedLetters[0] = evt.keyCode;
				return;
			} else {
				count ++;
			}
			
			var numPossibilities:int = _possibilities.length;
			var subTotal:int;
			
			for (var m:int = 0; m < numPossibilities; m++) {
				subTotal = _possibilities[m].code.length;
				for (var i:int = 0; i < subTotal; i++) {
					if (count == subTotal) {
						count = 0;
						
						if (_possibilities[m].enabled) {
							_instance.dispatchEvent(new CheatCodeManagerEvent(CheatCodeManagerEvent.CODE_PERFORM, _possibilities[m].sequence));
							endTimer();
							
							count = 0;
							_typedLetters = [];
						}
					}
				}
			}
		}
		
		/**
		 * ARRET DU TIMER APRES LA FIN D'UN CODE
		 */
		private function endTimer():void{
			if (_cheatTimer) {
				if (_cheatTimer.running) {
					_cheatTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onEndTimer);
					_cheatTimer.stop();
				}
			}
		}
		
		/**
		 * FIN DU TIMER DE TEMPS LIMITE
		 * @param	evt
		 */
		private function _onEndTimer(evt:TimerEvent):void {
			count = 0;
			_typedLetters = [];
		}
		
		public function get initialized():Boolean { return _initialized; }
			
	}
}


/**
 * CLASSE CURSOR MANAGER ERROR
 */
internal class CheatCodeManagerError extends Error {
    public function CheatCodeManagerError(message:String) {
        super(message);
    }
}

internal class SingletonBlocker {
	public function SingletonBlocker():void {
		
	}
}
