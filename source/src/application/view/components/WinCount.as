package application.view.components
{
	import flash.display.MovieClip;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class WinCount extends MovieClip
	{
		private var countText:TextField;
		private var format:TextFormat;
		
		public function WinCount()
		{
			drawContent();
		}
		
		public function set text(value:String):void
		{
			countText.text = value;
			countText.setTextFormat(format);
			var spark:Spark = new Spark();
			spark.x = 24;
			spark.y = 2;
			
			this.addChild(spark);
		}
		
		private function drawContent():void
		{
			countText = new TextField();
			countText.autoSize = TextFieldAutoSize.LEFT;
			countText.antiAliasType = AntiAliasType.ADVANCED;
			countText.selectable = false;
			
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 9;
			format.color = 0xD2B27A;
			
			countText.setTextFormat(format);
			
			this.addChild(countText);
		}
	}
}