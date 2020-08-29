package com.bitstrips.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class ColourBox extends Sprite
   {
      
      private static const scale_size:Number = 1.2;
       
      
      private var size:Number = 13;
      
      public var colour:Number = 16711680;
      
      private var selected:Boolean = false;
      
      public function ColourBox(param1:Number = -1)
      {
         super();
         buttonMode = true;
         if(param1 >= 0)
         {
            colour = param1;
         }
         draw_box();
         addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
         addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
         addEventListener(MouseEvent.MOUSE_DOWN,mouse_down);
         addEventListener(MouseEvent.MOUSE_UP,mouse_up);
      }
      
      public function select() : void
      {
         selected = true;
         draw_box();
      }
      
      public function set_colour(param1:Number, param2:Boolean = false) : void
      {
         colour = param1;
         draw_box();
         if(param2)
         {
            dispatchEvent(new Event("COLOUR_OVER"));
         }
      }
      
      private function mouse_over(param1:MouseEvent) : void
      {
         this.filters = [new GlowFilter(colour)];
         scaleX = scaleY = scale_size;
         dispatchEvent(new Event("COLOUR_OVER"));
      }
      
      private function draw_box() : void
      {
         graphics.clear();
         var _loc1_:Number = 0;
         if(selected)
         {
            trace("I\'m selected - " + name);
            _loc1_ = 13369344;
         }
         graphics.lineStyle(1.5,_loc1_);
         graphics.beginFill(colour);
         graphics.drawRect(-size / 2,-size / 2,size,size);
         graphics.endFill();
      }
      
      private function mouse_out(param1:MouseEvent) : void
      {
         this.filters = [];
         this.transform.colorTransform = new ColorTransform();
         scaleX = scaleY = 1;
         dispatchEvent(new Event("COLOUR_OUT"));
      }
      
      private function mouse_up(param1:MouseEvent) : void
      {
         trace("Selected: " + name);
         this.transform.colorTransform = new ColorTransform();
         scaleX = scaleY = scale_size;
         selected = true;
         draw_box();
         dispatchEvent(new Event("SELECTED"));
      }
      
      private function mouse_down(param1:MouseEvent) : void
      {
         this.transform.colorTransform = new ColorTransform(1,1,1,1,100,100,100);
      }
      
      public function deselect() : void
      {
         selected = false;
         draw_box();
      }
   }
}
