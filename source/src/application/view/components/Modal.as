package application.view.components
{
	import flash.display.MovieClip;
	
	public class Modal extends MovieClip
	{
		public function Modal()
		{
			drawBox();
			this.alpha = 0;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			this.width = w;
			this.height = h;
		}
		
		private function drawBox():void
		{
			this.graphics.beginFill(0x000000, 0.3);
			this.graphics.drawRect(0, 0, 8, 8);
			this.graphics.endFill();
		}
	}
}