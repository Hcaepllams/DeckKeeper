package com.hcaepllams.command
{
	import com.hcaepllams.game.Game;
	import com.hcaepllams.game.GameManager;
	import com.hcaepllams.user.Player;
	import com.hcaepllams.user.PlayerManager;
	import com.hcaepllams.utils.MyDate;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.data.MicroBlogUser;
	
	public class CommandAbsent extends Command
	{
		private var absentUser:MicroBlogUser;
		
		public function CommandAbsent(mb:MicroBlog, status:MicroBlogStatus)
		{
			super(mb, status);
			
			var date:MyDate = new MyDate(new Date());
			var game:Game = GameManager.instance.getGameByDate(date);
			absentUser = status.user;
			
			game.removePlayers(PlayerManager.instance.getPlayerByUserID(absentUser.id));
			initText(game.getPlayers(), game.getAbsentPlayers());
		}
		
		private function initText(attends:Vector.<Player>, absents:Vector.<Player>):void
		{
			text = new Date().time.toString() + PlayerManager.instance.getNameByUID(absentUser.id) + "表示不来了。"; 
		}
		
		override public function excute():void
		{
			_mb.updateStatus(text);
			var command:CommandAsk = new CommandAsk(_mb, _status);
			command.excute();
		}
	}
}