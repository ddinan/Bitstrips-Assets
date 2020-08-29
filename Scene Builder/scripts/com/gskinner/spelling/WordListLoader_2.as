package com.gskinner.spelling
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
   public class WordListLoader extends EventDispatcher
   {
       
      
      public var maximumParseTime:uint = 50;
      
      protected var parseParams:Object;
      
      protected var _data:Array;
      
      protected var loader:URLLoader;
      
      public function WordListLoader(param1:URLRequest = null)
      {
         super();
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(Event.COMPLETE,handleComplete,false,0,true);
         loader.addEventListener(IOErrorEvent.IO_ERROR,handleError,false,0,true);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError,false,0,true);
         loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,bounceEvent,false,0,true);
         loader.addEventListener(Event.OPEN,bounceEvent,false,0,true);
         loader.addEventListener(ProgressEvent.PROGRESS,bounceEvent,false,0,true);
         if(param1)
         {
            load(param1);
         }
      }
      
      protected function handleComplete(param1:Event) : void
      {
         var _loc2_:ByteArray = loader.data as ByteArray;
         loadBytes(_loc2_);
      }
      
      protected function beginParse(param1:Object = null) : void
      {
         parseParams.ticker.removeEventListener(Event.ENTER_FRAME,beginParse);
         var _loc2_:String = parseParams.stringData.substr(0,3);
         if(_loc2_ == "SFX" || _loc2_ == "PFX")
         {
            parseParams.list = parseParams.stringData.split("\n");
            parseParams.index = 0;
            parseParams.data = [];
            parseParams.count = 0;
            parseAffixes();
            parseParams.ticker.addEventListener(Event.ENTER_FRAME,parse);
            delete parseParams.stringData;
         }
         else
         {
            parseParams.data = parseParams.stringData.split("\n");
            endParse();
         }
      }
      
      public function loadBytes(param1:ByteArray) : void
      {
         var byteArray:ByteArray = param1;
         try
         {
            byteArray.uncompress();
         }
         catch(e:*)
         {
         }
         byteArray.position = 0;
         loadString(byteArray.toString());
      }
      
      public function get data() : Array
      {
         return _data;
      }
      
      protected function parseAffixes() : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc1_:Array = parseParams.affixes = [];
         var _loc2_:Array = parseParams.prefixes = [];
         var _loc3_:uint = parseParams.index;
         var _loc4_:Array = parseParams.list;
         while(true)
         {
            _loc5_ = _loc4_[_loc3_].substr(0,3);
            if(_loc5_ == "PFX" || _loc5_ == "SFX")
            {
               _loc6_ = _loc4_[_loc3_].substr(4);
               _loc1_[_loc3_] = _loc6_;
               _loc2_[_loc3_] = _loc5_ == "PFX";
               _loc3_++;
               continue;
            }
            break;
         }
         parseParams.index = _loc3_;
      }
      
      public function load(param1:URLRequest) : void
      {
         _data = null;
         loader.load(param1);
      }
      
      protected function handleError(param1:Event) : void
      {
         bounceEvent(param1);
      }
      
      public function get bytesLoaded() : uint
      {
         return loader.bytesLoaded;
      }
      
      public function get bytesTotal() : uint
      {
         return loader.bytesTotal;
      }
      
      protected function bounceEvent(param1:Event) : void
      {
         dispatchEvent(param1.clone());
      }
      
      protected function parse(param1:Object = null) : void
      {
         var _loc10_:String = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc2_:uint = getTimer() + maximumParseTime;
         var _loc3_:Array = parseParams.list;
         var _loc4_:uint = _loc3_.length;
         var _loc5_:Array = parseParams.data;
         var _loc6_:Array = parseParams.affixes;
         var _loc7_:Array = parseParams.prefixes;
         var _loc8_:uint = parseParams.index;
         var _loc9_:uint = _loc6_.length;
         while(_loc8_ < _loc4_)
         {
            _loc10_ = String(_loc3_[_loc8_]);
            _loc11_ = _loc10_.lastIndexOf("/");
            if(_loc11_ != -1)
            {
               _loc12_ = parseInt(_loc10_.substr(_loc11_ + 1),32);
               _loc10_ = _loc10_.substring(0,_loc11_);
               _loc13_ = 0;
               while(_loc13_ < _loc9_)
               {
                  if(_loc12_ >> _loc13_ & 1)
                  {
                     _loc14_ = !!_loc7_[_loc13_]?_loc6_[_loc13_] + _loc10_:_loc10_ + _loc6_[_loc13_];
                     _loc5_.splice(SpellingUtils.findIndex(_loc5_,_loc14_),0,_loc14_);
                  }
                  _loc13_++;
               }
            }
            _loc5_.splice(SpellingUtils.findIndex(_loc5_,_loc10_),0,_loc10_);
            _loc8_++;
            if(_loc8_ % 100 == 0 && getTimer() >= _loc2_)
            {
               break;
            }
         }
         parseParams.index = _loc8_;
         parseParams.count++;
         if(_loc8_ == _loc4_)
         {
            endParse();
         }
      }
      
      public function loadString(param1:String) : void
      {
         parseParams = {"stringData":param1};
         parseParams.ticker = new Sprite();
         parseParams.ticker.addEventListener(Event.ENTER_FRAME,beginParse);
      }
      
      public function close() : void
      {
         loader.close();
      }
      
      protected function endParse() : void
      {
         parseParams.ticker.removeEventListener(Event.ENTER_FRAME,parse);
         _data = parseParams.data;
         parseParams = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
