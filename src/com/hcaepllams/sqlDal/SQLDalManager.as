package com.hcaepllams.sqlDal
{
	import com.maclema.mysql.Statement;
	
	public class SQLDalManager
	{
		private static var _instance:SQLDalManager;
		private var _state:Statement;
		
		public function SQLDalManager()
		{
		}
		
		public static function get instance():SQLDalManager
		{
			if (_instance == null)
			{
				_instance = new SQLDalManager;
			}
			return _instance;
		}
		
		public function set state(value:Statement):void
		{
			_state = value;
		}
		
		public function getADal():SQLDal
		{
			return new SQLDal(_state);
		}

	}
}