package application.controller
{
	import application.model.DataProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class RestartCommand extends SimpleCommand
	{
		private var data:DataProxy;
		
		override public function execute(notification:INotification):void
		{
			data = facade.retrieveProxy( DataProxy.NAME ) as DataProxy;
			data.AIWinCount++;
			data.resetGame();
		}
	}
}