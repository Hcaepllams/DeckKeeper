package com.hcaepllams.sqlDal
{
	import com.hcaepllams.sqlDal.SQLResultEvent;
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.MySqlToken;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.Statement;
	import com.maclema.mysql.events.MySqlErrorEvent;
	import com.maclema.mysql.events.MySqlEvent;
	
	import mx.rpc.AsyncResponder;	
	import flash.events.EventDispatcher;
	
	public class SQLDal extends EventDispatcher
	{
		//private const static SQL_GET_ALL_PLAYERS:String = "SELECT * FROM players";
		//private const static SQL_INSERT_A_GAME:String = "INSERT INTO `deckkeeper`.`games` (`idGames`, `Date`, `Players`) VALUES (0, '2012.5.3', '0,1,2,3,4,5,6,7');";
		
		private var _state:Statement;
		
		
		public function SQLDal(state:Statement)
		{
			_state = state;
		}
		
		public function getAllPlayers():void
		{
			var token:MySqlToken = _state.executeQuery("SELECT * FROM players");
			
	        token.info = "GetAllEmployees";
        	token.addResponder(new AsyncResponder(result, fault, token));
		}
		
		private function result(data:Object, token:Object):void {
	        var rs:ResultSet;
	        rs = ResultSet(data);
	         
	        if ( token.info == "GetAllEmployees" ) {
	        	this.dispatchEvent(new SQLResultEvent(SQLResultEvent.ON_RESULT_GET, rs));
	        }
//	        else if ( token.info == "GetEmployee" ) {
//	                rs = ResultSet(data);
//	                if ( rs.next() ) {
//	                        Alert.show("Employee " + token.employeeID + " username is '" + rs.getString("username") + "'");
//	                }
//	                else {
//	                        Alert.show("No such employee for id " + token.employeeID);
//	                }
//	        }
		}
		
		private function fault(info:Object, token:Object):void {
			trace (info);
		}
		

	}
}