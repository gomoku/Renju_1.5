package application.view.components
{
	import fl.controls.UIScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class InfoBox extends MovieClip
	{
		public static const CLOSE:String = "close";
		
		private var _title:String;
		private var _message:String;
		
		private var titleTF:Label;
		private var messageTF:TextField;
		
		public function get title():String
		{
			return _title;
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function InfoBox(title:String, message:String)
		{
			this.alpha = 0;
			this._title = title;
			this._message = message;
			this.draw();
		}
		
		private function draw():void
		{
			// Title.
			titleTF = new Label();
			titleTF.size = 24;
			titleTF.color = 0xffae3b;
			titleTF.setText(title);
			titleTF.x = 30;
			titleTF.y = 20;
			
			// Message.
			messageTF = new TextField();
			messageTF.selectable = false;
			messageTF.multiline = true;
			messageTF.wordWrap = true;
			messageTF.x = titleTF.x;
			messageTF.y = titleTF.y + titleTF.height + 10;
			messageTF.width = this.width - 75;
			messageTF.height = this.height - 110;
			messageTF.text = message;
			
			var messageFormat:TextFormat = new TextFormat();
			messageFormat.font = "Verdana";
			messageFormat.size = 12;
			messageFormat.letterSpacing = 2;
			messageFormat.color = 0xffffff;
			messageFormat.leading = 5;
			
			messageTF.setTextFormat( messageFormat );
			
			// Scroll.
			var scroll:UIScrollBar = new UIScrollBar();
			scroll.move( Math.round(messageTF.x + messageTF.width), Math.round(messageTF.y));
			scroll.setSize(13, messageTF.height);
			scroll.scrollTarget = messageTF;
			
			// CloseButton.
			var closeButton:AlertButton = new AlertButton();
			closeButton.label = "close";
			closeButton.addEventListener(MouseEvent.CLICK, onClose);
			closeButton.x = Math.round( (this.width - closeButton.width) / 2 );
			closeButton.y = Math.round( messageTF.y + messageTF.height + 5 );
			
			this.addChild(titleTF);
			this.addChild(messageTF);
			this.addChild(scroll);
			this.addChild(closeButton);
		}
		
		private function onClose(event:MouseEvent):void
		{
			dispatchEvent( new Event(InfoBox.CLOSE) );
		}
	}
}