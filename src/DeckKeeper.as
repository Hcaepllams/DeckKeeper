package
{
	import com.hcaepllams.command.Command;
	import com.hcaepllams.command.CommandManager;
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
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class DeckKeeper extends Sprite
	{
		private var _mb:MicroBlog= new MicroBlog();
		private var commandManager:CommandManager;
		private var playerManager:PlayerManager;
		private var messageManager:MessageManager;
		
		private var lastMentionID:String = "0";
		private var lastCommentID:String = "0";
		private var sharedObject:SharedObject;
		
		private var announcedNewGame:Boolean = false;
		private var announcedTheGameBegin:Boolean = false;
		
		public function DeckKeeper()
		{
			init_login();
		}
		
		public function init_login():void 
		{
			_mb.isTrustDomain = true;///设置为信任域
			_mb.source = "4042865151"; ///source是你申请的app key
			_mb.login(); ///用户名密码登录后会请求用户数据，以确认是否输入有效
			_mb.addEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginReslut);
		}
		private function onLoginReslut(e:MicroBlogEvent):void
		{	
			_mb.removeEventListener(MicroBlogEvent.LOGIN_RESULT, onLoginReslut);
			_mb.addEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialsResult);
			_mb.addEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyCredentialsError);
			_mb.verifyCredentials();
		}
		
		private function onVerifyCredentialsResult(e:MicroBlogEvent):void
		{
			_mb.removeEventListener(MicroBlogEvent.VERIFY_CREDENTIALS_RESULT, onVerifyCredentialsResult);
			_mb.removeEventListener(MicroBlogErrorEvent.VERIFY_CREDENTIALS_ERROR, onVerifyCredentialsError);
			
			_mb.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, onMentionsLoaded);
			_mb.addEventListener(MicroBlogEvent.LOAD_COMMENTS_TO_ME_RESULT, onCommentsLoaded);
			
			initConfig();
		}
		
		private function initConfig():void
		{
			sharedObject = SharedObject.getLocal("savedData");
			lastMentionID = sharedObject.data.lastMentionID;
			if (lastMentionID == null)
			{
				lastMentionID = "0";
			}
			
			initLogic();
		}
		
		private function initLogic():void
		{
			commandManager = CommandManager.instance;
			commandManager.mb = _mb;
			
			playerManager = PlayerManager.instance;
			playerManager.mb = _mb;
			playerManager.initAllPlayers();
			
			messageManager = MessageManager.instance;
			messageManager.mb = _mb;
			
			var timer:Timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER, update);
			timer.start();
			
		}
		
		private function update(e:TimerEvent):void
		{
			
			_mb.loadMentions(lastMentionID);
			
			
			_mb.loadCommentsToMe(lastCommentID);
			
			var date:Date = new Date();
			if (date.hours == 23)
			{
				var myDate:MyDate = new MyDate(date);
				GameManager.instance.createNewGame(myDate);
				anounceANewGame(myDate);
			}
			
			if (date.hours == 23 && date.minutes == 35)
			{
				anounceAGameAtTime(myDate);
			}
			
			if (date.hours == 24)
			{
				announcedNewGame = false;
				announcedTheGameBegin = false;
			}
		}
		
		private function anounceANewGame(myDate:MyDate):void
		{
			if (announcedNewGame == false)
			{
				var text:String = new String();
				text = new Date().time + " 今天有谁中午不杀的？" + PlayerManager.instance.getAtStrings();
				var message:Message = new Message(text, "", GameManager.instance.getGameByDate(new MyDate(new Date)), null);
				messageManager.addAMessage(message);
				announcedNewGame = true;
			}
			
		}
		
		private function anounceAGameAtTime(myDate:MyDate):void
		{
			if (announcedTheGameBegin == true)
			{
				return;
			}
			else
			{
				var players:Vector.<Player> = GameManager.instance.getGameByDate(myDate).getPlayers();
				var text:String = "走了呀";
				for (var i:int = 0; i < players.length; i ++)
				{
					text = text + "@" + (players[i] as Player).microBlogUser.screenName + " ";
				}
				var message:Message = new Message(text, "", GameManager.instance.getGameByDate(new MyDate(new Date)), null);
				messageManager.addAMessage(message);
				messageManager.run();
				announcedTheGameBegin = true;
			}
		}
		
		private function onMentionsLoaded(e:MicroBlogEvent):void
		{
			var result:Array = e.result as Array;
			phraseMentions(result);
			if (result.length > 0)
			{
				lastMentionID = (result[result.length - 1] as MicroBlogStatus).id;
			}
			updateConfig();
		}
		
		private function onCommentsLoaded(e:MicroBlogEvent):void
		{
			var result:Array = e.result as Array;
			phraseComments(result);
			if (result.length > 0)
			{
				lastCommentID = (result[result.length - 1] as MicroBlogComment).id;
			}
			updateConfig();
		}
		
		private function updateConfig():void
		{
			sharedObject.data.lastMentionID = lastMentionID;
		}
		
		private function phraseMentions(mentions:Array):void
		{
			var mention:MicroBlogStatus;
			for (var i:int = 0; i < mentions.length; i ++)
			{
				mention = mentions[i] as MicroBlogStatus;
				checkStatus(mention);
			}
		}
		
		private function phraseComments(comments:Array):void
		{
			var comment:MicroBlogComment;
			for (var i:int = 0; i < comments.length; i ++)
			{
				comment = comments[i] as MicroBlogComment;
				checkComment(comment);
			}
		}
		
		private function checkStatus(status:MicroBlogStatus):void
		{
			var command:Command = commandManager.createCommandByType(commandManager.phraseCommandByText(status.text), status);
			command.excute();
		}
		
		private function checkComment(comment:MicroBlogComment):void
		{
			var command:Command = commandManager.createCommandByType(commandManager.phraseCommandByText(comment.text), comment);
			command.excute();
		}
		
		private function onVerifyCredentialsError(e:MicroBlogErrorEvent):void
		{
			trace (e);
		}
	}
}