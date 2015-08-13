package application.view.components
{
	import application.utils.GlowFilterHelper;
	import application.view.sounds.GameOverSound;
	import application.view.sounds.TileSound;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
	public class Board extends MovieClip
	{
		public static const TILE_CLICK:String = "tile_click";
		
		private var _boardSize:Number;
		private var _tileSize:Number;		
		private var _tileCoordinate:Object = new Object();
		private var _soundState:Boolean;
		
		// Getters/Setteres.
		// boardSize.
		public function get boardSize():Number
		{
			return _boardSize;
		}
		
		// tileSize.
		public function get tileSize():Number
		{
			return _tileSize;
		}
		
		// tileCoordinate.
		public function get tileCoordinate():Object
		{
			return _tileCoordinate;
		}
		
		// Sound state.
		public function get soundState():Boolean
		{
			return _soundState;
		}
		
		public function set soundState(value:Boolean):void
		{
			_soundState = value;
		}
		
		// Counstructor.
		public function Board(boardSize:Number, tileSize:Number)
		{
			_boardSize = boardSize;
			_tileSize = tileSize;
			
			drawBoard();
		}
		
		public function setBoardEnabled(state:Boolean):void
		{
			for ( var i:Number = 0; i < boardSize; i++ )
			{
				for ( var j:Number = 0; j < boardSize; j++ )
				{
					var tile:Tile = this.getChildByName("Tile_" + i + "_" + j) as Tile;
					
					setTileEnabled(tile, state);
				}
			}
		}
		
		public function makeFirstMove():void
		{
			var center:Number = Math.floor(boardSize / 2);
			showAIMove(center, center);
			
			if ( this.getChildByName("winLine") != null )
			{
				var winLine:Shape = this.getChildByName("winLine") as Shape;
				this.removeChild(winLine);
			}
		}
		
		public function showAIMove(x:Number, y:Number):void
		{
			var tile:Tile = this.getChildByName("Tile_" + x + "_" + y) as Tile;
			tile.gotoAndPlay("AITile");
			setTileEnabled(tile, false);
			
			var sound:Sound = new TileSound();
			if ( soundState ) sound.play();
		}
		
		public function drawWinLine(y1:Number, x1:Number, y2:Number, x2:Number, tile:Number):void
		{
			var line:Shape = new Shape();
			line.name = "winLine";
			
			// May draw different line color depending on winner.
			var color:uint = tile == 1 ? 0xffffff : 0xffffff;
			
			line.graphics.lineStyle(3, color, 1);
			line.graphics.moveTo(0, 0);
			line.graphics.lineTo(1000, 0);
			
			var kx:Number = (x1 - x2) * 20;
		    var ky:Number = (y1 - y2) * 20;
		    var distance:Number = Math.sqrt(kx * kx + ky * ky);
		    distance = distance == 0 ? 1 : distance;
		    var rotation:Number = 57.295780 * Math.acos(kx / distance);
		    rotation = y1 < y2 ? (180 - rotation) : (rotation - 180);
		    
		    line.width = distance + 5;
		    line.rotation = rotation;
		    line.x = x1 * 21 + 10.5;
		    line.y = y1 * 21 + 10.5;
			
			this.addChild(line);
			
			GlowFilterHelper.apply(line, 0xffffff, 1, 5, 5, 2);
			
			var sound:Sound = new GameOverSound();
			if ( soundState ) sound.play();
		}
		
		private function onOver(event:MouseEvent):void
		{
			event.target.gotoAndPlay("over");
		}
		
		private function onOut(event:MouseEvent):void
		{
			event.target.gotoAndPlay("out");
		}
		
		private function onClick(event:MouseEvent):void
		{
			var tile:Tile = event.target as Tile;
			
			var lastIndex:Number = tile.name.lastIndexOf("_");
			var xCoordinate:Number = Number( tile.name.substring(5, lastIndex) );
			var yCoordinate:Number = Number( tile.name.substring(lastIndex+1, tile.name.length) );
			
			_tileCoordinate.x = xCoordinate;
			_tileCoordinate.y = yCoordinate;
			
			tile.gotoAndPlay("userTile");
			setTileEnabled(tile, false);
			
			dispatchEvent( new Event(Board.TILE_CLICK) );
		}
		
		private function setTileEnabled(target:Tile, state:Boolean):void
		{
			if ( !state )
			{
				target.buttonMode = false;
				target.useHandCursor = false;
				target.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				target.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				target.removeEventListener(MouseEvent.CLICK, onClick);
			}
			else
			{
				target.gotoAndStop(1);
				target.buttonMode = true;
				target.useHandCursor = true;
				target.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				target.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				target.addEventListener(MouseEvent.CLICK, onClick);
			}
		}
		
		private function drawBoard():void
		{
			var boardDims:Number = boardSize * tileSize;
			
			// Border & background.
			var border:Shape = new Shape();
			var bg:Shape = new Shape();
			
			this.addChild( drawRect(border, 0xffffff, -1, -1, boardDims + 2, boardDims + 2) );
			this.addChild( drawRect(bg, 0x000000, 0, 0, boardDims, boardDims) );
			
			// Tiles.
			for ( var i:Number = 0; i < boardSize; i++ )
			{
				for ( var j:Number = 0; j < boardSize; j++ )
				{
					var tile:Tile = new Tile();
					tile.name = "Tile_" + i + "_" + j;
					tile.x = j * tile.width;
					tile.y = i * tile.height;
					this.addChild(tile);
				}
			}
		}
		
		private function drawRect(target:Shape, color:uint, x:Number, y:Number, width:Number, height:Number):Shape
		{
			var target:Shape = new Shape();
			target.graphics.beginFill(color, 1);
			target.graphics.drawRect(x, y, width, height);
			target.graphics.endFill();
			
			return target;
		}
	}
}