package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ErrorBlocker extends Sprite
   {
       
      
      private var ui:Error_UI;
      
      private var _status:String = "";
      
      private var _progress:Number;
      
      private var expanded:Boolean = false;
      
      public function ErrorBlocker(param1:Number, param2:Number, param3:String = "", param4:Boolean = true)
      {
         super();
         this.ui = new Error_UI();
         addChild(this.ui);
         BSConstants.tf_fix_cb(this.ui.main_lbl);
         BSConstants.tf_fix_cb(this.ui.status_lbl);
         this.tabEnabled = false;
         this.x = int(param1 / 2);
         this.y = int(param2 / 2);
         if(param3)
         {
            this.status = param3;
         }
         if(param4)
         {
            this.buttonMode = true;
            this.addEventListener(MouseEvent.CLICK,this.remove);
         }
      }
      
      public function remove(param1:Event) : void
      {
         this.parent.removeChild(this);
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.status = "";
         this.message = "";
      }
      
      public function show(param1:String = null, param2:Boolean = false) : void
      {
         if(param1 != null)
         {
            this.status = param1;
            this.message = "";
         }
         if(param2 == true)
         {
            this.ui.bg.alpha = 0;
         }
         else
         {
            this.ui.bg.alpha = 1;
         }
         this.on_top();
         this.visible = true;
      }
      
      public function on_top() : void
      {
         if(this.parent)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      public function set status(param1:String) : void
      {
         this.ui.main_lbl.text = param1;
         this._status = param1;
      }
      
      public function set message(param1:String) : void
      {
         this.ui.status_lbl.text = param1;
      }
   }
}
