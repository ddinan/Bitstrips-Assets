package com.bitstrips.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GradientBox3 extends Sprite
   {
       
      
      private var size:Number = 13;
      
      private var base_colour:Number;
      
      private var grad_dragging:Boolean = false;
      
      private var gradient_stuff:Sprite;
      
      private var colours:Class;
      
      private var bmap_c:Sprite;
      
      private var selector_point:Point;
      
      private var rainbow:Sprite;
      
      private var grad_selector:Sprite;
      
      private var bmap:Bitmap;
      
      private var grad_selector_point:Point;
      
      private var box:Sprite;
      
      public var colour:Number = 16776960;
      
      private var virgin:Boolean = true;
      
      private var dragging:Boolean = false;
      
      private var original:Number;
      
      private var grad_percent:Number = 0;
      
      private const scale_size:Number = 1.2;
      
      private var grad_box:Sprite;
      
      private var selector:Sprite;
      
      private var _selected:Boolean = false;
      
      public var phase:int = 0;
      
      public function GradientBox3(param1:uint = 0)
      {
         var align:uint = param1;
         base_colour = colour;
         gradient_stuff = new Sprite();
         selector = new Sprite();
         selector_point = new Point(0,0);
         grad_selector = new Sprite();
         grad_selector_point = new Point(0,0);
         grad_box = new Sprite();
         bmap_c = new Sprite();
         rainbow = new Sprite();
         colours = GradientBox3_colours;
         super();
         addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            add_stage_listeners();
         });
         addEventListener(Event.REMOVED_FROM_STAGE,function(param1:Event):void
         {
            remove_stage_listeners();
         });
         bmap = new colours() as Bitmap;
         var tmp:BitmapData = new BitmapData(13,13,false);
         var mat:Matrix = new Matrix();
         mat.scale(0.13,0.5);
         tmp.draw(bmap,mat,null,null,null,true);
         rainbow.addChild(new Bitmap(tmp));
         bmap_c.addChild(bmap);
         bmap_c.graphics.lineStyle(2);
         bmap_c.graphics.drawRect(-1,-1,98,98);
         gradient_stuff.addChild(bmap_c);
         selector.graphics.lineStyle(1);
         selector.graphics.drawRect(-2,-2,4,4);
         selector.x = 15;
         selector.y = 15;
         bmap_c.addChild(selector);
         gradient_stuff.addChild(grad_box);
         grad_box.x = 100;
         grad_box.y = -1;
         grad_selector.graphics.lineStyle(1);
         grad_selector.graphics.drawRect(-2,-2,24,4);
         grad_box.addChild(grad_selector);
         grad_selector.y = 50;
         draw_gradient();
         gradient_stuff.visible = false;
         gradient_stuff.x = 11;
         gradient_stuff.y = -6;
         addChild(gradient_stuff);
         buttonMode = true;
         box = new Sprite();
         addChild(box);
         box.addChild(rainbow);
         rainbow.x = -6.5;
         rainbow.y = -6.5;
         draw_box();
         bmap_c.addEventListener(MouseEvent.MOUSE_DOWN,bmap_c_down);
         grad_box.addEventListener(MouseEvent.MOUSE_DOWN,grad_down);
         box.addEventListener(MouseEvent.CLICK,box_click);
         if(align != 0)
         {
            this.grad_align(align);
         }
      }
      
      public static function adjustBrightness(param1:uint, param2:Number) : uint
      {
         var _loc3_:Number = Math.max(Math.min((param1 >> 16 & 255) + param2,255),0);
         var _loc4_:Number = Math.max(Math.min((param1 >> 8 & 255) + param2,255),0);
         var _loc5_:Number = Math.max(Math.min((param1 & 255) + param2,255),0);
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
      
      private function remove_stage_listeners() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,mouse_up);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouse_move);
      }
      
      private function box_click(param1:MouseEvent) : void
      {
         if(_selected == false)
         {
            _selected = true;
            if(rainbow.visible == false)
            {
               dispatchEvent(new Event("SELECTED"));
            }
            draw_box();
         }
         else if(!virgin && gradient_stuff.visible)
         {
            trace("box click");
            dispatchEvent(new Event("COLOUR_OVER"));
         }
         gradient_stuff.visible = !gradient_stuff.visible;
         if(gradient_stuff.visible)
         {
            add_stage_listeners();
         }
         else
         {
            remove_stage_listeners();
         }
      }
      
      private function update_selector() : Boolean
      {
         if(selector.x != selector_point.x || selector.y != selector_point.y)
         {
            selector_point.x = selector.x;
            selector_point.y = selector.y;
            base_colour = bmap.bitmapData.getPixel(selector_point.x,selector_point.y);
            adjust_colour();
            draw_gradient();
            draw_box();
            return true;
         }
         return false;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      private function bmap_c_down(param1:MouseEvent) : void
      {
         dragging = true;
         selector.startDrag(true,new Rectangle(0,0,95,95));
         if(update_selector())
         {
            dispatchEvent(new Event("COLOUR_OVER"));
         }
      }
      
      private function mouse_move(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(gradient_stuff.visible == false)
         {
            return;
         }
         phase = 1;
         if(dragging)
         {
            if(update_selector())
            {
               virgin = false;
            }
            dispatchEvent(new Event("COLOUR_OVER"));
         }
         else if(grad_dragging)
         {
            _loc2_ = (grad_selector.y - 49) / 49;
            if(_loc2_ != grad_percent)
            {
               grad_percent = _loc2_;
               adjust_colour();
               draw_box();
               dispatchEvent(new Event("COLOUR_OVER"));
            }
         }
      }
      
      private function add_stage_listeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,mouse_up);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,mouse_move);
      }
      
      public function set selected(param1:Boolean) : void
      {
         _selected = param1;
         gradient_stuff.visible = param1;
         draw_box();
      }
      
      public function set_colour(param1:Number, param2:Boolean = false) : void
      {
         if(param1 != -1)
         {
            rainbow.visible = false;
            colour = param1;
            original = colour;
            draw_box();
            draw_gradient();
            if(param2)
            {
               dispatchEvent(new Event("COLOUR_OVER"));
            }
         }
         else
         {
            rainbow.visible = true;
         }
      }
      
      private function draw_box(param1:int = 0) : void
      {
         box.graphics.clear();
         var _loc2_:Number = 0;
         if(_selected)
         {
            _loc2_ = 13369344;
         }
         box.graphics.lineStyle(1.5,_loc2_);
         if(param1)
         {
            param1 = param1;
         }
         else
         {
            box.graphics.beginFill(colour);
         }
         box.graphics.drawRect(-size / 2,-size / 2,size,size);
         box.graphics.endFill();
      }
      
      private function draw_gradient() : void
      {
         grad_box.graphics.lineStyle(2);
         var _loc1_:String = GradientType.LINEAR;
         var _loc2_:Array = [16777215,base_colour,0];
         var _loc3_:Array = [1,1,1];
         var _loc4_:Array = [0,127,255];
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(98,98,Math.PI / 2,0,0);
         grad_box.graphics.beginGradientFill(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_);
         grad_box.graphics.drawRect(0,0,20,98);
      }
      
      public function grad_align(param1:uint = 0) : void
      {
         gradient_stuff.x = 11;
         gradient_stuff.y = -6;
         if(param1 == 1)
         {
            gradient_stuff.y = gradient_stuff.y - 85;
         }
         else if(param1 == 2)
         {
            gradient_stuff.x = -6 - gradient_stuff.width;
         }
         else if(param1 == 3)
         {
            gradient_stuff.x = -6 - gradient_stuff.width;
            gradient_stuff.y = -6 - gradient_stuff.height;
         }
         else if(param1 == 4)
         {
            gradient_stuff.x = -6;
            gradient_stuff.y = -6 + size + 4;
         }
      }
      
      private function grad_down(param1:MouseEvent) : void
      {
         grad_dragging = true;
         grad_selector.y = Math.max(0,Math.min(98,param1.localY));
         mouse_move(param1);
         grad_selector.startDrag(true,new Rectangle(0,0,0,98));
      }
      
      private function mouse_up(param1:MouseEvent) : void
      {
         if(gradient_stuff.visible == false)
         {
            return;
         }
         if(dragging)
         {
            selector.stopDrag();
            dragging = false;
         }
         else if(grad_dragging)
         {
            grad_selector.stopDrag();
            grad_dragging = false;
         }
         else
         {
            if(this.hitTestPoint(param1.stageX,param1.stageY,false) == false)
            {
               gradient_stuff.visible = false;
            }
            return;
         }
         _selected = true;
         update_selector();
         original = colour;
         phase = 2;
         dispatchEvent(new Event("SELECTED"));
         box.visible = true;
      }
      
      private function adjust_colour() : void
      {
         colour = adjustBrightness(base_colour,255 * grad_percent * -1);
         rainbow.visible = false;
      }
   }
}
