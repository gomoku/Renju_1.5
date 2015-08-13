package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class OptionsBox extends MovieClip
	{
		public static const CLOSE:String = "close";
		
		private var levels:Array = new Array("easy", "normal", "hard");
		private var _currentLevel:Number;
		private var inGame:Boolean;
		
		public function get currentLevel():Number
		{
			return _currentLevel;
		}
		
		public function set currentLevel(value:Number):void
		{
			_currentLevel = value;
		}
		
		public function OptionsBox(level:Number, inGame:Boolean)
		{
			this.alpha = 0;
			this.currentLevel = level;
			this.inGame = inGame;
			this.draw();
		}
		
		private function draw():void
		{
			// Title.
			var title:Label = new Label();
			title.size = 24;
			title.color = 0xffae3b;
			title.setText("options");
			title.x = 30;
			title.y = 20;
			
			// Complexity.
			var level:Label = new Label();
			level.color = 0xffe6c5;
			level.setText("complexity:");
			level.x = 60;
			level.y = title.y + title.height + 50;
			
			if ( !inGame )
			{
				level.x = 100;
				
				for ( var i:Number = 0; i < levels.length; i++ )
				{
					var menuItem:ToogleButton = new ToogleButton();
					menuItem.label = levels[i];
					menuItem.name = levels[i];
					menuItem.addEventListener(MouseEvent.CLICK, onClick);
					
					if ( i == 0 )
					{
						menuItem.x = level.x + level.width + 20;
					}
					else
					{
						var previousItem:ToogleButton = this.getChildByName(levels[i - 1]) as ToogleButton;
						menuItem.x = previousItem.x + previousItem.width + 20;
					}
					
					menuItem.y = level.y;
					
					this.addChild(menuItem);
				}
				
				var selectedItem:ToogleButton = this.getChildByName(levels[currentLevel - 1]) as ToogleButton;
				selectedItem.selected = true;
			}
			else
			{
				var info:Label = new Label();
				info.setText("Please, finish your current game \nto change level.");
				info.x = level.x + level.width + 10;
				info.y = level.y;
				this.addChild(info);
			}
			
			// CloseButton.
			var closeButton:AlertButton = new AlertButton();
			closeButton.label = "close";
			closeButton.addEventListener(MouseEvent.CLICK, onClose);
			closeButton.x = Math.round( (this.width - closeButton.width) / 2 );
			closeButton.y = Math.round( this.height - 20 - closeButton.height );
			
			this.addChild(title);
			this.addChild(level);
			this.addChild(closeButton);
		}
		
		private function onClick(event:MouseEvent):void
		{
			for ( var i:Number = 0; i < levels.length; i++ )
			{
				var menuItem:ToogleButton = this.getChildByName(levels[i]) as ToogleButton;
				if ( event.target.parent.name == menuItem.name )
				{
					menuItem.selected = true;
					currentLevel = i + 1;
				}
				else
				{
					menuItem.selected = false;
				}
				
			}
		}
		
		private function onClose(event:MouseEvent):void
		{
			dispatchEvent( new Event(OptionsBox.CLOSE) );
		}
	}
}