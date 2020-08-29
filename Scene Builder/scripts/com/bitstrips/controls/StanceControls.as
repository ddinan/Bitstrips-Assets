package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.IBody;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class StanceControls extends Sprite
   {
       
      
      private var _body:IBody;
      
      private var _enabled:Boolean = false;
      
      private var ui:StanceUI;
      
      public function StanceControls()
      {
         super();
         ui = new StanceUI();
         addChild(ui);
         ui.stance_up.addEventListener(MouseEvent.CLICK,stance_up_click);
         ui.stance_down.addEventListener(MouseEvent.CLICK,stance_down_click);
         ui.stance_left.addEventListener(MouseEvent.CLICK,stance_left_click);
         ui.stance_right.addEventListener(MouseEvent.CLICK,stance_right_click);
         this.disable();
      }
      
      private function enable() : void
      {
         _enabled = true;
         Utils.enable_shade(ui);
      }
      
      public function get body() : IBody
      {
         return _body;
      }
      
      public function set body(param1:IBody) : void
      {
         _body = param1;
         if(_body)
         {
            body_change();
            _body.addEventListener(Event.CHANGE,body_change,false,0,true);
         }
         else
         {
            disable();
         }
      }
      
      private function body_change(param1:Event = null) : void
      {
         var _loc3_:SimpleButton = null;
         trace(_body.mode + " - " + _body.stance);
         var _loc2_:uint = _body.stance;
         if(_body.mode == 2 || _body.mode == 3)
         {
            if(_enabled)
            {
               disable();
            }
         }
         else
         {
            if(_enabled == false)
            {
               enable();
            }
            for each(_loc3_ in [ui.stance_left,ui.stance_right,ui.stance_down,ui.stance_up])
            {
               _loc3_.mouseEnabled = true;
            }
            if(_loc2_ % 3 == 0)
            {
               if(_body.flipped)
               {
                  ui.stance_right.mouseEnabled = false;
               }
               else
               {
                  ui.stance_left.mouseEnabled = false;
               }
            }
            if(_loc2_ % 3 == 2)
            {
               if(_body.flipped)
               {
                  ui.stance_left.mouseEnabled = false;
               }
               else
               {
                  ui.stance_right.mouseEnabled = false;
               }
            }
            if(_loc2_ < 3)
            {
               ui.stance_up.mouseEnabled = false;
            }
            if(_loc2_ > 5)
            {
               ui.stance_down.mouseEnabled = false;
            }
         }
      }
      
      private function disable() : void
      {
         _enabled = false;
         Utils.disable_shade(ui);
      }
      
      private function stance_down_click(param1:MouseEvent) : void
      {
         _body.stance_down();
      }
      
      private function stance_right_click(param1:MouseEvent) : void
      {
         _body.stance_right();
      }
      
      private function stance_up_click(param1:MouseEvent) : void
      {
         _body.stance_up();
      }
      
      private function stance_left_click(param1:MouseEvent) : void
      {
         _body.stance_left();
      }
   }
}
