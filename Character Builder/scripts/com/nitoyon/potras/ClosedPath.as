package com.nitoyon.potras
{
   import flash.display.Graphics;
   import flash.geom.Point;
   
   public class ClosedPath
   {
       
      
      public var $a:Array;
      
      public function ClosedPath(param1:Array = null)
      {
         super();
         $a = param1 || [];
      }
      
      private function getBezierPoint(param1:Point, param2:Point, param3:Point, param4:Point, param5:Number) : Point
      {
         return new Point(Math.pow(1 - param5,3) * param1.x + 3 * param5 * Math.pow(1 - param5,2) * param2.x + 3 * param5 * param5 * (1 - param5) * param3.x + param5 * param5 * param5 * param4.x,Math.pow(1 - param5,3) * param1.y + 3 * param5 * Math.pow(1 - param5,2) * param2.y + 3 * param5 * param5 * (1 - param5) * param3.y + param5 * param5 * param5 * param4.y);
      }
      
      public function draw(param1:Graphics) : void
      {
         var _loc4_:Curve = null;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc2_:Point = $a[$a.length - 1].c[2];
         param1.moveTo(_loc2_.x,_loc2_.y);
         var _loc3_:int = 0;
         while(_loc3_ < $a.length)
         {
            _loc4_ = $a[_loc3_];
            if(_loc4_.tag == ProcessPath.POTRACE_CORNER)
            {
               param1.lineTo(_loc4_.c[1].x,_loc4_.c[1].y);
               param1.lineTo(_loc4_.c[2].x,_loc4_.c[2].y);
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < 1)
               {
                  _loc6_ = getBezierPoint(_loc2_,_loc4_.c[0],_loc4_.c[1],_loc4_.c[2],_loc5_);
                  param1.lineTo(_loc6_.x,_loc6_.y);
                  _loc5_ = _loc5_ + 0.02;
               }
               param1.lineTo(_loc4_.c[2].x,_loc4_.c[2].y);
            }
            _loc2_ = _loc4_.c[2];
            _loc3_++;
         }
      }
   }
}
