package com.gskinner.spelling
{
   public class SpellingUtils
   {
       
      
      public function SpellingUtils()
      {
         super();
         throw new Error("SpellingUtils cannot be instantiated");
      }
      
      public static function findIndex(param1:Array, param2:String) : int
      {
         var _loc7_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = param1.length;
         var _loc5_:* = _loc4_ >> 1;
         var _loc6_:String = param2.toLowerCase();
         if(_loc3_ == _loc4_)
         {
            return _loc3_;
         }
         do
         {
            _loc7_ = (param1[_loc5_] as String).toLowerCase();
            if(_loc6_ > _loc7_)
            {
               _loc3_ = _loc5_;
            }
            else
            {
               _loc4_ = _loc5_;
            }
            _loc5_ = int((_loc4_ - _loc3_ >> 1) + _loc3_);
         }
         while(!(_loc5_ == _loc3_ || _loc5_ == _loc4_));
         
         return _loc7_ < _loc6_?int(_loc5_ + 1):int(_loc5_);
      }
      
      public static function mergeWordLists(param1:Array, param2:Array) : Array
      {
         var _loc9_:String = null;
         var _loc3_:Array = param1.length > param2.length?param1:param2;
         var _loc4_:Array = param1.length > param2.length?param2:param1;
         var _loc5_:int = _loc3_.length;
         var _loc6_:Object = {};
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_[_loc3_[_loc7_]] = true;
            _loc7_++;
         }
         var _loc8_:Array = _loc3_.slice(0);
         _loc5_ = _loc4_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc9_ = _loc4_[_loc7_];
            if(!_loc6_[_loc9_])
            {
               _loc8_.splice(findIndex(_loc8_,_loc9_),0,_loc9_);
            }
            _loc7_++;
         }
         return _loc8_;
      }
   }
}
