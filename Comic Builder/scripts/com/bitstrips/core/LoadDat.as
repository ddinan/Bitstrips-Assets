package com.bitstrips.core
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   
   public class LoadDat extends EventDispatcher
   {
       
      
      private var loaders:Object;
      
      private var bodies:Object;
      
      private var body_data:Object;
      
      private var context:LoaderContext;
      
      private var testing:Boolean = false;
      
      private var remote:Remote;
      
      private var bl:BulkLoader;
      
      private var so:SharedObject;
      
      private var _retry_list:Object;
      
      public function LoadDat(param1:Remote, param2:Boolean = false)
      {
         this.loaders = {};
         this.bodies = {};
         this.body_data = {};
         this.context = new LoaderContext();
         this._retry_list = {};
         super();
         this.context.checkPolicyFile = true;
         this.remote = param1;
         this.remote.dat_loader = this;
         this.testing = this.remote.testing;
         this.bl = new BulkLoader("dat_loader");
         this.bl.addEventListener(BulkLoader.ERROR,dispatchEvent);
         if(param2)
         {
            this.so = SharedObject.getLocal("bitstrips.core.LoadDat","/");
            if(this.so.data["body_data"])
            {
               this.body_data = this.so.data["body_data"];
            }
         }
      }
      
      public function load_dat(param1:String, param2:Function) : void
      {
         var _loc3_:LoadingItem = this.bl.add(param1,{
            "type":BulkLoader.TYPE_BINARY,
            "context":this.context
         });
         _loc3_.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         this.loaders[param1] = param2;
         this.bl.start();
      }
      
      private function recover_error(param1:String) : Boolean
      {
         if(this._retry_list.hasOwnProperty(param1) == false)
         {
            this._retry_list[param1] = 0;
         }
         this._retry_list[param1] = this._retry_list[param1] + 1;
         if(this._retry_list[param1] > 2)
         {
            return false;
         }
         this.bl.remove(param1);
         var _loc2_:LoadingItem = this.bl.add(param1,{
            "type":BulkLoader.TYPE_BINARY,
            "context":this.context,
            "preventCache":true
         });
         _loc2_.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
         this.bl.start();
         return true;
      }
      
      private function onComplete(param1:Event) : void
      {
         var url:String = null;
         var data:ByteArray = null;
         var text:String = null;
         var e:Event = param1;
         url = e.target.url.url;
         if(url.indexOf("?BulkLoader") > 0)
         {
            url = url.slice(0,url.indexOf("?BulkLoader"));
         }
         data = this.bl.getBinary(url,true);
         if(data.length == 0)
         {
            trace("Null data length:" + url);
            if(this.recover_error(url) == false)
            {
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Null Data Error: " + url));
               this.remote.log_error("Null Data Error, Retry: " + this._retry_list[url],url);
            }
            this.bl.start();
            return;
         }
         try
         {
            data.uncompress();
         }
         catch(e:Error)
         {
            if(data.length < 50000)
            {
               text = data.toString().toLowerCase();
               if(text.indexOf("blue coat systems") > 0)
               {
                  dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"We are being blocked by a Blue Coat Systems firewall - contact support@bitstripsforschools for more information"));
                  remote.log_error("Uncompress Data Error Blue Coat",{
                     "url":url,
                     "data":data.toString(),
                     "binary":data
                  });
                  bl.start();
                  return;
               }
               if(text.indexOf("sophos inc") > 0)
               {
                  dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"We are being blocked by a Sophos firewall - contact support@bitstripsforschools for more information"));
                  remote.log_error("Uncompress Data Error Sophos",{
                     "url":url,
                     "data":data.toString(),
                     "binary":data
                  });
                  bl.start();
                  return;
               }
            }
            if(recover_error(url) == false)
            {
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Uncompress error, Length: " + data.length + " URL:" + url));
               remote.log_error("Uncompress Data Error, Retry: " + _retry_list[url],{
                  "url":url,
                  "data":data.toString(),
                  "binary":data
               });
            }
            bl.start();
            return;
         }
         var b:Object = data.readObject();
         if(b && b.hasOwnProperty("type") && b["type"] == "exception")
         {
            dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,b["message"]));
            this.bl.start();
            return;
         }
         if(b.hasOwnProperty("body_id"))
         {
            if(b["deleted"] == 1)
            {
               trace("Deleted character! " + b["body_id"]);
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Deleted Character: " + b["body_id"] + "\n" + url));
               this.bl.start();
               return;
            }
            this.save_char_data(b["body_id"],b["version"],b);
         }
         this.loaders[url](b);
         this.bl.remove(url);
         this.bl.start();
      }
      
      public function save_char_data(param1:String, param2:int, param3:Object) : void
      {
         if(this.body_data[param1] == null)
         {
            this.body_data[param1] = {};
         }
         this.body_data[param1][param2] = param3;
         if(this.so)
         {
            this.so.data["body_data"] = this.body_data;
            this.so.flush();
         }
      }
      
      public function get_char_data(param1:String, param2:int = -1) : Object
      {
         var _loc3_:* = null;
         if(this.body_data[param1] && this.body_data[param1][param2])
         {
            return this.body_data[param1][param2];
         }
         if(param2 == -1 && this.body_data[param1])
         {
            for(_loc3_ in this.body_data[param1])
            {
               trace(_loc3_);
            }
            return this.body_data[param1][_loc3_];
         }
         if(this.body_data[param1])
         {
            for(_loc3_ in this.body_data[param1])
            {
               trace(_loc3_);
            }
            if(Number(_loc3_) > param2)
            {
               return this.body_data[param1][_loc3_];
            }
         }
         return null;
      }
      
      public function load_char(param1:String, param2:Function, param3:int = -1) : void
      {
         var _loc4_:* = null;
         if(this.body_data[param1] && this.body_data[param1][param3])
         {
            param2(this.body_data[param1][param3]);
         }
         else if(param3 == -1 && this.body_data[param1])
         {
            for(_loc4_ in this.body_data[param1])
            {
               trace(_loc4_);
            }
            param2(this.body_data[param1][_loc4_]);
         }
         else
         {
            if(param3 == -1)
            {
               param3 = int(Math.random() * 1000);
            }
            this.load_dat(this.remote.base_url + "get/char/" + param1 + "/" + param3 + "/",param2);
         }
      }
   }
}
