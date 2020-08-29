package com.bitstrips.controls
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.ComicCharAsset;
   import com.bitstrips.comicbuilder.Comic;
   import com.bitstrips.comicbuilder.TextBubble;
   import com.bitstrips.ui.GradientBox3;
   import com.bitstrips.ui.TextFloat;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public final class ComicControls extends Sprite implements ComicControl
   {
      
      public static const HEIGHT:Number = 46;
      
      private static var debug:Boolean = false;
       
      
      private var myComic:Comic;
      
      private var ui:ComicControlsUI;
      
      private var nameFloat:TextFloat;
      
      private var floatList:Array;
      
      private var floatTimer:Timer;
      
      private var _locked:Boolean = false;
      
      private var skyGradientBox:GradientBox3;
      
      private var groundGradientBox:GradientBox3;
      
      private var _linked_colours:Boolean = true;
      
      private var _move_mode:uint = 0;
      
      public function ComicControls(param1:Comic, param2:String = "comic")
      {
         var tf:TextFormat = null;
         var comic:Comic = param1;
         var type:String = param2;
         super();
         this.myComic = comic;
         this.ui = new ComicControlsUI();
         addChild(this.ui);
         Utils.disable_shade_btn(this.ui.undo_btn);
         Utils.disable_shade_btn(this.ui.redo_btn);
         this.ui.undo_btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(myComic)
            {
               myComic.do_undo();
            }
         });
         this.ui.redo_btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(myComic)
            {
               myComic.do_redo();
            }
         });
         this.nameFloat = new TextFloat();
         this.nameFloat.mouseEnabled = false;
         this.nameFloat.visible = false;
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.move_nameFloat);
         addChild(this.nameFloat);
         this.floatList = [this.ui.lock_btn,this.ui.move_up_btn,this.ui.move_down_btn,this.ui.copy_btn,this.ui.paste_btn,this.ui.undo_btn,this.ui.redo_btn,this.ui.delete_btn,this.ui.panel_controls.addPanel_btn,this.ui.panel_controls.removePanel_btn,this.ui.panel_controls.addStrip_btn,this.ui.save_btn,this.ui.mode_0,this.ui.mode_1,this.ui.mode_2];
         this.floatTimer = new Timer(500,1);
         this.floatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.testFloatList);
         this.ui.lock_mc.mouseEnabled = false;
         this.ui.panel_controls.rowToggle_mc.mouseEnabled = false;
         this.ui.mode_0.gotoAndStop(3);
         this.ui.panel_controls.rowToggle_mc.gotoAndStop(2);
         var toggleList:Array = [this.ui.mode_0,this.ui.mode_1,this.ui.mode_2];
         var i:int = 0;
         while(i < toggleList.length)
         {
            toggleList[i].gotoAndStop(1);
            toggleList[i].addEventListener(MouseEvent.MOUSE_OVER,this.btn_over);
            toggleList[i].addEventListener(MouseEvent.MOUSE_OUT,this.btn_out);
            toggleList[i].addEventListener(MouseEvent.CLICK,this.btn_click);
            toggleList[i].buttonMode = true;
            i++;
         }
         BSConstants.tf_fix(this.ui.save_txt);
         this.ui.save_txt.mouseEnabled = false;
         this.ui.save_txt.text = this._("SAVE");
         if(this.ui.save_txt.text.length >= 5)
         {
            this.ui.save_txt.setTextFormat(new TextFormat(null,10));
         }
         this.myComic.addEventListener("NO_UNDO",function(param1:Event):void
         {
            Utils.disable_shade_btn(ui.undo_btn);
         });
         this.myComic.addEventListener("UNDO_READY",function(param1:Event):void
         {
            Utils.enable_shade_btn(ui.undo_btn);
         });
         this.myComic.addEventListener("NO_REDO",function(param1:Event):void
         {
            Utils.disable_shade_btn(ui.redo_btn);
         });
         this.myComic.addEventListener("REDO_READY",function(param1:Event):void
         {
            Utils.enable_shade_btn(ui.redo_btn);
         });
         this.myComic.addEventListener("POSE_BEGIN",this.pose_begin_handler);
         this.myComic.addEventListener("POSE_END",this.pose_end_handler);
         this.myComic.addEventListener("PANEL_SELECT",this.panel_select);
         this.myComic.addEventListener("ASSET_SELECT",this.asset_select);
         this.panel_select(new Event("PANEL_SELECT"));
         this.asset_select(new Event("ASSET_SELECT"));
         if(type == "comic")
         {
            this.ui.skyground_controls.visible = false;
         }
         else
         {
            this.ui.panel_controls.visible = false;
            this.skyground_init();
         }
      }
      
      private function skyground_init() : void
      {
         this.skyGradientBox = new GradientBox3();
         this.groundGradientBox = new GradientBox3();
         this.skyGradientBox.x = this.ui.skyground_controls.x + this.ui.skyground_controls.sky_colourBox_area_mc.x;
         this.skyGradientBox.y = this.ui.skyground_controls.y + this.ui.skyground_controls.sky_colourBox_area_mc.y;
         this.skyGradientBox.grad_align(3);
         addChild(this.skyGradientBox);
         this.groundGradientBox.x = this.ui.skyground_controls.x + this.ui.skyground_controls.ground_colourBox_area_mc.x;
         this.groundGradientBox.y = this.ui.skyground_controls.y + this.ui.skyground_controls.ground_colourBox_area_mc.y;
         this.groundGradientBox.grad_align(3);
         addChild(this.groundGradientBox);
         this.skyGradientBox.addEventListener("COLOUR_OVER",this.sky_setColour);
         this.groundGradientBox.addEventListener("COLOUR_OVER",this.ground_setColour);
         this.ui.skyground_controls.link_mc.addEventListener(MouseEvent.CLICK,this.click_link);
         this.ui.skyground_controls.link_mc.buttonMode = true;
      }
      
      private function sky_setColour(param1:Event) : void
      {
         trace("--layout_controls.sky_setColour(" + this.skyGradientBox.colour + ")--");
         this.myComic.setBackdropColour(this.skyGradientBox.colour,false);
         if(this._linked_colours)
         {
            trace("888");
            this.myComic.setGroundColour(this.skyGradientBox.colour,false);
            this.groundGradientBox.set_colour(this.skyGradientBox.colour);
         }
      }
      
      private function ground_setColour(param1:Event) : void
      {
         trace("--layout_controls.ground_setColour(" + this.groundGradientBox.colour + ")--");
         this.myComic.setGroundColour(this.groundGradientBox.colour,false);
         if(this._linked_colours)
         {
            this.myComic.setBackdropColour(this.groundGradientBox.colour,false);
            this.skyGradientBox.set_colour(this.groundGradientBox.colour);
         }
      }
      
      private function click_link(param1:MouseEvent) : void
      {
         this._linked_colours = !this._linked_colours;
         if(this._linked_colours)
         {
            this.ui.skyground_controls.link_mc.gotoAndStop(1);
         }
         else
         {
            this.ui.skyground_controls.link_mc.gotoAndStop(2);
         }
      }
      
      private function panel_select(param1:Event) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc2_:Array = [this.ui.panel_controls.addPanel_btn,this.ui.panel_controls.removePanel_btn,this.ui.panel_controls.addStrip_btn,this.ui.delete_btn,this.ui.copy_btn,this.ui.paste_btn];
         if(this.myComic.selectedPanel)
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.enable_shade_btn(_loc3_);
            }
         }
         else
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.disable_shade_btn(_loc3_);
            }
         }
         Utils.disable_shade_btn(this.ui.move_down_btn);
         Utils.disable_shade_btn(this.ui.move_up_btn);
         if(this.myComic.strips.length == 1 && this.myComic.strips[0].panels.length == 1)
         {
            Utils.disable_shade_btn(this.ui.panel_controls.removePanel_btn);
         }
         if(this.myComic.selectedStrip && this.myComic.selectedStrip.panels.length >= Comic.PANEL_MAX)
         {
            Utils.disable_shade_btn(this.ui.panel_controls.addPanel_btn);
         }
         if(this.myComic.strips.length >= Comic.STRIP_MAX)
         {
            Utils.disable_shade_btn(this.ui.panel_controls.addStrip_btn);
         }
      }
      
      public function update_stacking() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         if(!this.myComic._popped_asset)
         {
            Utils.disable_shade_btn(this.ui.move_down_btn);
            Utils.disable_shade_btn(this.ui.move_up_btn);
         }
         else if(this.myComic._popped_asset is ComicCharAsset)
         {
            _loc1_ = (this.myComic._popped_asset as ComicCharAsset).body.simple_stack_report();
            if(_loc1_["up"])
            {
               Utils.enable_shade_btn(this.ui.move_up_btn);
            }
            else
            {
               Utils.disable_shade_btn(this.ui.move_up_btn);
            }
            if(_loc1_["down"])
            {
               Utils.enable_shade_btn(this.ui.move_down_btn);
            }
            else
            {
               Utils.disable_shade_btn(this.ui.move_down_btn);
            }
         }
         if(this.myComic.selectedAsset && this.myComic.selectedAsset.locked == false && this.myComic.selectedAsset.editing == false)
         {
            _loc2_ = this.myComic.selectedAsset.get_touches();
            trace("Above: " + _loc2_[0]);
            trace("Below: " + _loc2_[1]);
            if(_loc2_[0].length)
            {
               Utils.enable_shade_btn(this.ui.move_down_btn);
            }
            if(_loc2_[1].length)
            {
               Utils.enable_shade_btn(this.ui.move_up_btn);
            }
            if(this.myComic.selectedAsset is TextBubble)
            {
               if(this.myComic.selectedAsset.asset_type == "promoted text")
               {
                  Utils.enable_shade_btn(this.ui.move_down_btn);
               }
               else
               {
                  Utils.enable_shade_btn(this.ui.move_up_btn);
               }
            }
         }
      }
      
      private function asset_select(param1:Event) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc2_:Array = [this.ui.lock_btn,this.ui.move_down_btn,this.ui.move_up_btn];
         if(this.myComic.selectedAsset)
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.enable_shade_btn(_loc3_);
            }
            this.update_stacking();
            this._locked = this.myComic.selectedAsset.locked;
            if(this._locked)
            {
               this.ui.lock_mc.gotoAndStop(2);
            }
            else
            {
               this.ui.lock_mc.gotoAndStop(1);
            }
         }
         else
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.disable_shade_btn(_loc3_);
            }
         }
      }
      
      private function testFloatList(param1:Event) : void
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         _loc2_["mode_0"] = "MOVE";
         _loc2_["mode_1"] = "SCALE";
         _loc2_["mode_2"] = "ROTATE";
         _loc2_["undo_btn"] = "Undo";
         _loc2_["redo_btn"] = "Redo";
         _loc2_["move_up_btn"] = "MOVE IN-FRONT";
         _loc2_["move_down_btn"] = "MOVE BEHIND";
         _loc2_["copy_btn"] = "COPY";
         _loc2_["paste_btn"] = "PASTE";
         _loc2_["addPanel_btn"] = "ADD\nPANEL";
         _loc2_["removePanel_btn"] = "REMOVE\nPANEL";
         _loc2_["save_btn"] = "MOVE";
         _loc2_["delete_btn"] = "CLEAR\nPANEL";
         _loc2_["addStrip_btn"] = "ADD\nROW";
         if(this.myComic.selectedAsset)
         {
            _loc2_["delete_btn"] = "DELETE";
         }
         _loc2_["lock_btn"] = "LOCK";
         if(this._locked)
         {
            _loc2_["lock_btn"] = "UNLOCK";
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.floatList.length)
         {
            if(this.floatList[_loc4_].hitTestPoint(stage.mouseX,stage.mouseY,false))
            {
               _loc3_ = this.floatList[_loc4_].name;
               if(_loc2_.hasOwnProperty(_loc3_))
               {
                  this.displayName(this._(_loc2_[_loc3_]));
               }
               else
               {
                  this.displayName(_loc3_);
               }
               this.nameFloat.x = this.floatList[_loc4_].x + this.floatList[_loc4_].width / 2;
               this.nameFloat.y = this.floatList[_loc4_].y - this.nameFloat.height / 2 - 3;
               break;
            }
            _loc4_++;
         }
      }
      
      public function get save_btn() : SimpleButton
      {
         return this.ui.save_btn;
      }
      
      public function get addPanel_btn() : SimpleButton
      {
         return this.ui.panel_controls.addPanel_btn;
      }
      
      public function get removePanel_btn() : SimpleButton
      {
         return this.ui.panel_controls.removePanel_btn;
      }
      
      public function get addStrip_btn() : SimpleButton
      {
         return this.ui.panel_controls.addStrip_btn;
      }
      
      public function get delete_btn() : SimpleButton
      {
         return this.ui.delete_btn;
      }
      
      public function get copy_btn() : SimpleButton
      {
         return this.ui.copy_btn;
      }
      
      public function get paste_btn() : SimpleButton
      {
         return this.ui.paste_btn;
      }
      
      public function get lock_btn() : SimpleButton
      {
         return this.ui.lock_btn;
      }
      
      public function get move_up_btn() : SimpleButton
      {
         return this.ui.move_up_btn;
      }
      
      public function get move_down_btn() : SimpleButton
      {
         return this.ui.move_down_btn;
      }
      
      private function btn_over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name != "mode_" + this._move_mode)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function btn_out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name != "mode_" + this._move_mode)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      public function set move_mode(param1:int) : void
      {
         if(param1 == this._move_mode || param1 == 3)
         {
            return;
         }
         this._move_mode = param1;
         this.ui["mode_" + 0].gotoAndStop(0);
         this.ui["mode_" + 1].gotoAndStop(0);
         this.ui["mode_" + 2].gotoAndStop(0);
         this.ui["mode_" + this._move_mode].gotoAndStop(3);
         if(this.myComic.move_mode != this._move_mode)
         {
            this.myComic.move_mode = this._move_mode;
         }
      }
      
      public function get move_mode() : int
      {
         return this._move_mode;
      }
      
      private function btn_click(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "mode_0")
         {
            this.move_mode = 0;
         }
         else if(param1.currentTarget.name == "mode_1")
         {
            this.move_mode = 1;
         }
         else if(param1.currentTarget.name == "mode_2")
         {
            this.move_mode = 2;
         }
      }
      
      private function move_nameFloat(param1:MouseEvent) : void
      {
         this.nameFloat.visible = false;
         this.floatTimer.reset();
         this.floatTimer.start();
      }
      
      private function displayName(param1:String) : void
      {
         if(param1 == "")
         {
            this.nameFloat.visible = false;
         }
         else
         {
            this.nameFloat.setText(param1);
            this.nameFloat.visible = true;
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function pose_begin_handler(param1:Event) : void
      {
         Utils.enable_shade_btn(this.ui.move_down_btn);
         Utils.enable_shade_btn(this.ui.move_up_btn);
      }
      
      private function pose_end_handler(param1:Event) : void
      {
         this.update_stacking();
      }
   }
}
