package com.hcaepllams.utils
{
	public class MyDate
	{
		private var _date:Date
		public function MyDate(date:Date)
		{
			_date = date;
		}
		
		public function getMyDate():String
		{
			var month:String = _date.month.toString();
			var day:String = _date.day.toString();
			if (_date.month < 10)
			{
				month = "0" + month;
			}
			
			if (date.day < 10)
			{
				day = "0" + day;
			}
			return _date.fullYear + "-" + month + "-" + day + " 00:00:00";
		}
		
		public function get date():Date
		{
			return _date;
		}
	}
}