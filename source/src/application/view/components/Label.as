package application.view.components
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Label extends TextField
	{
		private var format:TextFormat;
		
		private var _size:Number = 18;
		private var _color:uint = 0xffffff;
		
		// size.
		public function get size():Number
		{
			return _size;
		}
		
		public function set size(value:Number):void
		{
			_size = value;
		}
		
		// color.
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		public function Label()
		{
			this.selectable = false;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.antiAliasType = AntiAliasType.ADVANCED;
			this.embedFonts = true;
			
			format = new TextFormat();
			format.font = "Japan";
			format.size = size;
			format.color = color;
			
			this.setTextFormat(format);
		}
		
		public function setText(value:String):void
		{
			this.text = value;
			
			format.size = size;
			format.color = color;
			this.setTextFormat(format);
		}
	}
}