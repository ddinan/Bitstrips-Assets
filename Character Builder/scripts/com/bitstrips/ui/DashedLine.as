package com.bitstrips.ui
{
   public class DashedLine
   {
       
      
      private var overflow:Number = 0;
      
      public var target:Object;
      
      private var pen:Object;
      
      private var dashLength:Number = 0;
      
      private var onLength:Number = 0;
      
      public var _curveaccuracy:Number = 6;
      
      private var offLength:Number = 0;
      
      private var isLine:Boolean = true;
      
      public function DashedLine(param1:Object, param2:Number, param3:Number)
      {
         super();
         this.target = param1.graphics;
         this.setDash(param2,param3);
         this.isLine = true;
         this.overflow = 0;
         this.pen = {
            "x":0,
            "y":0
         };
      }
      
      private function targetLineTo(param1:Number, param2:Number) : void
      {
         if(param1 == this.pen.x && param2 == this.pen.y)
         {
            return;
         }
         this.pen = {
            "x":param1,
            "y":param2
         };
         this.target.lineTo(param1,param2);
      }
      
      public function endFill() : void
      {
         this.target.endFill();
      }
      
      public function getDash() : Array
      {
         return [this.onLength,this.offLength];
      }
      
      public function curveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc10_:Array = null;
         var _loc15_:uint = 0;
         var _loc5_:Number = this.pen.x;
         var _loc6_:Number = this.pen.y;
         var _loc7_:Number = this.curveLength(_loc5_,_loc6_,param1,param2,param3,param4);
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         if(this.overflow)
         {
            if(this.overflow > _loc7_)
            {
               if(this.isLine)
               {
                  this.targetCurveTo(param1,param2,param3,param4);
               }
               else
               {
                  this.targetMoveTo(param3,param4);
               }
               this.overflow = this.overflow - _loc7_;
               return;
            }
            _loc8_ = this.overflow / _loc7_;
            _loc10_ = this.curveSliceUpTo(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_);
            if(this.isLine)
            {
               this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
            }
            else
            {
               this.targetMoveTo(_loc10_[4],_loc10_[5]);
            }
            this.overflow = 0;
            this.isLine = !this.isLine;
            if(!_loc7_)
            {
               return;
            }
         }
         var _loc11_:Number = _loc7_ - _loc7_ * _loc8_;
         var _loc12_:uint = Math.floor(_loc11_ / this.dashLength);
         var _loc13_:Number = this.onLength / _loc7_;
         var _loc14_:Number = this.offLength / _loc7_;
         if(_loc12_)
         {
            _loc15_ = 0;
            while(_loc15_ < _loc12_)
            {
               if(this.isLine)
               {
                  _loc9_ = _loc8_ + _loc13_;
                  _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
                  this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
                  _loc8_ = _loc9_;
                  _loc9_ = _loc8_ + _loc14_;
                  _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
                  this.targetMoveTo(_loc10_[4],_loc10_[5]);
               }
               else
               {
                  _loc9_ = _loc8_ + _loc14_;
                  _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
                  this.targetMoveTo(_loc10_[4],_loc10_[5]);
                  _loc8_ = _loc9_;
                  _loc9_ = _loc8_ + _loc13_;
                  _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
                  this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
               }
               _loc8_ = _loc9_;
               _loc15_++;
            }
         }
         _loc11_ = _loc7_ - _loc7_ * _loc8_;
         if(this.isLine)
         {
            if(_loc11_ > this.onLength)
            {
               _loc9_ = _loc8_ + _loc13_;
               _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
               this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
               this.targetMoveTo(param3,param4);
               this.overflow = this.offLength - (_loc11_ - this.onLength);
               this.isLine = false;
            }
            else
            {
               _loc10_ = this.curveSliceFrom(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_);
               this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
               if(_loc7_ == this.onLength)
               {
                  this.overflow = 0;
                  this.isLine = !this.isLine;
               }
               else
               {
                  this.overflow = this.onLength - _loc11_;
                  this.targetMoveTo(param3,param4);
               }
            }
         }
         else if(_loc11_ > this.offLength)
         {
            _loc9_ = _loc8_ + _loc14_;
            _loc10_ = this.curveSlice(_loc5_,_loc6_,param1,param2,param3,param4,_loc8_,_loc9_);
            this.targetMoveTo(_loc10_[4],_loc10_[5]);
            _loc10_ = this.curveSliceFrom(_loc5_,_loc6_,param1,param2,param3,param4,_loc9_);
            this.targetCurveTo(_loc10_[2],_loc10_[3],_loc10_[4],_loc10_[5]);
            this.overflow = this.onLength - (_loc11_ - this.offLength);
            this.isLine = true;
         }
         else
         {
            this.targetMoveTo(param3,param4);
            if(_loc11_ == this.offLength)
            {
               this.overflow = 0;
               this.isLine = !this.isLine;
            }
            else
            {
               this.overflow = this.offLength - _loc11_;
            }
         }
      }
      
      public function beginFill(param1:Number, param2:Number = 1) : void
      {
         this.target.beginFill(param1,param2);
      }
      
      public function clear() : void
      {
         this.target.clear();
      }
      
      public function lineTo(param1:Number, param2:Number) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:int = 0;
         var _loc3_:Number = param1 - this.pen.x;
         var _loc4_:Number = param2 - this.pen.y;
         var _loc5_:Number = Math.atan2(_loc4_,_loc3_);
         var _loc6_:Number = Math.cos(_loc5_);
         var _loc7_:Number = Math.sin(_loc5_);
         var _loc8_:Number = this.lineLength(_loc3_,_loc4_);
         if(this.overflow)
         {
            if(this.overflow > _loc8_)
            {
               if(this.isLine)
               {
                  this.targetLineTo(param1,param2);
               }
               else
               {
                  this.targetMoveTo(param1,param2);
               }
               this.overflow = this.overflow - _loc8_;
               return;
            }
            if(this.isLine)
            {
               this.targetLineTo(this.pen.x + _loc6_ * this.overflow,this.pen.y + _loc7_ * this.overflow);
            }
            else
            {
               this.targetMoveTo(this.pen.x + _loc6_ * this.overflow,this.pen.y + _loc7_ * this.overflow);
            }
            _loc8_ = _loc8_ - this.overflow;
            this.overflow = 0;
            this.isLine = !this.isLine;
            if(!_loc8_)
            {
               return;
            }
         }
         var _loc9_:int = Math.floor(_loc8_ / this.dashLength);
         if(_loc9_)
         {
            _loc10_ = _loc6_ * this.onLength;
            _loc11_ = _loc7_ * this.onLength;
            _loc12_ = _loc6_ * this.offLength;
            _loc13_ = _loc7_ * this.offLength;
            _loc14_ = 0;
            while(_loc14_ < _loc9_)
            {
               if(this.isLine)
               {
                  this.targetLineTo(this.pen.x + _loc10_,this.pen.y + _loc11_);
                  this.targetMoveTo(this.pen.x + _loc12_,this.pen.y + _loc13_);
               }
               else
               {
                  this.targetMoveTo(this.pen.x + _loc12_,this.pen.y + _loc13_);
                  this.targetLineTo(this.pen.x + _loc10_,this.pen.y + _loc11_);
               }
               _loc14_++;
            }
            _loc8_ = _loc8_ - this.dashLength * _loc9_;
         }
         if(this.isLine)
         {
            if(_loc8_ > this.onLength)
            {
               this.targetLineTo(this.pen.x + _loc6_ * this.onLength,this.pen.y + _loc7_ * this.onLength);
               this.targetMoveTo(param1,param2);
               this.overflow = this.offLength - (_loc8_ - this.onLength);
               this.isLine = false;
            }
            else
            {
               this.targetLineTo(param1,param2);
               if(_loc8_ == this.onLength)
               {
                  this.overflow = 0;
                  this.isLine = !this.isLine;
               }
               else
               {
                  this.overflow = this.onLength - _loc8_;
                  this.targetMoveTo(param1,param2);
               }
            }
         }
         else if(_loc8_ > this.offLength)
         {
            this.targetMoveTo(this.pen.x + _loc6_ * this.offLength,this.pen.y + _loc7_ * this.offLength);
            this.targetLineTo(param1,param2);
            this.overflow = this.onLength - (_loc8_ - this.offLength);
            this.isLine = true;
         }
         else
         {
            this.targetMoveTo(param1,param2);
            if(_loc8_ == this.offLength)
            {
               this.overflow = 0;
               this.isLine = !this.isLine;
            }
            else
            {
               this.overflow = this.offLength - _loc8_;
            }
         }
      }
      
      public function setDash(param1:Number, param2:Number) : void
      {
         this.onLength = param1;
         this.offLength = param2;
         this.dashLength = this.onLength + this.offLength;
      }
      
      private function curveLength(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, ... rest) : Number
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc8_:Number = 0;
         var _loc9_:Number = param1;
         var _loc10_:Number = param2;
         var _loc18_:Number = rest[0] != null?Number(rest[0]):Number(this._curveaccuracy);
         var _loc19_:Number = 1;
         while(_loc19_ <= _loc18_)
         {
            _loc13_ = _loc19_ / _loc18_;
            _loc14_ = 1 - _loc13_;
            _loc15_ = _loc14_ * _loc14_;
            _loc16_ = 2 * _loc13_ * _loc14_;
            _loc17_ = _loc13_ * _loc13_;
            _loc11_ = _loc15_ * param1 + _loc16_ * param3 + _loc17_ * param5;
            _loc12_ = _loc15_ * param2 + _loc16_ * param4 + _loc17_ * param6;
            _loc8_ = _loc8_ + this.lineLength(_loc9_,_loc10_,_loc11_,_loc12_);
            _loc9_ = _loc11_;
            _loc10_ = _loc12_;
            _loc19_++;
         }
         return _loc8_;
      }
      
      private function targetCurveTo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         if(param1 == param3 && param2 == param4 && param3 == this.pen.x && param4 == this.pen.y)
         {
            return;
         }
         this.pen = {
            "x":param3,
            "y":param4
         };
         this.target.curveTo(param1,param2,param3,param4);
      }
      
      public function beginGradientFill(param1:String, param2:Array, param3:Array, param4:Array, param5:Object) : void
      {
         this.target.beginGradientFill(param1,param2,param3,param4,param5);
      }
      
      public function lineStyle(param1:Number, param2:Number, param3:Number) : void
      {
         this.target.lineStyle(param1,param2,param3);
      }
      
      private function curveSlice(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Array
      {
         if(param7 == 0)
         {
            return this.curveSliceUpTo(param1,param2,param3,param4,param5,param6,param8);
         }
         if(param8 == 1)
         {
            return this.curveSliceFrom(param1,param2,param3,param4,param5,param6,param7);
         }
         var _loc9_:Array = this.curveSliceUpTo(param1,param2,param3,param4,param5,param6,param8);
         _loc9_.push(param7 / param8);
         return this.curveSliceFrom.apply(this,_loc9_);
      }
      
      private function targetMoveTo(param1:Number, param2:Number) : void
      {
         this.pen = {
            "x":param1,
            "y":param2
         };
         this.target.moveTo(param1,param2);
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         this.targetMoveTo(param1,param2);
      }
      
      private function curveSliceFrom(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = 0) : Array
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param7 == 0)
         {
            param7 = 1;
         }
         if(param7 != 1)
         {
            _loc8_ = param1 + (param3 - param1) * param7;
            _loc9_ = param2 + (param4 - param2) * param7;
            param3 = param3 + (param5 - param3) * param7;
            param4 = param4 + (param6 - param4) * param7;
            param1 = _loc8_ + (param3 - _loc8_) * param7;
            param2 = _loc9_ + (param4 - _loc9_) * param7;
         }
         return [param1,param2,param3,param4,param5,param6];
      }
      
      private function curveSliceUpTo(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number = 0) : Array
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(param7 == 0)
         {
            param7 = 1;
         }
         if(param7 != 1)
         {
            _loc8_ = param3 + (param5 - param3) * param7;
            _loc9_ = param4 + (param6 - param4) * param7;
            param3 = param1 + (param3 - param1) * param7;
            param4 = param2 + (param4 - param2) * param7;
            param5 = param3 + (_loc8_ - param3) * param7;
            param6 = param4 + (_loc9_ - param4) * param7;
         }
         return [param1,param2,param3,param4,param5,param6];
      }
      
      private function lineLength(param1:Number, param2:Number, ... rest) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(!rest.length)
         {
            return Math.sqrt(param1 * param1 + param2 * param2);
         }
         _loc6_ = rest[0];
         _loc7_ = rest[1];
         var _loc4_:Number = _loc6_ - param1;
         var _loc5_:Number = _loc7_ - param2;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
   }
}
