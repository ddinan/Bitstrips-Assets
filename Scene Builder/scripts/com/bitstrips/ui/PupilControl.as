package com.bitstrips.ui
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PupilControl extends Sprite
   {
       
      
      private var pmask:Shape;
      
      private var pupil:Sprite;
      
      private var radius:int;
      
      public var pupil_width:Number;
      
      public var selected:Boolean = false;
      
      private var pwidth:int;
      
      public function PupilControl(param1:uint = 80)
      {
         super();
         pwidth = param1;
         radius = pwidth / 2;
         pupil_width = 0.25;
         graphics.lineStyle(2,0,1,false);
         graphics.drawCircle(0,0,radius);
         pupil = new Sprite();
         pupil.buttonMode = true;
         pupil.graphics.lineStyle(3,0,1,false);
         pupil.graphics.beginFill(0);
         pupil.graphics.drawCircle(0,0,5);
         pupil.addEventListener(MouseEvent.MOUSE_DOWN,pupil_down);
         pupil.addEventListener(MouseEvent.MOUSE_UP,pupil_up);
         pmask = new Shape();
         pmask.graphics.beginFill(0);
         pmask.graphics.drawCircle(0,0,radius);
         addChild(pmask);
         pupil.mask = pmask;
         addChild(pupil);
         set_pupil_width(pupil_width);
      }
      
      private function pupil_down(param1:MouseEvent) : void
      {
         pupil.startDrag(false,new Rectangle(-radius,-radius,pwidth,pwidth));
         stage.addEventListener(MouseEvent.MOUSE_MOVE,pupil_move);
         stage.addEventListener(MouseEvent.MOUSE_UP,pupil_up);
      }
      
      public function get_pupil() : Object
      {
         return {
            "x":pupil.x / pwidth,
            "y":pupil.y / pwidth,
            "width":pupil_width
         };
      }
      
      private function pupil_move(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("PUPIL_UPDATE"));
      }
      
      public function set_pupil(param1:Object) : void
      {
         pupil.x = param1.x * pwidth;
         pupil.y = param1.y * pwidth;
         set_pupil_width(param1.width);
      }
      
      private function pupil_up(param1:MouseEvent) : void
      {
         pupil.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,pupil_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,pupil_up);
         dispatchEvent(new Event("PUPIL_UPDATE"));
      }
      
      public function set_pupil_width(param1:Number) : void
      {
         pupil_width = Math.min(1,Math.max(0.1,param1));
         pupil.width = pwidth * pupil_width;
         pupil.height = pwidth * pupil_width;
      }
   }
}
