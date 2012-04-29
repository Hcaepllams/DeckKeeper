package com.hcaepllams.game
{
	import com.hcaepllams.utils.MyDate;
	
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
			if (games[date.getMyDate()] == null)
			{
				createNewGame(date);
			}
			return games[date.getMyDate()];
		}
		
		public function createNewGame(date:MyDate):void
		{
			if (games[date.getMyDate()] == null)
			{
				games[date.getMyDate()] = new Game(date);
			}
		}
	}
}