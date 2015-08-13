package application.view.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SoundButton extends MovieClip
	{
		public static const SOUND_ON:String = "sound_on";
		public static const SOUND_OFF:String = "sound_off";
		
		private var _soundState:Boolean;
		
		public function get soundState():Boolean
		{
			return _soundState;
		}
		
		public function set soundState(value:Boolean):void
		{
			_soundState = value;
			this.gotoAndStop( !value ? 2 : 1 );
		}
		
		public function SoundButton()
		{
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			soundState = !soundState;
			this.gotoAndStop( !soundState ? 2 : 1 );
			
			if ( !soundState )
			{
				dispatchEvent( new Event(SoundButton.SOUND_OFF) );
			}
			else
			{
				dispatchEvent( new Event(SoundButton.SOUND_ON) );
			}
		}
	}
}