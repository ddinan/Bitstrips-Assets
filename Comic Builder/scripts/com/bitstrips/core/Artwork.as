package com.bitstrips.core
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class Artwork extends MovieClip
   {
       
      
      public var body_part:String = "";
      
      private var new_frame_func:Function = null;
      
      public var lines:Object;
      
      public var type:String;
      
      public var base_colour:String;
      
      public var depth:Number = 0;
      
      private var last_frame_call:Number = -1;
      
      public function Artwork()
      {
         super();
         this.new_frame_func = null;
         this.depth = 0;
         this.last_frame_call = -1;
         this.stop();
      }
      
      public function set_lines(param1:Object) : void
      {
         this.lines = param1;
      }
      
      public function set_base_colour(param1:String) : void
      {
         this.base_colour = param1.toLowerCase();
         var _loc2_:int = int("0x" + param1);
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = _loc2_;
         _loc3_.redOffset = _loc3_.redOffset + -255;
         _loc3_.greenOffset = _loc3_.greenOffset + -255;
         _loc3_.blueOffset = _loc3_.blueOffset + -255;
         _loc3_.redMultiplier = 1;
         _loc3_.greenMultiplier = 1;
         _loc3_.blueMultiplier = 1;
         transform.colorTransform = _loc3_;
      }
      
      public function set_depth(param1:Number) : void
      {
         this.depth = param1;
      }
      
      public function set_new_frame_func(param1:Function) : void
      {
         this.new_frame_func = param1;
         this.new_frame_func(this);
      }
      
      public function on_new_frame() : void
      {
         if(this.new_frame_func != null)
         {
            this.new_frame_func(this);
         }
      }
      
      public function no_base_colour() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.totalFrames)
         {
            this.addFrameScript(_loc1_,this.on_new_frame);
            _loc1_++;
         }
      }
      
      public function go_to_frame(param1:Number) : Number
      {
         if(this.last_frame_call == param1 && this.currentFrame == param1)
         {
            return param1;
         }
         this.gotoAndStop(param1);
         return param1;
      }
   }
}
