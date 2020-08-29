package com.nitoyon.potras
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class PotrAs
   {
       
      
      public function PotrAs()
      {
         super();
      }
      
      public static function traceLetter(param1:String, param2:int) : ClosedPathList
      {
         var _loc3_:TextFormat = new TextFormat();
         _loc3_.size = param2;
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = _loc3_;
         _loc4_.autoSize = "left";
         _loc4_.text = param1;
         var _loc5_:BitmapData = new BitmapData(param2 * param1.length,param2 * 1.2,true);
         var _loc6_:BitmapData = _loc5_.clone();
         _loc5_.draw(_loc4_);
         _loc6_.threshold(_loc5_,_loc5_.rect,new Point(),"<",4292730333,4278190080);
         var _loc7_:Array = PathList.create(_loc6_);
         var _loc8_:ClosedPathList = ProcessPath.processPath(_loc7_);
         _loc5_.dispose();
         _loc6_.dispose();
         return _loc8_;
      }
      
      public static function traceBitmap(param1:BitmapData) : ClosedPathList
      {
         var _loc2_:Array = PathList.create(param1);
         return ProcessPath.processPath(_loc2_);
      }
   }
}
