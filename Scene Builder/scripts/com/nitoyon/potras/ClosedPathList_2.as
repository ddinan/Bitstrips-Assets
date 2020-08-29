package com.nitoyon.potras
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   
   public class ClosedPathList
   {
       
      
      public var $a:Array;
      
      public function ClosedPathList()
      {
         super();
         $a = [];
      }
      
      public static function trace(param1:BitmapData) : ClosedPathList
      {
         var _loc2_:Array = PathList.create(param1);
         return ProcessPath.processPath(_loc2_);
      }
      
      public function draw(param1:Graphics) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in $a)
         {
            if(_loc2_ is ClosedPath)
            {
               _loc2_.draw(param1);
            }
         }
      }
   }
}
