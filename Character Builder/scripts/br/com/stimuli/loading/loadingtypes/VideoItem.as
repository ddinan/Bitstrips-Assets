package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.ProgressEvent;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class VideoItem extends LoadingItem
   {
       
      
      public var stream:NetStream;
      
      public var dummyEventTrigger:Sprite;
      
      public var pausedAtStart:Boolean = false;
      
      public var _metaData:Object;
      
      public var _canBeginStreaming:Boolean = false;
      
      private var nc:NetConnection;
      
      public var _checkPolicyFile:Boolean;
      
      public function VideoItem(param1:URLRequest, param2:String, param3:String)
      {
         specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE,BulkLoader.PAUSED_AT_START];
         super(param1,param2,param3);
         _bytesTotal = _bytesLoaded = 0;
      }
      
      public function get checkPolicyFile() : Object
      {
         return _checkPolicyFile;
      }
      
      override public function onStartedHandler(param1:Event) : void
      {
         _content = stream;
         if(pausedAtStart && stream)
         {
            stream.pause();
            stream.seek(0);
         }
         super.onStartedHandler(param1);
      }
      
      override public function stop() : void
      {
         try
         {
            if(stream)
            {
               stream.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function _parseOptions(param1:Object) : Array
      {
         pausedAtStart = param1[BulkLoader.PAUSED_AT_START] || false;
         _checkPolicyFile = param1[BulkLoader.CHECK_POLICY_FILE] || false;
         return super._parseOptions(param1);
      }
      
      private function fireCanBeginStreamingEvent() : void
      {
         if(_canBeginStreaming)
         {
            return;
         }
         _canBeginStreaming = true;
         var _loc1_:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
         dispatchEvent(_loc1_);
      }
      
      public function get metaData() : Object
      {
         return _metaData;
      }
      
      function onNetStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:Event = null;
         if(!stream)
         {
            return;
         }
         stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         if(param1.info.code == "NetStream.Play.Start")
         {
            _content = stream;
            _loc2_ = new Event(Event.OPEN);
            onStartedHandler(_loc2_);
         }
         else if(param1.info.code == "NetStream.Play.StreamNotFound")
         {
            onErrorHandler(_createErrorEvent(new Error("[VideoItem] NetStream not found at " + this.url.url)));
         }
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function load() : void
      {
         super.load();
         nc = new NetConnection();
         nc.connect(null);
         stream = new NetStream(nc);
         stream.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         stream.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false,0,true);
         dummyEventTrigger = new Sprite();
         dummyEventTrigger.addEventListener(Event.ENTER_FRAME,createNetStreamEvent,false,0,true);
         var customClient:Object = new Object();
         customClient.onCuePoint = function(... rest):void
         {
         };
         customClient.onMetaData = onVideoMetadata;
         customClient.onPlayStatus = function(... rest):void
         {
         };
         stream.client = customClient;
         try
         {
            stream.play(url.url,_checkPolicyFile);
            return;
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
            return;
         }
      }
      
      public function get canBeginStreaming() : Boolean
      {
         return _canBeginStreaming;
      }
      
      function onVideoMetadata(param1:*) : void
      {
         _metaData = param1;
      }
      
      override public function onCompleteHandler(param1:Event) : void
      {
         _content = stream;
         super.onCompleteHandler(param1);
      }
      
      override public function cleanListeners() : void
      {
         if(stream)
         {
            stream.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            stream.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus,false);
         }
         if(dummyEventTrigger)
         {
            dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            dummyEventTrigger = null;
         }
      }
      
      override public function isVideo() : Boolean
      {
         return true;
      }
      
      public function createNetStreamEvent(param1:Event) : void
      {
         var _loc2_:Event = null;
         var _loc3_:Event = null;
         var _loc4_:ProgressEvent = null;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(_bytesTotal == _bytesLoaded && _bytesTotal > 8)
         {
            if(dummyEventTrigger)
            {
               dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,createNetStreamEvent,false);
            }
            fireCanBeginStreamingEvent();
            _loc2_ = new Event(Event.COMPLETE);
            onCompleteHandler(_loc2_);
         }
         else if(_bytesTotal == 0 && stream && stream.bytesTotal > 4)
         {
            _loc3_ = new Event(Event.OPEN);
            onStartedHandler(_loc3_);
            _bytesLoaded = stream.bytesLoaded;
            _bytesTotal = stream.bytesTotal;
         }
         else if(stream)
         {
            _loc4_ = new ProgressEvent(ProgressEvent.PROGRESS,false,false,stream.bytesLoaded,stream.bytesTotal);
            if(isVideo() && metaData && !_canBeginStreaming)
            {
               _loc5_ = getTimer() - responseTime;
               if(_loc5_ > 100)
               {
                  _loc6_ = bytesLoaded / (_loc5_ / 1000);
                  _bytesRemaining = _bytesTotal - bytesLoaded;
                  _loc7_ = _bytesRemaining / (_loc6_ * 0.8);
                  _loc8_ = metaData.duration - stream.bufferLength;
                  if(_loc8_ > _loc7_)
                  {
                     fireCanBeginStreamingEvent();
                  }
               }
            }
            super.onProgressHandler(_loc4_);
         }
      }
      
      override public function destroy() : void
      {
         if(!stream)
         {
         }
         stop();
         cleanListeners();
         stream = null;
         super.destroy();
      }
   }
}
