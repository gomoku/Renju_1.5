package application.utils
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	
	public class GlowFilterHelper
	{
		public static function apply(target:DisplayObject, 
									 color:Number = 0x33CCFF, 
									 alpha:Number = 0.8, 
									 blurX:Number = 35, 
									 blurY:Number = 35, 
									 strength:Number = 2, 
									 inner:Boolean = false, 
									 knockout:Boolean = false, 
									 quality:int = 3 ):void
		{
			var filter:BitmapFilter = new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
			var filters:Array = new Array();
			filters.push(filter);
			target.filters = filters;
		}
		
		public static function remove(target:DisplayObject):void
		{
			target.filters = null;
		}
	}
}