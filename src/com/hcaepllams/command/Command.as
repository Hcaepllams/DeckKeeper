package com.hcaepllams.command
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogStatus;

	public class Command
	{
		protected var text:String = "Who let's the dogs out!";
		protected var _mb:MicroBlog;
		protected var _statusOrComment:Object;
		
		public function Command(mb:MicroBlog, statusOrComment:Object)
		{
			_mb = mb;
			_statusOrComment = statusOrComment;
		}
		
		public function excute():void
		{
			
		}
	}
}