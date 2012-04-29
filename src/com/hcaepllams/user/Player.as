package com.hcaepllams.user
{
	import com.sina.microblog.data.MicroBlogUser;

	public class Player
	{
		private var _name:String;
		private var _user:MicroBlogUser;
		
		public function get microBlogUser():MicroBlogUser
		{
			return _user;
		}
		
		public function get nameAsUsual():String
		{
			return _name;
		}
		
		public function Player(name:String, user:MicroBlogUser)
		{
			_name = name;
			_user = user;
		}
	}
}