package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public final class ProgressBlocker extends Sprite
   {
       
      
      private var _progress:Number;
      
      private var _status:String = "";
      
      private var ui:Progress_UI;
      
      private var expanded:Boolean = false;
      
      public function ProgressBlocker(param1:Number, param2:Number, param3:String = "")
      {
         super();
         ui = new Progress_UI();
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
      }
      
      public function set status(param1:String) : void
      {
         ui.main_lbl.text = param1;
         _status = param1;
      }
      
      public function hide() : void
      {
         this.visible = false;
         this.status = "";
         this.message = "";
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         ui.status_lbl.text = param1;
         if(param1.length > 50)
         {
            _loc2_ = new TextFormat(null,8);
            ui.status_lbl.setTextFormat(_loc2_);
            if(expanded == false)
            {
               ui.status_lbl.y = ui.status_lbl.y - 5;
               ui.status_lbl.x = ui.status_lbl.x - 15;
               ui.status_lbl.width = ui.status_lbl.width + 30;
               ui.status_lbl.height = ui.status_lbl.height + 30;
            }
            ui.status_lbl.selectable = true;
            ui.status_lbl.mouseEnabled = true;
            expanded = true;
         }
      }
      
      public function on_top() : void
      {
         if(this.parent)
         {
            this.parent.setChildIndex(this,this.parent.numChildren - 1);
         }
      }
      
      public function set progress(param1:Number) : void
      {
         _progress = param1;
         ui.main_lbl.text = _status + ": " + int(param1 * 100) + "%";
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
