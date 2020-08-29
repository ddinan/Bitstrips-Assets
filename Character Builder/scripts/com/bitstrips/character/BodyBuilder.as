package com.bitstrips.character
{
   import com.adobe.images.PNGEncoder;
   import com.bitstrips.BSConstants;
   import com.bitstrips.BitStrips;
   import com.bitstrips.Utils;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.core.Remote;
   import com.bitstrips.ui.ArtLibrary;
   import com.bitstrips.ui.BodyArtLibrary;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class BodyBuilder extends EventDispatcher
   {
       
      
      public var done:Boolean = false;
      
      private var save_timer:Timer;
      
      var bio:Object;
      
      public var name:String = "";
      
      public var user_id:int;
      
      public var char_loader:CharLoader;
      
      public var wiz_head_lib:ArtLibrary;
      
      public var body:SkeletonBuddy;
      
      private var error_callback:Function;
      
      public var friend:Boolean = false;
      
      public var head_lib:ArtLibrary;
      
      public var bs_save:Boolean = false;
      
      private var save_onError:Function;
      
      public var brothers:Array;
      
      public var remote:Remote;
      
      private var save_callback:Function;
      
      private var orig_name:String = "";
      
      private var bs:BitStrips;
      
      public var saved_id:String;
      
      public var avatar:Boolean = false;
      
      public var head_id:String;
      
      private var save_new_name:String;
      
      public var head:Head;
      
      public var body_lib:BodyArtLibrary;
      
      public var bb_type:int = 0;
      
      private var restarting:Boolean = false;
      
      public function BodyBuilder(param1:BitStrips, param2:int = 0)
      {
         bio = new Object();
         brothers = [];
         super();
         remote = param1.remote;
         char_loader = param1.char_loader;
         head_lib = new ArtLibrary(char_loader.art_loader);
         if(name != "introbuilder_99")
         {
            wiz_head_lib = new ArtLibrary(char_loader.art_loader);
            body_lib = new BodyArtLibrary();
         }
         this.bs = param1;
         this.user_id = param1.user_id;
         name = "Name";
         if(param1.char_id)
         {
            this.head_id = param1.char_id;
            name = param1.char_name;
         }
         else
         {
            head_id = "-1";
            if(param1.char_name)
            {
               name = param1.char_name;
            }
            else
            {
               name = "Name";
            }
         }
         bb_type = param2;
         if(param2 == 1 || param2 == 3)
         {
            avatar = true;
         }
         else if(param2 == 2)
         {
            friend = true;
            head_id = "-1";
            name = "Name";
         }
         orig_name = name;
         char_loader.get_char(head_id,loaded,-1);
      }
      
      public static function set_man(param1:Head) : void
      {
         trace("Set man in BodyBuilder");
         param1.set_art("mouth","mouth","mouth_art1");
         param1.set_art("eyelash_R","eyelash","_blank");
         param1.set_art("eyelash_L","eyelash","_blank");
         param1.set_backstyle(1);
         if(BSConstants.KID_MODE)
         {
            param1.set_art("forehead","forehead","forehead_art5");
            param1.set_art("hair_front","hair_front","hair_front_art12");
            param1.set_hairstyle(11);
         }
         else
         {
            param1.set_art("brow_R","brow","brow_art1");
            param1.set_art("brow_L","brow","brow_art1");
            param1.set_art("forehead","forehead","forehead_art1");
            param1.set_art("nose","nose","nose_art1");
            param1.set_art("hair_front","hair_front","_blank");
            param1.set_hairstyle(1);
         }
      }
      
      public static function set_woman(param1:Head) : void
      {
         trace("Set woman in BodyBuilder");
         param1.set_art("brow_R","brow","brow_art3");
         param1.set_art("brow_L","brow","brow_art3");
         param1.set_art("nose","nose","nose_art4");
         param1.set_art("mouth","mouth","mouth_art3");
         param1.set_art("eyelash_R","eyelash","eyelash_art2_1");
         param1.set_art("eyelash_L","eyelash","eyelash_art2_1");
         if(BSConstants.KID_MODE)
         {
            param1.set_art("hair_front","hair_front","hair_front_art1");
            param1.set_art("forehead","forehead","forehead_art5");
            param1.set_backstyle(16);
            param1.set_hairstyle(9);
         }
         else
         {
            param1.set_art("hair_front","hair_front","_blank");
            param1.set_art("forehead","forehead","forehead_art1");
            param1.set_backstyle(16);
            param1.set_hairstyle(1);
         }
      }
      
      public static function body2bitmap(param1:DisplayObject, param2:Number) : BitmapData
      {
         var _loc3_:Rectangle = param1.getBounds(param1);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(param2,param2);
         _loc4_.translate(-_loc3_.x * param2,-_loc3_.y * param2);
         var _loc5_:BitmapData = new BitmapData(_loc3_.width * param2,_loc3_.height * param2,true,16777215);
         _loc5_.draw(param1,_loc4_);
         return Utils.alpha_trim(_loc5_);
      }
      
      private function loaded(param1:Number, param2:SkeletonBuddy) : void
      {
         trace("BodyBuilder: loaded");
         body = param2;
         head = body.head as Head;
         param2.head.set_lipsync(1);
         param2.head.set_lids([1,1]);
         param2.head.set_expression(1);
         if(head_id == "-1")
         {
            body.add_clothing("pants05");
            body.add_clothing("shirt02");
            body.cld.set_colour("ffcc99",int("0xffcc99"));
         }
         body.name = "BigBoy";
         head.name = body.name;
         head.cld.name = head.name;
         head_lib.set_head(head);
         head_lib.set_body(body);
         head.library = head_lib.head_event;
         if(name != "introbuilder_99")
         {
            wiz_head_lib.set_head(head);
            wiz_head_lib.set_body(body);
         }
         if(head_id == "-1")
         {
            body.cld.set_colour("fffffe",15987699);
            body.cld.set_colour("f5f5f5",6710886);
            body.cld.set_colour("D4D4D4",6710886);
         }
         this.done = true;
         dispatchEvent(new Event("loaded"));
      }
      
      public function set_sex(param1:uint) : void
      {
         if(body.sex != param1)
         {
            body.sex = param1;
            if(param1 == 1)
            {
               set_man(head);
            }
            else
            {
               set_woman(head);
            }
            equalize();
         }
      }
      
      public function save_work(param1:Body) : Array
      {
         var _loc4_:BitmapData = null;
         var _loc2_:Object = param1.head.save();
         _loc2_["body"] = param1.save();
         _loc2_["state"] = param1.save_state();
         var _loc3_:Rectangle = param1.getBounds(param1);
         var _loc5_:Matrix = new Matrix();
         _loc5_.translate(-_loc3_.x,-_loc3_.y);
         var _loc6_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,16777215);
         _loc6_.draw(param1,_loc5_);
         var _loc7_:Rectangle = _loc6_.getColorBoundsRect(4278190080,0,false);
         _loc4_ = new BitmapData(_loc7_.width,_loc7_.height,true,16777215);
         _loc4_.copyPixels(_loc6_,_loc7_,new Point(0,0),null,null,true);
         var _loc8_:ByteArray = PNGEncoder.encode(_loc4_);
         _loc8_.compress();
         return [_loc2_,_loc8_];
      }
      
      public function equalize() : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc1_:int = 0;
         while(_loc1_ < brothers.length)
         {
            if(restarting)
            {
               brothers[_loc1_].cld.clear();
            }
            if(brothers[_loc1_].body_height != body.body_height)
            {
               brothers[_loc1_].body_height = body.body_height;
            }
            if(brothers[_loc1_].body_type != body.body_type)
            {
               brothers[_loc1_].body_type = body.body_type;
            }
            brothers[_loc1_].cld.equalize(body.cld);
            if(brothers[_loc1_].sex != body.sex)
            {
               brothers[_loc1_].sex = body.sex;
            }
            if(brothers[_loc1_].breast_type != body.breast_type)
            {
               brothers[_loc1_].breast_type = body.breast_type;
            }
            equalize_heads(head,brothers[_loc1_].head);
            _loc2_ = new Array();
            for(_loc3_ in brothers[_loc1_].clothes)
            {
               if(body.clothes.indexOf(brothers[_loc1_].clothes[_loc3_]) == -1)
               {
                  _loc2_.push(brothers[_loc1_].clothes[_loc3_]);
               }
            }
            for(_loc3_ in _loc2_)
            {
               brothers[_loc1_].remove_clothing(_loc2_[_loc3_]);
            }
            for(_loc3_ in body.clothes)
            {
               brothers[_loc1_].add_clothing(body.clothes[_loc3_]);
            }
            brothers[_loc1_].head.set_expression(1);
            _loc1_ = _loc1_ + 1;
         }
         head.set_expression(1);
      }
      
      public function restart() : void
      {
         trace("Restarting: ");
         restarting = true;
         char_loader.get_char(head_id,loaded,-1);
         equalize();
         restarting = false;
      }
      
      private function finish_save(param1:TimerEvent) : void
      {
         var _loc2_:DisplayObject = null;
         if(body.mask)
         {
            _loc2_ = body.mask;
         }
         body.mask = null;
         body.scaleX = body.scaleY = 1;
         head.edit = false;
         body.y = 0;
         var _loc3_:Object = head.save();
         _loc3_["body"] = body.save();
         _loc3_["state"] = body.save_state();
         _loc3_["head_type"] = "Buddy";
         var _loc4_:ByteArray = PNGEncoder.encode(BodyBuilder.body2bitmap(body,1));
         var _loc5_:ByteArray = PNGEncoder.encode(BodyBuilder.body2bitmap(body,0.45));
         var _loc6_:ByteArray = PNGEncoder.encode(BodyBuilder.body2bitmap(body,0.25));
         if(save_callback == null)
         {
            save_callback = save_call;
         }
         var _loc7_:uint = 0;
         if(avatar)
         {
            _loc7_ = 1;
         }
         this.error_callback = save_onError;
         if(avatar || head_id != "-1" && orig_name == name)
         {
            remote.save_char_v2(user_id,head_id,_loc3_,_loc7_,_loc4_,_loc5_,_loc6_,save_callback,save_onError);
         }
         else
         {
            remote.save_new_char_v2(user_id,save_new_name,_loc3_,Number(friend),_loc4_,_loc5_,_loc6_,save_callback,save_onError);
         }
         body.mask = _loc2_;
      }
      
      public function naked(param1:SkeletonBuddy) : void
      {
         trace("MAKING NAKED: " + param1);
         var _loc2_:int = param1.clothes.length - 1;
         while(_loc2_ >= 0)
         {
            param1.remove_clothing(param1.clothes[_loc2_]);
            _loc2_--;
         }
         trace("\t" + param1.clothes);
      }
      
      private function equalize_heads(param1:Head, param2:Head) : void
      {
         var _loc3_:* = null;
         if(param1.hairstyle != param2.hairstyle)
         {
            param2.set_hairstyle(param1.hairstyle);
         }
         if(param1.beardstyle != param2.beardstyle)
         {
            param2.set_beardstyle(param1.beardstyle);
         }
         if(param1.backstyle != param2.backstyle)
         {
            param2.set_backstyle(param1.backstyle);
         }
         for(_loc3_ in param1.pieces)
         {
            if(param1.pieces[_loc3_]["art_id"] != param2.pieces[_loc3_]["art_id"])
            {
               param2.set_art(param1.pieces[_loc3_].piece_id,param1.pieces[_loc3_]["art_type"],param1.pieces[_loc3_]["art_id"]);
            }
         }
      }
      
      public function sex_options() : void
      {
         brothers[0].sex = 1;
         brothers[1].sex = 2;
         if(body.sex == 2)
         {
            set_man(brothers[0].head);
         }
         else
         {
            if(BSConstants.KID_MODE)
            {
               brothers[1].breast_type = 3;
            }
            set_woman(brothers[1].head);
         }
      }
      
      private function brother_loaded(param1:Number, param2:SkeletonBuddy) : void
      {
         trace("Brother loaded: " + param1 + " " + brothers.length);
         param2.buttonMode = true;
         brothers.push(param2);
         Head(param2.head).ppd = Head(head).ppd;
         param2.name = (brothers.length - 1).toString();
         param2.head.name = param2.cld.name = param2.name;
         param2.head.set_expression(1);
         param2.head.set_lipsync(1);
         param2.head.set_lids([1,1]);
         param2.clear_listeners();
         trace("\tBrothers? " + brothers);
         if(head_id == "-1")
         {
            param2.add_clothing("pants05");
            param2.add_clothing("shirt02");
         }
         if(brothers.length == 5)
         {
            trace("\t All brothers loaded, dispatching event");
            dispatchEvent(new Event("brothers_loaded"));
         }
      }
      
      private function save_call(param1:String) : void
      {
         trace("Saved id:" + param1);
         if(param1 == "" || param1 == "-1")
         {
            this.error_callback({"error":"Return ID: " + param1});
            return;
         }
         ExternalInterface.call("clear_leave_block");
         this.saved_id = param1;
         if(bb_type == 4)
         {
            dispatchEvent(new Event("CLOSE_BUILDER"));
            return;
         }
         if(BSConstants.EDU)
         {
            if(bb_type == 3)
            {
               ExternalInterface.call("avatar_update",param1);
            }
            else
            {
               navigateToURL(new URLRequest(remote.base_url + "characters/#char" + param1),"_self");
            }
            return;
         }
         if(bs_save)
         {
            navigateToURL(new URLRequest(remote.base_url + "create/comic/?char_id=" + param1),"_self");
         }
         else if(avatar)
         {
            navigateToURL(new URLRequest(remote.base_url + "user/"),"_self");
         }
         else
         {
            navigateToURL(new URLRequest(remote.base_url + "character/" + param1 + "/"),"_self");
         }
      }
      
      public function load_brothers() : void
      {
         brothers = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            char_loader.get_char(head_id,brother_loaded,-1);
            _loc1_ = _loc1_ + 1;
         }
      }
      
      public function save(param1:String, param2:Function = null, param3:Function = null) : Boolean
      {
         if(param1 == "Name")
         {
            return false;
         }
         if(user_id <= 0)
         {
            return false;
         }
         body.mode = 0;
         body.set_rotation(0);
         body.stance = 1;
         body.gesture = 1;
         save_timer = new Timer(500,1);
         save_new_name = param1;
         save_callback = param2;
         save_onError = param3;
         save_timer.addEventListener(TimerEvent.TIMER,finish_save);
         save_timer.start();
         return true;
      }
   }
}
