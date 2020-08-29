package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class URLItem extends LoadingItem
   {
       
      
      public var loader:URLLoader;
      
      public function URLItem(param1:URLRequest, param2:String, param3:String)
      {
         super(param1,param2,param3);
      }
      
      override public function stop() : void
      {
         try
         {
            if(loader)
            {
               loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(loader)
         {
            loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            loader.removeEventListener(Event.COMPLETE,onCompleteHandler,false);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            loader.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
         }
      }
      
      override public function load() : void
      {
         super.load();
         loader = new URLLoader();
         loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         loader.addEventListener(Event.COMPLETE,onCompleteHandler,false,0,true);
         loader.addEventListener(IOErrorEvent.IO_ERROR,super.onErrorHandler,false,0,true);
         loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         loader.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         try
         {
            loader.load(url);
            return;
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
            return;
         }
      }
      
      override public function isText() : Boolean
      {
         return true;
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         super.onStartedHandler(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = loader.data;
         super.onCompleteHandler(param1);
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         return super._parseOptions(param1);
      }
      
      override public function destroy() : void
      {
         stop();
         cleanListeners();
         _content = null;
         loader = null;
      }
   }
}
