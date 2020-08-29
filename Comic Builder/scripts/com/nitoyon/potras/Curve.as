package com.nitoyon.potras
{
   import flash.geom.Point;
   
   public class Curve
   {
       
      
      public var tag:int;
      
      public var c:Array;
      
      public var vertex:Point;
      
      public var alpha:Number;
      
      public var alpha0:Number;
      
      public var beta:Number;
      
      public function Curve()
      {
         this.c = new Array(3);
         super();
         this.c[0] = new Point();
         this.c[1] = new Point();
         this.c[2] = new Point();
         this.vertex = new Point();
      }
      
      public function toString() : String
      {
         return "alpha0: " + this.alpha0 + "\n" + "alpha:  " + this.alpha + "\n" + "beta:   " + this.beta + "\n" + "corner: " + (this.tag == ProcessPath.POTRACE_CORNER) + "\n" + "bezier: " + this.c[0] + "," + this.c[1] + "," + this.c[2];
      }
   }
}
