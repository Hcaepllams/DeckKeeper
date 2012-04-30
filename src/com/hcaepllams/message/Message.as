package com.hcaepllams.message
{
	import com.hcaepllams.game.Game;

	public class Message
	{
		private var _text:String;
		private var _type:String;
		private var _gameSnapshot:Game;
		protected var _statusOrComment:Object;
		
		public function Message(text:String, type:String, gameSnapshot:Game, sOC:Object = null)
		{
			_text = text;
			_type = type;
			_gameSnapshot = gameSnapshot.duplicated();
			_statusOrComment = sOC;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		
		public function get gameSnapshot():Game
		{
			return _gameSnapshot;
		}
		
		public function get statusOrComment():Object
		{
			return _statusOrComment;
		}
		
	}
}