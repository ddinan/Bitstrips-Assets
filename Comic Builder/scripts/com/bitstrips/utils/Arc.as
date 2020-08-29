package com.bitstrips.utils
{
   import flash.display.Sprite;
   
   public class Arc
   {
       
      
      public function Arc()
      {
         super();
      }
      
      public static function draw(param1:Sprite, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number = 0, param7:Boolean = false) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         param1.graphics.moveTo(param2,param3);
         if(Math.abs(param5) > 360)
         {
            param5 = 360;
         }
         _loc11_ = Math.ceil(Math.abs(param5) / 45);
         _loc8_ = param5 / _loc11_;
         _loc8_ = _loc8_ / 180 * Math.PI;
         _loc9_ = param6 / 180 * Math.PI;
         _loc12_ = param2 - Math.cos(_loc9_) * param4;
         _loc13_ = param3 - Math.sin(_loc9_) * param4;
         var _loc18_:int = 0;
         while(_loc18_ < _loc11_)
         {
            _loc9_ = _loc9_ + _loc8_;
            _loc10_ = _loc9_ - _loc8_ / 2;
            _loc14_ = _loc12_ + Math.cos(_loc9_) * param4;
            _loc15_ = _loc13_ + Math.sin(_loc9_) * param4;
            _loc16_ = _loc12_ + Math.cos(_loc10_) * (param4 / Math.cos(_loc8_ / 2));
            _loc17_ = _loc13_ + Math.sin(_loc10_) * (param4 / Math.cos(_loc8_ / 2));
            param1.graphics.curveTo(_loc16_,_loc17_,_loc14_,_loc15_);
            _loc18_++;
         }
      }
   }
}
