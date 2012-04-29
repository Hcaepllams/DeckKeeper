package com.hcaepllams.command
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogStatus;

	public class CommandManager
	{
		private static var _instance:CommandManager;
		
		private var _mb:MicroBlog;
		
		private var addCommandKeyWords:Array = new Array("多少", "几人", "几个", "有没有");
		private var absentCommandKeyWords:Array = new Array("不来","出去","不杀","不三国杀");
		
		public function CommandManager()
		{
			//Disable
		}
		
		public static function get instance():CommandManager
		{
			if (_instance == null)
			{
				_instance = new CommandManager;
			}
			return _instance;
		}
		
		public function set mb(i:MicroBlog):void
		{
			_mb = i;
		}
		
		public function createCommandByType(type:String, statusOrComment:Object):Command
		{
			var command:Command;
			switch (type)
			{
				case CommandType.ADD:
					command = new CommandAsk(_mb, statusOrComment);
					break;
				case CommandType.ABSENT:
					command = new CommandAbsent(_mb, statusOrComment);
					break;
				default:
					command = new Command(_mb, statusOrComment);
					break;
			}
			
			return command;
		}
		
		public function phraseCommandByText(text:String):String
		{
			if (isAddCommand(text))
			{
				return CommandType.ADD;
			}
			else if (isAbsentCommand(text))
			{
				return CommandType.ABSENT;
			}
			return "";
		}
		
		private function isAddCommand(text:String):Boolean
		{
			for (var i:int = 0;i < addCommandKeyWords.length; i ++)
			{
				if (text.search(addCommandKeyWords[i] as String) > 0)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isAbsentCommand(text:String):Boolean
		{
			for (var i:int = 0;i < absentCommandKeyWords.length; i ++)
			{
				if (text.search(absentCommandKeyWords[i] as String) > 0)
				{
					return true;
				}
			}
			return false;
		}
		
		private function deleteUser(text:String):String
		{
			var index:int = text.search("@");
			if (index == -1)
			{
				return text;
			}
			else
			{
				return text;
			}
			
		}
	}
}