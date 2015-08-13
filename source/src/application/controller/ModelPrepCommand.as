package application.controller
{
	import application.model.DataProxy;
	import application.model.InfoProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ModelPrepCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			facade.registerProxy( new DataProxy() );
			facade.registerProxy( new InfoProxy() );
		}
	}
}