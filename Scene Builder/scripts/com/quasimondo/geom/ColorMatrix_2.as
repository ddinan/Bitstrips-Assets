package com.quasimondo.geom
{
   import flash.filters.ColorMatrixFilter;
   
   public class ColorMatrix
   {
      
      private static const ONETHIRD:Number = 1 / 3;
      
      private static const LUMA_G:Number = 0.71516;
      
      private static const LUMA_B:Number = 0.072169;
      
      private static const LUMA_R2:Number = 0.3086;
      
      private static const LUMA_G2:Number = 0.6094;
      
      private static const LUMA_R:Number = 0.212671;
      
      private static const LUMA_B2:Number = 0.082;
      
      private static const RAD:Number = Math.PI / 180;
      
      private static const IDENTITY:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      public static const COLOR_DEFICIENCY_TYPES:Array = ["Protanopia","Protanomaly","Deuteranopia","Deuteranomaly","Tritanopia","Tritanomaly","Achromatopsia","Achromatomaly"];
       
      
      public var matrix:Array;
      
      private var preHue:ColorMatrix;
      
      private var postHue:ColorMatrix;
      
      private var hueInitialized:Boolean;
      
      public function ColorMatrix(param1:Object = null)
      {
         super();
         if(param1 is ColorMatrix)
         {
            matrix = param1.matrix.concat();
         }
         else if(param1 is Array)
         {
            matrix = param1.concat();
         }
         else
         {
            reset();
         }
      }
      
      public function adjustBrightness(param1:Number, param2:Number = NaN, param3:Number = NaN) : void
      {
         if(isNaN(param2))
         {
            param2 = param1;
         }
         if(isNaN(param3))
         {
            param3 = param1;
         }
         concat([1,0,0,0,param1,0,1,0,0,param2,0,0,1,0,param3,0,0,0,1,0]);
      }
      
      public function averageRGB2Alpha() : void
      {
         concat([0,0,0,0,255,0,0,0,0,255,0,0,0,0,255,ONETHIRD,ONETHIRD,ONETHIRD,0,0]);
      }
      
      public function luminance2Alpha() : void
      {
         concat([0,0,0,0,255,0,0,0,0,255,0,0,0,0,255,LUMA_R,LUMA_G,LUMA_B,0,0]);
      }
      
      public function rotateRed(param1:Number) : void
      {
         rotateColor(param1,2,1);
      }
      
      public function get filter() : ColorMatrixFilter
      {
         return new ColorMatrixFilter(matrix);
      }
      
      public function adjustSaturation(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc2_ = 1 - param1;
         _loc3_ = _loc2_ * LUMA_R;
         _loc4_ = _loc2_ * LUMA_G;
         _loc5_ = _loc2_ * LUMA_B;
         concat([_loc3_ + param1,_loc4_,_loc5_,0,0,_loc3_,_loc4_ + param1,_loc5_,0,0,_loc3_,_loc4_,_loc5_ + param1,0,0,0,0,0,1,0]);
      }
      
      public function adjustAlphaContrast(param1:Number) : void
      {
         param1 = param1 + 1;
         concat([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,param1,128 * (1 - param1)]);
      }
      
      public function reset() : void
      {
         matrix = IDENTITY.concat();
      }
      
      public function blend(param1:ColorMatrix, param2:Number) : void
      {
         var _loc3_:Number = 1 - param2;
         var _loc4_:int = 0;
         while(_loc4_ < 20)
         {
            matrix[_loc4_] = _loc3_ * Number(matrix[_loc4_]) + param2 * Number(param1.matrix[_loc4_]);
            _loc4_++;
         }
      }
      
      public function setChannels(param1:int = 1, param2:int = 2, param3:int = 4, param4:int = 8) : void
      {
         var _loc5_:Number = !!((!!(((param1 & 1) == 1?1:!!(0 + ((param1 & 2) == 2))?1:0) + ((param1 & 4) == 4))?1:0) + ((param1 & 8) == 8))?Number(1):Number(0);
         if(_loc5_ > 0)
         {
            _loc5_ = 1 / _loc5_;
         }
         var _loc6_:Number = !!((!!(((param2 & 1) == 1?1:!!(0 + ((param2 & 2) == 2))?1:0) + ((param2 & 4) == 4))?1:0) + ((param2 & 8) == 8))?Number(1):Number(0);
         if(_loc6_ > 0)
         {
            _loc6_ = 1 / _loc6_;
         }
         var _loc7_:Number = !!((!!(((param3 & 1) == 1?1:!!(0 + ((param3 & 2) == 2))?1:0) + ((param3 & 4) == 4))?1:0) + ((param3 & 8) == 8))?Number(1):Number(0);
         if(_loc7_ > 0)
         {
            _loc7_ = 1 / _loc7_;
         }
         var _loc8_:Number = !!((!!(((param4 & 1) == 1?1:!!(0 + ((param4 & 2) == 2))?1:0) + ((param4 & 4) == 4))?1:0) + ((param4 & 8) == 8))?Number(1):Number(0);
         if(_loc8_ > 0)
         {
            _loc8_ = 1 / _loc8_;
         }
         concat([(param1 & 1) == 1?_loc5_:0,(param1 & 2) == 2?_loc5_:0,(param1 & 4) == 4?_loc5_:0,(param1 & 8) == 8?_loc5_:0,0,(param2 & 1) == 1?_loc6_:0,(param2 & 2) == 2?_loc6_:0,(param2 & 4) == 4?_loc6_:0,(param2 & 8) == 8?_loc6_:0,0,(param3 & 1) == 1?_loc7_:0,(param3 & 2) == 2?_loc7_:0,(param3 & 4) == 4?_loc7_:0,(param3 & 8) == 8?_loc7_:0,0,(param4 & 1) == 1?_loc8_:0,(param4 & 2) == 2?_loc8_:0,(param4 & 4) == 4?_loc8_:0,(param4 & 8) == 8?_loc8_:0,0]);
      }
      
      public function randomize(param1:Number = 1) : void
      {
         var _loc2_:Number = 1 - param1;
         var _loc3_:Number = _loc2_ + param1 * (Math.random() - Math.random());
         var _loc4_:Number = param1 * (Math.random() - Math.random());
         var _loc5_:Number = param1 * (Math.random() - Math.random());
         var _loc6_:Number = param1 * 255 * (Math.random() - Math.random());
         var _loc7_:Number = param1 * (Math.random() - Math.random());
         var _loc8_:Number = _loc2_ + param1 * (Math.random() - Math.random());
         var _loc9_:Number = param1 * (Math.random() - Math.random());
         var _loc10_:Number = param1 * 255 * (Math.random() - Math.random());
         var _loc11_:Number = param1 * (Math.random() - Math.random());
         var _loc12_:Number = param1 * (Math.random() - Math.random());
         var _loc13_:Number = _loc2_ + param1 * (Math.random() - Math.random());
         var _loc14_:Number = param1 * 255 * (Math.random() - Math.random());
         concat([_loc3_,_loc4_,_loc5_,0,_loc6_,_loc7_,_loc8_,_loc9_,0,_loc10_,_loc11_,_loc12_,_loc13_,0,_loc14_,0,0,0,1,0]);
      }
      
      public function concat(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < 4)
         {
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               _loc2_[int(_loc3_ + _loc4_)] = Number(param1[_loc3_]) * Number(matrix[_loc4_]) + Number(param1[int(_loc3_ + 1)]) * Number(matrix[int(_loc4_ + 5)]) + Number(param1[int(_loc3_ + 2)]) * Number(matrix[int(_loc4_ + 10)]) + Number(param1[int(_loc3_ + 3)]) * Number(matrix[int(_loc4_ + 15)]) + (_loc4_ == 4?Number(param1[int(_loc3_ + 4)]):0);
               _loc4_++;
            }
            _loc3_ = _loc3_ + 5;
            _loc5_++;
         }
         matrix = _loc2_;
      }
      
      public function invert() : void
      {
         concat([-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0]);
      }
      
      private function rotateColor(param1:Number, param2:int, param3:int) : void
      {
         param1 = param1 * RAD;
         var _loc4_:Array = IDENTITY.concat();
         _loc4_[param2 + param2 * 5] = _loc4_[param3 + param3 * 5] = Math.cos(param1);
         _loc4_[param3 + param2 * 5] = Math.sin(param1);
         _loc4_[param2 + param3 * 5] = -Math.sin(param1);
         concat(_loc4_);
      }
      
      public function colorize(param1:int, param2:Number = 1) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc3_ = (param1 >> 16 & 255) / 255;
         _loc4_ = (param1 >> 8 & 255) / 255;
         _loc5_ = (param1 & 255) / 255;
         _loc6_ = 1 - param2;
         concat([_loc6_ + param2 * _loc3_ * LUMA_R,param2 * _loc3_ * LUMA_G,param2 * _loc3_ * LUMA_B,0,0,param2 * _loc4_ * LUMA_R,_loc6_ + param2 * _loc4_ * LUMA_G,param2 * _loc4_ * LUMA_B,0,0,param2 * _loc5_ * LUMA_R,param2 * _loc5_ * LUMA_G,_loc6_ + param2 * _loc5_ * LUMA_B,0,0,0,0,0,1,0]);
      }
      
      public function rgb2Alpha(param1:Number, param2:Number, param3:Number) : void
      {
         concat([0,0,0,0,255,0,0,0,0,255,0,0,0,0,255,param1,param2,param3,0,0]);
      }
      
      private function shearColor(param1:int, param2:int, param3:Number, param4:int, param5:Number) : void
      {
         var _loc6_:Array = IDENTITY.concat();
         _loc6_[param2 + param1 * 5] = param3;
         _loc6_[param4 + param1 * 5] = param5;
         concat(_loc6_);
      }
      
      public function shearBlue(param1:Number, param2:Number) : void
      {
         shearColor(2,0,param1,1,param2);
      }
      
      public function setAlpha(param1:Number) : void
      {
         concat([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,param1,0]);
      }
      
      public function rotateHue(param1:Number) : void
      {
         initHue();
         concat(preHue.matrix);
         rotateBlue(param1);
         concat(postHue.matrix);
      }
      
      public function applyMatrix(param1:uint) : uint
      {
         var _loc2_:Number = param1 >>> 24 & 255;
         var _loc3_:Number = param1 >>> 16 & 255;
         var _loc4_:Number = param1 >>> 8 & 255;
         var _loc5_:Number = param1 & 255;
         var _loc6_:int = 0.5 + _loc3_ * matrix[0] + _loc4_ * matrix[1] + _loc5_ * matrix[2] + _loc2_ * matrix[3] + matrix[4];
         var _loc7_:int = 0.5 + _loc3_ * matrix[5] + _loc4_ * matrix[6] + _loc5_ * matrix[7] + _loc2_ * matrix[8] + matrix[9];
         var _loc8_:int = 0.5 + _loc3_ * matrix[10] + _loc4_ * matrix[11] + _loc5_ * matrix[12] + _loc2_ * matrix[13] + matrix[14];
         var _loc9_:int = 0.5 + _loc3_ * matrix[15] + _loc4_ * matrix[16] + _loc5_ * matrix[17] + _loc2_ * matrix[18] + matrix[19];
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc9_ > 255)
         {
            _loc9_ = 255;
         }
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         if(_loc6_ > 255)
         {
            _loc6_ = 255;
         }
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(_loc7_ > 255)
         {
            _loc7_ = 255;
         }
         if(_loc8_ < 0)
         {
            _loc8_ = 0;
         }
         if(_loc8_ > 255)
         {
            _loc8_ = 255;
         }
         return _loc9_ << 24 | _loc6_ << 16 | _loc7_ << 8 | _loc8_;
      }
      
      private function initHue() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = 39.182655;
         if(!hueInitialized)
         {
            hueInitialized = true;
            preHue = new ColorMatrix();
            preHue.rotateRed(45);
            preHue.rotateGreen(-_loc1_);
            _loc2_ = [LUMA_R2,LUMA_G2,LUMA_B2,1];
            preHue.transformVector(_loc2_);
            _loc3_ = _loc2_[0] / _loc2_[2];
            _loc4_ = _loc2_[1] / _loc2_[2];
            preHue.shearBlue(_loc3_,_loc4_);
            postHue = new ColorMatrix();
            postHue.shearBlue(-_loc3_,-_loc4_);
            postHue.rotateGreen(_loc1_);
            postHue.rotateRed(-45);
         }
      }
      
      public function shearGreen(param1:Number, param2:Number) : void
      {
         shearColor(1,0,param1,2,param2);
      }
      
      public function shearRed(param1:Number, param2:Number) : void
      {
         shearColor(0,1,param1,2,param2);
      }
      
      public function average(param1:Number = 0.0, param2:Number = 0.0, param3:Number = 0.0) : void
      {
         concat([param1,param2,param3,0,0,param1,param2,param3,0,0,param1,param2,param3,0,0,0,0,0,1,0]);
      }
      
      public function transformVector(param1:Array) : void
      {
         if(param1.length != 4)
         {
            return;
         }
         var _loc2_:Number = param1[0] * matrix[0] + param1[1] * matrix[1] + param1[2] * matrix[2] + param1[3] * matrix[3] + matrix[4];
         var _loc3_:Number = param1[0] * matrix[5] + param1[1] * matrix[6] + param1[2] * matrix[7] + param1[3] * matrix[8] + matrix[9];
         var _loc4_:Number = param1[0] * matrix[10] + param1[1] * matrix[11] + param1[2] * matrix[12] + param1[3] * matrix[13] + matrix[14];
         var _loc5_:Number = param1[0] * matrix[15] + param1[1] * matrix[16] + param1[2] * matrix[17] + param1[3] * matrix[18] + matrix[19];
         param1[0] = _loc2_;
         param1[1] = _loc3_;
         param1[2] = _loc4_;
         param1[3] = _loc5_;
      }
      
      public function invertAlpha() : void
      {
         concat([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,-1,255]);
      }
      
      public function adjustHue(param1:Number) : void
      {
         param1 = param1 * RAD;
         var _loc2_:Number = Math.cos(param1);
         var _loc3_:Number = Math.sin(param1);
         concat([LUMA_R + _loc2_ * (1 - LUMA_R) + _loc3_ * -LUMA_R,LUMA_G + _loc2_ * -LUMA_G + _loc3_ * -LUMA_G,LUMA_B + _loc2_ * -LUMA_B + _loc3_ * (1 - LUMA_B),0,0,LUMA_R + _loc2_ * -LUMA_R + _loc3_ * 0.143,LUMA_G + _loc2_ * (1 - LUMA_G) + _loc3_ * 0.14,LUMA_B + _loc2_ * -LUMA_B + _loc3_ * -0.283,0,0,LUMA_R + _loc2_ * -LUMA_R + _loc3_ * -(1 - LUMA_R),LUMA_G + _loc2_ * -LUMA_G + _loc3_ * LUMA_G,LUMA_B + _loc2_ * (1 - LUMA_B) + _loc3_ * LUMA_B,0,0,0,0,0,1,0]);
      }
      
      public function threshold(param1:Number, param2:Number = 256) : void
      {
         concat([LUMA_R * param2,LUMA_G * param2,LUMA_B * param2,0,-param2 * param1,LUMA_R * param2,LUMA_G * param2,LUMA_B * param2,0,-param2 * param1,LUMA_R * param2,LUMA_G * param2,LUMA_B * param2,0,-param2 * param1,0,0,0,1,0]);
      }
      
      public function clone() : ColorMatrix
      {
         return new ColorMatrix(matrix);
      }
      
      public function rotateBlue(param1:Number) : void
      {
         rotateColor(param1,1,0);
      }
      
      public function rotateGreen(param1:Number) : void
      {
         rotateColor(param1,0,2);
      }
      
      public function desaturate() : void
      {
         concat([LUMA_R,LUMA_G,LUMA_B,0,0,LUMA_R,LUMA_G,LUMA_B,0,0,LUMA_R,LUMA_G,LUMA_B,0,0,0,0,0,1,0]);
      }
      
      public function adjustContrast(param1:Number, param2:Number = NaN, param3:Number = NaN) : void
      {
         if(isNaN(param2))
         {
            param2 = param1;
         }
         if(isNaN(param3))
         {
            param3 = param1;
         }
         param1 = param1 + 1;
         param2 = param2 + 1;
         param3 = param3 + 1;
         concat([param1,0,0,0,128 * (1 - param1),0,param2,0,0,128 * (1 - param2),0,0,param3,0,128 * (1 - param3),0,0,0,1,0]);
      }
      
      public function setMultiplicators(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1) : void
      {
         var _loc5_:Array = new Array(param1,0,0,0,0,0,param2,0,0,0,0,0,param3,0,0,0,0,0,param4,0);
         concat(_loc5_);
      }
      
      public function thresholdAlpha(param1:Number, param2:Number = 256) : void
      {
         concat([1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,param2,-param2 * param1]);
      }
      
      public function clearChannels(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         if(param1)
         {
            matrix[0] = matrix[1] = matrix[2] = matrix[3] = matrix[4] = 0;
         }
         if(param2)
         {
            matrix[5] = matrix[6] = matrix[7] = matrix[8] = matrix[9] = 0;
         }
         if(param3)
         {
            matrix[10] = matrix[11] = matrix[12] = matrix[13] = matrix[14] = 0;
         }
         if(param4)
         {
            matrix[15] = matrix[16] = matrix[17] = matrix[18] = matrix[19] = 0;
         }
      }
      
      public function applyColorDeficiency(param1:String) : void
      {
         switch(param1)
         {
            case "Protanopia":
               concat([0.567,0.433,0,0,0,0.558,0.442,0,0,0,0,0.242,0.758,0,0,0,0,0,1,0]);
               break;
            case "Protanomaly":
               concat([0.817,0.183,0,0,0,0.333,0.667,0,0,0,0,0.125,0.875,0,0,0,0,0,1,0]);
               break;
            case "Deuteranopia":
               concat([0.625,0.375,0,0,0,0.7,0.3,0,0,0,0,0.3,0.7,0,0,0,0,0,1,0]);
               break;
            case "Deuteranomaly":
               concat([0.8,0.2,0,0,0,0.258,0.742,0,0,0,0,0.142,0.858,0,0,0,0,0,1,0]);
               break;
            case "Tritanopia":
               concat([0.95,0.05,0,0,0,0,0.433,0.567,0,0,0,0.475,0.525,0,0,0,0,0,1,0]);
               break;
            case "Tritanomaly":
               concat([0.967,0.033,0,0,0,0,0.733,0.267,0,0,0,0.183,0.817,0,0,0,0,0,1,0]);
               break;
            case "Achromatopsia":
               concat([0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0.299,0.587,0.114,0,0,0,0,0,1,0]);
               break;
            case "Achromatomaly":
               concat([0.618,0.32,0.062,0,0,0.163,0.775,0.062,0,0,0.163,0.32,0.516,0,0,0,0,0,1,0]);
         }
      }
   }
}
