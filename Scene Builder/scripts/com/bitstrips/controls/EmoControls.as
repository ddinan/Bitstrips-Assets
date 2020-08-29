package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   
   public class EmoControls extends Sprite
   {
       
      
      private var _enabled:Boolean = true;
      
      private var _emo:uint = 0;
      
      private var emos:Container;
      
      private var ui:EmoControlsUI;
      
      private var _head:IHead;
      
      public function EmoControls()
      {
         super();
         ui = new EmoControlsUI();
         addChild(ui);
         emos = new Container([ui.emo1,ui.emo2,ui.emo3,ui.emo4,ui.emo5,ui.emo6,ui.emo7,ui.emo8]);
         emos.over_updates = false;
         emos.click_function = function(param1:String):void
         {
            var _loc2_:Number = Number(param1.substr(3)) * 1;
            if(_head)
            {
               _head.set_expression(_loc2_);
            }
            trace("Emo clicked: " + param1 + ", " + _loc2_);
         };
         this.disable();
      }
      
      public function get head() : IHead
      {
         return _head;
      }
      
      private function enable() : void
      {
         Utils.enable_shade(ui);
      }
      
      public function set head(param1:IHead) : void
      {
         _head = param1;
         if(_head)
         {
            enable();
            emos.select(_head.cur_expression - 1);
         }
         else
         {
            disable();
            emos.deselect();
         }
      }
      
      private function disable() : void
      {
         Utils.disable_shade(ui);
      }
   }
}
