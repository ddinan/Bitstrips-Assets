package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Features;
   import com.bitstrips.character.IBody;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StanceControls extends Sprite
   {
       
      
      private var ui:StanceUI;
      
      private var _body:IBody;
      
      private var _enabled:Boolean = false;
      
      public function StanceControls()
      {
         super();
         this.ui = new StanceUI();
         addChild(this.ui);
         this.ui.stance_up.addEventListener(MouseEvent.CLICK,this.stance_up_click);
         this.ui.stance_down.addEventListener(MouseEvent.CLICK,this.stance_down_click);
         this.ui.stance_left.addEventListener(MouseEvent.CLICK,this.stance_left_click);
         this.ui.stance_right.addEventListener(MouseEvent.CLICK,this.stance_right_click);
         this.disable();
      }
      
      private function stance_up_click(param1:MouseEvent) : void
      {
         this._body.stance_up();
      }
      
      private function stance_down_click(param1:MouseEvent) : void
      {
         this._body.stance_down();
      }
      
      private function stance_left_click(param1:MouseEvent) : void
      {
         this._body.stance_left();
      }
      
      private function stance_right_click(param1:MouseEvent) : void
      {
         this._body.stance_right();
      }
      
      public function get body() : IBody
      {
         return this._body;
      }
      
      public function set body(param1:IBody) : void
      {
         this._body = param1;
         if(this._body && this._body.features.indexOf(Features.STANCE) != -1)
         {
            this.body_change();
            this._body.addEventListener(Event.CHANGE,this.body_change,false,0,true);
         }
         else
         {
            this.disable();
         }
      }
      
      private function body_change(param1:Event = null) : void
      {
         var _loc3_:SimpleButton = null;
         trace(this._body.mode + " - " + this._body.stance);
         var _loc2_:uint = this._body.stance;
         if(this._body.mode == 2 || this._body.mode == 3)
         {
            if(this._enabled)
            {
               this.disable();
            }
         }
         else
         {
            if(this._enabled == false)
            {
               this.enable();
            }
            for each(_loc3_ in [this.ui.stance_left,this.ui.stance_right,this.ui.stance_down,this.ui.stance_up])
            {
               _loc3_.mouseEnabled = true;
            }
            if(_loc2_ % 3 == 0)
            {
               if(this._body.flipped)
               {
                  this.ui.stance_right.mouseEnabled = false;
               }
               else
               {
                  this.ui.stance_left.mouseEnabled = false;
               }
            }
            if(_loc2_ % 3 == 2)
            {
               if(this._body.flipped)
               {
                  this.ui.stance_left.mouseEnabled = false;
               }
               else
               {
                  this.ui.stance_right.mouseEnabled = false;
               }
            }
            if(_loc2_ < 3)
            {
               this.ui.stance_up.mouseEnabled = false;
            }
            if(_loc2_ > 5)
            {
               this.ui.stance_down.mouseEnabled = false;
            }
         }
      }
      
      private function disable() : void
      {
         this._enabled = false;
         Utils.disable_shade(this.ui);
      }
      
      private function enable() : void
      {
         this._enabled = true;
         Utils.enable_shade(this.ui);
      }
   }
}
