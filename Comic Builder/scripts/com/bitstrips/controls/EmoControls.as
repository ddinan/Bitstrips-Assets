package com.bitstrips.controls
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Features;
   import com.bitstrips.character.IHead;
   import flash.display.Sprite;
   
   public class EmoControls extends Sprite
   {
       
      
      private var ui:EmoControlsUI;
      
      private var emos:Container;
      
      private var _enabled:Boolean = true;
      
      private var _emo:uint = 0;
      
      private var _head:IHead;
      
      public function EmoControls()
      {
         super();
         this.ui = new EmoControlsUI();
         addChild(this.ui);
         this.emos = new Container([this.ui.emo1,this.ui.emo2,this.ui.emo3,this.ui.emo4,this.ui.emo5,this.ui.emo6,this.ui.emo7,this.ui.emo8]);
         this.emos.over_updates = false;
         this.emos.click_function = function(param1:String):void
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
      
      private function disable() : void
      {
         Utils.disable_shade(this.ui);
      }
      
      private function enable() : void
      {
         Utils.enable_shade(this.ui);
      }
      
      public function get head() : IHead
      {
         return this._head;
      }
      
      public function set head(param1:IHead) : void
      {
         this._head = param1;
         if(this._head && this._head.features.indexOf(Features.EXPRESSION) != -1)
         {
            this.enable();
            this.emos.select(this._head.cur_expression - 1);
         }
         else
         {
            this.disable();
            this.emos.deselect();
         }
      }
   }
}
