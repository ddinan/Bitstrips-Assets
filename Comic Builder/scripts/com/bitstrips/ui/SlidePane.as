package com.bitstrips.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SlidePane extends Sprite
   {
       
      
      public var area:Sprite;
      
      public var bkgr:Sprite;
      
      public var container:Sprite;
      
      public var source:Sprite;
      
      public var xMove:Number;
      
      public var speed:Number;
      
      public function SlidePane()
      {
         super();
         trace("--SlidePane()--");
         this.xMove = 0;
         this.speed = 0;
         this.bkgr = new Sprite();
         addChild(this.bkgr);
         this.area = new Sprite();
         addChild(this.area);
         this.container = new Sprite();
         addChild(this.container);
         this.source = new Sprite();
         this.container.addChild(this.source);
         this.container.mask = this.area;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.startTracking);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.stopTracking);
      }
      
      public function startTracking(param1:MouseEvent) : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.track);
         this.addEventListener(Event.ENTER_FRAME,this.relocate);
      }
      
      public function stopTracking(param1:MouseEvent) : void
      {
         this.xMove = 0;
         this.removeEventListener(Event.ENTER_FRAME,this.track);
      }
      
      public function track(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.container.width > this.bkgr.width)
         {
            _loc2_ = 30;
            _loc3_ = this.bkgr.width / 5;
            _loc4_ = 0;
            if(this.bkgr.mouseX < _loc3_)
            {
               _loc4_ = (_loc3_ - this.bkgr.mouseX) / _loc3_;
               this.xMove = _loc2_ * _loc4_;
            }
            else if(this.bkgr.mouseX > this.bkgr.width - _loc3_)
            {
               _loc4_ = (this.bkgr.mouseX - (this.bkgr.width - _loc3_)) / _loc3_;
               this.xMove = 0 - _loc2_ * _loc4_;
            }
         }
      }
      
      public function go_to_x(param1:int) : void
      {
         var _loc2_:Boolean = false;
         if(this.container.width > this.bkgr.width)
         {
            _loc2_ = true;
            if(param1 > 0)
            {
               this.container.x = param1;
            }
            else if(param1 < this.bkgr.width - this.container.width)
            {
               this.container.x = param1 - 5;
            }
            this.container.x = param1;
         }
      }
      
      public function relocate(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         if(this.container.width > this.bkgr.width)
         {
            _loc2_ = 3;
            _loc3_ = 3;
            if(this.xMove > this.speed)
            {
               this.speed = this.speed + _loc2_;
            }
            else if(this.xMove < this.speed)
            {
               this.speed = this.speed - _loc3_;
            }
            _loc4_ = true;
            if(this.container.x + this.speed > 0)
            {
               this.container.x = 0;
               _loc4_ = false;
            }
            else if(this.container.x + this.speed < this.bkgr.width - this.container.width)
            {
               this.container.x = this.bkgr.width - this.container.width - 5;
               _loc4_ = false;
            }
            if(_loc4_)
            {
               this.container.x = this.container.x + this.speed;
            }
         }
      }
      
      public function set_source(param1:Sprite) : void
      {
         this.source = param1;
         this.container.addChild(this.source);
         var _loc2_:Object = this.source.getBounds(this);
         this.source.x = -_loc2_.x + 5;
         this.source.y = 0;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         trace("--SlidePane.setSize()--");
         this.area.graphics.clear();
         this.area.graphics.beginFill(16711935,1);
         this.area.graphics.drawRect(1,1,param1 - 2,param2 - 2);
         this.bkgr.graphics.clear();
         this.bkgr.graphics.lineStyle(2,0);
         this.bkgr.graphics.beginFill(16777215,1);
         this.bkgr.graphics.drawRect(0,0,param1,param2);
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
   }
}
