package com.bitstrips.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SlidePane extends Sprite
   {
       
      
      public var container:Sprite;
      
      public var speed:Number;
      
      public var xMove:Number;
      
      public var area:Sprite;
      
      public var bkgr:Sprite;
      
      public var source:Sprite;
      
      public function SlidePane()
      {
         super();
         trace("--SlidePane()--");
         xMove = 0;
         speed = 0;
         bkgr = new Sprite();
         addChild(bkgr);
         area = new Sprite();
         addChild(area);
         container = new Sprite();
         addChild(container);
         source = new Sprite();
         container.addChild(source);
         container.mask = area;
         this.addEventListener(MouseEvent.MOUSE_OVER,startTracking);
         this.addEventListener(MouseEvent.MOUSE_OUT,stopTracking);
      }
      
      public function stopTracking(param1:MouseEvent) : void
      {
         xMove = 0;
         this.removeEventListener(Event.ENTER_FRAME,track);
      }
      
      public function go_to_x(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(container.width > bkgr.width)
         {
            _loc2_ = true;
            if(param1 > 0)
            {
               container.x = param1;
            }
            else if(param1 < bkgr.width - container.width)
            {
               container.x = param1 - 5;
            }
            container.x = param1;
         }
      }
      
      public function relocate(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         if(container.width > bkgr.width)
         {
            _loc2_ = 3;
            _loc3_ = 3;
            if(xMove > speed)
            {
               speed = speed + _loc2_;
            }
            else if(xMove < speed)
            {
               speed = speed - _loc3_;
            }
            _loc4_ = true;
            if(container.x + speed > 0)
            {
               container.x = 0;
               _loc4_ = false;
            }
            else if(container.x + speed < bkgr.width - container.width)
            {
               container.x = bkgr.width - container.width - 5;
               _loc4_ = false;
            }
            if(_loc4_)
            {
               container.x = container.x + speed;
            }
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         trace("--SlidePane.setSize()--");
         area.graphics.clear();
         area.graphics.beginFill(16711935,1);
         area.graphics.drawRect(1,1,param1 - 2,param2 - 2);
         bkgr.graphics.clear();
         bkgr.graphics.lineStyle(2,0);
         bkgr.graphics.beginFill(16777215,1);
         bkgr.graphics.drawRect(0,0,param1,param2);
      }
      
      public function track(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(container.width > bkgr.width)
         {
            _loc2_ = 30;
            _loc3_ = bkgr.width / 5;
            _loc4_ = 0;
            if(bkgr.mouseX < _loc3_)
            {
               _loc4_ = (_loc3_ - bkgr.mouseX) / _loc3_;
               xMove = _loc2_ * _loc4_;
            }
            else if(bkgr.mouseX > bkgr.width - _loc3_)
            {
               _loc4_ = (bkgr.mouseX - (bkgr.width - _loc3_)) / _loc3_;
               xMove = 0 - _loc2_ * _loc4_;
            }
         }
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function set_source(param1:Sprite) : void
      {
         source = param1;
         container.addChild(source);
         var _loc2_:Object = source.getBounds(this);
         source.x = -_loc2_.x + 5;
         source.y = 0;
      }
      
      public function startTracking(param1:MouseEvent) : void
      {
         this.addEventListener(Event.ENTER_FRAME,track);
         this.addEventListener(Event.ENTER_FRAME,relocate);
      }
   }
}
