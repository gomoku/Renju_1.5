package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class AlertBox extends MovieClip
	{
		public static const YES:String = "yes";
		public static const NO:String = "no";
		public static const OK:String = "ok";
		
		private var _message:String;
		private var _mode:String;
		
		private var textField:TextField;
		private var format:TextFormat;
		
		// Message getter.
		public function get message():String
		{
			return _message;
		}
		
		// Mode getter.
		public function get mode():String
		{
			return _mode;
		}
		
		public function AlertBox(message:String, mode:String)
		{
			this.alpha = 0;
			_message = message;
			_mode = mode;
			draw();
		}
		
		private function draw():void
		{
			// TextField setup.
			textField = new TextField();
			textField.selectable = false;
			textField.wordWrap = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.embedFonts = true;
			textField.text = message;
			textField.x = 30;
			textField.y = 45;
			textField.width = this.width - (textField.x * 2);
			textField.height = this.height - (textField.y * 2) - 5;
			
			format = new TextFormat();
			format.font = "Japan";
			format.color = 0xffffff;
			format.size = 18;
			format.align = TextFormatAlign.CENTER;
			format.leading = 7;
			
			textField.setTextFormat(format);
			
			// Buttons setup.
			if ( mode == AlertBox.YES )
			{
				var yes:AlertButton = new AlertButton();
				yes.addEventListener(MouseEvent.CLICK, onClick);
				yes.label = "yes";
				yes.name = "yes";
				this.addChild(yes);
				
				var no:AlertButton = new AlertButton();
				no.addEventListener(MouseEvent.CLICK, onClick);
				no.label = "no";
				no.name = "no";
				this.addChild(no);
				
				yes.x = 90;
				yes.y = textField.y + textField.height;
				
				no.x = yes.x + yes.width + 20;
				no.y = yes.y;
			}
			else
			{
				var ok:AlertButton = new AlertButton();
				ok.addEventListener(MouseEvent.CLICK, onClick);
				ok.label = "ok";
				ok.name = "ok";
				this.addChild(ok);
				
				ok.x = (this.width - ok.width) / 2;
				ok.y = textField.y + textField.height;
			}
			
			this.addChild(textField);
		}
		
		private function onClick(event:MouseEvent):void
		{
			switch( event.target.parent.name )
			{
				case "no":
					dispatchEvent( new Event(AlertBox.NO) );
					break;
				
				case "ok":
					dispatchEvent( new Event(AlertBox.OK) );
					break;
				
				case "yes":
					dispatchEvent( new Event(AlertBox.YES) );
					break;
			}
		}
	}
}