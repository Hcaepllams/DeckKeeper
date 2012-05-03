package com.hcaepllams.sqlDal
{
	import flash.events.Event;
	
	public class SQLResultEvent extends Event
	{
		public static const ON_RESULT_GET:String = "on result get"
		
		private var _result:Object;
		
		public function SQLResultEvent(type:String, result:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_result = result;
		}
		
		public function get result():Object
		{
			return _result;
		}

	}
}