package application.model
{
	import application.ApplicationFacade;
	
	import com.ericfeminella.collections.IMap;
	import com.ericfeminella.collections.LocalPersistenceMap;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DataProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "DataProxy";
		
		public static const EASY:Number = 1;
		public static const NORMAL:Number = 2;
		public static const HARD:Number = 3;
		
		// Defaults.
		private var _boardSize:Number = 15;
		private var _tileSize:Number = 21;
		private var _inGame:Boolean = false;
		
		private var centerTile:Number = Math.floor(boardSize / 2);
		
		private var _AIWinCount:Number = 0;
		private var _userWinCount:Number = 0;
		
		private var _level:Number;
		
		private var map:IMap;
		
		private var _soundState:Boolean;
		
		// Logic variables.
		private var userTile:Number = 1;
		private var AITile:Number = -1;
		private var winningMove:Number = 9999999;
		private var openFour:Number = 8888888;
		private var twoThrees:Number = 7777777;
		private var movesArray:Array = new Array();
		private var nPosition:Array = new Array();
		private var w:Array = new Array(0, 20, 17, 15.400000, 14, 10);
		private var userArray:Array = new Array();
		private var AIArray:Array = new Array();
		private var iMax:Array = new Array();
		private var jMax:Array = new Array();
		private var directionArray:Array = new Array();
		private var nMax:Number = 0;
		private var drawPosition:Boolean;
		
		private var winningY1:Number;
		private var winningX1:Number;
		private var winningY2:Number;
		private var winningX2:Number;
		
		// Getters/Setters.
		// Board.
		public function get boardSize():Number
		{
			return _boardSize;
		}
		
		// Tile.
		public function get tileSize():Number
		{
			return _tileSize;
		}
		
		// inGame.
		public function get inGame():Boolean
		{
			return _inGame;
		}
		
		public function set inGame(value:Boolean):void
		{
			_inGame = value;
		}
		
		// AI win count.
		public function get AIWinCount():Number
		{
			return _AIWinCount;
		}
		
		public function set AIWinCount(value:Number):void
		{
			_AIWinCount = value;
		}
		
		// user win count.
		public function get userWinCount():Number
		{
			return _userWinCount;
		}
		
		public function set userWinCount(value:Number):void
		{
			_userWinCount = value;
		}
		
		// Level.
		public function get level():Number
		{
			return _level;
		}
		
		public function set level(value:Number):void
		{
			if ( value <= 3 && value >= 1 )
			{
				_level = value;
				map.put("level", value);
			}
			else
			{
				trace("Wrong value.");
			}
		}
		
		// soundState.
		public function get soundState():Boolean
		{
			return _soundState;
		}
		
		public function set soundState(value:Boolean):void
		{
			_soundState = value;
			sendNotification(ApplicationFacade.SOUND_CHANGE, value);
			map.put("soundState", value);
		}
		
		// Constructor.
		public function DataProxy()
		{
			super(NAME);
			
			map = new LocalPersistenceMap("storage", "/");
			
			if ( !map.containsKey("level") )
			{
				map.put("level", DataProxy.NORMAL);
				map.put("soundState", true);
			}
			
			this.level = map.getValue("level");
			this.soundState = map.getValue("soundState");
			
			// Fill default arrays.
			for ( var i:Number = 0; i < boardSize; i++ )
			{
				movesArray[i] = new Array();
				userArray[i] = new Array();
				AIArray[i] = new Array();
				
				for ( var j:Number = 0; j < boardSize; j++ )
				{
					if ( i == this.centerTile && j == this.centerTile )
					{
						movesArray[i][j] = -1;
						AIArray[i][j] = -1;
					}
					else
					{
						movesArray[i][j] = 0;
						AIArray[i][j] = 0;
					}
					userArray[i][j] = 0;
				}
			}
		}
		
		public function userMove(x:Number, y:Number):void
		{
			movesArray[x][y] = userTile;
			
			if ( isWinner(x, y, userTile) == winningMove )
			{
				userWinCount++;
				inGame = false;
				sendNotification( ApplicationFacade.GAME_OVER, wrapWinCoordinates(userTile) );
				resetGame();
			}
			else
			{
				AIMove();
			}
		}
		
		public function resetGame():void
		{
			for ( var i:Number = 0; i < boardSize; i++ )
			{
				for ( var j:Number = 0; j < boardSize; j++ )
				{
					if ( i == centerTile && j == centerTile ) 
					{
						movesArray[i][j] = -1;
					}
					else
					{
						movesArray[i][j] = 0;
					}
				}
			}
		}
		
		// @tile - checks over user or AI tile.	
		private function isWinner(x:Number, y:Number, tile:Number):Number
		{
			var testForThree:Number = 0;
			var testForFour:Number = 0;
			var length:Number = 1;
			
			// Horizontal check.
			for ( var m:Number = 1; y + m < boardSize && movesArray[x][y + m] == tile; m++ )
			{
				length++;
			}
			var m1:Number = m;
			
			for ( m = 1; y - m >= 0 && movesArray[x][y - m] == tile; m++ )
			{
				length++;
			}
			var m2:Number = m;
			
			if ( length > 4 ) 
			{
				winningY1 = x;
				winningX1 = y - m2 + 1;
				winningY2 = x;
				winningX2 = y + m1 - 1;
				return winningMove;			
			}
			
			// Check if there are horizontal 2 by 3 lines or 1 by 4 line, for AI to respond.
			var side1:Boolean = y + m1 < boardSize && movesArray[x][y + m] == 0;
			var side2:Boolean = y - m2 >= 0 && movesArray[x][y - m] == 0;
			
			if ( length == 4 && (side1 || side2) ) testForThree++;
			
			if ( side1 || side2 )
			{
				if ( length == 4 ) testForFour = 1;
				if ( length == 3 ) testForThree++;
			}
			
			// Vertical check.
			length = 1;
			for ( m = 1; x + m < boardSize && movesArray[x + m][y] == tile; m++ )
			{
				length++;
			}
			m1 = m;
			
			for ( m = 1; x - m >= 0 && movesArray[x - m][y] == tile; m++ )
			{
				length++;
			}
			m2 = m;
			
			if ( length > 4 )
			{
				winningY1 = x - m2 + 1;
				winningX1 = y;
				winningY2 = x + m1 - 1;
				winningX2 = y;
				return winningMove;			
			}
			
			side1 = x + m1 < boardSize && movesArray[x + m1][y] == 0;
			side2 = x - m2 >= 0 && movesArray[x - m2][y] == 0;
			
			if ( length == 4 && (side1 || side2) ) testForThree++;
			
			if ( side1 || side2 )
			{
				if ( length == 4 ) testForFour = 1;
				if ( length == 3 ) testForThree++;
			}
			
			// Dioganal check [\].
			length = 1;
			for ( m = 1; x + m < boardSize && y + m < boardSize && movesArray[x + m][y + m] == tile; m++ )
			{
				length++;
			}
			m1 = m
			
			for ( m = 1; x - m >= 0 && y - m >= 0 && movesArray[x - m][y -m] == tile; m++ )
			{
				length++;
			}
			m2 = m;
			
			if ( length > 4 )
			{
				winningY1 = x - m2 + 1;
				winningX1 = y - m2 + 1;
				winningY2 = x + m1 - 1;
				winningX2 = y + m1 - 1;
				return winningMove;			
			}
			
			side1 = x + m1 < boardSize && y + m1 < boardSize && movesArray[x + m1][y + m1] == 0;
			side2 = x - m2 >= 0 && y - m2 >= 0 && movesArray[x - m2][y - m2] == 0;
			
			if ( length == 4 && (side1 || side2) ) testForThree++;
			
			if ( side1 || side2 )
			{
				if ( length == 4 ) testForFour = 1;
				if ( length == 3 ) testForThree++;
			}
			
			// Dioganal check [/].
			length = 1;
			for ( m = 1; x + m < boardSize && y - m < boardSize && movesArray[x + m][y - m] == tile; m++ )
			{
				length++;
			}
			m1 = m;
			
			for ( m = 1; x - m >= 0 && y + m < boardSize && movesArray[x - m][y + m] == tile; m++ )
			{
				length++;
			}
			m2 = m;
			
			if ( length > 4 )
			{
				winningY1 = x - m2 + 1;
				winningX1 = y + m2 - 1;
				winningY2 = x + m1 - 1;
				winningX2 = y - m1 + 1;
				return winningMove;			
			}
			
			side1 = x + m1 < boardSize && y - m1 >= 0 && movesArray[x + m1][y - m1] == 0;
			side2 = x - m2 >= 0 && y + m2 < boardSize && movesArray[x - m2][y + m2] == 0;
			
			if ( length == 4 && (side1 || side2) ) testForThree++;
			
			if ( side1 || side2 )
			{
				if ( length == 4 ) testForFour = 1;
				if ( length == 3 ) testForThree++;
			}
			
			if ( testForFour == 1 ) return openFour;
			if ( testForThree >= 2 ) return twoThrees;
			
			return -1;
		}
		
		private function AIMove():void
		{
			var maxS:Number = evaluatePosition(userArray, userTile);
			var maxQ:Number = evaluatePosition(AIArray, AITile);
			
			if ( maxQ >= maxS )
			{
				maxS = -1;
				
				for ( var i:Number = 0; i < boardSize; i++ )
				{
					for ( var j:Number = 0; j < boardSize; j++ )
					{
						if ( AIArray[i][j] == maxQ )
		                {
		                    if ( maxS < userArray[i][j] )
		                    {
		                        maxS = userArray[i][j];
		                        nMax = 0;
		                    }
		                    if ( userArray[i][j] == maxS )
		                    {
		                        iMax[nMax] = i;
		                        jMax[nMax] = j;
		                        nMax++;
		                    }
		                }
					}
				}
			}
			else
			{
				maxQ = -1;
		        for ( i = 0; i < boardSize; i++ )
		        {
		            for ( j = 0; j < boardSize; j++ )
		            {
		                if ( userArray[i][j] == maxS )
		                {
		                    if ( maxQ < AIArray[i][j] )
		                    {
		                        maxQ = AIArray[i][j];
		                        nMax = 0;
		                    }
		                    if ( AIArray[i][j] == maxQ )
		                    {
		                        iMax[nMax] = i;
		                        jMax[nMax] = j;
		                        nMax++;
		                    } 
		                }
		            }
		        }
			}
			
			var randomK:Number = Math.floor( nMax * Math.random() );

			var xAI:Number = iMax[randomK];
    		var yAI:Number = jMax[randomK];
    		
    		movesArray[xAI][yAI] = AITile;
    		
    		var coordinates:Object = new Object();
    		coordinates.x = xAI;
    		coordinates.y = yAI;
    		
    		sendNotification(ApplicationFacade.AI_MOVE, coordinates);
    		
    		if ( isWinner(xAI, yAI, AITile) == winningMove )
    		{
    			AIWinCount++;
    			inGame = false;
    			sendNotification( ApplicationFacade.GAME_OVER, wrapWinCoordinates(AITile) );
    			resetGame();
    		}
    		else if ( drawPosition )
    		{
    			sendNotification(ApplicationFacade.DRAWN_GAME);
    			inGame = false;
    			resetGame();
    		}
		}
		
		private function evaluatePosition(array:Array, tile:Number):Number
		{
			var maxA:Number = -1;
			drawPosition = true;
			
			for ( var i:Number = 0; i < boardSize; i++ )
			{
				for ( var j:Number = 0; j < boardSize; j++ )
				{
					if ( movesArray[i][j] != 0 )
					{
						array[i][j] = -1;
						continue;
					}
					if ( hasNeighbors(i, j) == false )
					{
						array[i][j] = -1;
						continue;
					}
					var winningMove:Number = isWinner(i, j, tile);
					
					if ( winningMove > 0 )
					{
						switch ( level )
						{
							case DataProxy.EASY:
								array[i][j] = Math.floor( (Math.random() * 2)+1) == 1 ? winningMove : -1;
								break;
								
							case DataProxy.NORMAL:
								array[i][j] = Math.floor( (Math.random() * 2)+1) == 1 ? winningMove : -1;
								if ( array[i][j] == -1 ) array[i][j] = Math.floor( (Math.random() * 2)+1) == 1 ? winningMove : -1;
								break;
							
							case DataProxy.HARD:
								array[i][j] = winningMove;
								break;
						}
					}
					else
					{
						var minM:Number = i - 4;
						if ( minM < 0 )	minM = 0;
						
						var minN:Number = j - 4;
						if ( minN < 0 ) minN = 0;
						
						var maxM:Number = i + 5;
						if ( boardSize < maxM ) maxM = boardSize;
						
						var maxN:Number = j + 5;
						if ( boardSize < maxN ) maxN = boardSize;
						
						// 1.
						nPosition[1] = 1;
						var A1:Number = 0;
						
						for ( var m:Number = 1; j + m < maxN && movesArray[i][j + m] != -tile; m++ )
						{
							nPosition[1]++;
							A1 = A1 + w[m] * movesArray[i][j + m];
						}
						
						if ( j + m >= boardSize || movesArray[i][j + m] == -tile )
						{
							A1 = A1 + ( movesArray[i][j + m - 1] == tile ? (w[5] * tile) : (0) );
						}
						
						for ( m = 1; j - m >= minN && movesArray[i][j - m] != -tile; m++ )
		                {
		                    nPosition[1]++;
		                    A1 = A1 + w[m] * movesArray[i][j - m];
		                }
		                
		                if (j - m < 0 || movesArray[i][j - m] == -tile)
		                {
		                    A1 = A1 - ( movesArray[i][j - m + 1] == tile ? (w[5] * tile) : (0) );
		                }
		                if (nPosition[1] > 4) drawPosition = false;
		                
		                // 2.
		                nPosition[2] = 1;
		                var A2:Number = 0;
		                
		                for ( m = 1; i + m < maxM && movesArray[i + m][j] != -tile; m++ )
		                {
		                    nPosition[2]++;
		                    A2 = A2 + w[m] * movesArray[i + m][j];
		                }
		                
		                if ( i + m >= boardSize || movesArray[i + m][j] == -tile )
		                {
		                    A2 = A2 - ( movesArray[i + m - 1][j] == tile ? (w[5] * tile) : (0) );
		                }
		                
		                for ( m = 1; i - m >= minM && movesArray[i - m][j] != -tile; m++ )
		                {
		                    nPosition[2]++;
		                    A2 = A2 + w[m] * movesArray[i - m][j];
		                }
		                
		                if ( i - m < 0 || movesArray[i - m][j] == -tile)
		                {
		                    A2 = A2 - (movesArray[i - m + 1][j] == tile ? (w[5] * tile) : (0) );
		                }
		                if ( nPosition[2] > 4 ) drawPosition = false;
		                
		                // 3.
		                nPosition[3] = 1;
		                var A3:Number = 0;
		                
		                for ( m = 1; i + m < maxM && j + m < maxN && movesArray[i + m][j + m] != -tile; m++ )
		                {
		                    nPosition[3]++;
		                    A3 = A3 + w[m] * movesArray[i + m][j + m];
		                }
		                
		                if ( i + m >= boardSize || j + m >= boardSize || movesArray[i + m][j + m] == -tile)
		                {
		                    A3 = A3 - ( movesArray[i + m - 1][j + m - 1] == tile ? (w[5] * tile) : (0) );
		                }
		                
		                for ( m = 1; i - m >= minM && j - m >= minN && movesArray[i - m][j - m] != -tile; m++)
		                {
		                    nPosition[3]++;
		                    A3 = A3 + w[m] * movesArray[i - m][j - m];
		                }
		                
		                if ( i - m < 0 || j - m < 0 || movesArray[i - m][j - m] == -tile )
		                {
		                    A3 = A3 - ( movesArray[i - m + 1][j - m + 1] == tile ? (w[5] * tile) : (0) );
		                }
		                if (nPosition[3] > 4) drawPosition = false;
		                
		                // 4.
		                nPosition[4] = 1;
		                var A4:Number = 0;
		                
		                for ( m = 1; i + m < maxM && j - m >= minN && movesArray[i + m][j - m] != -tile; m++)
		                {
		                    nPosition[4]++;
		                    A4 = A4 + w[m] * movesArray[i + m][j - m];
		                }
		                
		                if ( i + m >= boardSize || j - m < 0 || movesArray[i + m][j - m] == -tile )
		                {
		                    A4 = A4 - ( movesArray[i + m - 1][j - m + 1] == tile ? (w[5] * tile) : (0) );
		                }
		                
		                for ( m = 1; i - m >= minM && j + m < maxN && movesArray[i - m][j + m] != -tile; m++ )
		                {
		                    nPosition[4]++;
		                    A4 = A4 + w[m] * movesArray[i - m][j + m];
		                }
		                
		                if ( i - m < 0 || j + m >= boardSize || movesArray[i - m][j + m] == -tile)
		                {
		                    A4 = A4 - ( movesArray[i - m + 1][j + m - 1] == tile ? (w[5] * tile) : (0) );
		                }
		                if (nPosition[4] > 4) drawPosition = false;
		                
		                // final.
		                directionArray[1] = nPosition[1] > 4 ? (A1 * A1) : (0);
		                directionArray[2] = nPosition[2] > 4 ? (A2 * A2) : (0);
		                directionArray[3] = nPosition[3] > 4 ? (A3 * A3) : (0);
		                directionArray[4] = nPosition[4] > 4 ? (A4 * A4) : (0);
		                
		                A1 = 0;
		                A2 = 0;
		                
		                for ( var k:Number = 0; k < 5; k++ )
		                {
		                	if ( directionArray[k] >= A1 )
		                	{
		                		A2 = A1;
		                		A1 = directionArray[k];
		                	}
		                }
		                
		                array[i][j] = A1 + A2;
					}
					if ( maxA < array[i][j] ) maxA = array[i][j];
				}
			}
			
			return maxA;
		}
		
		private function hasNeighbors(x:Number, y:Number):Boolean
		{
			if ( y > 0 && movesArray[x][y - 1] != 0 ) return true;			
			if ( y + 1 < boardSize && movesArray[x][y + 1] != 0 ) return true;
			
			if ( x > 0 )
			{
				if ( movesArray[x - 1][y] != 0 ) return true;				
				if ( y > 0 && movesArray[x - 1][y - 1] != 0 ) return true;				
				if ( y + 1 < boardSize && movesArray[x - 1][y + 1] != 0 ) return true;
			}
			
			if ( x + 1 < boardSize )
			{
				if ( movesArray[x + 1][y] != 0 ) return true;
				if ( y > 0 && boardSize && movesArray[x + 1][y - 1] != 0 ) return true;
				if ( y + 1 <  boardSize && movesArray[x + 1][y + 1] != 0 ) return true;
			}
			
			return false;
		}
		
		private function wrapWinCoordinates(tile:Number):Object
		{
			var winCoordinates:Object = new Object();
			winCoordinates.y1 = winningY1;
			winCoordinates.x1 = winningX1;
			winCoordinates.y2 = winningY2;
			winCoordinates.x2 = winningX2;
			winCoordinates.tile = tile;
			
			return winCoordinates;
		}
	}
}