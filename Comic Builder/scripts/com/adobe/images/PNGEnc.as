package com.adobe.images
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class PNGEnc
   {
      
      private static var crcTable:Array;
      
      private static var crcTableComputed:Boolean = false;
       
      
      public function PNGEnc()
      {
         super();
      }
      
      public static function encode(param1:BitmapData, param2:uint = 0) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUnsignedInt(2303741511);
         _loc3_.writeUnsignedInt(218765834);
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeInt(param1.width);
         _loc4_.writeInt(param1.height);
         if(param1.transparent || param2 == 0)
         {
            _loc4_.writeUnsignedInt(134610944);
         }
         else
         {
            _loc4_.writeUnsignedInt(134348800);
         }
         _loc4_.writeByte(0);
         writeChunk(_loc3_,1229472850,_loc4_);
         var _loc5_:ByteArray = new ByteArray();
         switch(param2)
         {
            case 0:
               writeRaw(param1,_loc5_);
               break;
            case 1:
               writeSub(param1,_loc5_);
         }
         _loc5_.compress();
         writeChunk(_loc3_,1229209940,_loc5_);
         writeChunk(_loc3_,1229278788,null);
         return _loc3_;
      }
      
      private static function writeRaw(param1:BitmapData, param2:ByteArray) : void
      {
         var _loc7_:ByteArray = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc3_:int = param1.height;
         var _loc4_:int = param1.width;
         var _loc5_:Boolean = param1.transparent;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            if(!_loc5_)
            {
               _loc7_ = param1.getPixels(new Rectangle(0,_loc6_,_loc4_,1));
               _loc7_[0] = 0;
               param2.writeBytes(_loc7_);
               param2.writeByte(255);
            }
            else
            {
               param2.writeByte(0);
               _loc9_ = 0;
               while(_loc9_ < _loc4_)
               {
                  _loc8_ = param1.getPixel32(_loc9_,_loc6_);
                  param2.writeUnsignedInt(uint((_loc8_ & 16777215) << 8 | _loc8_ >>> 24));
                  _loc9_++;
               }
            }
            _loc6_++;
         }
      }
      
      private static function writeSub(param1:BitmapData, param2:ByteArray) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc19_:int = 0;
         var _loc16_:int = param1.height;
         var _loc17_:int = param1.width;
         var _loc18_:int = 0;
         while(_loc18_ < _loc16_)
         {
            param2.writeByte(1);
            if(!param1.transparent)
            {
               _loc3_ = 0;
               _loc4_ = 0;
               _loc5_ = 0;
               _loc6_ = 255;
               _loc19_ = 0;
               while(_loc19_ < _loc17_)
               {
                  _loc15_ = param1.getPixel(_loc19_,_loc18_);
                  _loc7_ = _loc15_ >> 16 & 255;
                  _loc8_ = _loc15_ >> 8 & 255;
                  _loc9_ = _loc15_ & 255;
                  _loc11_ = _loc7_ - _loc3_ + 256 & 255;
                  _loc12_ = _loc8_ - _loc4_ + 256 & 255;
                  _loc13_ = _loc9_ - _loc5_ + 256 & 255;
                  param2.writeByte(_loc11_);
                  param2.writeByte(_loc12_);
                  param2.writeByte(_loc13_);
                  _loc3_ = _loc7_;
                  _loc4_ = _loc8_;
                  _loc5_ = _loc9_;
                  _loc6_ = 0;
                  _loc19_++;
               }
            }
            else
            {
               _loc3_ = 0;
               _loc4_ = 0;
               _loc5_ = 0;
               _loc6_ = 0;
               _loc19_ = 0;
               while(_loc19_ < _loc17_)
               {
                  _loc15_ = param1.getPixel32(_loc19_,_loc18_);
                  _loc10_ = _loc15_ >> 24 & 255;
                  _loc7_ = _loc15_ >> 16 & 255;
                  _loc8_ = _loc15_ >> 8 & 255;
                  _loc9_ = _loc15_ & 255;
                  _loc11_ = _loc7_ - _loc3_ + 256 & 255;
                  _loc12_ = _loc8_ - _loc4_ + 256 & 255;
                  _loc13_ = _loc9_ - _loc5_ + 256 & 255;
                  _loc14_ = _loc10_ - _loc6_ + 256 & 255;
                  param2.writeByte(_loc11_);
                  param2.writeByte(_loc12_);
                  param2.writeByte(_loc13_);
                  param2.writeByte(_loc14_);
                  _loc3_ = _loc7_;
                  _loc4_ = _loc8_;
                  _loc5_ = _loc9_;
                  _loc6_ = _loc10_;
                  _loc19_++;
               }
            }
            _loc18_++;
         }
      }
      
      private static function writeChunk(param1:ByteArray, param2:uint, param3:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(!crcTableComputed)
         {
            crcTableComputed = true;
            crcTable = [];
            _loc9_ = 0;
            while(_loc9_ < 256)
            {
               _loc4_ = _loc9_;
               _loc10_ = 0;
               while(_loc10_ < 8)
               {
                  if(_loc4_ & 1)
                  {
                     _loc4_ = uint(uint(3988292384) ^ uint(_loc4_ >>> 1));
                  }
                  else
                  {
                     _loc4_ = uint(_loc4_ >>> 1);
                  }
                  _loc10_++;
               }
               crcTable[_loc9_] = _loc4_;
               _loc9_++;
            }
         }
         var _loc5_:uint = 0;
         if(param3 != null)
         {
            _loc5_ = param3.length;
         }
         param1.writeUnsignedInt(_loc5_);
         var _loc6_:uint = param1.position;
         param1.writeUnsignedInt(param2);
         if(param3 != null)
         {
            param1.writeBytes(param3);
         }
         var _loc7_:uint = param1.position;
         param1.position = _loc6_;
         _loc4_ = 4294967295;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_ - _loc6_)
         {
            _loc4_ = uint(crcTable[(_loc4_ ^ param1.readUnsignedByte()) & 255] ^ _loc4_ >>> 8);
            _loc8_++;
         }
         _loc4_ = uint(_loc4_ ^ uint(4294967295));
         param1.position = _loc7_;
         param1.writeUnsignedInt(_loc4_);
      }
   }
}
