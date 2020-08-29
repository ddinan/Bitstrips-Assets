package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.utils.SmartURL;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class LoadingItem extends EventDispatcher
   {
      
      public static const STATUS_STOPPED:String = "stopped";
      
      public static const STATUS_STARTED:String = "started";
      
      public static const STATUS_ERROR:String = "error";
      
      public static const STATUS_FINISHED:String = "finished";
       
      
      public var _priority:int = 0;
      
      public var _type:String;
      
      public var _parsedURL:SmartURL;
      
      public var _isLoaded:Boolean;
      
      public var _isLoading:Boolean;
      
      public var _additionIndex:int;
      
      public var _bytesTotal:int = -1;
      
      public var _httpStatus:int = -1;
      
      public var _content;
      
      public var status:String;
      
      public var _speed:Number;
      
      public var _weightPercentLoaded:Number;
      
      public var propertyParsingErrors:Array;
      
      public var url:URLRequest;
      
      public var errorEvent:ErrorEvent;
      
      public var weight:int = 1;
      
      public var _addedTime:int;
      
      public var _context = null;
      
      public var preventCache:Boolean;
      
      public var _responseTime:Number;
      
      public var _uid:String;
      
      public var maxTries:int = 3;
      
      public var _bytesLoaded:int = 0;
      
      public var _percentLoaded:Number;
      
      public var _totalTime:int;
      
      public var numTries:int = 0;
      
      public var _id:String;
      
      public var _latency:Number;
      
      public var _startTime:int;
      
      public var _bytesRemaining:int = 2.147483647E9;
      
      public var _timeToDownload:Number;
      
      public var specificAvailableProps:Array;
      
      public function LoadingItem(param1:URLRequest, param2:String, param3:String)
      {
         super();
         this._type = param2;
         this.url = param1;
         _parsedURL = new SmartURL(param1.url);
         if(!specificAvailableProps)
         {
            specificAvailableProps = [];
         }
         this._uid = param3;
      }
      
      public function onSecurityErrorHandler(param1:ErrorEvent) : void
      {
         status = STATUS_ERROR;
         errorEvent = param1 as ErrorEvent;
         param1.stopPropagation();
         _dispatchErrorEvent(errorEvent);
      }
      
      public function stop() : void
      {
         if(_isLoaded)
         {
            return;
         }
         status = STATUS_STOPPED;
         _isLoading = false;
      }
      
      public function isSound() : Boolean
      {
         return false;
      }
      
      public function onCompleteHandler(param1:Event) : void
      {
         _totalTime = getTimer();
         _timeToDownload = (_totalTime - _responseTime) / 1000;
         if(_timeToDownload == 0)
         {
            _timeToDownload = 0.1;
         }
         _bytesTotal = _bytesLoaded;
         _bytesRemaining = 0;
         _speed = BulkLoader.truncateNumber(bytesTotal / 1024 / _timeToDownload);
         status = STATUS_FINISHED;
         _isLoaded = true;
         dispatchEvent(param1);
         param1.stopPropagation();
      }
      
      public function get weightPercentLoaded() : Number
      {
         return _weightPercentLoaded;
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function _dispatchErrorEvent(param1:ErrorEvent) : void
      {
         status = STATUS_ERROR;
         dispatchEvent(new ErrorEvent(BulkLoader.ERROR,true,false,param1.text));
      }
      
      public function onHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         _httpStatus = param1.status;
         dispatchEvent(param1);
      }
      
      public function get totalTime() : int
      {
         return _totalTime;
      }
      
      public function get type() : String
      {
         return _type;
      }
      
      public function get speed() : Number
      {
         return _speed;
      }
      
      public function _parseOptions(param1:Object) : Array
      {
         var _loc3_:* = null;
         preventCache = param1[BulkLoader.PREVENT_CACHING];
         _id = param1[BulkLoader.ID];
         _priority = int(int(param1[BulkLoader.PRIORITY])) || 0;
         maxTries = int(param1[BulkLoader.MAX_TRIES]) || 3;
         weight = int(int(param1[BulkLoader.WEIGHT])) || 1;
         var _loc2_:Array = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(specificAvailableProps);
         propertyParsingErrors = [];
         for(_loc3_ in param1)
         {
            if(_loc2_.indexOf(_loc3_) == -1)
            {
               propertyParsingErrors.push(this + ": got a wrong property name: " + _loc3_ + ", with value:" + param1[_loc3_]);
            }
         }
         return propertyParsingErrors;
      }
      
      public function get startTime() : int
      {
         return _startTime;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      public function isImage() : Boolean
      {
         return false;
      }
      
      public function onStartedHandler(param1:Event) : void
      {
         _responseTime = getTimer();
         _latency = BulkLoader.truncateNumber((_responseTime - _startTime) / 1000);
         status = STATUS_STARTED;
         dispatchEvent(param1);
      }
      
      public function get hostName() : String
      {
         return _parsedURL.host;
      }
      
      override public function toString() : String
      {
         return "LoadingItem url: " + url.url + ", type:" + _type + ", status: " + status;
      }
      
      public function isVideo() : Boolean
      {
         return false;
      }
      
      public function isText() : Boolean
      {
         return false;
      }
      
      public function get content() : *
      {
         return _content;
      }
      
      public function onProgressHandler(param1:ProgressEvent) : void
      {
         _bytesLoaded = param1.bytesLoaded;
         _bytesTotal = param1.bytesTotal;
         _bytesRemaining = _bytesTotal - bytesLoaded;
         if(_bytesRemaining < 0)
         {
            _bytesRemaining = int.MAX_VALUE;
         }
         if(_bytesTotal < 4 && _bytesLoaded > 0)
         {
            _bytesTotal = int.MAX_VALUE;
         }
         _percentLoaded = _bytesLoaded / _bytesTotal;
         _weightPercentLoaded = _percentLoaded * weight;
         var _loc2_:BulkProgressEvent = new BulkProgressEvent(BulkLoader.PROGRESS,true,false);
         _loc2_._percentLoaded = _percentLoaded;
         _loc2_.bytesTotal = _bytesTotal;
         _loc2_.bytesLoaded = _bytesLoaded;
         param1.stopImmediatePropagation();
         dispatchEvent(_loc2_);
      }
      
      public function isXML() : Boolean
      {
         return false;
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function get httpStatus() : int
      {
         return _httpStatus;
      }
      
      public function onErrorHandler(param1:ErrorEvent) : void
      {
         numTries++;
         param1.stopPropagation();
         if(numTries < maxTries)
         {
            status = null;
            load();
         }
         else
         {
            status = STATUS_ERROR;
            errorEvent = param1;
            _dispatchErrorEvent(errorEvent);
         }
      }
      
      public function get humanFiriendlySize() : String
      {
         var _loc1_:Number = _bytesTotal / 1024;
         if(_loc1_ < 1024)
         {
            return Math.ceil(_loc1_) + " kb";
         }
         return (_loc1_ / 1024).toPrecision(3) + " mb";
      }
      
      public function isStreamable() : Boolean
      {
         return false;
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get responseTime() : Number
      {
         return _responseTime;
      }
      
      public function get priority() : int
      {
         return _priority;
      }
      
      public function get bytesRemaining() : int
      {
         return _bytesRemaining;
      }
      
      public function get isLoaded() : Boolean
      {
         return _isLoaded;
      }
      
      public function get timeToDownload() : int
      {
         return _timeToDownload;
      }
      
      public function isLoader() : Boolean
      {
         return false;
      }
      
      public function load() : void
      {
         var _loc1_:String = null;
         if(preventCache)
         {
            _loc1_ = "BulkLoaderNoCache=" + _uid + "_" + int(Math.random() * 100 * getTimer());
            if(url.url.indexOf("?") == -1)
            {
               url.url = url.url + ("?" + _loc1_);
            }
            else
            {
               url.url = url.url + ("&" + _loc1_);
            }
         }
         _isLoading = true;
         _startTime = getTimer();
      }
      
      public function getStats() : String
      {
         return "Item url: " + url.url + "(s), total time: " + (_totalTime / 1000).toPrecision(3) + "(s), download time: " + _timeToDownload.toPrecision(3) + "(s), latency:" + _latency + "(s), speed: " + _speed + " kb/s, size: " + humanFiriendlySize;
      }
      
      public function get addedTime() : int
      {
         return _addedTime;
      }
      
      public function _createErrorEvent(param1:Error) : ErrorEvent
      {
         return new ErrorEvent(BulkLoader.ERROR,false,false,param1.message);
      }
      
      public function cleanListeners() : void
      {
      }
      
      public function isSWF() : Boolean
      {
         return false;
      }
      
      public function destroy() : void
      {
         _content = null;
      }
      
      public function get latency() : Number
      {
         return _latency;
      }
   }
}
