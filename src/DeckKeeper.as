package
{
	import com.hcaepllams.command.Command;
	import com.hcaepllams.command.CommandManager;
	import com.hcaepllams.user.PlayerManager;
	import com.sina.microblog.MicroBlog;
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
		
		private var lastMentionID:String = "0";
		private var sharedObject:SharedObject;
		
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
			
			var timer:Timer = new Timer(10000);
			timer.addEventListener(TimerEvent.TIMER, update);
			timer.start();
		}
		
		private function update(e:TimerEvent):void
		{
			_mb.addEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, onMentionsLoaded);
			_mb.loadMentions(lastMentionID);
		}
		
		private function onMentionsLoaded(e:MicroBlogEvent):void
		{
			_mb.removeEventListener(MicroBlogEvent.LOAD_MENSIONS_RESULT, onMentionsLoaded);
			var result:Array = e.result as Array;
			phraseMentions(result);
			if (result.length > 0)
			{
				lastMentionID = (result[result.length - 1] as MicroBlogStatus).id;
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
		
		private function checkStatus(status:MicroBlogStatus):void
		{
			var command:Command = commandManager.createCommandByType(commandManager.phraseCommandByText(status.text), status);
			command.excute();
		}
		
		private function onVerifyCredentialsError(e:MicroBlogErrorEvent):void
		{
			
		}
	}
}