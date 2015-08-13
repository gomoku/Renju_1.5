package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ToogleButton extends MovieClip
	{
		private var _label:String;
		private var _selected:Boolean = false;
		
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
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if ( value )
			{
				textField.color = 0xffac43;
				textField.setText(label);
			}
			else
			{
				textField.color = 0xffffff;
				textField.setText(label);
			}
		}
		
		public function ToogleButton()
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
			buttonHitArea.graphics.beginFill(0x000000, 0.0);
			buttonHitArea.graphics.drawRect(0, 0 , 1, 1);
			buttonHitArea.graphics.endFill();			
			
			this.addChild(textField);
			this.addChild(buttonHitArea);
		}
		
		private function onOver(event:MouseEvent):void
		{
			if ( !selected )
			{
				textField.color = 0xffe6c5;
				textField.setText(label);
			}
		}
		
		private function onOut(event:MouseEvent):void
		{
			if ( !selected )
			{
				textField.color = 0xffffff;
				textField.setText(label);
			}
		}
	}
}