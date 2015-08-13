package application
{
	import application.controller.RestartCommand;
	import application.controller.StartupCommand;
	import application.controller.UserMoveCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		// Notification name constants
		public static const STARTUP:String = "startup";
		
		public static const START_GAME:String = "start_game";
		public static const RESTART_REQUEST:String = "restart_request";
		public static const RESTART_GAME:String = "restart_game";
		public static const GAME_OVER:String = "game_over";
		public static const DRAWN_GAME:String = "drawn_game";
		
		public static const USER_MOVE:String = "user_move";
		public static const AI_MOVE:String = "ai_move";
		
		public static const SHOW_RULES:String = "show_rules";
		public static const SHOW_HISTORY:String = "show_history";
		public static const SHOW_OPTIONS:String = "show_options";
		
		public static const SOUND_CHANGE:String = "sound_change";
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance():ApplicationFacade
		{
			if ( instance == null ) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		/**
		 * Register Commands with the Controller
		 */
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(ApplicationFacade.STARTUP, StartupCommand);
			registerCommand(ApplicationFacade.USER_MOVE, UserMoveCommand);
			registerCommand(ApplicationFacade.RESTART_GAME, RestartCommand);
		}
	}
}