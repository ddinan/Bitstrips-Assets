package com.nitoyon.potras
{
   import flash.geom.Point;
   
   public class Curve
   {
       
      
      public var c:Array;
      
      public var vertex:Point;
      
      public var beta:Number;
      
      public var alpha0:Number;
      
      public var tag:int;
      
      public var alpha:Number;
      
      public function Curve()
      {
         c = new Array(3);
         super();
         c[0] = new Point();
         c[1] = new Point();
         c[2] = new Point();
         vertex = new Point();
      }
      
      public function toString() : String
      {
         return "alpha0: " + alpha0 + "\n" + "alpha:  " + alpha + "\n" + "beta:   " + beta + "\n" + "corner: " + (tag == ProcessPath.POTRACE_CORNER) + "\n" + "bezier: " + c[0] + "," + c[1] + "," + c[2];
      }
   }
}
