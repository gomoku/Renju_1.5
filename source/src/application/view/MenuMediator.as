package application.view
{
	import application.ApplicationFacade;
	import application.model.DataProxy;
	import application.view.components.Menu;
	import application.view.sounds.AlertSound;
	
	import flash.events.Event;
	import flash.media.Sound;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuMediator";
		
		private var data:DataProxy;
		private var alertSound:Sound;
		
		public function MenuMediator( viewComponent:Object )
		{
			super(NAME, viewComponent);
			
			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			
			menu.addEventListener(Menu.START, onStart);
			menu.addEventListener(Menu.RULES, onRules);
			menu.addEventListener(Menu.HISTORY, onHistory);
			menu.addEventListener(Menu.OPTIONS, onOptions);
			
			alertSound = new AlertSound();
		}
		
		override public function listNotificationInterests():Array
		{
			return new Array();
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
		}
		
		protected function get menu():Menu
		{
			return viewComponent as Menu;
		}
		
		private function onStart(event:Event):void
		{
			if ( !data.inGame )
			{
				sendNotification(ApplicationFacade.START_GAME);
				data.inGame = true;			
			}
			else
			{
				if ( data.soundState ) alertSound.play();				
				sendNotification(ApplicationFacade.RESTART_REQUEST);
			}
		}
		
		private function onRules(event:Event):void
		{
			if ( data.soundState ) alertSound.play();
			sendNotification(ApplicationFacade.SHOW_RULES);
		}
		
		private function onHistory(event:Event):void
		{
			if ( data.soundState ) alertSound.play();
			sendNotification(ApplicationFacade.SHOW_HISTORY);
		}
		
		private function onOptions(event:Event):void
		{
			if ( data.soundState ) alertSound.play();
			sendNotification(ApplicationFacade.SHOW_OPTIONS);
		}
	}
}