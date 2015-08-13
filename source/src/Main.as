package 
{
	import application.ApplicationFacade;
	
	import flash.display.Sprite;

	public class Main extends Sprite
	{
		private var facade:ApplicationFacade;
		
		public function Main()
		{
			facade = ApplicationFacade.getInstance();
			facade.sendNotification(ApplicationFacade.STARTUP, this);
		}
	}
}
