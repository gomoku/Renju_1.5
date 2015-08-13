package application.utils
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	
	public class DropShadowFilterHelper
	{
		public static function apply(target:DisplayObject, 
									 distance:Number = 4, angle:Number = 45, color:uint = 0,
									 alpha:Number = 1, blurX:Number = 4, blurY:Number = 4, 
									 strength:Number = 1, quality:int = 1, 
									 inner:Boolean = false, knockout:Boolean = false, 
									 hideObject:Boolean = false):void
		{
			var filter:BitmapFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
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