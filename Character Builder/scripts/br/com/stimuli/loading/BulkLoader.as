package br.com.stimuli.loading
{
   import br.com.stimuli.loading.loadingtypes.BinaryItem;
   import br.com.stimuli.loading.loadingtypes.ImageItem;
   import br.com.stimuli.loading.loadingtypes.LoadingItem;
   import br.com.stimuli.loading.loadingtypes.SoundItem;
   import br.com.stimuli.loading.loadingtypes.URLItem;
   import br.com.stimuli.loading.loadingtypes.VideoItem;
   import br.com.stimuli.loading.loadingtypes.XMLItem;
   import flash.display.AVM1Movie;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.net.NetStream;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class BulkLoader extends EventDispatcher
   {
      
      public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
      
      public static const TYPE_VIDEO:String = "video";
      
      public static const PREVENT_CACHING:String = "preventCache";
      
      public static const TYPE_TEXT:String = "text";
      
      public static const ID:String = "id";
      
      public static const PAUSED_AT_START:String = "pausedAtStart";
      
      public static const SECURITY_ERROR:String = "securityError";
      
      public static const LOG_WARNINGS:int = 3;
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
      
      public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO,TYPE_XML,TYPE_TEXT,TYPE_SOUND,TYPE_MOVIECLIP,TYPE_IMAGE,TYPE_BINARY];
      
      public static const LOG_VERBOSE:int = 0;
      
      public static const OPEN:String = "open";
      
      public static var MOVIECLIP_EXTENSIONS:Array = ["swf"];
      
      public static var XML_EXTENSIONS:Array = ["xml"];
      
      public static var SOUND_EXTENSIONS:Array = ["mp3","f4a","f4b"];
      
      public static var TEXT_EXTENSIONS:Array = ["txt","js","php","asp","py"];
      
      public static var AVAILABLE_EXTENSIONS:Array = ["swf","jpg","jpeg","gif","png","flv","mp3","xml","txt","js"];
      
      public static const HEADERS:String = "headers";
      
      public static const TYPE_XML:String = "xml";
      
      public static var _allLoaders:Object = {};
      
      public static var VIDEO_EXTENSIONS:Array = ["flv","f4v","f4p","mp4"];
      
      public static const HTTP_STATUS:String = "httpStatus";
      
      public static const CONTEXT:String = "context";
      
      public static const WEIGHT:String = "weight";
      
      public static const CHECK_POLICY_FILE:String = "checkPolicyFile";
      
      public static var IMAGE_EXTENSIONS:Array = ["jpg","jpeg","gif","png"];
      
      public static const TYPE_MOVIECLIP:String = "movieclip";
      
      public static const PRIORITY:String = "priority";
      
      public static const TYPE_BINARY:String = "binary";
      
      public static const TYPE_SOUND:String = "sound";
      
      public static var _customTypesExtensions:Object;
      
      public static const MAX_TRIES:String = "maxTries";
      
      public static const VERSION:String = "$Id: BulkLoader.as 321 2010-04-10 19:11:05Z debert $";
      
      public static const GENERAL_AVAILABLE_PROPS:Array = [WEIGHT,MAX_TRIES,HEADERS,ID,PRIORITY,PREVENT_CACHING,"type"];
      
      public static const DEFAULT_NUM_CONNECTIONS:int = 12;
      
      public static var _typeClasses:Object = {
         "image":ImageItem,
         "movieclip":ImageItem,
         "xml":XMLItem,
         "video":VideoItem,
         "sound":SoundItem,
         "text":URLItem,
         "binary":BinaryItem
      };
      
      public static const LOG_SILENT:int = 10;
      
      public static const ERROR:String = "error";
      
      public static const LOG_INFO:int = 2;
      
      public static const DEFAULT_LOG_LEVEL:int = LOG_ERRORS;
      
      public static const LOG_ERRORS:int = 4;
      
      public static const TYPE_IMAGE:String = "image";
      
      public static var _instancesCreated:int = 0;
       
      
      public var _itemsTotal:int = 0;
      
      public var speedAvg:Number;
      
      public var _numConnections:int = 12;
      
      public var _totalWeight:int = 0;
      
      public var _bytesTotalCurrent:int = 0;
      
      public var _itemsLoaded:int = 0;
      
      public var totalTime:Number;
      
      public var _additionIndex:int = 0;
      
      public var _bytesTotal:int = 0;
      
      public var _loadedRatio:Number = 0;
      
      public var _speed:Number;
      
      public var _lastSpeedCheck:int;
      
      public var _isPaused:Boolean = true;
      
      public var _isFinished:Boolean;
      
      public var _name:String;
      
      public var _allowsAutoIDFromFileName:Boolean = false;
      
      public var _contents:Dictionary;
      
      public var _logFunction:Function;
      
      public var _bytesLoaded:int = 0;
      
      public var _connections:Object;
      
      public var logLevel:int = 4;
      
      public var _percentLoaded:Number = 0;
      
      public var _weightPercent:Number;
      
      public var _lastBytesCheck:int;
      
      public var _isRunning:Boolean;
      
      public var _id:int;
      
      public var _items:Array;
      
      public var _stringSubstitutions:Object;
      
      public var avgLatency:Number;
      
      public var _startTime:int;
      
      public var maxConnectionsPerHost:int = 2;
      
      public var _speedTotal:Number;
      
      public var _endTIme:int;
      
      public function BulkLoader(param1:String = null, param2:int = 12, param3:int = 4)
      {
         _items = [];
         _contents = new Dictionary(true);
         _logFunction = trace;
         super();
         if(!param1)
         {
            param1 = getUniqueName();
         }
         if(Boolean(_allLoaders[param1]))
         {
            __debug_print_loaders();
            throw new Error("BulkLoader with name\'" + param1 + "\' has already been created.");
         }
         if(!param1)
         {
            throw new Error("Cannot create a BulkLoader instance without a name");
         }
         _allLoaders[param1] = this;
         if(param2 > 0)
         {
            this._numConnections = param2;
         }
         this.logLevel = param3;
         _name = param1;
         _instancesCreated++;
         _id = _instancesCreated;
         _additionIndex = 0;
         addEventListener(BulkLoader.ERROR,_swallowError,false,1,true);
      }
      
      public static function getLoader(param1:String) : BulkLoader
      {
         return BulkLoader._allLoaders[param1] as BulkLoader;
      }
      
      public static function whichLoaderHasItem(param1:*) : BulkLoader
      {
         var _loc2_:BulkLoader = null;
         for each(_loc2_ in _allLoaders)
         {
            if(BulkLoader._hasItemInBulkLoader(param1,_loc2_))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function truncateNumber(param1:Number, param2:int = 2) : Number
      {
         var _loc3_:int = Math.pow(10,param2);
         return Math.round(param1 * _loc3_) / _loc3_;
      }
      
      public static function __debug_printStackTrace() : void
      {
         try
         {
            throw new Error("stack trace");
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
            return;
         }
      }
      
      public static function __debug_print_loaders() : void
      {
         var instNames:String = null;
         var theNames:Array = [];
         for each(instNames in BulkLoader._allLoaders)
         {
            theNames.push(instNames);
         }
         theNames.sort();
         trace("All loaders");
         theNames.forEach(function(param1:*, ... rest):void
         {
            trace("\t",param1);
         });
         trace("===========");
      }
      
      public static function pauseAllLoaders() : void
      {
         var _loc1_:BulkLoader = null;
         for each(_loc1_ in _allLoaders)
         {
            _loc1_.pauseAll();
         }
      }
      
      public static function _hasItemInBulkLoader(param1:*, param2:BulkLoader) : Boolean
      {
         var _loc3_:LoadingItem = param2.get(param1);
         if(_loc3_ && _loc3_._isLoaded)
         {
            return true;
         }
         return false;
      }
      
      public static function createUniqueNamedLoader(param1:int = 12, param2:int = 4) : BulkLoader
      {
         return new BulkLoader(BulkLoader.getUniqueName(),param1,param2);
      }
      
      public static function removeAllLoaders() : void
      {
         var _loc1_:BulkLoader = null;
         for each(_loc1_ in _allLoaders)
         {
            _loc1_.removeAll();
            _loc1_.clear();
            _loc1_ = null;
         }
         _allLoaders = {};
      }
      
      public static function getFileName(param1:String, param2:Boolean = false) : String
      {
         if(param1.lastIndexOf("/") == param1.length - 1)
         {
            return getFileName(param1.substring(0,param1.length - 1));
         }
         var _loc3_:int = param1.lastIndexOf("/") + 1;
         var _loc4_:String = param1.substring(_loc3_);
         var _loc5_:int = !!param2?int(_loc4_.length):int(_loc4_.indexOf("."));
         if(_loc5_ == -1)
         {
            if(_loc4_.indexOf("?") > -1)
            {
               _loc5_ = _loc4_.indexOf("?");
            }
            else
            {
               _loc5_ = _loc4_.length;
            }
         }
         var _loc6_:String = _loc4_.substring(0,_loc5_);
         return _loc6_;
      }
      
      public static function __debug_print_num_loaders() : void
      {
         var _loc2_:String = null;
         var _loc1_:int = 0;
         for each(_loc2_ in BulkLoader._allLoaders)
         {
            _loc1_++;
         }
         trace("BulkLoader has ",_loc1_,"instances");
      }
      
      public static function guessType(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:String = null;
         var _loc2_:String = param1.indexOf("?") > -1?param1.substring(0,param1.indexOf("?")):param1;
         var _loc3_:String = _loc2_.substring(_loc2_.lastIndexOf("/"));
         var _loc4_:String = _loc3_.substring(_loc3_.lastIndexOf(".") + 1).toLowerCase();
         if(!Boolean(_loc4_))
         {
            _loc4_ = BulkLoader.TYPE_TEXT;
         }
         if(_loc4_ == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(_loc4_) > -1)
         {
            _loc5_ = BulkLoader.TYPE_IMAGE;
         }
         else if(_loc4_ == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(_loc4_) > -1)
         {
            _loc5_ = BulkLoader.TYPE_SOUND;
         }
         else if(_loc4_ == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(_loc4_) > -1)
         {
            _loc5_ = BulkLoader.TYPE_VIDEO;
         }
         else if(_loc4_ == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(_loc4_) > -1)
         {
            _loc5_ = BulkLoader.TYPE_XML;
         }
         else if(_loc4_ == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(_loc4_) > -1)
         {
            _loc5_ = BulkLoader.TYPE_MOVIECLIP;
         }
         else
         {
            for(_loc6_ in _customTypesExtensions)
            {
               for each(_loc7_ in _customTypesExtensions[_loc6_])
               {
                  if(_loc7_ == _loc4_)
                  {
                     _loc5_ = _loc6_;
                     break;
                  }
                  if(_loc5_)
                  {
                     break;
                  }
               }
            }
            if(!_loc5_)
            {
               _loc5_ = BulkLoader.TYPE_TEXT;
            }
         }
         return _loc5_;
      }
      
      public static function registerNewType(param1:String, param2:String, param3:Class = null) : Boolean
      {
         var _loc4_:Array = null;
         if(param1.charAt(0) == ".")
         {
            param1 = param1.substring(1);
         }
         if(!_customTypesExtensions)
         {
            _customTypesExtensions = {};
         }
         param2 = param2.toLowerCase();
         if(AVAILABLE_TYPES.indexOf(param2) == -1)
         {
            if(!Boolean(param3))
            {
               throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
            }
            _typeClasses[param2] = param3;
            if(!_customTypesExtensions[param2])
            {
               _customTypesExtensions[param2] = [];
               AVAILABLE_TYPES.push(param2);
            }
            _customTypesExtensions[param2].push(param1);
            return true;
         }
         if(_customTypesExtensions[param2])
         {
            _customTypesExtensions[param2].push(param1);
         }
         var _loc5_:Object = {};
         _loc5_[TYPE_IMAGE] = IMAGE_EXTENSIONS;
         _loc5_[TYPE_MOVIECLIP] = MOVIECLIP_EXTENSIONS;
         _loc5_[TYPE_VIDEO] = VIDEO_EXTENSIONS;
         _loc5_[TYPE_SOUND] = SOUND_EXTENSIONS;
         _loc5_[TYPE_TEXT] = TEXT_EXTENSIONS;
         _loc5_[TYPE_XML] = XML_EXTENSIONS;
         _loc4_ = _loc5_[param2];
         if(_loc4_ && _loc4_.indexOf(param1) == -1)
         {
            _loc4_.push(param1);
            return true;
         }
         return false;
      }
      
      public static function substituteURLString(param1:String, param2:Object) : String
      {
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc12_:String = null;
         if(!param2)
         {
            return param1;
         }
         var _loc3_:RegExp = /(?P<var_name>\{\s*[^\}]*\})/g;
         var _loc4_:Object = _loc3_.exec(param1);
         var _loc5_:String = !!_loc4_?_loc4_.var_name:null;
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(Boolean(_loc4_) && Boolean(_loc4_.var_name))
         {
            if(_loc4_.var_name)
            {
               _loc5_ = _loc4_.var_name;
               _loc5_ = _loc5_.replace("{","");
               _loc5_ = _loc5_.replace("}","");
               _loc5_ = _loc5_.replace(/\s*/g,"");
            }
            _loc6_.push({
               "start":_loc4_.index,
               "end":_loc4_.index + _loc4_.var_name.length,
               "changeTo":param2[_loc5_]
            });
            _loc7_++;
            if(_loc7_ > 400)
            {
               break;
            }
            _loc4_ = _loc3_.exec(param1);
            _loc5_ = !!_loc4_?_loc4_.var_name:null;
         }
         if(_loc6_.length == 0)
         {
            return param1;
         }
         var _loc8_:Array = [];
         var _loc11_:String = param1.substr(0,_loc6_[0].start);
         for each(_loc10_ in _loc6_)
         {
            if(_loc9_)
            {
               _loc11_ = param1.substring(_loc9_.end,_loc10_.start);
            }
            _loc8_.push(_loc11_);
            _loc8_.push(_loc10_.changeTo);
            _loc9_ = _loc10_;
         }
         _loc8_.push(param1.substring(_loc10_.end));
         return _loc8_.join("");
      }
      
      public static function getUniqueName() : String
      {
         return "BulkLoader-" + _instancesCreated;
      }
      
      public function get allowsAutoIDFromFileName() : Boolean
      {
         return _allowsAutoIDFromFileName;
      }
      
      public function _onItemComplete(param1:Event) : void
      {
         var _loc2_:LoadingItem = param1.target as LoadingItem;
         _removeFromConnections(_loc2_);
         log("Loaded ",_loc2_,LOG_INFO);
         log("Items to load",getNotLoadedItems(),LOG_VERBOSE);
         _loc2_.cleanListeners();
         _contents[_loc2_.url.url] = _loc2_.content;
         var _loc3_:Boolean = _loadNext();
         var _loc4_:Boolean = _isAllDoneP();
         if(_loc4_)
         {
            _onAllLoaded();
         }
         param1.stopPropagation();
      }
      
      public function get loadedRatio() : Number
      {
         return _loadedRatio;
      }
      
      public function loadNow(param1:*) : Boolean
      {
         var _loc3_:LoadingItem = null;
         var _loc2_:LoadingItem = get(param1);
         if(!_loc2_)
         {
            return false;
         }
         if(!_connections)
         {
            _connections = {};
         }
         if(_loc2_.status == LoadingItem.STATUS_FINISHED || _loc2_.status == LoadingItem.STATUS_STARTED)
         {
            return true;
         }
         if(_getNumConnections() >= numConnections || _getNumConnectionsForItem(_loc2_) >= maxConnectionsPerHost)
         {
            _loc3_ = _getLeastUrgentOpenedItem();
            pause(_loc3_);
            _removeFromConnections(_loc3_);
            _loc3_.status = null;
         }
         _loc2_._priority = highestPriority;
         _loadNext(_loc2_);
         return true;
      }
      
      public function set allowsAutoIDFromFileName(param1:Boolean) : void
      {
         _allowsAutoIDFromFileName = param1;
      }
      
      public function _getContentAsType(param1:*, param2:Class, param3:Boolean = false) : *
      {
         var res:* = undefined;
         var key:* = param1;
         var type:Class = param2;
         var clearMemory:Boolean = param3;
         if(!_name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         var item:LoadingItem = get(key);
         if(!item)
         {
            return null;
         }
         try
         {
            if(item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
            {
               res = item.content as type;
               if(res == null)
               {
                  throw new Error("bad cast");
               }
               if(clearMemory)
               {
                  remove(key);
                  if(!_isPaused)
                  {
                     _loadNext();
                  }
               }
               return res;
            }
         }
         catch(e:Error)
         {
            log("Failed to get content with url: \'" + key + "\'as type:",type,LOG_ERRORS);
         }
         return null;
      }
      
      public function set stringSubstitutions(param1:Object) : void
      {
         _stringSubstitutions = param1;
      }
      
      public function get contents() : Object
      {
         return _contents;
      }
      
      public function get id() : int
      {
         return _id;
      }
      
      public function _getConnectionsForHostName(param1:String) : Array
      {
         if(_connections[param1] == null)
         {
            _connections[param1] = [];
         }
         return _connections[param1];
      }
      
      public function getBitmap(param1:String, param2:Boolean = false) : Bitmap
      {
         return Bitmap(_getContentAsType(param1,Bitmap,param2));
      }
      
      public function _removeFromConnections(param1:*) : Boolean
      {
         if(!_connections || _getNumConnectionsForItem(param1) == 0)
         {
            return false;
         }
         var _loc2_:Array = _getConnectionsForHostName(param1.hostName);
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ > -1)
         {
            _loc2_.splice(_loc3_,1);
            return true;
         }
         return false;
      }
      
      public function resume(param1:*) : Boolean
      {
         var _loc2_:LoadingItem = param1 is LoadingItem?param1:get(param1);
         _isPaused = false;
         if(_loc2_ && _loc2_.status == LoadingItem.STATUS_STOPPED)
         {
            _loc2_.status = null;
            _loadNext();
            return true;
         }
         return false;
      }
      
      public function _onAllLoaded() : void
      {
         if(_isFinished)
         {
            return;
         }
         var _loc1_:BulkProgressEvent = new BulkProgressEvent(COMPLETE);
         _loc1_.setInfo(bytesLoaded,bytesTotal,bytesTotalCurrent,_itemsLoaded,itemsTotal,weightPercent);
         var _loc2_:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         _loc2_.setInfo(bytesLoaded,bytesTotal,bytesTotalCurrent,_itemsLoaded,itemsTotal,weightPercent);
         _isRunning = false;
         _endTIme = getTimer();
         totalTime = BulkLoader.truncateNumber((_endTIme - _startTime) / 1000);
         _updateStats();
         _connections = {};
         getStats();
         _isFinished = true;
         log("Finished all",LOG_INFO);
         dispatchEvent(_loc2_);
         dispatchEvent(_loc1_);
      }
      
      public function removePausedItems() : Boolean
      {
         var stoppedLoads:Array = _items.filter(function(param1:LoadingItem, ... rest):Boolean
         {
            return param1.status == LoadingItem.STATUS_STOPPED;
         });
         stoppedLoads.forEach(function(param1:LoadingItem, ... rest):void
         {
            remove(param1);
         });
         _loadNext();
         return stoppedLoads.length > 0;
      }
      
      public function resumeAll() : Boolean
      {
         log("Resuming all items",LOG_VERBOSE);
         var affected:Boolean = false;
         _items.forEach(function(param1:LoadingItem, ... rest):void
         {
            if(param1.status == LoadingItem.STATUS_STOPPED)
            {
               resume(param1);
               affected = true;
            }
         });
         _loadNext();
         return affected;
      }
      
      public function get isRunning() : Boolean
      {
         return _isRunning;
      }
      
      public function _getNumConnectionsForItem(param1:LoadingItem) : int
      {
         var _loc2_:Array = _getConnectionsForHostName(param1.hostName);
         if(!_loc2_)
         {
            return 0;
         }
         return _loc2_.length;
      }
      
      public function getProgressForItems(param1:Array) : BulkProgressEvent
      {
         var _loc11_:LoadingItem = null;
         var _loc13_:* = undefined;
         _bytesLoaded = _bytesTotal = _bytesTotalCurrent = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc12_:Array = [];
         for each(_loc13_ in param1)
         {
            _loc11_ = get(_loc13_);
            if(_loc11_)
            {
               _loc6_++;
               _loc3_ = _loc3_ + _loc11_.weight;
               if(_loc11_.status == LoadingItem.STATUS_STARTED || _loc11_.status == LoadingItem.STATUS_FINISHED || _loc11_.status == LoadingItem.STATUS_STOPPED)
               {
                  _loc8_ = _loc8_ + _loc11_._bytesLoaded;
                  _loc10_ = _loc10_ + _loc11_._bytesTotal;
                  if(_loc11_._bytesTotal > 0)
                  {
                     _loc5_ = _loc5_ + _loc11_._bytesLoaded / _loc11_._bytesTotal * _loc11_.weight;
                  }
                  if(_loc11_.status == LoadingItem.STATUS_FINISHED)
                  {
                     _loc7_++;
                  }
                  _loc4_++;
               }
            }
         }
         if(_loc4_ != _loc6_)
         {
            _loc9_ = Number.POSITIVE_INFINITY;
         }
         else
         {
            _loc9_ = _loc10_;
         }
         _loc2_ = _loc5_ / _loc3_;
         if(_loc3_ == 0)
         {
            _loc2_ = 0;
         }
         var _loc14_:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         _loc14_.setInfo(_loc8_,_loc9_,_loc9_,_loc7_,_loc6_,_loc2_);
         return _loc14_;
      }
      
      public function get logFunction() : Function
      {
         return _logFunction;
      }
      
      public function getNetStreamMetaData(param1:String, param2:Boolean = false) : Object
      {
         var _loc3_:NetStream = getNetStream(param1,param2);
         return !!Boolean(_loc3_)?(get(param1) as Object).metaData:null;
      }
      
      public function getContent(param1:String, param2:Boolean = false) : *
      {
         return _getContentAsType(param1,Object,param2);
      }
      
      public function getSerializedData(param1:*, param2:Boolean = false, param3:Function = null) : *
      {
         var raw:* = undefined;
         var parsed:* = undefined;
         var key:* = param1;
         var clearMemory:Boolean = param2;
         var encodingFunction:Function = param3;
         try
         {
            raw = _getContentAsType(key,Object,clearMemory);
            parsed = encodingFunction.apply(null,[raw]);
            return parsed;
         }
         catch(e:Error)
         {
            log("Failed to parse key:",key,"with encodingFunction:" + encodingFunction,LOG_ERRORS);
         }
         return null;
      }
      
      public function log(... rest) : void
      {
         var _loc2_:int = !!isNaN(rest[rest.length - 1])?3:int(int(rest.pop()));
         if(_loc2_ >= logLevel)
         {
            _logFunction("[BulkLoader] " + rest.join(" "));
         }
      }
      
      public function clear() : void
      {
         removeAll();
         delete _allLoaders[name];
         _name = null;
      }
      
      public function get speed() : Number
      {
         var _loc1_:int = getTimer() - _lastSpeedCheck;
         var _loc2_:int = (bytesLoaded - _lastBytesCheck) / 1024;
         var _loc3_:int = _loc2_ / (_loc1_ / 1000);
         _lastSpeedCheck = _loc1_;
         _lastBytesCheck = bytesLoaded;
         return _loc3_;
      }
      
      public function get bytesLoaded() : int
      {
         return _bytesLoaded;
      }
      
      public function getFailedItems() : Array
      {
         return _items.filter(function(param1:LoadingItem, ... rest):Boolean
         {
            return param1.status == LoadingItem.STATUS_ERROR;
         });
      }
      
      public function _loadNext(param1:LoadingItem = null) : Boolean
      {
         var _loc3_:Array = null;
         if(_isFinished)
         {
            return false;
         }
         if(!_connections)
         {
            _connections = {};
         }
         var _loc2_:Boolean = false;
         param1 = param1 || _getNextItemToLoad();
         if(param1)
         {
            _loc2_ = true;
            _isRunning = true;
            if(_canOpenConnectioForItem(param1))
            {
               _loc3_ = _getConnectionsForHostName(param1.hostName);
               _loc3_.push(param1);
               param1.load();
               log("Will load item:",param1,LOG_INFO);
            }
            if(_getNextItemToLoad())
            {
               _loadNext();
            }
         }
         return _loc2_;
      }
      
      public function getSound(param1:*, param2:Boolean = false) : Sound
      {
         return Sound(_getContentAsType(param1,Sound,param2));
      }
      
      public function removeFailedItems() : int
      {
         var numCleared:int = 0;
         var badItems:Array = _items.filter(function(param1:LoadingItem, ... rest):Boolean
         {
            return param1.status == LoadingItem.STATUS_ERROR;
         });
         numCleared = badItems.length;
         badItems.forEach(function(param1:LoadingItem, ... rest):void
         {
            remove(param1);
         });
         _loadNext();
         return numCleared;
      }
      
      public function get(param1:*) : LoadingItem
      {
         var _loc2_:LoadingItem = null;
         if(!param1)
         {
            return null;
         }
         if(param1 is LoadingItem)
         {
            return param1;
         }
         for each(_loc2_ in _items)
         {
            if(_loc2_._id == param1 || _loc2_._parsedURL.rawString == param1 || _loc2_.url == param1 || param1 is URLRequest && _loc2_.url.url == param1.url)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function _getNumConnections() : int
      {
         var _loc2_:* = null;
         var _loc1_:int = 0;
         for(_loc2_ in _connections)
         {
            _loc1_ = _loc1_ + _connections[_loc2_].length;
         }
         return _loc1_;
      }
      
      public function get highestPriority() : int
      {
         var _loc2_:LoadingItem = null;
         var _loc1_:int = int.MIN_VALUE;
         for each(_loc2_ in _items)
         {
            if(_loc2_.priority > _loc1_)
            {
               _loc1_ = _loc2_.priority;
            }
         }
         return _loc1_;
      }
      
      public function start(param1:int = -1) : void
      {
         if(param1 > 0)
         {
            _numConnections = param1;
         }
         if(_connections)
         {
            _loadNext();
            return;
         }
         _startTime = getTimer();
         _connections = {};
         _loadNext();
         _isRunning = true;
         _lastBytesCheck = 0;
         _lastSpeedCheck = getTimer();
         _isPaused = false;
      }
      
      public function _getAllConnections() : Array
      {
         var _loc2_:* = null;
         var _loc1_:Array = [];
         for(_loc2_ in _connections)
         {
            _loc1_ = _loc1_.concat(_connections[_loc2_]);
         }
         return _loc1_;
      }
      
      public function _getLeastUrgentOpenedItem() : LoadingItem
      {
         var _loc1_:Array = _getAllConnections();
         _loc1_.sortOn(["priority","bytesRemaining","_additionIndex"],[Array.NUMERIC,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC]);
         var _loc2_:LoadingItem = LoadingItem(_loc1_[0]);
         return _loc2_;
      }
      
      public function getBitmapData(param1:*, param2:Boolean = false) : BitmapData
      {
         var key:* = param1;
         var clearMemory:Boolean = param2;
         try
         {
            return getBitmap(key,clearMemory).bitmapData;
         }
         catch(e:Error)
         {
            log("Failed to get bitmapData with url:",key,LOG_ERRORS);
         }
         return null;
      }
      
      public function set logFunction(param1:Function) : void
      {
         _logFunction = param1;
      }
      
      override public function toString() : String
      {
         return "[BulkLoader] name:" + name + ", itemsTotal: " + itemsTotal + ", itemsLoaded: " + _itemsLoaded;
      }
      
      public function get itemsTotal() : int
      {
         return items.length;
      }
      
      public function sortItemsByPriority() : void
      {
         _items.sortOn(["priority","_additionIndex"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
      }
      
      public function get stringSubstitutions() : Object
      {
         return _stringSubstitutions;
      }
      
      public function _swallowError(param1:Event) : void
      {
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function remove(param1:*, param2:Boolean = false) : Boolean
      {
         var item:LoadingItem = null;
         var allDone:Boolean = false;
         var key:* = param1;
         var internalCall:Boolean = param2;
         try
         {
            item = get(key);
            if(!item)
            {
               return false;
            }
            _removeFromItems(item);
            _removeFromConnections(item);
            item.destroy();
            delete _contents[item.url.url];
            if(internalCall)
            {
               return true;
            }
            item = null;
            _onProgress();
            allDone = _isAllDoneP();
            if(allDone)
            {
               _onAllLoaded();
            }
            return true;
         }
         catch(e:Error)
         {
            log("Error while removing item from key:" + key,e.getStackTrace(),LOG_ERRORS);
         }
         return false;
      }
      
      public function removeAll() : void
      {
         var _loc1_:LoadingItem = null;
         for each(_loc1_ in _items.slice())
         {
            remove(_loc1_,true);
         }
         _items = [];
         _connections = {};
         _contents = new Dictionary(true);
         _percentLoaded = _weightPercent = _loadedRatio = 0;
      }
      
      public function _updateStats() : void
      {
         var _loc4_:LoadingItem = null;
         avgLatency = 0;
         speedAvg = 0;
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         _speedTotal = 0;
         var _loc3_:Number = 0;
         for each(_loc4_ in _items)
         {
            if(_loc4_._isLoaded && _loc4_.status != LoadingItem.STATUS_ERROR)
            {
               _loc1_ = _loc1_ + _loc4_.latency;
               _loc2_ = _loc2_ + _loc4_.bytesTotal;
               _loc3_++;
            }
         }
         _speedTotal = _loc2_ / 1024 / totalTime;
         avgLatency = _loc1_ / _loc3_;
         speedAvg = _speedTotal / _loc3_;
      }
      
      public function reload(param1:*) : Boolean
      {
         var _loc2_:LoadingItem = get(param1);
         if(!_loc2_)
         {
            return false;
         }
         _removeFromItems(_loc2_);
         _removeFromConnections(_loc2_);
         _loc2_.stop();
         _loc2_.cleanListeners();
         _loc2_.status = null;
         _isFinished = false;
         _loc2_._addedTime = getTimer();
         _loc2_._additionIndex = _additionIndex++;
         _loc2_.addEventListener(Event.COMPLETE,_onItemComplete,false,int.MIN_VALUE,true);
         _loc2_.addEventListener(Event.COMPLETE,_incrementItemsLoaded,false,int.MAX_VALUE,true);
         _loc2_.addEventListener(ERROR,_onItemError,false,0,true);
         _loc2_.addEventListener(Event.OPEN,_onItemStarted,false,0,true);
         _loc2_.addEventListener(ProgressEvent.PROGRESS,_onProgress,false,0,true);
         _items.push(_loc2_);
         _itemsTotal = _itemsTotal + 1;
         _totalWeight = _totalWeight + _loc2_.weight;
         sortItemsByPriority();
         _isFinished = false;
         loadNow(_loc2_);
         return true;
      }
      
      public function _onItemStarted(param1:Event) : void
      {
         var _loc2_:LoadingItem = param1.target as LoadingItem;
         log("Started loading",_loc2_,LOG_INFO);
         dispatchEvent(param1);
      }
      
      public function add(param1:*, param2:Object = null) : LoadingItem
      {
         var _loc4_:String = null;
         var _loc6_:String = null;
         if(!_name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         if(!param1 || !String(param1))
         {
            throw new Error("[BulkLoader] Cannot add an item with a null url");
         }
         param2 = param2 || {};
         if(param1 is String)
         {
            param1 = new URLRequest(BulkLoader.substituteURLString(param1,_stringSubstitutions));
            if(param2[HEADERS])
            {
               param1.requestHeaders = param2[HEADERS];
            }
         }
         else if(!param1 is URLRequest)
         {
            throw new Error("[BulkLoader] cannot add object with bad type for url:\'" + param1.url);
         }
         var _loc3_:LoadingItem = get(param2[ID]);
         if(_loc3_)
         {
            log("Add received an already added id: " + param2[ID] + ", not adding a new item");
            return _loc3_;
         }
         if(param2["type"])
         {
            _loc4_ = param2["type"].toLowerCase();
            if(AVAILABLE_TYPES.indexOf(_loc4_) == -1)
            {
               log("add received an unknown type:",_loc4_,"and will cast it to text",LOG_WARNINGS);
            }
         }
         if(!_loc4_)
         {
            _loc4_ = guessType(param1.url);
         }
         _additionIndex++;
         _loc3_ = new _typeClasses[_loc4_](param1,_loc4_,_instancesCreated + "_" + String(_additionIndex));
         if(!param2["id"] && _allowsAutoIDFromFileName)
         {
            param2["id"] = getFileName(param1.url);
            log("Adding automatic id from file name for item:",_loc3_,"( id= " + param2["id"] + " )");
         }
         var _loc5_:Array = _loc3_._parseOptions(param2);
         for each(_loc6_ in _loc5_)
         {
            log(_loc6_,LOG_WARNINGS);
         }
         log("Added",_loc3_,LOG_VERBOSE);
         _loc3_._addedTime = getTimer();
         _loc3_._additionIndex = _additionIndex;
         _loc3_.addEventListener(Event.COMPLETE,_onItemComplete,false,int.MIN_VALUE,true);
         _loc3_.addEventListener(Event.COMPLETE,_incrementItemsLoaded,false,int.MAX_VALUE,true);
         _loc3_.addEventListener(ERROR,_onItemError,false,0,true);
         _loc3_.addEventListener(Event.OPEN,_onItemStarted,false,0,true);
         _loc3_.addEventListener(ProgressEvent.PROGRESS,_onProgress,false,0,true);
         _items.push(_loc3_);
         _itemsTotal = _itemsTotal + 1;
         _totalWeight = _totalWeight + _loc3_.weight;
         sortItemsByPriority();
         _isFinished = false;
         if(!_isPaused)
         {
            _loadNext();
         }
         return _loc3_;
      }
      
      public function getText(param1:*, param2:Boolean = false) : String
      {
         return String(_getContentAsType(param1,String,param2));
      }
      
      public function get percentLoaded() : Number
      {
         return _percentLoaded;
      }
      
      public function get weightPercent() : Number
      {
         return _weightPercent;
      }
      
      public function get bytesTotalCurrent() : int
      {
         return _bytesTotalCurrent;
      }
      
      public function getAVM1Movie(param1:String, param2:Boolean = false) : AVM1Movie
      {
         return AVM1Movie(_getContentAsType(param1,AVM1Movie,param2));
      }
      
      public function get bytesTotal() : int
      {
         return _bytesTotal;
      }
      
      public function getSprite(param1:String, param2:Boolean = false) : Sprite
      {
         return Sprite(_getContentAsType(param1,Sprite,param2));
      }
      
      public function get isFinished() : Boolean
      {
         return _isFinished;
      }
      
      public function _getNextItemToLoad() : LoadingItem
      {
         var checkItem:LoadingItem = null;
         _getAllConnections().forEach(function(param1:LoadingItem, ... rest):void
         {
            if(param1.status == LoadingItem.STATUS_ERROR && param1.numTries >= param1.maxTries)
            {
               _removeFromConnections(param1);
            }
         });
         for each(checkItem in _items)
         {
            if(!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED && _canOpenConnectioForItem(checkItem))
            {
               return checkItem;
            }
         }
         return null;
      }
      
      public function changeItemPriority(param1:String, param2:int) : Boolean
      {
         var _loc3_:LoadingItem = get(param1);
         if(!_loc3_)
         {
            return false;
         }
         _loc3_._priority = param2;
         sortItemsByPriority();
         return true;
      }
      
      public function get items() : Array
      {
         return _items.slice();
      }
      
      public function getNetStream(param1:String, param2:Boolean = false) : NetStream
      {
         return NetStream(_getContentAsType(param1,NetStream,param2));
      }
      
      public function getHttpStatus(param1:*) : int
      {
         var _loc2_:LoadingItem = get(param1);
         if(_loc2_)
         {
            return _loc2_.httpStatus;
         }
         return -1;
      }
      
      public function set itemsLoaded(param1:int) : void
      {
         _itemsLoaded = param1;
      }
      
      public function _onProgress(param1:Event = null) : void
      {
         var _loc2_:BulkProgressEvent = getProgressForItems(_items);
         _bytesLoaded = _loc2_.bytesLoaded;
         _bytesTotal = _loc2_.bytesTotal;
         _weightPercent = _loc2_.weightPercent;
         _percentLoaded = _loc2_.percentLoaded;
         _bytesTotalCurrent = _loc2_.bytesTotalCurrent;
         _loadedRatio = _loc2_.ratioLoaded;
         dispatchEvent(_loc2_);
      }
      
      public function hasItem(param1:*, param2:Boolean = true) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:BulkLoader = null;
         if(param2)
         {
            _loc3_ = _allLoaders;
         }
         else
         {
            _loc3_ = [this];
         }
         for each(_loc4_ in _loc3_)
         {
            if(_hasItemInBulkLoader(param1,_loc4_))
            {
               return true;
            }
         }
         return false;
      }
      
      public function _removeFromItems(param1:LoadingItem) : Boolean
      {
         var _loc2_:int = _items.indexOf(param1);
         if(_loc2_ > -1)
         {
            _items.splice(_loc2_,1);
            if(param1._isLoaded)
            {
               _itemsLoaded--;
            }
            _itemsTotal--;
            _totalWeight = _totalWeight - param1.weight;
            log("Removing " + param1,LOG_VERBOSE);
            param1.removeEventListener(Event.COMPLETE,_onItemComplete,false);
            param1.removeEventListener(Event.COMPLETE,_incrementItemsLoaded,false);
            param1.removeEventListener(ERROR,_onItemError,false);
            param1.removeEventListener(Event.OPEN,_onItemStarted,false);
            param1.removeEventListener(ProgressEvent.PROGRESS,_onProgress,false);
            return true;
         }
         return false;
      }
      
      public function _incrementItemsLoaded(param1:Event) : void
      {
         _itemsLoaded++;
      }
      
      public function _getNumConnectionsForHostname(param1:String) : int
      {
         var _loc2_:Array = _getConnectionsForHostName(param1);
         if(!_loc2_)
         {
            return 0;
         }
         return _loc2_.length;
      }
      
      public function _onItemError(param1:ErrorEvent) : void
      {
         var _loc2_:LoadingItem = param1.target as LoadingItem;
         _removeFromConnections(_loc2_);
         log("After " + _loc2_.numTries + " I am giving up on " + _loc2_.url.url,LOG_ERRORS);
         log("Error loading",_loc2_,param1.text,LOG_ERRORS);
         _loadNext();
         dispatchEvent(param1);
      }
      
      public function pauseAll() : void
      {
         var _loc1_:LoadingItem = null;
         for each(_loc1_ in _items)
         {
            pause(_loc1_);
         }
         _isRunning = false;
         _isPaused = true;
         log("Stopping all items",LOG_INFO);
      }
      
      public function _isAllDoneP() : Boolean
      {
         return _items.every(function(param1:LoadingItem, ... rest):Boolean
         {
            return param1._isLoaded;
         });
      }
      
      public function getNotLoadedItems() : Array
      {
         return _items.filter(function(param1:LoadingItem, ... rest):Boolean
         {
            return param1.status != LoadingItem.STATUS_FINISHED;
         });
      }
      
      public function getXML(param1:*, param2:Boolean = false) : XML
      {
         return XML(_getContentAsType(param1,XML,param2));
      }
      
      public function get totalWeight() : int
      {
         return _totalWeight;
      }
      
      public function get itemsLoaded() : int
      {
         return _itemsLoaded;
      }
      
      public function _canOpenConnectioForItem(param1:LoadingItem) : Boolean
      {
         if(_getNumConnections() >= numConnections)
         {
            return false;
         }
         if(_getNumConnectionsForItem(param1) >= maxConnectionsPerHost)
         {
            return false;
         }
         return true;
      }
      
      public function getMovieClip(param1:String, param2:Boolean = false) : MovieClip
      {
         return MovieClip(_getContentAsType(param1,MovieClip,param2));
      }
      
      public function getDisplayObjectLoader(param1:String, param2:Boolean = false) : Loader
      {
         var res:Loader = null;
         var key:String = param1;
         var clearMemory:Boolean = param2;
         if(!_name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         var item:ImageItem = get(key) as ImageItem;
         if(!item)
         {
            return null;
         }
         try
         {
            res = item.loader as Loader;
            if(!res)
            {
               throw new Error("bad cast");
            }
            if(clearMemory)
            {
               remove(key);
               if(!_isPaused)
               {
                  _loadNext();
               }
            }
            return res;
         }
         catch(e:Error)
         {
            log("Failed to get content with url: \'" + key + "\'as type: Loader",LOG_ERRORS);
         }
         return null;
      }
      
      public function get numConnections() : int
      {
         return _numConnections;
      }
      
      public function getStats() : String
      {
         var stats:Array = [];
         stats.push("\n************************************");
         stats.push("All items loaded(" + itemsTotal + ")");
         stats.push("Total time(s):       " + totalTime);
         stats.push("Average latency(s):  " + truncateNumber(avgLatency));
         stats.push("Average speed(kb/s): " + truncateNumber(speedAvg));
         stats.push("Median speed(kb/s):  " + truncateNumber(_speedTotal));
         stats.push("KiloBytes total:     " + truncateNumber(bytesTotal / 1024));
         var itemsInfo:Array = _items.map(function(param1:LoadingItem, ... rest):String
         {
            return "\t" + param1.getStats();
         });
         stats.push(itemsInfo.join("\n"));
         stats.push("************************************");
         var statsString:String = stats.join("\n");
         log(statsString,LOG_VERBOSE);
         return statsString;
      }
      
      public function pause(param1:*, param2:Boolean = false) : Boolean
      {
         var _loc3_:LoadingItem = get(param1);
         if(!_loc3_)
         {
            return false;
         }
         if(_loc3_.status != LoadingItem.STATUS_FINISHED)
         {
            _loc3_.stop();
         }
         log("STOPPED ITEM:",_loc3_,LOG_INFO);
         var _loc4_:Boolean = _removeFromConnections(_loc3_);
         if(param2)
         {
            _loadNext();
         }
         return _loc4_;
      }
      
      public function getBinary(param1:*, param2:Boolean = false) : ByteArray
      {
         return ByteArray(_getContentAsType(param1,ByteArray,param2));
      }
   }
}
