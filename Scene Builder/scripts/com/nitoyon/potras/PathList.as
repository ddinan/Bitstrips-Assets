package com.nitoyon.potras
{
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PathList
   {
       
      
      public function PathList()
      {
         super();
      }
      
      private static function xorPath(param1:BitmapData, param2:Object, param3:ColorMatrixFilter) : void
      {
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc4_:Array = param2.priv as Array;
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 99999;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_ = Math.min(_loc6_,_loc4_[_loc7_].x);
            _loc7_++;
         }
         var _loc8_:int = _loc4_[_loc5_ - 1].y;
         var _loc9_:Point = new Point();
         var _loc10_:Rectangle = new Rectangle();
         _loc7_ = 0;
         while(_loc7_ < _loc5_)
         {
            _loc11_ = _loc4_[_loc7_].x;
            _loc12_ = _loc4_[_loc7_].y;
            if(_loc12_ != _loc8_)
            {
               _loc13_ = Math.max(_loc12_,_loc8_);
               _loc9_.x = _loc6_;
               _loc9_.y = _loc13_;
               _loc10_.x = _loc6_;
               _loc10_.y = _loc13_;
               _loc10_.width = _loc11_ - _loc6_;
               _loc10_.height = 1;
               param1.applyFilter(param1,_loc10_,_loc9_,param3);
               _loc8_ = _loc12_;
            }
            _loc7_++;
         }
      }
      
      private static function findNext(param1:BitmapData, param2:Point) : Boolean
      {
         var _loc4_:int = 0;
         var _loc3_:int = param2.y;
         while(_loc3_ < param1.height)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.width)
            {
               if(param1.getPixel(_loc4_,_loc3_) == 0)
               {
                  param2.x = _loc4_;
                  param2.y = _loc3_;
                  return true;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function create(param1:BitmapData) : Array
      {
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         var _loc4_:BitmapData = param1.clone();
         var _loc5_:Object = {"turdSize":3};
         var _loc6_:ColorMatrixFilter = new ColorMatrixFilter([-1,0,0,0,255,-1,0,0,0,255,-1,0,0,0,255,0,0,0,1,0]);
         var _loc7_:Point = new Point();
         while(findNext(_loc4_,_loc7_))
         {
            _loc8_ = _loc4_.getPixel(_loc7_.x,_loc7_.y) == 0?"+":"-";
            _loc9_ = findPath(_loc4_,new Point(_loc7_.x,_loc7_.y - 1),_loc8_,_loc5_.turnPolicy);
            if(!_loc9_)
            {
               _loc2_ = null;
               break;
            }
            xorPath(_loc4_,_loc9_,_loc6_);
            if(_loc9_.area > _loc5_.turdSize)
            {
               _loc2_.push(_loc9_);
            }
         }
         _loc4_.dispose();
         return _loc2_;
      }
      
      private static function findPath(param1:BitmapData, param2:Point, param3:String, param4:int) : Object
      {
         var _loc12_:* = false;
         var _loc13_:* = false;
         var _loc5_:int = 0;
         var _loc6_:Array = [];
         var _loc7_:Point = param2.clone();
         var _loc8_:Point = new Point(0,1);
         var _loc9_:Matrix = new Matrix(0,-1,1,0);
         var _loc10_:Matrix = new Matrix(0,1,-1,0);
         while(true)
         {
            _loc6_.push(_loc7_.clone());
            _loc7_.offset(_loc8_.x,_loc8_.y);
            _loc5_ = _loc5_ + _loc7_.x * -_loc8_.y;
            if(_loc7_.equals(param2))
            {
               break;
            }
            _loc12_ = param1.getPixel32(_loc7_.x + (_loc8_.x - _loc8_.y - 1) / 2,_loc7_.y + (_loc8_.y + _loc8_.x + 1) / 2) == 4278190080;
            _loc13_ = param1.getPixel32(_loc7_.x + (_loc8_.x + _loc8_.y - 1) / 2,_loc7_.y + (_loc8_.y - _loc8_.x + 1) / 2) == 4278190080;
            if(_loc12_ && !_loc13_)
            {
               _loc8_ = _loc10_.transformPoint(_loc8_);
            }
            else if(_loc12_)
            {
               _loc8_ = _loc10_.transformPoint(_loc8_);
            }
            else if(!_loc13_)
            {
               _loc8_ = _loc9_.transformPoint(_loc8_);
            }
         }
         var _loc11_:Object = {};
         _loc11_.priv = _loc6_;
         _loc11_.area = _loc5_;
         _loc11_.sign = param3;
         return _loc11_;
      }
   }
}
