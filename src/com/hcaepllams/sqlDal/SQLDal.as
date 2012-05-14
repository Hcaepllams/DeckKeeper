package com.hcaepllams.sqlDal
{
	import com.hcaepllams.game.Game;
	import com.hcaepllams.game.GameManager;
	import com.hcaepllams.utils.MyDate;
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.MySqlResponse;
	import com.maclema.mysql.MySqlToken;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.Statement;
	import com.maclema.mysql.events.MySqlErrorEvent;
	import com.maclema.mysql.events.MySqlEvent;
	
	import flash.events.EventDispatcher;
	
	import mx.rpc.AsyncResponder;
	
	public class SQLDal extends EventDispatcher
	{
		private static const SQL_GET_ALL_PLAYERS:String = "SELECT * FROM players";
		private static const SQL_INSERT_A_GAME:String = "INSERT INTO `deckkeeper`.`games` (`Date`, `Players`) VALUES ";
		private static const SQL_GET_A_GAME_BY_DATE:String = "SELECT * FROM games WHERE Date = '";//SELECT * FROM employees WHERE employeeID = ?
		private static const SQL_UPDATE_A_GAME:String = "UPDATE `deckkeeper`.`games` SET `Players`='";
		private static const SQL_UPDATE_A_GAME_PART2:String = "' WHERE `Date`='";	
		
		private var _state:Statement;
		
		
		public function SQLDal(state:Statement)
		{
			_state = state;
		}
		
		public function getAllPlayers():void
		{
			var token:MySqlToken = _state.executeQuery(SQL_GET_ALL_PLAYERS);
        	token.addResponder(new AsyncResponder(result, fault, token));
		}
		
		public function createANewGame(date:MyDate):void
		{
			var sqlText:String = SQL_INSERT_A_GAME + "('" + date.getMyDate() + "', '1,2,3,4,5,6,7,8');";			
			var token:MySqlToken = _state.executeQuery(sqlText);			
        	token.addResponder(new AsyncResponder(result, fault, token));
		}
		
		public function getGameByDate(date:MyDate):void
		{
			var text:String = SQL_GET_A_GAME_BY_DATE + date.getMyDate() + "';";
       		var token:MySqlToken = _state.executeQuery();			
        	token.addResponder(new AsyncResponder(result, fault, token));
		}
		
		public function updateGame():void
		{
			var date:MyDate = new MyDate(new Date);
			var game:Game = GameManager.instance.getGameByDate(date);
			var text:String = SQL_UPDATE_A_GAME + game.getPlayersIndexString() + "'" + SQL_UPDATE_A_GAME_PART2 + date.getMyDate() + "';";
			var token:MySqlToken = _state.executeQuery();			
        	token.addResponder(new AsyncResponder(result, fault, token));
		}
		
		private function result(data:Object, token:Object):void {
			if (data is MySqlResponse)
			{
				trace (data.toString());
			}
			else
			{
				var rs:ResultSet;
	        	rs = ResultSet(data);	         
	        	this.dispatchEvent(new SQLResultEvent(SQLResultEvent.ON_RESULT_GET, rs));	
			}	        	        
		}
		
		private function fault(info:Object, token:Object):void {
			trace (info);
		}
		

	}
}