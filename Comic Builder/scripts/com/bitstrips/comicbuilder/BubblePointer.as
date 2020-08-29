package com.bitstrips.comicbuilder
{
   import com.bitstrips.ui.DashedLine;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BubblePointer extends Sprite
   {
       
      
      private var pointerData:Object;
      
      private var myBubble:TextBubble;
      
      private var pointer:Sprite;
      
      private var control:Sprite;
      
      private var curveMax:Number = 50;
      
      private var bkgr:Sprite;
      
      private var outline:Sprite;
      
      private var debug:Boolean = false;
      
      public function BubblePointer()
      {
         super();
         if(this.debug)
         {
            trace("--BubblePointer()--");
         }
         this.pointer = new Sprite();
         this.control = new Sprite();
         this.pointerData = {
            "bkgrColor":16777215,
            "controlX":0,
            "controlY":40,
            "centerX":0,
            "centerY":0,
            "curve":0,
            "rotation":0,
            "style":"normal"
         };
         this.bkgr = new Sprite();
         this.outline = new Sprite();
         this.buttonMode = true;
         this.initialDraw();
      }
      
      private function control_over(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         if(param1.buttonDown == false)
         {
            param1.stopPropagation();
         }
      }
      
      public function setBubble(param1:TextBubble) : void
      {
         this.myBubble = param1;
      }
      
      public function getData() : Object
      {
         return this.pointerData;
      }
      
      public function doSelect(param1:Boolean) : void
      {
         this.control.visible = param1;
      }
      
      public function initialDraw() : void
      {
         addChild(this.pointer);
         this.pointer.addChild(this.bkgr);
         this.pointer.addChild(this.outline);
         this.pointer.rotation = this.pointerData.rotation;
         this.control = new crossmark();
         this.control.buttonMode = true;
         this.pointer.addChild(this.control);
         this.control.x = this.pointerData.controlX;
         this.control.y = this.pointerData.controlY;
         this.control.addEventListener(MouseEvent.MOUSE_DOWN,this.dragControlStart,false,100,true);
         this.control.addEventListener(MouseEvent.MOUSE_OVER,this.control_over,false,0,true);
         this.doSelect(false);
      }
      
      public function dragControlStart(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--BubblePointer.dragControlStart()--");
         }
         if(this.myBubble)
         {
            if(!this.myBubble.getLock())
            {
               param1.stopPropagation();
               stage.addEventListener(MouseEvent.MOUSE_UP,this.dragControlStop);
               stage.addEventListener(MouseEvent.MOUSE_MOVE,this.dragControlMove);
            }
         }
      }
      
      public function dragControlMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         _loc2_ = this.globalToLocal(_loc2_);
         this.pointerData.controlX = _loc2_.x;
         this.pointerData.controlY = _loc2_.y;
         this.drawMe();
      }
      
      public function dragControlStop(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(this.debug)
         {
            trace("--BubblePointer.dragControlStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.dragControlStop);
         if(this.myBubble)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragControlMove);
         }
         for(_loc2_ in this.pointerData)
         {
            if(this.debug)
            {
               trace(_loc2_ + ": " + this.pointerData[_loc2_]);
            }
         }
         if(this.debug)
         {
            trace("-------------");
         }
      }
      
      public function drawMe() : void
      {
         var _loc10_:DashedLine = null;
         var _loc1_:Number = Math.min(this.myBubble.bubble_width,this.myBubble.bubble_height) / 4;
         _loc1_ = Math.max(_loc1_,20);
         if(this.debug)
         {
            trace("--BubblePointer.drawMe()-<");
         }
         if(this.debug)
         {
            trace("IN pointerData.curve: " + this.pointerData.curve);
         }
         var _loc2_:Point = new Point(this.pointerData.centerX,this.pointerData.centerY);
         var _loc3_:Point = new Point(this.pointerData.controlX,this.pointerData.controlY);
         var _loc4_:Number = _loc2_.x - _loc3_.x;
         var _loc5_:Number = _loc2_.y - _loc3_.y;
         var _loc6_:Number = Math.sqrt(Math.pow(_loc4_,2) + Math.pow(_loc5_,2));
         var _loc7_:Number = Math.atan2(_loc3_.y - _loc2_.y,_loc3_.x - _loc2_.x);
         var _loc8_:Number = _loc7_ * (180 / Math.PI) - 90;
         if(this.debug)
         {
            trace("deg: " + _loc8_);
         }
         this.pointerData.centerX = 0;
         this.pointerData.centerY = 0;
         var _loc9_:Number = _loc8_ - this.pointerData.rotation;
         if(_loc9_ < -180)
         {
            _loc9_ = _loc9_ + 360;
         }
         else if(_loc9_ > 180)
         {
            _loc9_ = _loc9_ - 360;
         }
         if(this.debug)
         {
            trace("degDiff: " + _loc9_);
         }
         this.pointerData.curve = this.pointerData.curve + _loc9_;
         this.pointerData.curve = Math.min(this.curveMax,this.pointerData.curve);
         this.pointerData.curve = Math.max(0 - this.curveMax,this.pointerData.curve);
         if(this.debug)
         {
            trace("OUT pointerData.curve: " + this.pointerData.curve);
         }
         this.pointer.rotation = _loc8_;
         this.pointerData.rotation = _loc8_;
         this.control.x = 0;
         this.control.y = _loc6_;
         this.pointerData.centerX = 0;
         this.pointerData.centerY = 0;
         this.pointer.graphics.clear();
         this.bkgr.graphics.clear();
         this.outline.graphics.clear();
         switch(this.pointerData["style"])
         {
            case "whisper":
               this.pointer.graphics.clear();
               this.bkgr.graphics.clear();
               this.bkgr.graphics.beginFill(this.pointerData.bkgrColor,1);
               this.bkgr.graphics.moveTo(0 - _loc1_ / 2,0);
               this.bkgr.graphics.curveTo(this.pointerData.curve,_loc6_ / 2,0,_loc6_);
               this.bkgr.graphics.curveTo(_loc1_ / 2 + this.pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               this.bkgr.graphics.endFill();
               _loc10_ = new DashedLine(this.outline,6,6);
               this.outline.graphics.clear();
               _loc10_.clear();
               _loc10_.lineStyle(2,0,1);
               _loc10_.beginFill(this.pointerData.bkgrColor,1);
               _loc10_.moveTo(0 - _loc1_ / 2,0);
               _loc10_.curveTo(this.pointerData.curve,_loc6_ / 2,0,_loc6_);
               _loc10_.curveTo(_loc1_ / 2 + this.pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               _loc10_.endFill();
               break;
            case "thought":
               this.pointer.graphics.clear();
               this.pointer.graphics.lineStyle(2,0,1);
               this.pointer.graphics.beginFill(this.pointerData.bkgrColor,1);
               this.pointer.graphics.drawCircle(0,_loc6_ - 2,3);
               this.pointer.graphics.drawCircle(0,_loc6_ * (7 / 10),5);
               this.pointer.graphics.drawCircle(0,_loc6_ * (4 / 10),7);
               break;
            case "shout":
               this.pointer.graphics.clear();
               this.pointer.graphics.lineStyle(2,0,1);
               this.pointer.graphics.beginFill(this.pointerData.bkgrColor,1);
               this.pointer.graphics.moveTo(0 - _loc1_ / 2,0);
               this.pointer.graphics.lineTo(0,_loc6_);
               this.pointer.graphics.lineTo(_loc1_ / 2,0);
               this.pointer.graphics.endFill();
               break;
            default:
               this.pointer.graphics.clear();
               this.pointer.graphics.lineStyle(2,0,1);
               this.pointer.graphics.beginFill(this.pointerData.bkgrColor,1);
               this.pointer.graphics.moveTo(0 - _loc1_ / 2,0);
               this.pointer.graphics.curveTo(this.pointerData.curve,_loc6_ / 2,0,_loc6_);
               this.pointer.graphics.curveTo(_loc1_ / 2 + this.pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               this.pointer.graphics.endFill();
         }
         if(this.debug)
         {
            trace(">-BubblePointer.drawMe()--");
         }
      }
      
      public function setColour(param1:Number) : void
      {
         this.pointerData.bkgrColor = param1;
         this.drawMe();
      }
      
      public function save_state() : Object
      {
         return this.pointerData;
      }
      
      public function load_state(param1:Object) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            if(this.pointerData.hasOwnProperty(_loc2_) == false)
            {
               trace("Warning: undefined property: " + _loc2_);
            }
            else
            {
               this.pointerData[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function bump(param1:Object) : void
      {
         if(this.debug)
         {
            trace(">-BubblePointer.bump(x: " + param1.x + " y: " + param1.y + ")--");
         }
         this.pointerData.controlX = this.pointerData.controlX + param1.x;
         this.pointerData.controlY = this.pointerData.controlY + param1.y;
         this.drawMe();
      }
   }
}
