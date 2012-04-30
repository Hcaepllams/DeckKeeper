package com.hcaepllams.message
{
	import com.hcaepllams.command.Command;
	import com.hcaepllams.command.CommandManager;
	import com.hcaepllams.game.Game;
	import com.hcaepllams.game.GameManager;
	import com.hcaepllams.utils.MyDate;
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogComment;
	import com.sina.microblog.data.MicroBlogStatus;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class MessageManager
	{	
		private static var _instance:MessageManager;
		private var _mb:MicroBlog;
		
		private var _timer:Timer;
		
		private var _messageList:Vector.<Message>;
		
		private var _currentMessageIndex:int = 0;
		
		public function MessageManager()
		{
			_messageList = new Vector.<Message>;
			_timer = new Timer(600000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerDone);
		}
		
		public static function get instance():MessageManager
		{
			if (_instance == null)
			{
				_instance = new MessageManager();
			}
			return _instance;
		}
		
		public function set mb(i:MicroBlog):void
		{
			_mb = i;
			_mb.addEventListener(MicroBlogEvent.UPDATE_STATUS_RESULT, sendSucess);
			_mb.addEventListener(MicroBlogErrorEvent.UPDATE_STATUS_ERROR, sendFail);
			_mb.addEventListener(MicroBlogEvent.REPLY_STATUS_RESULT, sendSucess);
			_mb.addEventListener(MicroBlogErrorEvent.REPLY_STATUS_ERROR, sendFail);
		}
		
		public function addAMessage(m:Message):void
		{
			_messageList.push(m);
			
			if (_messageList.length == 1)
			{
				run();
			}
		}
		
		private function removeTheMessage(m:Message):void
		{
			var index:int = _messageList.indexOf(m);
			_messageList.splice(index, 1);
		}
		
		public function run():void
		{
			_timer.stop();
			checkAllMessage();
			sendAMessage();
		}
		
		private function sendAMessage(index:int = 0):Boolean
		{
			if (_messageList.length < 1 || index >= _messageList.length)
			{
				return false;
			}
			else 
			{
				var message:Message = _messageList[index];
				if (message.statusOrComment == null)
				{
					_mb.updateStatus(message.text);
				}
				else
				{
					if (message.statusOrComment is MicroBlogStatus)
					{
						_mb.replyStatus((message.statusOrComment as MicroBlogStatus).id, message.text, "0"); 
					}
					else if (message.statusOrComment is MicroBlogComment)
					{
						var comment:MicroBlogComment = message.statusOrComment as MicroBlogComment;
						_mb.commentStatus(comment.status.id, message.text, comment.id);
					}
				}
				return true;
			}
		}
		
		private function removeCurrentMessage():void
		{
			if (_messageList.length < 1)
			{
				return;
			}
			else
			{
				_messageList.splice(_currentMessageIndex, 1);
			}
		}
		
		private function onTimerDone(e:TimerEvent):void
		{
			run();
			_timer.stop();
		}
		
		private function sendSucess(e:MicroBlogEvent):void
		{
			removeCurrentMessage();
			sendAMessage(_currentMessageIndex);
		}
		
		private function sendFail(e:MicroBlogErrorEvent):void
		{
			trace (e.message);
			_currentMessageIndex ++;
			if (sendAMessage(_currentMessageIndex) == false)
			{// No more message or all message has been tried and faild;
				_timer.start();
				_currentMessageIndex = 0;
			}
		}
		
		private function checkAllMessage():void
		{
			if (_messageList.length < 1)
			{
				return;
			}
			else
			{
				var date:MyDate = new MyDate(new Date);
				for (var i:int = 0; i < _messageList.length; i ++)
				{
					var message:Message = _messageList[i] as Message;
					var game:Game = GameManager.instance.getGameByDate(date);
					if (!game.equal(message.gameSnapshot))
					{
						removeTheMessage(message);
						var command:Command = CommandManager.instance.createCommandByType(message.type, message.statusOrComment);
						command.excute();
						
					}
				}
			}
		}
	}
}