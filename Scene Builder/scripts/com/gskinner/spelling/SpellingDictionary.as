package com.gskinner.spelling
{
   import com.gskinner.text.CharacterSet;
   import com.gskinner.text.StringPosition;
   import flash.events.EventDispatcher;
   
   public class SpellingDictionary extends EventDispatcher
   {
      
      public static const COMBINED_LIST:uint = 3;
      
      public static const MASTER_LIST:uint = 1;
      
      private static var allowInstantiation:Boolean = false;
      
      protected static var _instance:SpellingDictionary;
      
      public static const CUSTOM_LIST:uint = 2;
       
      
      protected var combinedList:Array;
      
      public var useFastMode:Boolean = false;
      
      public var ignoreMixedCaps:Boolean = true;
      
      protected var masterHash:Object;
      
      public var ignoreInitialCaps:Boolean = false;
      
      protected var customHash:Object;
      
      protected var masterList:Array;
      
      protected var dontSuggestHash:Object;
      
      protected var customList:Array;
      
      public var ignoreAllCaps:Boolean = true;
      
      protected var dontSuggestList:Array;
      
      protected var combinedHash:Object;
      
      public function SpellingDictionary()
      {
         super();
         if(!allowInstantiation)
         {
            throw "SpellingDictionary can not be instantiated directly. Use SpellingDictionary.getInstance instead.";
         }
         setCustomWordList([]);
         dontSuggestWordList = [];
      }
      
      public static function getInstance() : SpellingDictionary
      {
         if(_instance == null)
         {
            allowInstantiation = true;
            _instance = new SpellingDictionary();
            allowInstantiation = false;
         }
         return _instance;
      }
      
      public function getWordList(param1:int = 3, param2:String = null, param3:String = null) : Array
      {
         var _loc4_:Array = param1 == COMBINED_LIST?combinedList:param1 == MASTER_LIST?masterList:customList;
         if(_loc4_ == null)
         {
            return null;
         }
         if(param2 == null && param3 == null)
         {
            return _loc4_;
         }
         var _loc5_:uint = param2 == null?uint(0):uint(SpellingUtils.findIndex(_loc4_,param2));
         var _loc6_:uint = param3 == null?uint(_loc4_.length):uint(SpellingUtils.findIndex(_loc4_,param3));
         if(_loc4_[_loc6_] == param3)
         {
            _loc6_++;
         }
         return _loc4_.slice(_loc5_,_loc6_);
      }
      
      public function checkWordList(param1:Array, param2:int = 3) : Array
      {
         var _loc3_:int = param1.length;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_[_loc5_] = checkWord(param1[_loc5_],param2);
            _loc5_++;
         }
         return _loc4_;
      }
      
      protected function listToHash(param1:Array) : Object
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Object = {};
         var _loc3_:int = param1.length;
         while(_loc3_--)
         {
            _loc2_[param1[_loc3_]] = true;
         }
         return _loc2_;
      }
      
      public function getNextMisspelledWord(param1:String, param2:uint = 0, param3:int = 3) : StringPosition
      {
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc4_:Array = CharacterSet.wordCharSet;
         var _loc5_:Array = CharacterSet.innerWordCharSet;
         var _loc6_:Array = CharacterSet.invalidWordCharSet;
         var _loc7_:int = param1.length;
         var _loc8_:int = 0;
         var _loc9_:int = param2;
         var _loc10_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc11_ = param1.charCodeAt(_loc9_);
            if(_loc10_ == 0 && (_loc4_[_loc11_] || _loc6_[_loc11_]))
            {
               _loc8_ = _loc9_;
               _loc10_ = !!_loc4_[_loc11_]?1:2;
            }
            else if(_loc10_ > 0 && !_loc4_[_loc11_])
            {
               if(_loc5_[_loc11_])
               {
                  if(!_loc4_[param1.charCodeAt(_loc9_ + 1)])
                  {
                     _loc10_ = _loc10_ == 1?3:0;
                  }
               }
               else
               {
                  _loc10_ = !!_loc6_[_loc11_]?2:_loc10_ == 1?3:0;
               }
            }
            if(_loc10_ == 3)
            {
               _loc12_ = param1.substring(_loc8_,_loc9_);
               if(!checkWord(_loc12_))
               {
                  return new StringPosition(_loc8_,_loc9_,_loc12_);
               }
               _loc10_ = 0;
            }
            _loc9_++;
         }
         if(_loc10_ == 1)
         {
            _loc12_ = param1.substring(_loc8_);
            if(!checkWord(_loc12_))
            {
               return new StringPosition(_loc8_,_loc9_,_loc12_);
            }
         }
         return null;
      }
      
      public function get active() : Boolean
      {
         return masterList != null;
      }
      
      protected function combineLists() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:* = null;
         if(masterList == null && customList == null)
         {
            combinedList = null;
         }
         else if(masterList == null)
         {
            combinedList = customList.slice(0);
         }
         else if(customList == null)
         {
            combinedList = masterList.slice(0);
         }
         else
         {
            combinedList = masterList.slice(0);
            _loc1_ = combinedList;
            _loc2_ = customHash;
            _loc3_ = masterHash;
            for(_loc4_ in _loc2_)
            {
               if(!_loc3_[_loc4_])
               {
                  _loc1_.splice(SpellingUtils.findIndex(_loc1_,_loc4_),0,_loc4_);
               }
            }
         }
         combinedHash = listToHash(combinedList);
      }
      
      public function get dontSuggestWordList() : Array
      {
         return dontSuggestList.slice(0);
      }
      
      public function addCustomWord(param1:String) : void
      {
         var _loc2_:int = 0;
         param1 = param1.toLowerCase();
         if(!combinedHash[param1])
         {
            combinedHash[param1] = true;
            combinedList.splice(SpellingUtils.findIndex(combinedList,param1),0,param1);
         }
         if(!customHash[param1])
         {
            customHash[param1] = true;
            _loc2_ = SpellingUtils.findIndex(customList,param1);
            customList.splice(_loc2_,0,param1);
            dispatchEvent(new SpellingDictionaryEvent(SpellingDictionaryEvent.ADDED_CUSTOM_WORD,param1,_loc2_));
         }
      }
      
      public function setMasterWordList(param1:Array) : void
      {
         var _loc2_:Boolean = active;
         masterList = param1;
         masterHash = listToHash(param1);
         combineLists();
         dispatchEvent(new SpellingDictionaryEvent(SpellingDictionaryEvent.CHANGED_MASTER_WORD_LIST));
         if(_loc2_ != active)
         {
            dispatchEvent(new SpellingDictionaryEvent(SpellingDictionaryEvent.ACTIVE));
         }
      }
      
      public function setCustomWordList(param1:Array = null) : void
      {
         if(param1 == null)
         {
            param1 = [];
         }
         customList = param1;
         customHash = listToHash(param1);
         combineLists();
         dispatchEvent(new SpellingDictionaryEvent(SpellingDictionaryEvent.CHANGED_CUSTOM_WORD_LIST));
      }
      
      public function getWordHash(param1:int = 3, param2:String = null, param3:String = null) : Object
      {
         if(param2 == null && param3 == null)
         {
            return param1 == COMBINED_LIST?combinedHash:param1 == MASTER_LIST?masterHash:customHash;
         }
         return listToHash(getWordList(param1,param2,param3));
      }
      
      public function checkWord(param1:String, param2:int = 3) : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         if(param1.length < 2)
         {
            return true;
         }
         var _loc3_:Object = getWordHash(param2);
         if(_loc3_[param1] || _loc3_[_loc4_ = param1.toLowerCase()])
         {
            return true;
         }
         if(ignoreInitialCaps && param1.charAt(0) != _loc4_.charAt(0))
         {
            return true;
         }
         if(ignoreAllCaps || ignoreMixedCaps)
         {
            _loc5_ = param1.toUpperCase();
         }
         if(ignoreAllCaps && param1 == _loc5_)
         {
            return true;
         }
         if(ignoreMixedCaps && param1.substr(1) != _loc4_.substr(1) && param1 != _loc5_)
         {
            return true;
         }
         return false;
      }
      
      public function set dontSuggestWordList(param1:Array) : void
      {
         dontSuggestList = param1 == null?[]:param1.slice(0);
         dontSuggestHash = listToHash(dontSuggestList);
      }
      
      public function getSpellingSuggestions(param1:String, param2:uint = 5, param3:Number = 0.5, param4:int = 3, param5:* = null) : Array
      {
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc6_:* = param1.toUpperCase() == param1;
         var _loc7_:* = param1.charAt(0).toUpperCase() == param1.charAt(0);
         param5 = param5 == null?this.useFastMode:Boolean(param5);
         var _loc8_:String = param1.toLowerCase();
         var _loc9_:Array = [];
         var _loc10_:Array = [];
         var _loc11_:int = _loc8_.length;
         var _loc15_:Array = !!param5?getWordList(param4,_loc8_.charAt(0),_loc8_.charAt(0) + "~"):getWordList(param4);
         var _loc16_:int = !!param5?1:0;
         var _loc17_:int = (_loc11_ + 2.5) * (1.5 * param3);
         var _loc20_:int = _loc15_.length;
         var _loc21_:int = 0;
         while(_loc21_ < _loc20_)
         {
            _loc22_ = _loc15_[_loc21_];
            if(!dontSuggestHash[_loc22_])
            {
               _loc12_ = _loc22_.length;
               if(_loc12_ > _loc11_)
               {
                  _loc13_ = _loc12_;
                  _loc18_ = _loc12_ - _loc11_;
               }
               else
               {
                  _loc13_ = _loc11_;
                  _loc18_ = _loc11_ - _loc12_;
               }
               if(_loc18_ << 2 <= _loc17_)
               {
                  _loc19_ = _loc18_ = 0;
                  _loc23_ = _loc16_;
                  while(_loc23_ < _loc13_ && _loc18_ <= _loc17_)
                  {
                     _loc14_ = _loc8_.charAt(_loc23_);
                     _loc24_ = _loc22_.charAt(_loc23_ + _loc19_);
                     if(_loc24_ != _loc14_)
                     {
                        if(_loc23_ + _loc19_ < _loc13_ - 1 && _loc22_.charAt(_loc23_ + 1 + _loc19_) == _loc14_)
                        {
                           if(_loc24_ == _loc8_.charAt(_loc23_ + 1))
                           {
                              _loc18_ = _loc18_ + 3;
                              _loc23_++;
                           }
                           else
                           {
                              _loc18_ = _loc18_ + 3;
                              _loc19_++;
                           }
                        }
                        else if(_loc23_ < _loc13_ - 1 && _loc24_ == _loc8_.charAt(_loc23_ + 1))
                        {
                           _loc18_ = _loc18_ + 3;
                           _loc19_--;
                        }
                        else
                        {
                           _loc18_ = _loc18_ + 4;
                        }
                     }
                     _loc23_++;
                  }
                  if(_loc18_ <= _loc17_)
                  {
                     if(_loc19_ < 0 && _loc22_.charAt(_loc12_ - 1) != _loc8_.charAt(_loc11_ - 1))
                     {
                        _loc18_ = _loc18_ + 4;
                     }
                     if(_loc18_ <= _loc17_)
                     {
                        _loc9_.push({
                           "str":_loc22_,
                           "sc":_loc18_
                        });
                        if(_loc9_.length == 300)
                        {
                           break;
                        }
                     }
                  }
               }
            }
            _loc21_++;
         }
         _loc9_.sortOn(["sc","str"],[Array.NUMERIC,0]);
         _loc13_ = Math.min(_loc9_.length,param2);
         _loc23_ = 0;
         while(_loc23_ < _loc13_)
         {
            _loc25_ = _loc9_[_loc23_].str;
            if(_loc6_)
            {
               _loc25_ = _loc25_.toUpperCase();
            }
            else if(_loc7_)
            {
               _loc25_ = _loc25_.charAt(0).toUpperCase() + _loc25_.substr(1);
            }
            _loc10_.push(_loc25_);
            _loc23_++;
         }
         return _loc10_;
      }
      
      public function checkString(param1:String, param2:int = 3) : Array
      {
         var _loc5_:StringPosition = null;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(true)
         {
            _loc5_ = getNextMisspelledWord(param1,_loc4_,param2);
            if(_loc5_ == null)
            {
               break;
            }
            _loc3_.push(_loc5_);
            _loc4_ = _loc5_.endIndex + 1;
         }
         return _loc3_;
      }
      
      public function removeCustomWord(param1:String) : void
      {
         param1 = param1.toLowerCase();
         if(!customHash[param1])
         {
            return;
         }
         delete customHash[param1];
         var _loc2_:int = SpellingUtils.findIndex(customList,param1);
         customList.splice(_loc2_,1);
         if(!masterHash[param1])
         {
            delete combinedHash[param1];
            combinedList.splice(SpellingUtils.findIndex(combinedList,param1),1);
         }
         dispatchEvent(new SpellingDictionaryEvent(SpellingDictionaryEvent.REMOVED_CUSTOM_WORD,param1,_loc2_));
      }
   }
}
