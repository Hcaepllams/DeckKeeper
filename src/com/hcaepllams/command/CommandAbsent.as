package com.hcaepllams.command
{
	import com.hcaepllams.game.Game;
	import com.hcaepllams.game.GameManager;
	import com.hcaepllams.message.Message;
	import com.hcaepllams.message.MessageManager;
	import com.hcaepllams.user.Player;
	import com.hcaepllams.user.PlayerManager;
	import com.hcaepllams.utils.MyDate;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	
	public class CommandAbsent extends Command
	{
		private var absentUser:MicroBlogUser;
		
		public function CommandAbsent(mb:MicroBlog, statusOrComment:Object)
		{
			super(mb, statusOrComment);
			
			var date:MyDate = new MyDate(new Date());
			var game:Game = GameManager.instance.getGameByDate(date);
			
			if (game != null)
			{
				if (statusOrComment is MicroBlogStatus)
				{
					absentUser = (statusOrComment as MicroBlogStatus).user;
				}
				else
				{
					absentUser = (statusOrComment as MicroBlogComment).user;
				}
			
				game.removePlayers(PlayerManager.instance.getPlayerByUserID(absentUser.id));
				initText(game.getPlayers(), game.getAbsentPlayers());
			}
			else
			{
				text = "Who let's the dogs out ~~ Dong Dong Dong Dong";
			}
		}
		
		private function initText(attends:Vector.<Player>, absents:Vector.<Player>):void
		{
			text = new Date().time.toString() + PlayerManager.instance.getNameByUID(absentUser.id) + "表示不来了。"; 
		}
		
		override public function excute():void
		{
			var message:Message = new Message(text, CommandType.ABSENT, GameManager.instance.getGameByDate(new MyDate(new Date)), _statusOrComment);
			MessageManager.instance.addAMessage(message);
			var command:CommandAsk = new CommandAsk(_mb, null);
			command.excute();
		}
	}
}