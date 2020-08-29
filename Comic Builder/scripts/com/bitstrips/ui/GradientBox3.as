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
      
      private const scale_size:Number = 1.2;
      
      public var colour:Number = 16776960;
      
      private var base_colour:Number;
      
      private var grad_percent:Number = 0;
      
      private var original:Number;
      
      private var virgin:Boolean = true;
      
      private var gradient_stuff:Sprite;
      
      private var selector:Sprite;
      
      private var selector_point:Point;
      
      private var grad_selector:Sprite;
      
      private var grad_selector_point:Point;
      
      private var dragging:Boolean = false;
      
      private var grad_dragging:Boolean = false;
      
      private var grad_box:Sprite;
      
      private var _selected:Boolean = false;
      
      private var box:Sprite;
      
      private var bmap:Bitmap;
      
      private var bmap_c:Sprite;
      
      private var rainbow:Sprite;
      
      private var colours:Class;
      
      public var phase:int = 0;
      
      private var rgb_field:RGBField;
      
      public function GradientBox3(param1:uint = 0)
      {
         var align:uint = param1;
         this.base_colour = this.colour;
         this.gradient_stuff = new Sprite();
         this.selector = new Sprite();
         this.selector_point = new Point(0,0);
         this.grad_selector = new Sprite();
         this.grad_selector_point = new Point(0,0);
         this.grad_box = new Sprite();
         this.bmap_c = new Sprite();
         this.rainbow = new Sprite();
         this.colours = GradientBox3_colours;
         this.rgb_field = new RGBField();
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,function(param1:Event):void
         {
            remove_stage_listeners();
         });
         this.bmap = new this.colours() as Bitmap;
         var tmp:BitmapData = new BitmapData(13,13,false);
         var mat:Matrix = new Matrix();
         mat.scale(0.13,0.5);
         tmp.draw(this.bmap,mat,null,null,null,true);
         this.rainbow.addChild(new Bitmap(tmp));
         this.bmap_c.addChild(this.bmap);
         this.bmap_c.graphics.lineStyle(2);
         this.bmap_c.graphics.drawRect(-1,-1,98,98);
         this.gradient_stuff.addChild(this.bmap_c);
         this.selector.graphics.lineStyle(1);
         this.selector.graphics.drawRect(-2,-2,4,4);
         this.selector.x = 15;
         this.selector.y = 15;
         this.bmap_c.addChild(this.selector);
         this.gradient_stuff.addChild(this.grad_box);
         this.grad_box.x = 100;
         this.grad_box.y = -1;
         this.grad_selector.graphics.lineStyle(1);
         this.grad_selector.graphics.drawRect(-2,-2,24,4);
         this.grad_box.addChild(this.grad_selector);
         this.grad_selector.y = 50;
         this.draw_gradient();
         this.gradient_stuff.visible = false;
         this.gradient_stuff.x = 11;
         this.gradient_stuff.y = -6;
         addChild(this.gradient_stuff);
         buttonMode = true;
         this.rgb_field.y = 100;
         this.gradient_stuff.addChild(this.rgb_field);
         this.box = new Sprite();
         addChild(this.box);
         this.box.addChild(this.rainbow);
         this.rainbow.x = -6.5;
         this.rainbow.y = -6.5;
         this.draw_box();
         this.bmap_c.addEventListener(MouseEvent.MOUSE_DOWN,this.bmap_c_down);
         this.grad_box.addEventListener(MouseEvent.MOUSE_DOWN,this.grad_down);
         this.box.addEventListener(MouseEvent.CLICK,this.box_click);
         this.rgb_field.addEventListener(RGBField.CHANGE_EVENT,this.rgb_change);
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
      
      public function grad_align(param1:uint = 0) : void
      {
         this.gradient_stuff.x = 11;
         this.gradient_stuff.y = -6;
         if(param1 == 1)
         {
            this.gradient_stuff.y = this.gradient_stuff.y - 85;
         }
         else if(param1 == 2)
         {
            this.gradient_stuff.x = -136;
         }
         else if(param1 == 3)
         {
            this.gradient_stuff.x = -136;
            this.gradient_stuff.y = -136;
         }
         else if(param1 == 4)
         {
            this.gradient_stuff.x = -6;
            this.gradient_stuff.y = -6 + this.size + 4;
         }
      }
      
      private function add_stage_listeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouse_move);
      }
      
      private function remove_stage_listeners() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouse_up);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouse_move);
      }
      
      private function draw_gradient() : void
      {
         this.grad_box.graphics.lineStyle(2);
         var _loc1_:String = GradientType.LINEAR;
         var _loc2_:Array = [16777215,this.base_colour,0];
         var _loc3_:Array = [1,1,1];
         var _loc4_:Array = [0,127,255];
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(98,98,Math.PI / 2,0,0);
         this.grad_box.graphics.beginGradientFill(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_);
         this.grad_box.graphics.drawRect(0,0,20,98);
      }
      
      private function box_click(param1:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this._selected = true;
            if(this.rainbow.visible == false)
            {
               dispatchEvent(new Event("SELECTED"));
            }
            this.draw_box();
         }
         else if(!this.virgin && this.gradient_stuff.visible)
         {
            trace("box click");
            dispatchEvent(new Event("COLOUR_OVER"));
         }
         this.gradient_stuff.visible = !this.gradient_stuff.visible;
         if(this.gradient_stuff.visible)
         {
            this.add_stage_listeners();
         }
         else
         {
            this.remove_stage_listeners();
         }
      }
      
      private function grad_down(param1:MouseEvent) : void
      {
         this.grad_dragging = true;
         this.grad_selector.y = Math.max(0,Math.min(98,param1.localY));
         this.mouse_move(param1);
         this.grad_selector.startDrag(true,new Rectangle(0,0,0,98));
      }
      
      private function draw_box(param1:int = 0) : void
      {
         this.box.graphics.clear();
         var _loc2_:Number = 0;
         if(this._selected)
         {
            _loc2_ = 13369344;
         }
         this.box.graphics.lineStyle(1.5,_loc2_);
         if(param1)
         {
            param1 = param1;
         }
         else
         {
            this.box.graphics.beginFill(this.colour);
         }
         this.box.graphics.drawRect(-this.size / 2,-this.size / 2,this.size,this.size);
         this.box.graphics.endFill();
         this.rgb_field.color = this.colour;
      }
      
      public function set_colour(param1:Number, param2:Boolean = false) : void
      {
         if(param1 != -1)
         {
            this.rainbow.visible = false;
            this.colour = param1;
            this.original = this.colour;
            this.draw_box();
            this.draw_gradient();
            if(param2)
            {
               dispatchEvent(new Event("COLOUR_OVER"));
            }
         }
         else
         {
            this.rainbow.visible = true;
         }
      }
      
      private function update_selector() : Boolean
      {
         if(this.selector.x != this.selector_point.x || this.selector.y != this.selector_point.y)
         {
            this.selector_point.x = this.selector.x;
            this.selector_point.y = this.selector.y;
            this.base_colour = this.bmap.bitmapData.getPixel(this.selector_point.x,this.selector_point.y);
            this.adjust_colour();
            this.draw_gradient();
            this.draw_box();
            return true;
         }
         return false;
      }
      
      private function adjust_colour() : void
      {
         this.colour = adjustBrightness(this.base_colour,255 * this.grad_percent * -1);
         this.rainbow.visible = false;
      }
      
      private function mouse_move(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this.gradient_stuff.visible == false)
         {
            return;
         }
         this.phase = 1;
         if(this.dragging)
         {
            if(this.update_selector())
            {
               this.virgin = false;
            }
            dispatchEvent(new Event("COLOUR_OVER"));
         }
         else if(this.grad_dragging)
         {
            _loc2_ = (this.grad_selector.y - 49) / 49;
            if(_loc2_ != this.grad_percent)
            {
               this.grad_percent = _loc2_;
               this.adjust_colour();
               this.draw_box();
               dispatchEvent(new Event("COLOUR_OVER"));
            }
         }
      }
      
      private function bmap_c_down(param1:MouseEvent) : void
      {
         this.dragging = true;
         this.selector.startDrag(true,new Rectangle(0,0,95,95));
         if(this.update_selector())
         {
            dispatchEvent(new Event("COLOUR_OVER"));
         }
      }
      
      private function mouse_up(param1:MouseEvent) : void
      {
         if(this.gradient_stuff.visible == false)
         {
            return;
         }
         if(this.dragging)
         {
            this.selector.stopDrag();
            this.dragging = false;
         }
         else if(this.grad_dragging)
         {
            this.grad_selector.stopDrag();
            this.grad_dragging = false;
         }
         else
         {
            if(this.hitTestPoint(param1.stageX,param1.stageY,false) == false)
            {
               this.gradient_stuff.visible = false;
            }
            return;
         }
         this._selected = true;
         this.update_selector();
         this.original = this.colour;
         this.phase = 2;
         dispatchEvent(new Event("SELECTED"));
         this.box.visible = true;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         this.gradient_stuff.visible = param1;
         this.draw_box();
      }
      
      public function rgb_change(param1:Event) : void
      {
         this.set_colour(this.rgb_field.color,true);
         this.gradient_stuff.visible = false;
      }
   }
}
