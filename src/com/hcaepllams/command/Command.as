package com.hcaepllams.command
{
	import com.sina.microblog.MicroBlog;

	public class Command
	{
		protected var text:String = "Who let's the dogs out!";
		protected var _mb:MicroBlog;
		
		
		public function Command(mb:MicroBlog)
		{
			_mb = mb;
		}
		
		public function excute():void
		{
			
		}
	}
}