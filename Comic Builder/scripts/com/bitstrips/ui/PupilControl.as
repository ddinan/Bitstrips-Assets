package com.bitstrips.ui
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class PupilControl extends Sprite
   {
       
      
      private var pupil:Sprite;
      
      private var pmask:Shape;
      
      public var pupil_width:Number;
      
      public var selected:Boolean = false;
      
      private var pwidth:int;
      
      private var radius:int;
      
      public function PupilControl(param1:uint = 80)
      {
         super();
         this.pwidth = param1;
         this.radius = this.pwidth / 2;
         this.pupil_width = 0.25;
         graphics.lineStyle(2,0,1,false);
         graphics.drawCircle(0,0,this.radius);
         this.pupil = new Sprite();
         this.pupil.buttonMode = true;
         this.pupil.graphics.lineStyle(3,0,1,false);
         this.pupil.graphics.beginFill(0);
         this.pupil.graphics.drawCircle(0,0,5);
         this.pupil.addEventListener(MouseEvent.MOUSE_DOWN,this.pupil_down);
         this.pupil.addEventListener(MouseEvent.MOUSE_UP,this.pupil_up);
         this.pmask = new Shape();
         this.pmask.graphics.beginFill(0);
         this.pmask.graphics.drawCircle(0,0,this.radius);
         addChild(this.pmask);
         this.pupil.mask = this.pmask;
         addChild(this.pupil);
         this.set_pupil_width(this.pupil_width);
      }
      
      private function pupil_down(param1:MouseEvent) : void
      {
         this.pupil.startDrag(false,new Rectangle(-this.radius,-this.radius,this.pwidth,this.pwidth));
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.pupil_move);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.pupil_up);
      }
      
      private function pupil_up(param1:MouseEvent) : void
      {
         this.pupil.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.pupil_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.pupil_up);
         dispatchEvent(new Event("PUPIL_UPDATE"));
      }
      
      private function pupil_move(param1:MouseEvent) : void
      {
         dispatchEvent(new Event("PUPIL_UPDATE"));
      }
      
      public function set_pupil_width(param1:Number) : void
      {
         this.pupil_width = Math.min(1,Math.max(0.1,param1));
         this.pupil.width = this.pwidth * this.pupil_width;
         this.pupil.height = this.pwidth * this.pupil_width;
      }
      
      public function set_pupil(param1:Object) : void
      {
         this.pupil.x = param1.x * this.pwidth;
         this.pupil.y = param1.y * this.pwidth;
         this.set_pupil_width(param1.width);
      }
      
      public function get_pupil() : Object
      {
         return {
            "x":this.pupil.x / this.pwidth,
            "y":this.pupil.y / this.pwidth,
            "width":this.pupil_width
         };
      }
   }
}
