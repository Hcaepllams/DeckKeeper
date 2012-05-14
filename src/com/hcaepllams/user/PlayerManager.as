package com.hcaepllams.user
{
	import com.hcaepllams.sqlDal.SQLDal;
	import com.hcaepllams.sqlDal.SQLDalManager;
	import com.hcaepllams.sqlDal.SQLResultEvent;
	import com.maclema.mysql.ResultSet;
	import com.maclema.mysql.Statement;
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
		private var playersScreenNames:Array = new Array();
		private var playersUID:Dictionary = new Dictionary();
		
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
			var sqlDal:SQLDal = SQLDalManager.instance.getADal();
			sqlDal.getAllPlayers();			
			sqlDal.addEventListener(SQLResultEvent.ON_RESULT_GET, onPlayerLoaded);
			//loadAUser();
		}
		
		public function onPlayerLoaded(e:SQLResultEvent):void
		{
			var rs:ResultSet = e.result as ResultSet;			
			while (rs.next())
			{
				var name:String = rs.getString("playerCommonName");
				playersScreenNames.push(name);
				playersUID[name] = rs.getString("playerWeiboUID");
			}
			loadAUser();
		}
		
		private function loadAUser():void
		{
			if (initIndex > playersScreenNames.length)
				return;
			var name:String = playersScreenNames[initIndex];
			_mb.addEventListener(MicroBlogEvent.LOAD_USER_INFO_RESULT, onLoadUserComplete);
			_mb.loadUserInfo(playersUID[name]);
		}
		
		private function onLoadUserComplete(e:MicroBlogEvent):void
		{
			_mb.removeEventListener(MicroBlogEvent.LOAD_USER_INFO_RESULT, onLoadUserComplete);
			var user:MicroBlogUser = e.result as MicroBlogUser;
			var screenName:String = getNameByUID(user.id);
			var player:Player = new Player(playersScreenNames.indexOf(screenName) + 1, screenName, user);
			_fullPlayerList.push(player);
			initIndex ++;
			loadAUser();
		}
		
		public function getNameByUID(uid:String):String
		{
			for (var key:String in playersUID)
			{
				if (playersUID[key] == uid)
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
			//return text;
			return "@Hcaepllams";
		}
	}
}