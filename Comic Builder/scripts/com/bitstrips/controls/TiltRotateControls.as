package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Features;
   import com.bitstrips.character.IBody;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TiltRotateControls extends Sprite
   {
       
      
      private var ui:TiltRotUI;
      
      private var _body:IBody;
      
      private var _head:IHead;
      
      private const tiltMin:Number = -60;
      
      private const tiltMax:Number = 60;
      
      private var tiltRange:Number;
      
      public function TiltRotateControls()
      {
         super();
         this.tiltRange = this.tiltMax - this.tiltMin;
         this.ui = new TiltRotUI();
         addChild(this.ui);
         this.ui.tilt_mc.gotoAndStop(61);
         this.ui.tilt_mc.buttonMode = true;
         this.ui.tilt_mc.useHandCursor = true;
         this.ui.tilt_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.tilt_down);
         this.ui.head_inc.addEventListener(MouseEvent.CLICK,this.do_head_increment);
         this.ui.head_dec.addEventListener(MouseEvent.CLICK,this.do_head_decrement);
         this.ui.body_inc.addEventListener(MouseEvent.CLICK,this.do_body_increment);
         this.ui.body_dec.addEventListener(MouseEvent.CLICK,this.do_body_decrement);
         this.disable();
      }
      
      private function tilt_down(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.tilt_move);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.tilt_up);
         this.doTilt();
      }
      
      private function tilt_up(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.tilt_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.tilt_up);
      }
      
      private function tilt_move(param1:MouseEvent) : void
      {
         this.doTilt();
      }
      
      private function doTilt() : void
      {
         trace(this.ui.tilt_mc.mouseX);
         var _loc1_:Number = (this.ui.tilt_mc.mouseX * this.ui.tilt_mc.scaleX + this.ui.tilt_mc.width / 2) / this.ui.tilt_mc.width;
         _loc1_ = Math.min(1,Math.max(0,_loc1_));
         var _loc2_:Number = this.ui.tilt_mc.totalFrames;
         this.ui.tilt_mc.gotoAndStop(Math.round(_loc2_ * _loc1_));
         if(this._body)
         {
            this._body.head_angle = this.tiltMin + this.tiltRange * _loc1_;
         }
      }
      
      private function match_tilt(param1:Event) : void
      {
         var _loc2_:Number = IBody(param1.currentTarget).head_angle;
         if(_loc2_ > 180)
         {
            _loc2_ = _loc2_ - 360;
         }
         var _loc3_:Number = this.ui.tilt_mc.totalFrames;
         var _loc4_:Number = (_loc2_ - this.tiltMin) / this.tiltRange;
         this.ui.tilt_mc.gotoAndStop(Math.round(_loc3_ * _loc4_));
      }
      
      private function do_head_increment(param1:MouseEvent) : void
      {
         if(this._head)
         {
            this._head.set_rotation((this._head.h_rot + 1) % 8);
         }
      }
      
      private function do_head_decrement(param1:MouseEvent) : void
      {
         if(this._head == null)
         {
            return;
         }
         var _loc2_:Number = (this._head.h_rot - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         this._head.set_rotation(_loc2_);
      }
      
      private function do_body_increment(param1:MouseEvent) : void
      {
         if(this._head == null)
         {
            return;
         }
         this._head.set_rotation((this._head.h_rot + 1) % 8);
         this._body.set_rotation((this._body.master_rotation + 1) % 8);
      }
      
      private function do_body_decrement(param1:MouseEvent) : void
      {
         if(this._head == null)
         {
            return;
         }
         var _loc2_:Number = (this._head.h_rot - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         this._head.set_rotation(_loc2_);
         _loc2_ = (this._body.master_rotation - 1) % 8;
         if(_loc2_ == -1)
         {
            _loc2_ = 7;
         }
         this._body.set_rotation(_loc2_);
      }
      
      public function get head() : IHead
      {
         return this._head;
      }
      
      public function get body() : IBody
      {
         return this._body;
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         if(this._body)
         {
            this._head = this._body.head;
            this._body.addEventListener("head tilt",this.match_tilt);
            this._body.addEventListener(Event.CHANGE,this.match_tilt);
            this.enable();
         }
         else
         {
            this.disable();
         }
         if(this._body == null || this._body.features.indexOf(Features.HEAD_TILT) == -1)
         {
            this.ui.tilt_mc.visible = false;
         }
         else
         {
            this.ui.tilt_mc.visible = true;
         }
         if(this._body == null || this._body.features.indexOf(Features.BODY_ROTATION) == -1)
         {
            this.ui.body_inc.visible = false;
            this.ui.body_dec.visible = false;
         }
         else
         {
            this.ui.body_inc.visible = true;
            this.ui.body_dec.visible = true;
         }
         if(this._body && this._head)
         {
            if(this._head.features.indexOf(Features.HEAD_ROTATION) == -1 && this._body.features.indexOf(Features.HEAD_TILT) == -1 && this._body.features.indexOf(Features.BODY_ROTATION) == -1)
            {
               this.disable();
            }
         }
      }
      
      public function set head(param1:IHead) : void
      {
         this._head = param1;
         if(this._head && this._body)
         {
            this.enable();
         }
         else
         {
            this.disable();
         }
         if(this._head == null || this._head.features.indexOf(Features.HEAD_ROTATION) == -1)
         {
            this.ui.head_inc.visible = false;
            this.ui.head_dec.visible = false;
         }
         else
         {
            this.ui.head_inc.visible = true;
            this.ui.head_dec.visible = true;
         }
      }
      
      private function disable() : void
      {
         Utils.disable_shade(this.ui);
      }
      
      private function enable() : void
      {
         Utils.enable_shade(this.ui);
      }
   }
}
