package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class AlertButton extends MovieClip
	{
		private var _label:String;
		
		private var textField:Label;		
		private var buttonHitArea:MovieClip;
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			
			textField.setText(value);
			
			buttonHitArea.width = textField.width;
			buttonHitArea.height = textField.height;
		}
		
		public function AlertButton()
		{
			draw();
			this.buttonMode = true;
			this.useHandCursor = true;
			buttonHitArea.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			buttonHitArea.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		private function draw():void
		{
			// TextField setup.
			textField = new Label();
			textField.color = 0xffe6c5;
			textField.size = 24;
			textField.setText("button");
			
			// Draw hitArea.
			buttonHitArea = new MovieClip();
			buttonHitArea.graphics.beginFill(0x000000, 0.0);
			buttonHitArea.graphics.drawRect(0, 0 , 1, 1);
			buttonHitArea.graphics.endFill();			
			
			this.addChild(textField);
			this.addChild(buttonHitArea);
		}
		
		private function onOver(event:MouseEvent):void
		{
			textField.color = 0xffac43;
			textField.setText(label);
		}
		
		private function onOut(event:MouseEvent):void
		{
			textField.color = 0xffe6c5;
			textField.setText(label);
		}
	}
}