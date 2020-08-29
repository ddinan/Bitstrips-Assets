package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public final class ProgressBlocker extends Sprite
   {
       
      
      private var ui:Progress_UI;
      
      private var _status:String = "";
      
      private var _progress:Number;
      
      private var expanded:Boolean = false;
      
      public function ProgressBlocker(param1:Number, param2:Number, param3:String = "")
      {
         super();
         this.ui = new Progress_UI();
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
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1;
         this.ui.main_lbl.text = this._status + ": " + int(param1 * 100) + "%";
      }
      
      public function set status(param1:String) : void
      {
         this.ui.main_lbl.text = param1;
         this._status = param1;
      }
      
      public function get message() : String
      {
         return this.ui.status_lbl.text;
      }
      
      public function set message(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         this.ui.status_lbl.text = param1;
         if(param1.length > 50)
         {
            _loc2_ = new TextFormat(null,8);
            this.ui.status_lbl.setTextFormat(_loc2_);
            if(this.expanded == false)
            {
               this.ui.status_lbl.y = this.ui.status_lbl.y - 5;
               this.ui.status_lbl.x = this.ui.status_lbl.x - 15;
               this.ui.status_lbl.width = this.ui.status_lbl.width + 30;
               this.ui.status_lbl.height = this.ui.status_lbl.height + 30;
            }
            this.ui.status_lbl.selectable = true;
            this.ui.status_lbl.mouseEnabled = true;
            this.expanded = true;
         }
      }
   }
}
