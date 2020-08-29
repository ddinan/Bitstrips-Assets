package com.bitstrips.comicbuilder
{
   import com.bitstrips.ui.DashedLine;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BubblePointer extends Sprite
   {
       
      
      private var outline:Sprite;
      
      private var pointerData:Object;
      
      private var debug:Boolean = false;
      
      private var myBubble:TextBubble;
      
      private var control:Sprite;
      
      private var bkgr:Sprite;
      
      private var curveMax:Number = 50;
      
      private var pointer:Sprite;
      
      public function BubblePointer()
      {
         super();
         if(debug)
         {
            trace("--BubblePointer()--");
         }
         pointer = new Sprite();
         control = new Sprite();
         pointerData = {
            "bkgrColor":16777215,
            "controlX":0,
            "controlY":40,
            "centerX":0,
            "centerY":0,
            "curve":0,
            "rotation":0,
            "style":"normal"
         };
         bkgr = new Sprite();
         outline = new Sprite();
         this.buttonMode = true;
         initialDraw();
      }
      
      public function dragControlMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         _loc2_ = this.globalToLocal(_loc2_);
         pointerData.controlX = _loc2_.x;
         pointerData.controlY = _loc2_.y;
         drawMe();
      }
      
      public function bump(param1:Object) : void
      {
         if(debug)
         {
            trace(">-BubblePointer.bump(x: " + param1.x + " y: " + param1.y + ")--");
         }
         pointerData.controlX = pointerData.controlX + param1.x;
         pointerData.controlY = pointerData.controlY + param1.y;
         drawMe();
      }
      
      public function save_state() : Object
      {
         return pointerData;
      }
      
      public function setBubble(param1:TextBubble) : void
      {
         myBubble = param1;
      }
      
      public function dragControlStart(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--BubblePointer.dragControlStart()--");
         }
         if(myBubble)
         {
            if(!myBubble.getLock())
            {
               param1.stopPropagation();
               stage.addEventListener(MouseEvent.MOUSE_UP,dragControlStop);
               stage.addEventListener(MouseEvent.MOUSE_MOVE,dragControlMove);
            }
         }
      }
      
      public function getData() : Object
      {
         return pointerData;
      }
      
      public function doSelect(param1:Boolean) : void
      {
         control.visible = param1;
      }
      
      public function dragControlStop(param1:MouseEvent) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("--BubblePointer.dragControlStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,dragControlStop);
         if(myBubble)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,dragControlMove);
         }
         for(_loc2_ in pointerData)
         {
            if(debug)
            {
               trace(_loc2_ + ": " + pointerData[_loc2_]);
            }
         }
         if(debug)
         {
            trace("-------------");
         }
      }
      
      public function initialDraw() : void
      {
         addChild(pointer);
         pointer.addChild(bkgr);
         pointer.addChild(outline);
         pointer.rotation = pointerData.rotation;
         control = new crossmark();
         control.buttonMode = true;
         pointer.addChild(control);
         control.x = pointerData.controlX;
         control.y = pointerData.controlY;
         control.addEventListener(MouseEvent.MOUSE_DOWN,dragControlStart,false,100,true);
         control.addEventListener(MouseEvent.MOUSE_OVER,control_over,false,0,true);
         doSelect(false);
      }
      
      private function control_over(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         if(param1.buttonDown == false)
         {
            param1.stopPropagation();
         }
      }
      
      public function load_state(param1:Object) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in param1)
         {
            if(pointerData.hasOwnProperty(_loc2_) == false)
            {
               trace("Warning: undefined property: " + _loc2_);
            }
            else
            {
               pointerData[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function setColour(param1:Number) : void
      {
         pointerData.bkgrColor = param1;
         drawMe();
      }
      
      public function drawMe() : void
      {
         var _loc10_:DashedLine = null;
         var _loc1_:Number = Math.min(myBubble.bubble_width,myBubble.bubble_height) / 4;
         _loc1_ = Math.max(_loc1_,20);
         if(debug)
         {
            trace("--BubblePointer.drawMe()-<");
         }
         if(debug)
         {
            trace("IN pointerData.curve: " + pointerData.curve);
         }
         var _loc2_:Point = new Point(pointerData.centerX,pointerData.centerY);
         var _loc3_:Point = new Point(pointerData.controlX,pointerData.controlY);
         var _loc4_:Number = _loc2_.x - _loc3_.x;
         var _loc5_:Number = _loc2_.y - _loc3_.y;
         var _loc6_:Number = Math.sqrt(Math.pow(_loc4_,2) + Math.pow(_loc5_,2));
         var _loc7_:Number = Math.atan2(_loc3_.y - _loc2_.y,_loc3_.x - _loc2_.x);
         var _loc8_:Number = _loc7_ * (180 / Math.PI) - 90;
         if(debug)
         {
            trace("deg: " + _loc8_);
         }
         pointerData.centerX = 0;
         pointerData.centerY = 0;
         var _loc9_:Number = _loc8_ - pointerData.rotation;
         if(_loc9_ < -180)
         {
            _loc9_ = _loc9_ + 360;
         }
         else if(_loc9_ > 180)
         {
            _loc9_ = _loc9_ - 360;
         }
         if(debug)
         {
            trace("degDiff: " + _loc9_);
         }
         pointerData.curve = pointerData.curve + _loc9_;
         pointerData.curve = Math.min(curveMax,pointerData.curve);
         pointerData.curve = Math.max(0 - curveMax,pointerData.curve);
         if(debug)
         {
            trace("OUT pointerData.curve: " + pointerData.curve);
         }
         pointer.rotation = _loc8_;
         pointerData.rotation = _loc8_;
         control.x = 0;
         control.y = _loc6_;
         pointerData.centerX = 0;
         pointerData.centerY = 0;
         pointer.graphics.clear();
         bkgr.graphics.clear();
         outline.graphics.clear();
         switch(pointerData["style"])
         {
            case "whisper":
               pointer.graphics.clear();
               bkgr.graphics.clear();
               bkgr.graphics.beginFill(pointerData.bkgrColor,1);
               bkgr.graphics.moveTo(0 - _loc1_ / 2,0);
               bkgr.graphics.curveTo(pointerData.curve,_loc6_ / 2,0,_loc6_);
               bkgr.graphics.curveTo(_loc1_ / 2 + pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               bkgr.graphics.endFill();
               _loc10_ = new DashedLine(outline,6,6);
               outline.graphics.clear();
               _loc10_.clear();
               _loc10_.lineStyle(2,0,1);
               _loc10_.beginFill(pointerData.bkgrColor,1);
               _loc10_.moveTo(0 - _loc1_ / 2,0);
               _loc10_.curveTo(pointerData.curve,_loc6_ / 2,0,_loc6_);
               _loc10_.curveTo(_loc1_ / 2 + pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               _loc10_.endFill();
               break;
            case "thought":
               pointer.graphics.clear();
               pointer.graphics.lineStyle(2,0,1);
               pointer.graphics.beginFill(pointerData.bkgrColor,1);
               pointer.graphics.drawCircle(0,_loc6_ - 2,3);
               pointer.graphics.drawCircle(0,_loc6_ * (7 / 10),5);
               pointer.graphics.drawCircle(0,_loc6_ * (4 / 10),7);
               break;
            case "shout":
               pointer.graphics.clear();
               pointer.graphics.lineStyle(2,0,1);
               pointer.graphics.beginFill(pointerData.bkgrColor,1);
               pointer.graphics.moveTo(0 - _loc1_ / 2,0);
               pointer.graphics.lineTo(0,_loc6_);
               pointer.graphics.lineTo(_loc1_ / 2,0);
               pointer.graphics.endFill();
               break;
            default:
               pointer.graphics.clear();
               pointer.graphics.lineStyle(2,0,1);
               pointer.graphics.beginFill(pointerData.bkgrColor,1);
               pointer.graphics.moveTo(0 - _loc1_ / 2,0);
               pointer.graphics.curveTo(pointerData.curve,_loc6_ / 2,0,_loc6_);
               pointer.graphics.curveTo(_loc1_ / 2 + pointerData.curve,_loc6_ / 2,_loc1_ / 2,0);
               pointer.graphics.endFill();
         }
         if(debug)
         {
            trace(">-BubblePointer.drawMe()--");
         }
      }
   }
}
