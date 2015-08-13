package application.model
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class InfoProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "InfoProxy";
		
		private var _rules:String;
		private var _history:String;
		
		public function get rules():String
		{
			return  "The board has 15x15 lines. " + 
					"At first, the board is empty.\n\nThe player " + 
					"with the black stones begins the game. " + 
					"The first move has to be made to the center of the board.\n\n" + 
					"All the moves are placed on the lines intersections " + 
					"instead of placing them in the middle of the squares.(" + 
					"It has been a long tradition for hundreds of years and we " + 
					"keep it, too).\n\nAfter that, white makes the move to any " + 
					"vacant spot on the board.\n\nThe players take turns, " + 
					"placing the moves on the board.\n\nThe player wins " + 
					"the game when he gets 5 of his own stones in a row\n";
		}
		
		public function get history():String
		{
			return  "The first references comes from the surrounding of the " + 
					"river´s Hwang Ho delta in China. They are dated to the period " + 
					"about 2000 BC - so renju is about 4000 years old!!!\n\n" + 
					"Independently of China the indications about this game were " + 
					"found actually in ancient Greece and pre-Columbus America." + 
					"In Japan gomoku with rules is played for hundreds of years, " + 
					"maybe from the 7th century BC. In this time Go came into Japan.\n\n" + 
					"The game is often called Go-moku, but also another names are known, " + 
					"often specific for the specific country - kakugo, gomoku-narase, " + 
					"itsutsu-ishi, gobang, morphion, luffarschack, piskvorky, omok, " + 
					"wuzigi, connect5, nought and crosses, 5 in a row, rendzu, caro, " + 
					"kolko i kryzyk...\n\n" + 
					"Scientists in Japan argue if the game kakugo - presented in old " + 
					"papers - is today´s gomoku. When the first book about our game was " + 
					"published (1858BC), the game was called kakugo. But the ancient " + 
					"Chinese game wutzu used to be also considered as a antecedent of today´s gomoku.\n\n" + 
					"In the course of time the level of players get so high that they found out, " + 
					"that the gomoku rules gives a very big advantage for the black player.\n\n" + 
					"It is prooved, that with this rules Black has sure win." + 
					"In the year 1899 the Japanese players tried to play with some forbidden moves " + 
					"(the restriction was - not to make double three for both players - so called foul).\n\n" + 
					"On 6th December 1899 the first Japanese meijin called this game renju, what means 'pearl in a line' " + 
					"in translation. In the year 1903 the rules were changed a little and the " + 
					"double three was foul only for Black.\n\n" + 
					"In the year 1912 it was decided, that Black loses, if he make the double three " + 
					"even if he is only in defence.\n\n" + 
					"The year 1916 involved another restriction for Black - since this time he " + 
					"can´t make an overline (6 and more in a row).\n\n" + 
					"1918 - another foul - thisonce he can´t make 4x3x3 by one move. " + 
					"But making of 5x3x3 was still allowed.\n\n" + 
					"In the year 1931 the 3rd mejin Takagi Rakazan (maijin- now the player, " + 
					"who annually wins the final match, which included 5 games with 5hours " + 
					"limit per player) proposed another two rules. The first one - reducing " + 
					"of the board size from 19x19 to 15x15 and the second one - foul 4x4.\n\n" + 
					"The sense of all these restrictions is to make the equal chances for both players." + 
					"In the year 1966 all main organizations in Japan joined and set up Nihon Renju Sha, " + 
					"which is called the Japanese Renju Federation nowadays. And also a decision about " + 
					"way of openings was made. On 2nd February 1958 the Swedish Asociation was established " + 
					"and the Russian Renju Federation followed in August 1979.\n\n" + 
					"The Renju International Federation set in the year 1988 in Stockholm in Sweden. " + 
					"The world championships began to be organised. The first one was held in Kyoto in " + 
					"the year 1989 followed by Moscow (Russia) 1991, Arjeplog (Sweden) 1993, Tallinn " + 
					"(Estonia) 1995, Saint-Petersburg (Russia) 1997, Beijing (China) 1999. Kyoto " + 
					"(Japan) 2001 and finally Vadstena (Sweden) 2003..\n\n" + 
					"The winner of the first two championships was Shigeru Nakamura." + 
					"Nowadays, RIF has these members:" + 
					"Japan, Russia, Sweden - these are the founders, others - Estonia. " + 
					"The Czech Republic, Armenia, Azerbaijan, Uzbekistan, China, Taiwan, " + 
					"the Republic of South Korea, Kanada" + 
					"States, which were members, but didn´t pay the fee: Latvia, Belarus, Ukraine" + 
					"Another countries, where some players could be found: the USA, Finland, " + 
					"Nederlands, Italy, Australia, Austria, Denmark, France, " + 
					"Moldavia, Poland, Romania, Kazachstan, Hungary, Norway.\n\n" + 
					"Author: Kaprar";
		}
		
		public function InfoProxy()
		{
			super(NAME);
		}
	}
}