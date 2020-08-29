package com.bitstrips.core
{
   public class ColorTools
   {
       
      
      public function ColorTools()
      {
         super();
      }
      
      public static function RGBtoHSB(param1:Number) : Object
      {
         var _loc2_:Object = HEXtoRGB(param1);
         var _loc3_:uint = _loc2_.r;
         var _loc4_:uint = _loc2_.g;
         var _loc5_:uint = _loc2_.b;
         trace("r: " + _loc3_);
         var _loc6_:Object = new Object();
         _loc6_.b = Math.max(Math.max(_loc3_,_loc4_),_loc5_);
         var _loc7_:uint = Math.min(Math.min(_loc3_,_loc4_),_loc5_);
         _loc6_.s = _loc6_.b <= 0?0:Math.round(100 * (_loc6_.b - _loc7_) / _loc6_.b);
         _loc6_.b = Math.round(_loc6_.b / 255 * 100);
         _loc6_.h = 0;
         if(_loc3_ == _loc4_ && _loc4_ == _loc5_)
         {
            _loc6_.h = 0;
         }
         else if(_loc3_ >= _loc4_ && _loc4_ >= _loc5_)
         {
            _loc6_.h = 60 * (_loc4_ - _loc5_) / (_loc3_ - _loc5_);
         }
         else if(_loc4_ >= _loc3_ && _loc3_ >= _loc5_)
         {
            _loc6_.h = 60 + 60 * (_loc4_ - _loc3_) / (_loc4_ - _loc5_);
         }
         else if(_loc4_ >= _loc5_ && _loc5_ >= _loc3_)
         {
            _loc6_.h = 120 + 60 * (_loc5_ - _loc3_) / (_loc4_ - _loc3_);
         }
         else if(_loc5_ >= _loc4_ && _loc4_ >= _loc3_)
         {
            _loc6_.h = 180 + 60 * (_loc5_ - _loc4_) / (_loc5_ - _loc3_);
         }
         else if(_loc5_ >= _loc3_ && _loc3_ >= _loc4_)
         {
            _loc6_.h = 240 + 60 * (_loc3_ - _loc4_) / (_loc5_ - _loc4_);
         }
         else if(_loc3_ >= _loc5_ && _loc5_ >= _loc4_)
         {
            _loc6_.h = 300 + 60 * (_loc3_ - _loc5_) / (_loc3_ - _loc4_);
         }
         else
         {
            _loc6_.h = 0;
         }
         _loc6_.h = Math.round(_loc6_.h);
         return _loc6_;
      }
      
      public static function HEXtoRGB(param1:*) : Object
      {
         var _loc2_:int = !!isNaN(param1)?int(parseInt(param1,16)):int(param1);
         var _loc3_:uint = _loc2_ >> 16;
         var _loc4_:uint = (_loc2_ ^ _loc3_ << 16) >> 8;
         var _loc5_:uint = _loc2_ ^ _loc3_ << 16 ^ _loc4_ << 8;
         return {
            "r":_loc3_,
            "g":_loc4_,
            "b":_loc5_
         };
      }
   }
}
