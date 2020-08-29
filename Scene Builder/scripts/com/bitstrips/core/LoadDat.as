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
      
      private var remote:Remote;
      
      private var body_data:Object;
      
      private var bl:BulkLoader;
      
      private var context:LoaderContext;
      
      private var testing:Boolean = false;
      
      private var bodies:Object;
      
      private var so:SharedObject;
      
      public function LoadDat(param1:Remote, param2:Boolean = false)
      {
         loaders = {};
         bodies = {};
         body_data = {};
         context = new LoaderContext();
         super();
         context.checkPolicyFile = true;
         remote = param1;
         remote.dat_loader = this;
         testing = remote.testing;
         bl = new BulkLoader("dat_loader");
         bl.addEventListener(BulkLoader.ERROR,dispatchEvent);
         if(param2)
         {
            so = SharedObject.getLocal("bitstrips.core.LoadDat","/");
            if(so.data["body_data"])
            {
               body_data = so.data["body_data"];
            }
         }
      }
      
      public function load_dat(param1:String, param2:Function) : void
      {
         var _loc3_:LoadingItem = bl.add(param1,{
            "type":BulkLoader.TYPE_BINARY,
            "context":context
         });
         _loc3_.addEventListener(Event.COMPLETE,onComplete,false,0,true);
         loaders[param1] = param2;
         bl.start();
      }
      
      public function save_char_data(param1:String, param2:int, param3:Object) : void
      {
         if(body_data[param1] == null)
         {
            body_data[param1] = {};
         }
         body_data[param1][param2] = param3;
         if(so)
         {
            so.data["body_data"] = body_data;
            so.flush();
         }
      }
      
      private function onComplete(param1:Event) : void
      {
         var url:String = null;
         var data:ByteArray = null;
         var e:Event = param1;
         url = e.target.url.url;
         data = bl.getBinary(url,true);
         if(data.length == 0)
         {
            trace("Null data length:" + url);
            dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Null Data Error: " + url));
            remote.log_error("Null Data Error",url);
            return;
         }
         try
         {
            data.uncompress();
         }
         catch(e:Error)
         {
            trace("Failed to uncompress data:" + url);
            dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Uncompress error, Length: " + data.length + " URL:" + url));
            remote.log_error("Uncompress Data Error",{
               "url":url,
               "data":data.toString(),
               "binary":data
            });
            bl.start();
            return;
         }
         var b:Object = data.readObject();
         if(b && b.hasOwnProperty("type") && b["type"] == "exception")
         {
            dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,b["message"]));
            bl.start();
            return;
         }
         if(b.hasOwnProperty("body_id"))
         {
            if(b["deleted"] == 1)
            {
               trace("Deleted character! " + b["body_id"]);
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Deleted Character: " + b["body_id"] + "\n" + url));
               bl.start();
               return;
            }
            this.save_char_data(b["body_id"],b["version"],b);
         }
         loaders[url](b);
         bl.start();
      }
      
      public function load_char(param1:String, param2:Function, param3:int = -1) : void
      {
         var _loc4_:* = null;
         if(body_data[param1] && body_data[param1][param3])
         {
            param2(body_data[param1][param3]);
         }
         else if(param3 == -1 && body_data[param1])
         {
            for(_loc4_ in body_data[param1])
            {
               trace(_loc4_);
            }
            param2(body_data[param1][_loc4_]);
         }
         else
         {
            if(param3 == -1)
            {
               param3 = int(Math.random() * 1000);
            }
            load_dat(remote.base_url + "get/char/" + param1 + "/" + param3 + "/",param2);
         }
      }
      
      public function get_char_data(param1:String, param2:int = -1) : Object
      {
         var _loc3_:* = null;
         if(body_data[param1] && body_data[param1][param2])
         {
            return body_data[param1][param2];
         }
         if(param2 == -1 && body_data[param1])
         {
            for(_loc3_ in body_data[param1])
            {
               trace(_loc3_);
            }
            return body_data[param1][_loc3_];
         }
         if(body_data[param1])
         {
            for(_loc3_ in body_data[param1])
            {
               trace(_loc3_);
            }
            if(Number(_loc3_) > param2)
            {
               return body_data[param1][_loc3_];
            }
         }
         return null;
      }
   }
}
