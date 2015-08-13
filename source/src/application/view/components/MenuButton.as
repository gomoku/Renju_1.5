package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class MenuButton extends MovieClip
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
		
		public function MenuButton()
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
			textField.setText("button");
			
			// Draw hitArea.
			buttonHitArea = new MovieClip();
			buttonHitArea.graphics.beginFill(0x000000, 0.1);
			buttonHitArea.graphics.drawRect(0, 0 , 1, 1);
			buttonHitArea.graphics.endFill();			
			
			this.addChild(textField);
			this.addChild(buttonHitArea);
		}
		
		private function onOver(event:MouseEvent):void
		{
			textField.color = 0xcccccc;
			textField.setText(label);
		}
		
		private function onOut(event:MouseEvent):void
		{
			textField.color = 0xffffff;
			textField.setText(label);
		}
	}
}