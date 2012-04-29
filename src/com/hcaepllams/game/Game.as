package com.hcaepllams.game
{
	import com.hcaepllams.user.Player;
	import com.hcaepllams.user.PlayerManager;
	import com.hcaepllams.utils.MyDate;

	public class Game
	{
		private var _players:Vector.<Player>;
		private var _absentPlayers:Vector.<Player>;
		private var _time:MyDate;
		
		public function Game(time:MyDate)
		{
			_time = time;
			
			_players = PlayerManager.instance.getAllPlayers();
			_absentPlayers = new Vector.<Player>;
		}
		
		public function getPlayers():Vector.<Player>
		{
			return _players;
		}
		
		public function getAbsentPlayers():Vector.<Player>
		{
			return _absentPlayers;
		}
		
		public function removePlayers(player:Player):Vector.<Player>
		{
			var index:int = _players.indexOf(player);
			if (index > 0)
			{
				_players.splice(index, 1);
				_absentPlayers.push(player);
			}
			
			return _players;
		}
	}
}