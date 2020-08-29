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
      
      private var bl:BulkLoader;
      
      private var bodies:Object;
      
      private var testing:Boolean = false;
      
      private var so:SharedObject;
      
      private var body_data:Object;
      
      private var context:LoaderContext;
      
      private var _retry_list:Object;
      
      public function LoadDat(param1:Remote, param2:Boolean = false)
      {
         loaders = {};
         bodies = {};
         body_data = {};
         context = new LoaderContext();
         _retry_list = {};
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
      
      private function recover_error(param1:String) : Boolean
      {
         if(_retry_list.hasOwnProperty(param1) == false)
         {
            _retry_list[param1] = 0;
         }
         _retry_list[param1] = _retry_list[param1] + 1;
         if(_retry_list[param1] > 2)
         {
            return false;
         }
         bl.remove(param1);
         var _loc2_:LoadingItem = bl.add(param1,{
            "type":BulkLoader.TYPE_BINARY,
            "context":context,
            "preventCache":true
         });
         _loc2_.addEventListener(Event.COMPLETE,onComplete,false,0,true);
         bl.start();
         return true;
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
         var text:String = null;
         var e:Event = param1;
         url = e.target.url.url;
         if(url.indexOf("?BulkLoader") > 0)
         {
            url = url.slice(0,url.indexOf("?BulkLoader"));
         }
         data = bl.getBinary(url,true);
         if(data.length == 0)
         {
            trace("Null data length:" + url);
            if(recover_error(url) == false)
            {
               dispatchEvent(new ErrorEvent(BulkLoader.ERROR,false,false,"Null Data Error: " + url));
               remote.log_error("Null Data Error, Retry: " + _retry_list[url],url);
            }
            bl.start();
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
         bl.remove(url);
         bl.start();
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
   }
}
