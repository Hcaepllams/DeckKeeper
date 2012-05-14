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
		
		public function getPlayersIndexString():String
		{
			var returnText:String = "";
			for (var i:int = 0; i < _players.length; i ++)
			{
				if (i == _players.length - 1)
				{
					returnText += (_players[i] as Player).index;
				} 
				else
				{
					returnText += (_players[i] as Player).index + ",";
				}
			}
			return returnText;
		}
		
		public function getAbsentPlayers():Vector.<Player>
		{
			return _absentPlayers;
		}
		
		private function setPlayers(value:Vector.<Player>):void
		{
			_players = value;
		}
		
		private function setAbsentPlayers(value:Vector.<Player>):void
		{
			_absentPlayers = value;
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
		
		public function duplicated():Game
		{
			var game:Game = new Game(new MyDate(new Date));
			var absents:Vector.<Player> = new Vector.<Player>;
			for (var i:int = 0; i < _absentPlayers.length; i ++)
			{
				absents.push(_absentPlayers[i]);
			}
			
			var players:Vector.<Player> = new Vector.<Player>;
			for (var j:int = 0; j < _players.length; j ++)
			{
				players.push(_players[j]);
			}
			
			game.setPlayers(players);
			game.setAbsentPlayers(absents);
			return game;
		}
		
		public function equal(game:Game):Boolean
		{
			var players:Vector.<Player> = game.getPlayers();
			var absents:Vector.<Player> = game.getAbsentPlayers();
			
			if (players.length != _players.length)
			{
				return false;
			}
			
			if (absents.length != _absentPlayers.length)
			{
				return false;
			}
			
			for (var i:int = 0; i < players.length; i ++)
			{
				if (_players.indexOf(players[i]) < 0)
				{
					return false;
				}
			}
			
			for (var j:int = 0; j < absents.length; j ++)
			{
				if (_absentPlayers.indexOf(absents[i]) < 0)
				{
					return false;
				}
			}
			return true;
		}
	}
}