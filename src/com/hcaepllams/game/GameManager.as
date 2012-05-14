package com.hcaepllams.game
{
	import com.hcaepllams.sqlDal.SQLDal;
	import com.hcaepllams.sqlDal.SQLDalManager;
	import com.hcaepllams.sqlDal.SQLResultEvent;
	import com.hcaepllams.utils.MyDate;
	import com.maclema.mysql.Statement;
	
	import flash.utils.Dictionary;

	public class GameManager
	{
		private static var _instance:GameManager;
		
		private var games:Dictionary;
		
		public function GameManager()
		{
			if (_instance != null)
			{
				return;
			}
			games = new Dictionary();
		}
		
		public static function get instance():GameManager
		{
			if (_instance == null)
			{
				_instance = new GameManager();
			}
			return _instance;
		}		
		
		public function getGameByDate(date:MyDate):Game
		{
			return games[date.getMyDate()];
		}
		
		public function createNewGame(date:MyDate):void
		{
			if (games[date.getMyDate()] == null)
			{
				games[date.getMyDate()] = new Game(date);
				
				var dal:SQLDal = SQLDalManager.instance.getADal();
				dal.createANewGame(date);
				dal.addEventListener(SQLResultEvent.ON_RESULT_GET, onGameCreated);
			}
		}
		
		private function onGameCreated(e:SQLResultEvent):void
		{
			trace ("game created");
		}
	}
}