package com.hcaepllams.user
{
	import com.sina.microblog.data.MicroBlogUser;

	public class Player
	{
		private var _name:String;
		private var _user:MicroBlogUser;
		private var _index:int;
		
		public function get microBlogUser():MicroBlogUser
		{
			return _user;
		}
		
		public function get nameAsUsual():String
		{
			return _name;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function Player(index:int, name:String, user:MicroBlogUser)
		{
			_index = index;
			_name = name;
			_user = user;
		}
	}
}