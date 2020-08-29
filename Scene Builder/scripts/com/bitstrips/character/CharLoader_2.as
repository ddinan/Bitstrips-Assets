package com.bitstrips.character
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColourData;
   import com.bitstrips.core.LoadDat;
   import com.bitstrips.core.Remote;
   import flash.display.DisplayObject;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class CharLoader extends EventDispatcher
   {
      
      public static var pose_data:Object;
       
      
      private var loaders:Object;
      
      public var loaded:uint = 0;
      
      private var remote:Remote;
      
      public var loaded_done:Boolean = false;
      
      private var debug:Boolean = false;
      
      private var load_prop_list:Object;
      
      public var art_loader:ArtLoader;
      
      public var dat_loader:LoadDat;
      
      private var load_calls:Object;
      
      public function CharLoader(param1:Remote, param2:Boolean = false)
      {
         var _loc4_:Array = null;
         load_calls = new Object();
         art_loader = ArtLoader.getInstance();
         load_prop_list = new Object();
         loaders = new Object();
         super();
         this.remote = param1;
         dat_loader = new LoadDat(param1,param2);
         dat_loader.addEventListener(BulkLoader.ERROR,dispatchEvent);
         var _loc3_:* = BSConstants.NEW_ASSET_URL + "art/v1/lines.dat";
         if(BSConstants.AIR)
         {
            _loc3_ = "app:/lines.dat";
         }
         dat_loader.load_dat(_loc3_,done_load);
         if(BSConstants.SKELETON)
         {
            _loc3_ = BSConstants.NEW_ASSET_URL + "art/v1/poses.dat";
            if(BSConstants.AIR)
            {
               _loc3_ = "app:/poses.dat";
            }
            dat_loader.load_dat(_loc3_,pose_load);
         }
         _loc3_ = BSConstants.NEW_ASSET_URL + "art/v1/head_new.swf";
         if(BSConstants.AIR)
         {
            _loc3_ = "app:/head_new.swf";
         }
         _loc4_ = [_loc3_];
         if(BSConstants.OLD_BODY)
         {
            dat_loader.load_dat(param1.assurl("body_art/points.dat"),done_load2);
            _loc4_.push(param1.assurl("body_art/simple_bare.swf"));
         }
         if(BSConstants.PROPS)
         {
            _loc4_.push(param1.new_assurl("props.swf"));
         }
         if(BSConstants.BODY_BUILDER)
         {
            _loc4_.push(ArtLoader.clothing_url("bare"));
            _loc4_.push(ArtLoader.clothing_url("pants05"));
            _loc4_.push(ArtLoader.clothing_url("shirt02"));
         }
         var _loc5_:uint = art_loader.load_swfs(_loc4_,art_loaded);
         if(debug)
         {
            trace("Load ID: " + _loc5_);
         }
         art_loader.addEventListener(BulkProgressEvent.PROGRESS,dispatchEvent);
         art_loader.addEventListener(BulkLoader.ERROR,bulk_error);
      }
      
      private function done_load(param1:Object) : void
      {
         if(debug)
         {
            trace("CL: Done dat");
         }
         art_loader.line_data = param1;
         loaded = loaded + 1;
         load3_check();
      }
      
      private function done_load2(param1:Object) : void
      {
         if(debug)
         {
            trace("CL: Done points dat");
         }
         art_loader.points = param1;
         loaded = loaded + 1;
         load3_check();
      }
      
      public function get_char_asset(param1:String, param2:DisplayObject, param3:int = -1) : ComicCharAsset
      {
         var _loc4_:ComicCharAsset = new ComicCharAsset(param1);
         if(param2)
         {
            param2.scaleX = param2.scaleY = param2.scaleY * (BSConstants.RESCALE / 0.45);
            _loc4_.artwork.addChild(param2);
            param2.x = -param2.width / 2;
            param2.y = -param2.height;
            param2.transform.colorTransform = new ColorTransform(1,1,1,1,-100,-100,-100);
         }
         get_char(param1,_loc4_.loaded,param3);
         return _loc4_;
      }
      
      private function pose_load(param1:Object) : void
      {
         if(debug)
         {
            trace("CL: Done dat");
         }
         CharLoader.pose_data = param1;
         load3_check();
      }
      
      public function new_char(param1:String) : SkeletonBuddy
      {
         var _loc2_:Object = null;
         var _loc3_:PPData = null;
         var _loc4_:ColourData = null;
         var _loc5_:Head = null;
         var _loc6_:SkeletonBuddy = null;
         trace("New char for body: " + param1);
         if(param1 == "-1")
         {
            _loc3_ = new PPData();
            _loc4_ = new ColourData();
            _loc5_ = new Head(_loc3_,_loc4_);
            if(BSConstants.KID_MODE)
            {
               _loc6_ = new SkeletonBuddy(_loc5_,art_loader,{
                  "body_height":3,
                  "breast_type":3
               });
            }
            else
            {
               _loc6_ = new SkeletonBuddy(_loc5_,art_loader,undefined);
            }
            _loc6_.init();
            _loc6_.body_rotation = 0;
            return _loc6_;
         }
         _loc2_ = dat_loader.get_char_data(param1);
         _loc3_ = new PPData(_loc2_);
         _loc4_ = new ColourData(_loc2_["colours"]);
         _loc5_ = new Head(_loc3_,_loc4_);
         _loc6_ = new SkeletonBuddy(_loc5_,art_loader,_loc2_["body"]);
         if(_loc2_["user_id"])
         {
            _loc6_.name = _loc2_["user_id"];
         }
         _loc6_.init();
         if(_loc2_["state"])
         {
            if(debug)
            {
               trace("There\'s state! Calling load_state - " + _loc2_["state"]);
            }
            _loc6_.load_state(_loc2_["state"]);
         }
         else
         {
            _loc6_.body_rotation = 0;
         }
         return _loc6_;
      }
      
      private function load3_check() : void
      {
         var _loc1_:* = undefined;
         if(BSConstants.SKELETON && CharLoader.pose_data == null)
         {
            return;
         }
         if(BSConstants.OLD_BODY && loaded < 3)
         {
            return;
         }
         if(loaded >= 2)
         {
            trace("Load3 check is OK");
            for(_loc1_ in load_calls)
            {
               if(dat_loader.get_char_data(_loc1_) != null || _loc1_ == -1)
               {
                  trace("\tData Loaded: " + _loc1_);
                  call_load_calls(_loc1_);
               }
            }
            dispatchEvent(new Event("LOADED"));
            loaded_done = true;
         }
         else
         {
            trace("load3: Not loaded" + loaded);
         }
      }
      
      private function bulk_error(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
         remote.log_error("BulkLoader Error",param1);
      }
      
      public function loaded_body(param1:Object) : void
      {
         var _loc2_:String = param1["body_id"];
         trace("Load data call returned for body: " + _loc2_);
         if(loaded >= 2)
         {
            call_load_calls(_loc2_);
         }
      }
      
      public function get_prop_asset(param1:String) : ComicPropAsset
      {
         var _loc2_:ComicPropAsset = new ComicPropAsset(param1);
         if(loaded >= 2)
         {
            _loc2_.loadComplete(get_prop(param1));
         }
         else
         {
            if(load_prop_list[param1] == undefined)
            {
               load_prop_list[param1] = new Array();
            }
            load_prop_list[param1].push(_loc2_);
         }
         return _loc2_;
      }
      
      public function new_head(param1:String, param2:int = -1, param3:Boolean = false) : Head
      {
         var _loc4_:Object = null;
         var _loc5_:PPData = null;
         var _loc6_:ColourData = null;
         var _loc7_:Head = null;
         if(param1 == "-1")
         {
            _loc5_ = new PPData();
            _loc6_ = new ColourData();
            _loc7_ = new Head(_loc5_,_loc6_);
            return _loc7_;
         }
         _loc4_ = this.dat_loader.get_char_data(param1,param2);
         _loc5_ = new PPData(_loc4_);
         _loc6_ = new ColourData(_loc4_["colours"]);
         _loc7_ = new Head(_loc5_,_loc6_);
         return _loc7_;
      }
      
      private function art_loaded(param1:uint) : void
      {
         trace("Art has loaded, can now proceed with any new_char calls...");
         loaded = loaded + 1;
         load3_check();
      }
      
      public function get_prop(param1:String) : Object
      {
         var _loc2_:String = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:Object = art_loader.props;
         for(_loc4_ in _loc3_)
         {
            for(_loc5_ in _loc3_[_loc4_])
            {
               if(_loc5_ == param1)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
         }
         if(param1 == "parallelogram3" || param1 == "parallelogram4")
         {
            _loc2_ = "shapes";
         }
         return art_loader.get_prop(_loc2_,param1);
      }
      
      public function get_char(param1:String, param2:Function, param3:int = -1) : Boolean
      {
         trace("In get char, requesting " + param1);
         if((dat_loader.get_char_data(param1,param3) || param1 == "-1") && loaded == 2)
         {
            trace("\tI already have body_id " + param1 + ", imediattely calling load_call");
            param2(param1,new_char(param1));
            return true;
         }
         if(load_calls[param1])
         {
            trace("\tSomeone already requested this body, adding our load_call to the list");
            load_calls[param1].push(param2);
            return true;
         }
         trace("\tI don\'t have the body yet, making a load_data call");
         load_calls[param1] = [param2];
         if(param1 != "-1")
         {
            dat_loader.load_char(param1,loaded_body,param3);
         }
         return true;
      }
      
      private function call_load_calls(param1:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         trace("CL -- Call load_calls: " + param1);
         var _loc2_:uint = 0;
         while(_loc2_ < load_calls[param1].length)
         {
            trace("\tCL - Calling load: " + _loc2_);
            load_calls[param1][_loc2_](param1,new_char(param1));
            _loc2_ = _loc2_ + 1;
         }
         load_calls[param1] = new Array();
         for(_loc3_ in load_prop_list)
         {
            for(_loc4_ in load_prop_list[_loc3_])
            {
               trace("Loaded: " + _loc2_);
               load_prop_list[_loc3_][_loc4_].loadComplete(get_prop(_loc3_));
            }
         }
         trace("\tI made the all load_calls for the body...");
      }
   }
}
