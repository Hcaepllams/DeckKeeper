package com.hcaepllams.utils
{
	public class MyDate
	{
		var _date:Date
		public function MyDate(date:Date)
		{
			_date = date;
		}
		
		public function getMyDate():String
		{
			return _date.fullYear + "." + _date.month + "." + _date.date;
		}
	}
}