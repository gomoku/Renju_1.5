package application.view
{
	import application.ApplicationFacade;
	import application.model.DataProxy;
	import application.model.InfoProxy;
	import application.utils.DropShadowFilterHelper;
	import application.view.components.AlertBox;
	import application.view.components.Board;
	import application.view.components.InfoBox;
	import application.view.components.Menu;
	import application.view.components.Modal;
	import application.view.components.OptionsBox;
	import application.view.components.SoundButton;
	import application.view.components.WinCount;
	import application.view.sounds.Ambient;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import gs.TweenLite;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		// Model.
		private var data:DataProxy;
		private var info:InfoProxy;
		
		// Assets.
		private var board:Board;
		private var menu:Menu;
		private var AIWinCount:WinCount;
		private var userWinCount:WinCount;
		private var soundButton:SoundButton;
		private var modal:Modal;
		private var alert:AlertBox;
		private var infoBox:InfoBox;
		private var options:OptionsBox;
		private var loop:Sound;
		private var channel:SoundChannel;
		private var transform:SoundTransform;
		
		public function ApplicationMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
			
			// Stage setup.
			main.stage.align = StageAlign.TOP_LEFT;
			main.stage.scaleMode = StageScaleMode.NO_SCALE;
			main.stage.addEventListener(Event.RESIZE, alignContent);
			
			// Retrieve proxies.
			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			info = facade.retrieveProxy( InfoProxy.NAME ) as InfoProxy;
			
			drawAssets();
		}
		
		override public function listNotificationInterests():Array
		{
			return new Array( ApplicationFacade.GAME_OVER,
							  ApplicationFacade.RESTART_REQUEST,
							  ApplicationFacade.DRAWN_GAME,
							  ApplicationFacade.SHOW_RULES,
							  ApplicationFacade.SHOW_HISTORY,
							  ApplicationFacade.SHOW_OPTIONS );
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch( notification.getName() )
			{
				case ApplicationFacade.GAME_OVER:
					var winner:Number = notification.getBody().tile;
					
					if ( winner == 1 )
					{
						userWinCount.text = "USR:" + data.userWinCount;
					}
					else
					{
						AIWinCount.text = "CPU:" + data.AIWinCount;
					}
					break;
				
				case ApplicationFacade.RESTART_REQUEST:
					showModal();
					showAlert("This will restart your current game.\nAre you sure?", AlertBox.YES);
					
					alignContent();
					break;
				
				case ApplicationFacade.DRAWN_GAME:
					showModal();
					showAlert("Only draw is available.\nTry again.", AlertBox.OK);
					
					alignContent();
					break;
				
				case ApplicationFacade.SHOW_RULES:
					showModal();
					showInfo("rules", info.rules);
					
					alignContent();
					break;
				
				case ApplicationFacade.SHOW_HISTORY:
					showModal();
					showInfo("history", info.history);
					
					alignContent();
					break;
				
				case ApplicationFacade.SHOW_OPTIONS:
					showModal();
					showOptions();
					
					alignContent();
					break;
			}
		}
		
		protected function get main():Main
		{
			return viewComponent as Main;
		}
		
		// Modal handling functions.
		private function showModal():void
		{
			modal = new Modal();
			main.addChild(modal);
			TweenLite.to(modal, 0.5, {alpha:1, volume:0});
		}
		
		private function hideModal():void
		{
			TweenLite.to(modal, 0.5, {alpha:0, volume:0, onComplete:removeModal});
		}
		
		private function removeModal():void
		{
			main.removeChild(modal);
		}
		
		// Alert functions.
		private function showAlert(message:String, mode:String):void
		{
			alert = new AlertBox(message, mode);
			alert.addEventListener(AlertBox.YES, onYes);
			alert.addEventListener(AlertBox.NO, removeAlert);
			alert.addEventListener(AlertBox.OK, removeAlert);
			main.addChild(alert);
			TweenLite.to(alert, 0.5, {alpha:1, volume:0});
		}
		
		private function onYes(event:Event):void
		{
			sendNotification(ApplicationFacade.RESTART_GAME);
			removeAlert();
			AIWinCount.text = "CPU:" + data.AIWinCount;
		}
		
		private function removeAlert(event:Event = null):void
		{
			hideModal();
			main.removeChild(alert);
		}
		
		// Info functions.
		private function showInfo(title:String, message:String):void
		{
			infoBox = new InfoBox(title, message);
			infoBox.addEventListener(InfoBox.CLOSE, onClose);
			main.addChild(infoBox);
			TweenLite.to(infoBox, 0.5, {alpha:1, volume:0});
		}
		
		private function onClose(event:Event):void
		{
			hideModal();
			main.removeChild(infoBox);
		}
		
		// Options box.
		private function showOptions():void
		{
			options = new OptionsBox(data.level, data.inGame);
			options.addEventListener(OptionsBox.CLOSE, hideOptions);
			main.addChild(options);
			TweenLite.to(options, 0.5, {alpha:1, volume:0});
		}
		
		private function hideOptions(event:Event):void
		{
			data.level = options.currentLevel;
			hideModal();
			main.removeChild(options);
		}
		
		private function drawAssets():void
		{
			board = new Board(data.boardSize, data.tileSize);
			facade.registerMediator( new BoardMediator(board) );
			main.addChild(board);
			
			DropShadowFilterHelper.apply(board, 0, 0, 0, 0.8, 10, 10, 2);
			
			menu = new Menu();
			facade.registerMediator( new MenuMediator(menu) );
			main.addChild(menu);
			
			AIWinCount = new WinCount();
			AIWinCount.text = "CPU:" + data.AIWinCount;
			main.addChild(AIWinCount);
			
			userWinCount = new WinCount();
			userWinCount.text = "USR:" + data.userWinCount;
			main.addChild(userWinCount);
			
			soundButton = new SoundButton();
			soundButton.soundState = data.soundState;
			soundButton.addEventListener(SoundButton.SOUND_ON, onSoundOn);
			soundButton.addEventListener(SoundButton.SOUND_OFF, onSoundOff);
			main.addChild(soundButton);
			
			loop = new Ambient();
			
			if ( data.soundState ) 
			{
				channel = loop.play(0, 9999);			
				setSound(true);
			}
			
			alignContent();
		}
		
		private function onSoundOn(event:Event):void
		{
			data.soundState = true;
			
			if ( channel != null )
			{
				setSound(true);
			}
			else
			{
				channel = loop.play(0, 9999);			
				setSound(true);
			}
		}
		
		private function onSoundOff(event:Event):void
		{
			data.soundState = false;
			setSound(false);
		}
		
		private function setSound(value:Boolean):void
		{
			transform = channel.soundTransform;
			transform.volume = value ? 0.2 : 0;
			channel.soundTransform = transform;
		}
		
		private function alignContent(event:Event = null):void
		{
			var w:Number = main.stage.stageWidth;
			var h:Number = main.stage.stageHeight;
			
			board.x = 102;//( w - board.width ) / 2;
			board.y = 230;//( h - board.height ) / 2;
			
			menu.x = 112;
			menu.y = 200;
			
			AIWinCount.x = 70;
			AIWinCount.y = 571;
			
			userWinCount.x = 398;
			userWinCount.y = AIWinCount.y;
			
			soundButton.x = 253;
			soundButton.y = 586;
			
			if ( modal != null )
			{
				modal.setSize(w, h);
			}
			
			if ( alert != null )
			{
				alert.x = (w - alert.width) / 2;
				alert.y = (h - alert.height) / 2;
			}
			
			if ( infoBox != null )
			{
				infoBox.x = 10;//(w - infoBox.width) / 2;
				infoBox.y = (h - infoBox.height ) / 2;
			}
			
			if ( options != null )
			{
				options.x = 10;
				options.y = (h - options.height ) / 2;
			}
		}
	}
}