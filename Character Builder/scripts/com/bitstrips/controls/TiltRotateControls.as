package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.IBody;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TiltRotateControls extends Sprite
   {
       
      
      private var tiltRange:Number;
      
      private var _body:IBody;
      
      private var ui:TiltRotUI;
      
      private const tiltMin:Number = -60;
      
      private const tiltMax:Number = 60;
      
      private var _head:IHead;
      
      public function TiltRotateControls()
      {
         super();
         tiltRange = tiltMax - tiltMin;
         ui = new TiltRotUI();
         addChild(ui);
         ui.tilt_mc.gotoAndStop(61);
         ui.tilt_mc.buttonMode = true;
         ui.tilt_mc.useHandCursor = true;
         ui.tilt_mc.addEventListener(MouseEvent.MOUSE_DOWN,tilt_down);
         ui.head_inc.addEventListener(MouseEvent.CLICK,do_head_increment);
         ui.head_dec.addEventListener(MouseEvent.CLICK,do_head_decrement);
         ui.body_inc.addEventListener(MouseEvent.CLICK,do_body_increment);
         ui.body_dec.addEventListener(MouseEvent.CLICK,do_body_decrement);
         this.disable();
      }
      
      private function enable() : void
      {
         Utils.enable_shade(ui);
      }
      
      private function do_head_increment(param1:MouseEvent) : void
      {
         if(_head)
         {
            _head.set_rotation((_head.h_rot + 1) % 8);
         }
      }
      
      private function do_body_increment(param1:MouseEvent) : void
      {
         if(_head == null)
         {
            return;
         }
         _head.set_rotation((_head.h_rot + 1) % 8);
         _body.set_rotation((_body.master_rotation + 1) % 8);
      }
      
      private function do_head_decrement(param1:MouseEvent) : void
      {
         if(_head == null)
         {
            return;
         }
         var _loc2_:Number = (_head.h_rot - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         _head.set_rotation(_loc2_);
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         if(_body)
         {
            _head = _body.head;
            _body.addEventListener("head tilt",match_tilt);
            _body.addEventListener(Event.CHANGE,match_tilt);
            enable();
         }
         else
         {
            disable();
         }
      }
      
      public function set head(param1:IHead) : void
      {
         _head = param1;
         if(_head)
         {
            enable();
         }
         else
         {
            disable();
         }
      }
      
      private function tilt_move(param1:MouseEvent) : void
      {
         doTilt();
      }
      
      private function tilt_up(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,tilt_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,tilt_up);
      }
      
      public function get head() : IHead
      {
         return _head;
      }
      
      private function disable() : void
      {
         Utils.disable_shade(ui);
      }
      
      public function get body() : IBody
      {
         return _body;
      }
      
      private function tilt_down(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,tilt_move);
         stage.addEventListener(MouseEvent.MOUSE_UP,tilt_up);
         doTilt();
      }
      
      private function doTilt() : void
      {
         trace(ui.tilt_mc.mouseX);
         var _loc1_:Number = (ui.tilt_mc.mouseX * ui.tilt_mc.scaleX + ui.tilt_mc.width / 2) / ui.tilt_mc.width;
         _loc1_ = Math.min(1,Math.max(0,_loc1_));
         var _loc2_:Number = ui.tilt_mc.totalFrames;
         ui.tilt_mc.gotoAndStop(Math.round(_loc2_ * _loc1_));
         if(_body)
         {
            _body.head_angle = tiltMin + tiltRange * _loc1_;
         }
      }
      
      private function do_body_decrement(param1:MouseEvent) : void
      {
         if(_head == null)
         {
            return;
         }
         var _loc2_:Number = (_head.h_rot - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         _head.set_rotation(_loc2_);
         _loc2_ = (_body.master_rotation - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         _body.set_rotation(_loc2_);
      }
      
      private function match_tilt(param1:Event) : void
      {
         var _loc2_:Number = IBody(param1.currentTarget).head_angle;
         if(_loc2_ > 180)
         {
            _loc2_ = _loc2_ - 360;
         }
         var _loc3_:Number = ui.tilt_mc.totalFrames;
         var _loc4_:Number = (_loc2_ - tiltMin) / tiltRange;
         ui.tilt_mc.gotoAndStop(Math.round(_loc3_ * _loc4_));
      }
   }
}
