package com.bitstrips.core
{
   import com.bitstrips.BSConstants;
   import flash.events.AsyncErrorEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.Responder;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class Remote extends EventDispatcher
   {
       
      
      public var base_url:String;
      
      public var testing:Boolean = false;
      
      private var error_callback:Function;
      
      private var save_timeout:Timer;
      
      public var bs_user_id:int;
      
      public var asset_url:String = "http://cassets.bitstrips.com/";
      
      public var dat_loader:LoadDat;
      
      public var asset_dir:String = "2009_10_12/";
      
      private var _log_counter:int = 0;
      
      private var save_comic_callback_store:Function;
      
      public var prop_asset_dir:String = "2009_12_04_3/";
      
      public var local:Boolean = false;
      
      public var code:String = "";
      
      private var _bs:String = "bs_2.";
      
      private var _connection:NetConnection;
      
      public function Remote(param1:String = "", param2:String = "", param3:uint = 0)
      {
         super();
         if(param3 || param1.substr(0,4) == "file")
         {
            BSConstants.URL = "staging." + BSConstants.DOMAIN;
            if(BSConstants.STAGING == false && param3 == 2)
            {
               BSConstants.URL = "local." + BSConstants.DOMAIN;
               BSConstants.TESTING_PF = "_testing";
            }
         }
         base_url = "http://" + BSConstants.URL + "/";
         trace("\t Done init Remote -- base_url: " + base_url + ", Asset URL: " + asset_url + " -- " + param1);
         code = param2;
         var _loc4_:int = 4 * 60 * 1000;
         if(BSConstants.EDU == false)
         {
            _loc4_ = 10 * 60 * 1000;
         }
         save_timeout = new Timer(_loc4_,1);
         save_timeout.addEventListener(TimerEvent.TIMER,save_timeout_event);
      }
      
      public static function log_error_post(param1:String, param2:Object) : void
      {
         var loader:URLLoader = null;
         var n:String = null;
         var type:String = param1;
         var data:Object = param2;
         loader = new URLLoader();
         var request:URLRequest = new URLRequest("http://" + BSConstants.URL + "/logger.php");
         var vars:URLVariables = new URLVariables();
         vars["type"] = type;
         for(n in data)
         {
            vars[n] = data[n];
         }
         request.data = vars;
         request.method = URLRequestMethod.POST;
         loader.load(request);
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            trace(loader.data);
         });
      }
      
      public function get_image_signature(param1:String, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         check_connection();
         _connection.call("libraries.get_image_signature",_loc3_,code,bs_user_id,param1);
      }
      
      public function load_scene_data(param1:int, param2:String, param3:uint, param4:Function) : void
      {
         var _loc5_:Responder = new Responder(param4,onError);
         trace("Calling load scene data on: " + param2);
         check_connection();
         _connection.call(_bs + "load_scene_data",_loc5_,code,param1,param2,param3);
      }
      
      public function load_comic_data(param1:int, param2:String, param3:Function) : void
      {
         var _loc4_:Responder = new Responder(param3,onError);
         trace("Calling load comic data on: " + param2);
         check_connection();
         _connection.call(_bs + "load_comic_data",_loc4_,code,param1,param2);
      }
      
      public function get_basic_libs(param1:Function) : void
      {
         var _loc2_:Responder = new Responder(param1,onError);
         trace("Get basic_libs: " + param1);
         check_connection();
         _connection.call("libraries.basic_libs",_loc2_);
      }
      
      public function new_user(param1:String, param2:String, param3:String, param4:String, param5:Function) : void
      {
         var _loc6_:Responder = new Responder(param5,onError);
         trace("New user: " + param1 + " " + param5);
         check_connection();
         _connection.call(_bs + "make_new_user",_loc6_,param1,param2,param3,param4);
      }
      
      public function image_search(param1:String, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         check_connection();
         _connection.call("libraries.image_search",_loc3_,this.bs_user_id,param1);
      }
      
      public function new_series(param1:Number, param2:String, param3:Function) : void
      {
         var _loc4_:Responder = new Responder(param3,onError);
         trace("Calling new_series " + param1 + ", " + param2);
         check_connection();
         _connection.call(_bs + "new_series",_loc4_,code,param1,param2);
      }
      
      public function save_pose(param1:String, param2:String, param3:Object, param4:Function) : void
      {
         var _loc5_:Responder = new Responder(param4,onError);
         check_connection();
         _connection.call(_bs + "save_pose",_loc5_,param1,param2,param3);
      }
      
      public function save_test(param1:Object, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Save test: " + param1);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeObject(param1);
         _loc4_.compress();
         check_connection();
         _connection.call(_bs + "save_test",_loc3_,param1,_loc4_);
      }
      
      private function async_status(param1:AsyncErrorEvent) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            trace(param1 + " " + _loc2_ + " " + param1[_loc2_]);
         }
         trace(param1);
         if(this.error_callback != null)
         {
            error_callback("Network status error");
         }
      }
      
      public function save_new_char(param1:uint, param2:String, param3:Object, param4:ByteArray, param5:Object, param6:uint, param7:Function, param8:Function) : void
      {
         var _loc9_:Responder = new Responder(param7,param8);
         trace("Calling save_data: " + param1 + ", " + param2);
         this.error_callback = param8;
         check_connection();
         _connection.call(_bs + "save_new_char",_loc9_,code,param1,param2,param3,obj2ba(param3),param4,param5,param6);
      }
      
      public function save_comic(param1:Number, param2:String, param3:String, param4:Object, param5:Object, param6:ByteArray, param7:ByteArray, param8:ByteArray, param9:String, param10:Function, param11:Function) : void
      {
         save_comic_callback_store = param10;
         var _loc12_:Responder = new Responder(save_comic_callback,param11);
         trace("Calling save comic on: user_id: " + param1 + ", series_id:" + param2 + ", png_ba.lenght:" + param6.length + " Title: " + param3);
         check_connection();
         _connection.call(_bs + "save_comic_2",_loc12_,code,param1,param3,param2,param4,param5,param6,param7,param8,param9);
         save_timeout.start();
      }
      
      private function obj2ba(param1:Object) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.compress();
         trace("obj2ba: " + _loc2_.length);
         return _loc2_;
      }
      
      public function load_message_data(param1:Number, param2:String, param3:Function) : void
      {
         var _loc4_:Responder = new Responder(param3,onError);
         trace("Calling load message data on: " + param2);
         check_connection();
         _connection.call(_bs + "get_message_data",_loc4_,code,param1,param2);
      }
      
      public function save_comment(param1:int, param2:String, param3:String, param4:String, param5:ByteArray, param6:Function, param7:Function) : void
      {
         var _loc8_:Responder = new Responder(param6,param7);
         trace("Calling save comment on " + param5.length);
         check_connection();
         _connection.call(_bs + "save_comment2",_loc8_,code,param1,param2,param3,param4,param5);
      }
      
      public function get_user(param1:Number, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Calling get_user " + param1);
         check_connection();
         _connection.call(_bs + "get_user",_loc3_,code,param1);
      }
      
      public function save_new_char_v2(param1:uint, param2:String, param3:Object, param4:uint, param5:ByteArray, param6:ByteArray, param7:ByteArray, param8:Function, param9:Function) : void
      {
         var _loc10_:Responder = new Responder(param8,param9);
         trace("Calling save_data: " + param1 + ", " + param2);
         this.error_callback = param9;
         check_connection();
         _connection.call(_bs + "save_new_char_v2",_loc10_,code,param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function email_check(param1:String, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("email check: " + param1 + " " + param2);
         check_connection();
         _connection.call(_bs + "email_check",_loc3_,param1);
      }
      
      public function get_bio(param1:Number, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         check_connection();
         trace("Calling get bio: " + param1);
         _connection.call(_bs + "get_bio",_loc3_,param1);
      }
      
      public function get_friends_stuff(param1:uint, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Get friends char: " + param2);
         check_connection();
         _connection.call("libraries.friends_stuff",_loc3_,param1);
      }
      
      private function io_status(param1:IOErrorEvent) : void
      {
         if(this.error_callback != null)
         {
            error_callback("Network status error");
         }
      }
      
      public function save_data(param1:Number, param2:String, param3:Object, param4:ByteArray, param5:Function) : void
      {
         var _loc6_:Responder = new Responder(param5,onError);
         trace("Calling save_data: " + param1 + ", " + param3);
         check_connection();
         _connection.call(_bs + "save_head",_loc6_,code,param1,param2,param3,param4);
      }
      
      public function get_class_lib(param1:uint, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Get class libs: " + param2);
         check_connection();
         _connection.call("libraries.class_stuff",_loc3_,param1);
      }
      
      public function save_hq_comic(param1:int, param2:int, param3:ByteArray, param4:Function) : void
      {
         var _loc5_:Responder = new Responder(param4,onError);
         trace("Calling save hq comic on " + param3.length + " " + this.base_url);
         check_connection();
         _connection.call(_bs + "save_hq_comic",_loc5_,param1,param2,param3);
      }
      
      private function save_comic_callback(param1:String) : void
      {
         save_timeout.stop();
         save_comic_callback_store(param1);
      }
      
      public function get_chars(param1:Function) : void
      {
         var _loc2_:Responder = new Responder(param1,onError);
         trace("Get chars: " + param1);
         check_connection();
         _connection.call(_bs + "get_chars",_loc2_);
      }
      
      public function send_char(param1:uint, param2:String, param3:String, param4:String, param5:String, param6:uint, param7:uint, param8:ByteArray, param9:Function) : void
      {
         var _loc10_:Responder = new Responder(param9,onError);
         trace("Calling send_char on: " + param1 + ", " + param3);
         check_connection();
         _connection.call(_bs + "send_char",_loc10_,code,param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function save_char_v2(param1:uint, param2:String, param3:Object, param4:uint, param5:ByteArray, param6:ByteArray, param7:ByteArray, param8:Function, param9:Function) : void
      {
         var _loc10_:Responder = new Responder(param8,param9);
         trace("Calling save_data: " + param1 + ", " + param2);
         this.error_callback = param9;
         check_connection();
         _connection.call(_bs + "save_char_v2",_loc10_,code,param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function save_scene(param1:Number, param2:String, param3:Object, param4:ByteArray, param5:ByteArray, param6:Function) : void
      {
         var _loc7_:Responder = new Responder(param6,onError);
         trace("Calling save scene on: user_id: " + param1 + ", ba.lenght:" + param4.length + " Title: " + param2);
         check_connection();
         _connection.call(_bs + "save_scene2",_loc7_,code,param1,param2,param3,param4,param5);
      }
      
      public function load_test(param1:Number, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Load test: " + param1);
         check_connection();
         _connection.call(_bs + "load_test",_loc3_,param1);
      }
      
      public function save_shirt(param1:Number, param2:uint, param3:ByteArray, param4:Function) : void
      {
         var _loc5_:Responder = new Responder(param4,onError);
         trace("Calling save shirt on " + param3.length + " " + this.base_url);
         check_connection();
         _connection.call(_bs + "save_shirt",_loc5_,param1,param2,param3);
      }
      
      public function new_assurl(param1:String) : String
      {
         if(BSConstants.AIR)
         {
            return "app:/props.swf";
         }
         var _loc2_:String = BSConstants.NEW_ASSET_URL + BSConstants.NEW_ASSET_DIR + param1;
         if(param1 == "props.swf")
         {
            _loc2_ = BSConstants.NEW_ASSET_URL + BSConstants.NEW_PROP_ASSET_DIR + param1;
         }
         trace("ASS URL: " + _loc2_);
         return _loc2_;
      }
      
      public function assurl(param1:String) : String
      {
         var _loc2_:String = asset_url + asset_dir + param1;
         if(param1 == "props/props.swf")
         {
            _loc2_ = asset_url + prop_asset_dir + param1;
         }
         trace("ASS URL: " + _loc2_);
         return _loc2_;
      }
      
      public function send_message(param1:uint, param2:uint, param3:String, param4:Object, param5:ByteArray, param6:uint, param7:Function) : void
      {
         var _loc8_:Responder = new Responder(param7,onError);
         trace("Calling send_message on: " + param1 + ", " + param2 + ", " + param3 + ", " + param6);
         check_connection();
         _connection.call(_bs + "send_message",_loc8_,code,param1,param2,param3,param4,param5,param6);
      }
      
      public function save_comic_panels_edu(param1:Number, param2:String, param3:String, param4:Object, param5:Object, param6:Array, param7:Array, param8:String, param9:Function, param10:Function) : void
      {
         var _loc11_:Responder = new Responder(param9,param10);
         this.error_callback = param10;
         trace("Calling save comic panels edu on: user_id: " + param1 + ", assign_id:" + param2);
         check_connection();
         _connection.call(_bs + "save_comic_panels_edu",_loc11_,code,param1,param3,param2,param4,param5,param6,param7,obj2ba(param4),param8);
      }
      
      public function save_comic_panels(param1:Number, param2:Number, param3:String, param4:Object, param5:Object, param6:Array, param7:Array, param8:String, param9:Function, param10:Function) : void
      {
         var _loc11_:Responder = new Responder(param9,param10);
         this.error_callback = param10;
         trace("Calling save comic panels on: user_id: " + param1 + ", series_id:" + param2);
         check_connection();
         _connection.call(_bs + "save_comic_panels",_loc11_,code,param1,param3,param2,param4,param5,param6,param7,obj2ba(param4),param8);
      }
      
      public function get_poses(param1:Function) : void
      {
         var _loc2_:Responder = new Responder(param1,onError);
         check_connection();
         _connection.call(_bs + "get_poses",_loc2_);
      }
      
      private function net_status(param1:NetStatusEvent) : void
      {
         var _loc3_:* = null;
         trace("Network status? : " + param1.info.code + " " + param1.info.level);
         var _loc2_:Object = param1.info;
         for(_loc3_ in _loc2_)
         {
            trace(_loc2_ + " " + _loc3_ + " " + _loc2_[_loc3_]);
         }
         trace(param1);
         if(this.error_callback != null)
         {
            error_callback("Network status error");
         }
         else
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,_loc2_.code + ":" + _loc2_.description));
         }
         Remote.log_error_post("Net Status",_loc2_);
      }
      
      public function delete_asset(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:Responder = new Responder(onDelete,onError);
         check_connection();
         _connection.call("libraries.delete_asset",_loc4_,code,bs_user_id,param2,param3);
      }
      
      public function assign_hash(param1:String, param2:uint, param3:Function) : void
      {
         var _loc4_:Responder = new Responder(param3,onError);
         check_connection();
         _connection.call(_bs + "hash_assign",_loc4_,param1,param2);
      }
      
      public function username_check(param1:String, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Username check: " + param1 + " " + param2);
         check_connection();
         _connection.call(_bs + "username_check",_loc3_,param1);
      }
      
      public function get_faves(param1:uint, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Get friends char: " + param2);
         check_connection();
         _connection.call("libraries.faves",_loc3_,param1);
      }
      
      public function mini_email(param1:String, param2:String, param3:String, param4:String, param5:ByteArray, param6:Object, param7:ByteArray, param8:Object, param9:Function, param10:uint = 0) : void
      {
         var _loc11_:Responder = new Responder(param9,onError);
         trace("Calling mini_email " + param1 + " " + param2 + " " + param3 + " " + param4);
         check_connection();
         _connection.call(_bs + "mini_email",_loc11_,param1,param2,param3,param4,param5,param6,obj2ba(param6),param7,param8,param10);
      }
      
      public function load_data(param1:Number, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Load data call: " + param1 + " " + param2);
         check_connection();
         _connection.call(_bs + "load_head",_loc3_,param1);
      }
      
      public function log_error(param1:String, param2:Object) : void
      {
         var type:String = param1;
         var data:Object = param2;
         _log_counter = _log_counter + 1;
         if(_log_counter > 20)
         {
            return;
         }
         var responder:Responder = new Responder(function(param1:Event):void
         {
            trace("Logged: " + type);
         },function(param1:*):void
         {
            Remote.log_error_post(type,data);
         });
         check_connection();
         _connection.call("logger.log",responder,type,data);
      }
      
      private function onError(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--Remote.onError()--");
         for(_loc2_ in param1)
         {
            trace("error." + _loc2_ + ": " + param1[_loc2_]);
         }
         if(param1.hasOwnProperty("faultCode"))
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.faultCode + ":" + param1.faultString));
         }
         else
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.code));
         }
         Remote.log_error_post(param1.faultCode,param1);
      }
      
      public function get_my_stuff(param1:uint, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Get my char: " + param2);
         check_connection();
         _connection.call("libraries.my_stuff",_loc3_,param1);
      }
      
      public function save_jpeg(param1:ByteArray, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Calling save jpeg on " + param1.length);
         check_connection();
         _connection.call(_bs + "SaveAsJPEG",_loc3_,param1,true);
      }
      
      public function get_friends_lib(param1:uint, param2:Function) : void
      {
         var _loc3_:Responder = new Responder(param2,onError);
         trace("Get friends lib: " + param2);
         check_connection();
         _connection.call("libraries.friends_lib",_loc3_,param1);
      }
      
      private function check_connection() : void
      {
         if(_connection == null)
         {
            trace("Checking connection... ");
            _connection = new NetConnection();
            _connection.connect(base_url + "flapjacks/gateway.php");
            _connection.addEventListener(NetStatusEvent.NET_STATUS,net_status);
            _connection.addEventListener(IOErrorEvent.IO_ERROR,io_status);
            _connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,async_status);
         }
      }
      
      public function save_twit(param1:Number, param2:String, param3:String, param4:ByteArray, param5:Function) : void
      {
         var _loc6_:Responder = new Responder(param5,onError);
         trace("Calling save twit on " + param4.length);
         check_connection();
         _connection.call(_bs + "save_chatter",_loc6_,code,param1,param2,param3,param4);
      }
      
      private function onDelete(param1:String) : void
      {
         trace("Deleted: " + param1);
      }
      
      private function save_timeout_event(param1:TimerEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"Saving timed-out. Please try saving again"));
      }
   }
}
