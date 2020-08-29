package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   
   public class SoundItem extends LoadingItem
   {
       
      
      public var loader:Sound;
      
      public function SoundItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(param1,param2,param3);
      }
      
      override public function onErrorHandler(param1:ErrorEvent) : void
      {
         super.onErrorHandler(param1);
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
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function isSound() : Boolean
      {
         return true;
      }
      
      override public function load() : void
      {
         super.load();
         loader = new Sound();
         loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         loader.addEventListener(Event.COMPLETE,onCompleteHandler,false,0,true);
         loader.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         loader.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false,0,true);
         try
         {
            loader.load(url,_context);
            return;
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
            return;
         }
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         _content = loader;
         super.onStartedHandler(param1);
      }
      
      override public function destroy() : void
      {
         cleanListeners();
         stop();
         _content = null;
         loader = null;
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         _context = param1[BulkLoader.CONTEXT] || null;
         return super._parseOptions(param1);
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = loader;
         super.onCompleteHandler(param1);
      }
      
      override public function cleanListeners() : void
      {
         if(loader)
         {
            loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            loader.removeEventListener(Event.COMPLETE,onCompleteHandler,false);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            loader.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false);
         }
      }
   }
}
