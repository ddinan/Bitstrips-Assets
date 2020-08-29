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
       
      
      public var images:Object;
      
      private var _waiting_urls:Array;
      
      private var context:LoaderContext;
      
      public var remote:Remote;
      
      private var waiting_auths:Object;
      
      private var _io_error:int = 0;
      
      public function ImageLoader()
      {
         this.images = new Object();
         this._waiting_urls = [];
         this.context = new LoaderContext(true);
         this.waiting_auths = {};
         super();
         if(instance)
         {
            throw new Error("ImageLoader can only be accesed through ImageLoader.getInstance();");
         }
         this.context.checkPolicyFile = true;
      }
      
      public static function getInstance() : ImageLoader
      {
         return instance;
      }
      
      private function load_image(param1:String, param2:Function = null, param3:Function = null) : Loader
      {
         var _loc4_:Loader = new Loader();
         if(param1 == "givemetextbubble" || param1 == null || param1 == "")
         {
            return _loc4_;
         }
         this._waiting_urls.push(param1);
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.image_loaded);
         if(param3 != null)
         {
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,param3);
         }
         else
         {
            _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.error);
         }
         if(param2 != null)
         {
            _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,param2);
         }
         if(param1.substr(0,37) == "http://images.bitstripsforschools.com")
         {
            if(this.waiting_auths.hasOwnProperty(param1))
            {
               this.waiting_auths[param1].push({
                  "loader":_loc4_,
                  "error":param3
               });
            }
            else
            {
               this.waiting_auths[param1] = [{
                  "loader":_loc4_,
                  "error":param3
               }];
               this.remote.get_image_signature(param1,this.signature_loaded);
            }
            return _loc4_;
         }
         var _loc5_:URLRequest = new URLRequest(param1);
         _loc4_.load(_loc5_,this.context);
         return _loc4_;
      }
      
      private function signature_loaded(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:URLRequest = null;
         var _loc7_:Sprite = null;
         var _loc8_:Object = null;
         var _loc2_:String = param1["url"];
         var _loc3_:Array = this.waiting_auths[_loc2_];
         if(param1.hasOwnProperty("signed"))
         {
            _loc5_ = param1["signed"];
            _loc6_ = new URLRequest(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc3_[_loc4_]["loader"].load(_loc6_,this.context);
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
      
      private function error(param1:IOErrorEvent) : void
      {
         if(this._io_error == 0)
         {
            Remote.log_error_post("Error loading image " + param1.text,this._waiting_urls);
         }
         this._io_error = this._io_error + 1;
         dispatchEvent(new ErrorEvent("Error loading image " + param1.text,false,false,param1.text));
      }
      
      private function image_loaded(param1:Event) : void
      {
         var _loc2_:String = param1.target.url;
         if(_loc2_.search("AWSAccessKeyId=") > 0)
         {
            _loc2_ = _loc2_.substr(0,_loc2_.search("AWSAccessKeyId=") - 1);
         }
         if(this._waiting_urls.indexOf(_loc2_) >= 0)
         {
            this._waiting_urls.splice(this._waiting_urls.indexOf(_loc2_),1);
         }
         var _loc3_:Loader = Loader(param1.target.loader);
         this.images[_loc2_] = Bitmap(_loc3_.content).bitmapData;
         Bitmap(_loc3_.content).smoothing = true;
         Bitmap(_loc3_.content).pixelSnapping = PixelSnapping.NEVER;
      }
      
      public function get_image(param1:String, param2:Function = null, param3:Function = null) : DisplayObject
      {
         var _loc4_:Bitmap = null;
         if(this.images[param1])
         {
            _loc4_ = new Bitmap(this.images[param1],"auto",true);
            _loc4_.smoothing = true;
            return _loc4_;
         }
         return this.load_image(param1,param2,param3);
      }
   }
}
