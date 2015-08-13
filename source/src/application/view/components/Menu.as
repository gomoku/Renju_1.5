package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends MovieClip
	{
		public static const START:String = "start";
		public static const RULES:String = "rules";
		public static const HISTORY:String = "history";
		public static const OPTIONS:String = "options";
		
		private static const PADDING:Number = 20;
		
		private var labelsArray:Array = new Array("new game", "rules", "history", "options");
		
		public function Menu()
		{
			drawMenu();
		}
		
		private function drawMenu():void
		{
			for ( var i:Number = 0; i < labelsArray.length; i++ )
			{
				var menuItem:MenuButton = new MenuButton();
				menuItem.name = labelsArray[i];
				menuItem.label = labelsArray[i];
				menuItem.addEventListener(MouseEvent.CLICK, onClick);
				
				if ( i != 0 )
				{
					var previousItem:MenuButton = this.getChildByName(labelsArray[i - 1]) as MenuButton;
					menuItem.x = previousItem.x + previousItem.width + PADDING;
				}
				this.addChild(menuItem);
			}
			
			for ( i = 0; i < labelsArray.length - 1; i++ )
			{
				var separator:Separator = new Separator();
				
				previousItem = this.getChildByName(labelsArray[i]) as MenuButton;
				separator.x = previousItem.x + previousItem.width + (PADDING / 2);
				separator.y = 5;
				
				this.addChild(separator);
			}
		}
		
		private function onClick(event:MouseEvent):void
		{
			switch( event.target.parent.name )
			{
				case "new game":
					dispatchEvent( new Event(Menu.START) );
					break;
				
				case "rules":
					dispatchEvent( new Event(Menu.RULES) );
					break;
				
				case "history":
					dispatchEvent( new Event(Menu.HISTORY) );
					break;
				
				case "options":
					dispatchEvent( new Event(Menu.OPTIONS) );
					break;
			}
		}
	}
}