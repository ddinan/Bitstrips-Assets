package com.bitstrips.core
{
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ArtworkLines extends Sprite
   {
       
      
      private var _no_lines:Boolean = false;
      
      private var _flipped:int = 1;
      
      private var _scale_x:Number = 1;
      
      private var _scale_y:Number = 1;
      
      private var art_lines:Shape;
      
      private var _artwork:Object;
      
      private var my_frame:uint = 1;
      
      public function ArtworkLines()
      {
         super();
         art_lines = new Shape();
         addChild(art_lines);
      }
      
      private function draw_lines() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         if(_artwork == null || _artwork.lines == null || _no_lines)
         {
            art_lines.graphics.clear();
            return;
         }
         art_lines.graphics.clear();
         for(_loc1_ in _artwork.lines)
         {
            art_lines.graphics.lineStyle(Number(_loc1_));
            for each(_loc2_ in _artwork.lines[_loc1_][my_frame - 1])
            {
               art_lines.graphics.moveTo(_loc2_[0] * _scale_x * _flipped,_loc2_[1] * _scale_y);
               art_lines.graphics.curveTo(_loc2_[2] * _scale_x * _flipped,_loc2_[3] * _scale_y,_loc2_[4] * _scale_x * _flipped,_loc2_[5] * _scale_y);
            }
         }
      }
      
      private function update_scales() : void
      {
         if(_artwork)
         {
            _artwork.scaleX = _scale_x * _flipped;
            _artwork.scaleY = _scale_y;
         }
         draw_lines();
      }
      
      public function set scale_y(param1:Number) : void
      {
         _scale_y = param1;
         update_scales();
      }
      
      public function get scale_x() : Number
      {
         return _scale_x;
      }
      
      public function get scale_y() : Number
      {
         return _scale_y;
      }
      
      public function set art(param1:Object) : void
      {
         if(_artwork)
         {
            removeChild(DisplayObject(_artwork));
         }
         _artwork = param1;
         addChild(DisplayObject(param1));
         setChildIndex(art_lines,1);
         update_scales();
      }
      
      public function set scale_x(param1:Number) : void
      {
         _scale_x = param1;
         update_scales();
      }
   }
}
