package com.hcaepllams.command
{
	import com.hcaepllams.game.Game;
	import com.hcaepllams.game.GameManager;
	import com.hcaepllams.user.Player;
	import com.hcaepllams.utils.MyDate;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogStatus;

	public class CommandAsk extends Command
	{
		private var statusID:String;
		
		public function CommandAsk(mb:MicroBlog, status:MicroBlogStatus)
		{
			super (mb, status);
			statusID = status.id;
			var date:MyDate = new MyDate(new Date());
			var game:Game = GameManager.instance.getGameByDate(date);
			
			var attendPlayer:Vector.<Player> = game.getPlayers();
			var absentPlayer:Vector.<Player> = game.getAbsentPlayers();
			
			initText(attendPlayer, absentPlayer);
		}
		
		private function initText(attends:Vector.<Player>, absents:Vector.<Player>):void
		{
			text = new Date().time.toString() + "截止到目前，可能参与人数为";
			text = text + attends.length + "人，他们是：";
			for (var i:int = 0; i < attends.length; i ++)
			{
				if (i < attends.length - 1)
				{
					text = text + (attends[i] as Player).nameAsUsual + "，";
				}
				else
				{
					if (absents.length > 0)
					{
						text = text + (attends[i] as Player).nameAsUsual + "，可能缺席的人数为：" + absents.length + "人，他们是：";
					}
					else
					{
						text = text + (attends[i] as Player).nameAsUsual + "，无人缺席！";
					}
				}
			}
			
			for (var j:int = 0; j < absents.length; j ++)
			{
				if (j < absents.length - 1)
				{
					text = text + (absents[j] as Player).nameAsUsual + "，";
				}
				else
				{
					text = text + (absents[j] as Player).nameAsUsual + "。";
				}
			}
			
		}
		
		override public function excute():void
		{
			_mb.commentStatus(statusID, text);
			_mb.updateStatus(text);
		}
	}
}