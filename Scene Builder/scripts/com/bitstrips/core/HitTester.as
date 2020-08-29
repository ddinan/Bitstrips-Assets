package com.bitstrips.core
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HitTester
   {
       
      
      public function HitTester()
      {
         super();
      }
      
      public static function realHitTest(param1:DisplayObject, param2:Point) : Boolean
      {
         var _loc3_:Rectangle = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = null;
         var _loc6_:Boolean = false;
         if(param1 is BitmapData)
         {
            return (param1 as BitmapData).hitTest(new Point(0,0),0,param1.globalToLocal(param2));
         }
         if(!param1.hitTestPoint(param2.x,param2.y,true))
         {
            return false;
         }
         _loc3_ = param1.getBounds(param1);
         if(_loc3_.width > 2880 || _loc3_.height > 2880)
         {
            return true;
         }
         _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc5_ = new Matrix();
         _loc5_.translate(-_loc3_.x,-_loc3_.y);
         _loc4_.draw(param1,_loc5_);
         param2 = param1.globalToLocal(param2);
         param2.x = param2.x - _loc3_.x;
         param2.y = param2.y - _loc3_.y;
         _loc6_ = _loc4_.hitTest(new Point(0,0),0,param2);
         _loc4_.dispose();
         return _loc6_;
      }
   }
}
