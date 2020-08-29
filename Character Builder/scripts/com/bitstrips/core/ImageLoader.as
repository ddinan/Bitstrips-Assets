package com.bitstrips.core
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class ImageLoader extends EventDispatcher
   {
      
      private static var instance:ImageLoader = new ImageLoader();
       
      
      public var remote:Remote;
      
      private var _io_error:int = 0;
      
      private var context:LoaderContext;
      
      private var _waiting_urls:Array;
      
      public var images:Object;
      
      private var waiting_auths:Object;
      
      public function ImageLoader()
      {
         images = new Object();
         _waiting_urls = [];
         context = new LoaderContext(true);
         waiting_auths = {};
         super();
         if(instance)
         {
            throw new Error("ImageLoader can only be accesed through ImageLoader.getInstance();");
         }
         context.checkPolicyFile = true;
      }
      
      public static function getInstance() : ImageLoader
      {
         return instance;
      }
      
      public function get_image(param1:String, param2:Function = null, param3:Function = null) : DisplayObject
      {
         var _loc4_:Bitmap = null;
         if(images[param1])
         {
            _loc4_ = new Bitmap(images[param1],"auto",true);
            _loc4_.smoothing = true;
            return _loc4_;
         }
         return load_image(param1,param2,param3);
      }
      
      private function load_image(param1:String, param2:Function = null, param3:Function = null) : Loader
      {
         var _loc4_:Loader = new Loader();
         if(param1 == "givemetextbubble" || param1 == null || param1 == "")
         {
            return _loc4_;
         }
         _waiting_urls.push(param1);
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,image_loaded);
         if(param3 != null)
         {
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,param3);
         }
         else
         {
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,error);
         }
         if(param2 != null)
         {
            _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,param2);
         }
         if(param1.substr(0,37) == "http://images.bitstripsforschools.com")
         {
            if(waiting_auths.hasOwnProperty(param1))
            {
               waiting_auths[param1].push({
                  "loader":_loc4_,
                  "error":param3
               });
            }
            else
            {
               waiting_auths[param1] = [{
                  "loader":_loc4_,
                  "error":param3
               }];
               remote.get_image_signature(param1,signature_loaded);
            }
            return _loc4_;
         }
         var _loc5_:URLRequest = new URLRequest(param1);
         _loc4_.load(_loc5_,context);
         return _loc4_;
      }
      
      private function error(param1:IOErrorEvent) : void
      {
         if(_io_error == 0)
         {
            Remote.log_error_post("Error loading image " + param1.text,_waiting_urls);
         }
         _io_error = _io_error + 1;
         dispatchEvent(new ErrorEvent("Error loading image " + param1.text,false,false,param1.text));
      }
      
      private function image_loaded(param1:Event) : void
      {
         var _loc2_:String = param1.target.url;
         if(_loc2_.search("AWSAccessKeyId=") > 0)
         {
            _loc2_ = _loc2_.substr(0,_loc2_.search("AWSAccessKeyId=") - 1);
         }
         if(_waiting_urls.indexOf(_loc2_) >= 0)
         {
            _waiting_urls.splice(_waiting_urls.indexOf(_loc2_),1);
         }
         var _loc3_:Loader = Loader(param1.target.loader);
         images[_loc2_] = Bitmap(_loc3_.content).bitmapData;
         Bitmap(_loc3_.content).smoothing = true;
         Bitmap(_loc3_.content).pixelSnapping = PixelSnapping.NEVER;
      }
      
      private function signature_loaded(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:URLRequest = null;
         var _loc7_:Sprite = null;
         var _loc8_:Object = null;
         var _loc2_:String = param1["url"];
         var _loc3_:Array = waiting_auths[_loc2_];
         if(param1.hasOwnProperty("signed"))
         {
            _loc5_ = param1["signed"];
            _loc6_ = new URLRequest(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc3_[_loc4_]["loader"].load(_loc6_,context);
               _loc4_++;
            }
         }
         else if(param1.hasOwnProperty("error") == true)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc7_ = new Sprite();
               _loc7_.graphics.beginFill(16711680,0.5);
               _loc7_.graphics.drawRoundRect(-20,-20,40,40,10,10);
               _loc7_.graphics.endFill();
               _loc8_ = _loc3_[_loc4_];
               if(_loc8_["error"] != null)
               {
                  _loc8_["error"](new ErrorEvent("error",false,false,"Error loading image: " + param1["error"]));
               }
               else
               {
                  dispatchEvent(new ErrorEvent("error",false,false,"Error loading image: " + param1["error"]));
               }
               _loc4_++;
            }
         }
         else
         {
            dispatchEvent(new ErrorEvent("error",false,false,"No signature or error for " + _loc2_));
            return;
         }
      }
   }
}
