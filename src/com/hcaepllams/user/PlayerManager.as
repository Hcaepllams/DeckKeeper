package com.hcaepllams.user
{
	import com.sina.microblog.MicroBlog;
	import com.sina.microblog.data.MicroBlogUser;
	import com.sina.microblog.events.MicroBlogErrorEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	
	import flash.utils.Dictionary;

	public class PlayerManager
	{
		/*
		1808232384 Will
		1895460147 Sphie
		2188386820 LM
		2017834591 Mavis
		1993550360 Candy
		1627316017 Cindy
		1984606585 Jacky
		2218794712 Christin
		 */
		private const PLAYERS_NAME:Array = new Array("Will", "LM", "Jacky", "Cindy", "Sophie", "Candy", "Mavis", "Christie");
		private var PLAYERS_UID:Dictionary = new Dictionary();
		
		private static var _instance:PlayerManager;
		
		private var _mb:MicroBlog;
		
		private var _fullPlayerList:Vector.<Player>;
		private var initIndex:int = 0;
		
		public static function get instance():PlayerManager
		{
			if (_instance == null)
			{
				_instance = new PlayerManager();
			}
			return _instance;
		}
		
		public function set mb(i:MicroBlog):void
		{
			_mb = i; 
		}
		
		public function initAllPlayers():void
		{
			PLAYERS_UID["Will"] = "1808232384";
			PLAYERS_UID["Sophie"] = "1895460147";
			PLAYERS_UID["LM"] = "2188386820";
			PLAYERS_UID["Mavis"] = "2017834591";
			PLAYERS_UID["Candy"] = "1993550360";
			PLAYERS_UID["Cindy"] = "1627316017";
			PLAYERS_UID["Jacky"] = "1984606585";
			PLAYERS_UID["Christie"] = "2218794712";
			loadAUser();
		}
	
		private function loadAUser():void
		{
			if (initIndex > PLAYERS_NAME.length)
				return;
			var name:String = PLAYERS_NAME[initIndex];
			_mb.addEventListener(MicroBlogEvent.LOAD_USER_INFO_RESULT, onLoadUserComplete);
			_mb.loadUserInfo(PLAYERS_UID[name]);
		}
		
		private function onLoadUserComplete(e:MicroBlogEvent):void
		{
			_mb.removeEventListener(MicroBlogEvent.LOAD_USER_INFO_RESULT, onLoadUserComplete);
			var user:MicroBlogUser = e.result as MicroBlogUser;
			var player:Player = new Player(getNameByUID(user.id), user);
			_fullPlayerList.push(player);
			initIndex ++;
			loadAUser();
		}
		
		public function getNameByUID(uid:String):String
		{
			for (var key:String in PLAYERS_UID)
			{
				if (PLAYERS_UID[key] == uid)
				{
					return key;
				}
			}
			return "";
		}
		
		public function getAllPlayers():Vector.<Player>
		{
			var returnValue:Vector.<Player> = new Vector.<Player>;
			for (var i:int = 0; i < _fullPlayerList.length; i ++)
			{
				returnValue.push(_fullPlayerList[i] as Player);
			}
			return returnValue;
		}
		
		public function getPlayerByUserID(id:String):Player
		{
			for (var i:int = 0; i < _fullPlayerList.length; i ++)
			{
				if ((_fullPlayerList[i] as Player).microBlogUser.id == id)
				{
					return _fullPlayerList[i] as Player;
				}
			}
			return null;
		}
		
		public function PlayerManager()
		{
			_fullPlayerList = new Vector.<Player>;
		}
		
		public function getAtStrings():String
		{
			var text:String = new String;
			for (var i:int = 0; i < _fullPlayerList.length; i ++)
			{
				text = text + "@" + (_fullPlayerList[i] as Player).microBlogUser.screenName + " ";
			}
			return text;
			//return "@Hcaepllams";
		}
	}
}