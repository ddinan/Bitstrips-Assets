package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public final class ErrorBlocker extends Sprite
   {
       
      
      private var _progress:Number;
      
      private var _status:String = "";
      
      private var ui:Error_UI;
      
      private var expanded:Boolean = false;
      
      public function ErrorBlocker(param1:Number, param2:Number, param3:String = "", param4:Boolean = true)
      {
         super();
         ui = new Error_UI();
         addChild(ui);
         BSConstants.tf_fix_cb(ui.main_lbl);
         BSConstants.tf_fix_cb(ui.status_lbl);
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
            this.addEventListener(MouseEvent.CLICK,remove);
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
      
      public function set status(param1:String) : void
      {
         ui.main_lbl.text = param1;
         _status = param1;
      }
      
      public function set message(param1:String) : void
      {
         ui.status_lbl.text = param1;
      }
      
      public function on_top() : void
      {
         if(this.parent)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
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
            ui.bg.alpha = 0;
         }
         else
         {
            ui.bg.alpha = 1;
         }
         this.on_top();
         this.visible = true;
      }
   }
}
