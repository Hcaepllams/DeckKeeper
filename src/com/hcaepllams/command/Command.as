package com.hcaepllams.command
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogStatus;

	public class Command
	{
		protected var text:String = "Who let's the dogs out!";
		protected var _mb:MicroBlog;
		protected var _status:MicroBlogStatus;
		
		public function Command(mb:MicroBlog, status:MicroBlogStatus)
		{
			_mb = mb;
			_status = status;
		}
		
		public function excute():void
		{
			
		}
	}
}