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
      
      private static var debug:Boolean = false;
      
      public static const HEIGHT:Number = 46;
       
      
      private var myComic:Comic;
      
      private var nameFloat:TextFloat;
      
      private var ui:ComicControlsUI;
      
      private var skyGradientBox:GradientBox3;
      
      private var _linked_colours:Boolean = true;
      
      private var floatList:Array;
      
      private var _locked:Boolean = false;
      
      private var floatTimer:Timer;
      
      private var _move_mode:uint = 0;
      
      private var groundGradientBox:GradientBox3;
      
      public function ComicControls(param1:Comic, param2:String = "comic")
      {
         var tf:TextFormat = null;
         var comic:Comic = param1;
         var type:String = param2;
         super();
         myComic = comic;
         ui = new ComicControlsUI();
         addChild(ui);
         Utils.disable_shade_btn(ui.undo_btn);
         Utils.disable_shade_btn(ui.redo_btn);
         ui.undo_btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(myComic)
            {
               myComic.do_undo();
            }
         });
         ui.redo_btn.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(myComic)
            {
               myComic.do_redo();
            }
         });
         nameFloat = new TextFloat();
         nameFloat.mouseEnabled = false;
         nameFloat.visible = false;
         this.addEventListener(MouseEvent.MOUSE_MOVE,move_nameFloat);
         addChild(nameFloat);
         floatList = [ui.lock_btn,ui.move_up_btn,ui.move_down_btn,ui.copy_btn,ui.paste_btn,ui.undo_btn,ui.redo_btn,ui.delete_btn,ui.panel_controls.addPanel_btn,ui.panel_controls.removePanel_btn,ui.panel_controls.addStrip_btn,ui.save_btn,ui.mode_0,ui.mode_1,ui.mode_2];
         floatTimer = new Timer(500,1);
         floatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,testFloatList);
         ui.lock_mc.mouseEnabled = false;
         ui.panel_controls.rowToggle_mc.mouseEnabled = false;
         ui.mode_0.gotoAndStop(3);
         ui.panel_controls.rowToggle_mc.gotoAndStop(2);
         var toggleList:Array = [ui.mode_0,ui.mode_1,ui.mode_2];
         var i:int = 0;
         while(i < toggleList.length)
         {
            toggleList[i].gotoAndStop(1);
            toggleList[i].addEventListener(MouseEvent.MOUSE_OVER,btn_over);
            toggleList[i].addEventListener(MouseEvent.MOUSE_OUT,btn_out);
            toggleList[i].addEventListener(MouseEvent.CLICK,btn_click);
            toggleList[i].buttonMode = true;
            i++;
         }
         BSConstants.tf_fix(ui.save_txt);
         ui.save_txt.mouseEnabled = false;
         ui.save_txt.text = _("SAVE");
         if(ui.save_txt.text.length >= 5)
         {
            ui.save_txt.setTextFormat(new TextFormat(null,10));
         }
         myComic.addEventListener("NO_UNDO",function(param1:Event):void
         {
            Utils.disable_shade_btn(ui.undo_btn);
         });
         myComic.addEventListener("UNDO_READY",function(param1:Event):void
         {
            Utils.enable_shade_btn(ui.undo_btn);
         });
         myComic.addEventListener("NO_REDO",function(param1:Event):void
         {
            Utils.disable_shade_btn(ui.redo_btn);
         });
         myComic.addEventListener("REDO_READY",function(param1:Event):void
         {
            Utils.enable_shade_btn(ui.redo_btn);
         });
         myComic.addEventListener("POSE_BEGIN",pose_begin_handler);
         myComic.addEventListener("POSE_END",pose_end_handler);
         myComic.addEventListener("PANEL_SELECT",panel_select);
         myComic.addEventListener("ASSET_SELECT",asset_select);
         panel_select(new Event("PANEL_SELECT"));
         asset_select(new Event("ASSET_SELECT"));
         if(type == "comic")
         {
            ui.skyground_controls.visible = false;
         }
         else
         {
            ui.panel_controls.visible = false;
            skyground_init();
         }
      }
      
      public function get addPanel_btn() : SimpleButton
      {
         return ui.panel_controls.addPanel_btn;
      }
      
      private function pose_begin_handler(param1:Event) : void
      {
         Utils.enable_shade_btn(ui.move_down_btn);
         Utils.enable_shade_btn(ui.move_up_btn);
      }
      
      private function skyground_init() : void
      {
         skyGradientBox = new GradientBox3();
         groundGradientBox = new GradientBox3();
         skyGradientBox.x = ui.skyground_controls.x + ui.skyground_controls.sky_colourBox_area_mc.x;
         skyGradientBox.y = ui.skyground_controls.y + ui.skyground_controls.sky_colourBox_area_mc.y;
         skyGradientBox.grad_align(3);
         addChild(skyGradientBox);
         groundGradientBox.x = ui.skyground_controls.x + ui.skyground_controls.ground_colourBox_area_mc.x;
         groundGradientBox.y = ui.skyground_controls.y + ui.skyground_controls.ground_colourBox_area_mc.y;
         groundGradientBox.grad_align(3);
         addChild(groundGradientBox);
         skyGradientBox.addEventListener("COLOUR_OVER",sky_setColour);
         groundGradientBox.addEventListener("COLOUR_OVER",ground_setColour);
         ui.skyground_controls.link_mc.addEventListener(MouseEvent.CLICK,click_link);
         ui.skyground_controls.link_mc.buttonMode = true;
      }
      
      public function update_stacking() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         if(!myComic._popped_asset)
         {
            Utils.disable_shade_btn(ui.move_down_btn);
            Utils.disable_shade_btn(ui.move_up_btn);
         }
         else if(myComic._popped_asset is ComicCharAsset)
         {
            _loc1_ = (myComic._popped_asset as ComicCharAsset).body.simple_stack_report();
            if(_loc1_["up"])
            {
               Utils.enable_shade_btn(ui.move_up_btn);
            }
            else
            {
               Utils.disable_shade_btn(ui.move_up_btn);
            }
            if(_loc1_["down"])
            {
               Utils.enable_shade_btn(ui.move_down_btn);
            }
            else
            {
               Utils.disable_shade_btn(ui.move_down_btn);
            }
         }
         if(myComic.selectedAsset && myComic.selectedAsset.locked == false && myComic.selectedAsset.editing == false)
         {
            _loc2_ = myComic.selectedAsset.get_touches();
            trace("Above: " + _loc2_[0]);
            trace("Below: " + _loc2_[1]);
            if(_loc2_[0].length)
            {
               Utils.enable_shade_btn(ui.move_down_btn);
            }
            if(_loc2_[1].length)
            {
               Utils.enable_shade_btn(ui.move_up_btn);
            }
            if(myComic.selectedAsset is TextBubble)
            {
               if(myComic.selectedAsset.asset_type == "promoted text")
               {
                  Utils.enable_shade_btn(ui.move_down_btn);
               }
               else
               {
                  Utils.enable_shade_btn(ui.move_up_btn);
               }
            }
         }
      }
      
      private function ground_setColour(param1:Event) : void
      {
         trace("--layout_controls.ground_setColour(" + groundGradientBox.colour + ")--");
         myComic.setGroundColour(groundGradientBox.colour,false);
         if(_linked_colours)
         {
            myComic.setBackdropColour(groundGradientBox.colour,false);
            skyGradientBox.set_colour(groundGradientBox.colour);
         }
      }
      
      private function panel_select(param1:Event) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc2_:Array = [ui.panel_controls.addPanel_btn,ui.panel_controls.removePanel_btn,ui.panel_controls.addStrip_btn,ui.delete_btn,ui.copy_btn,ui.paste_btn];
         if(myComic.selectedPanel)
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
         Utils.disable_shade_btn(ui.move_down_btn);
         Utils.disable_shade_btn(ui.move_up_btn);
         if(this.myComic.strips.length == 1 && this.myComic.strips[0].panels.length == 1)
         {
            Utils.disable_shade_btn(ui.panel_controls.removePanel_btn);
         }
         if(this.myComic.selectedStrip && this.myComic.selectedStrip.panels.length >= Comic.PANEL_MAX)
         {
            Utils.disable_shade_btn(ui.panel_controls.addPanel_btn);
         }
         if(this.myComic.strips.length >= Comic.STRIP_MAX)
         {
            Utils.disable_shade_btn(ui.panel_controls.addStrip_btn);
         }
      }
      
      public function get copy_btn() : SimpleButton
      {
         return ui.copy_btn;
      }
      
      public function get addStrip_btn() : SimpleButton
      {
         return ui.panel_controls.addStrip_btn;
      }
      
      private function move_nameFloat(param1:MouseEvent) : void
      {
         nameFloat.visible = false;
         floatTimer.reset();
         floatTimer.start();
      }
      
      private function asset_select(param1:Event) : void
      {
         var _loc3_:SimpleButton = null;
         var _loc2_:Array = [ui.lock_btn,ui.move_down_btn,ui.move_up_btn];
         if(myComic.selectedAsset)
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.enable_shade_btn(_loc3_);
            }
            this.update_stacking();
            _locked = myComic.selectedAsset.locked;
            if(_locked)
            {
               ui.lock_mc.gotoAndStop(2);
            }
            else
            {
               ui.lock_mc.gotoAndStop(1);
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
         if(myComic.selectedAsset)
         {
            _loc2_["delete_btn"] = "DELETE";
         }
         _loc2_["lock_btn"] = "LOCK";
         if(_locked)
         {
            _loc2_["lock_btn"] = "UNLOCK";
         }
         var _loc4_:int = 0;
         while(_loc4_ < floatList.length)
         {
            if(floatList[_loc4_].hitTestPoint(stage.mouseX,stage.mouseY,false))
            {
               _loc3_ = floatList[_loc4_].name;
               if(_loc2_.hasOwnProperty(_loc3_))
               {
                  displayName(_(_loc2_[_loc3_]));
               }
               else
               {
                  displayName(_loc3_);
               }
               nameFloat.x = floatList[_loc4_].x + floatList[_loc4_].width / 2;
               nameFloat.y = floatList[_loc4_].y - nameFloat.height / 2 - 3;
               break;
            }
            _loc4_++;
         }
      }
      
      public function set move_mode(param1:int) : void
      {
         if(param1 == _move_mode || param1 == 3)
         {
            return;
         }
         _move_mode = param1;
         ui["mode_" + 0].gotoAndStop(0);
         ui["mode_" + 1].gotoAndStop(0);
         ui["mode_" + 2].gotoAndStop(0);
         ui["mode_" + _move_mode].gotoAndStop(3);
         if(this.myComic.move_mode != _move_mode)
         {
            this.myComic.move_mode = _move_mode;
         }
      }
      
      public function get save_btn() : SimpleButton
      {
         return ui.save_btn;
      }
      
      private function sky_setColour(param1:Event) : void
      {
         trace("--layout_controls.sky_setColour(" + skyGradientBox.colour + ")--");
         myComic.setBackdropColour(skyGradientBox.colour,false);
         if(_linked_colours)
         {
            trace("888");
            myComic.setGroundColour(skyGradientBox.colour,false);
            groundGradientBox.set_colour(skyGradientBox.colour);
         }
      }
      
      private function pose_end_handler(param1:Event) : void
      {
         update_stacking();
      }
      
      public function get paste_btn() : SimpleButton
      {
         return ui.paste_btn;
      }
      
      public function get delete_btn() : SimpleButton
      {
         return ui.delete_btn;
      }
      
      public function get lock_btn() : SimpleButton
      {
         return ui.lock_btn;
      }
      
      private function btn_over(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name != "mode_" + _move_mode)
         {
            param1.currentTarget.gotoAndStop(2);
         }
      }
      
      private function click_link(param1:MouseEvent) : void
      {
         _linked_colours = !_linked_colours;
         if(_linked_colours)
         {
            ui.skyground_controls.link_mc.gotoAndStop(1);
         }
         else
         {
            ui.skyground_controls.link_mc.gotoAndStop(2);
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      public function get move_mode() : int
      {
         return _move_mode;
      }
      
      private function btn_click(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "mode_0")
         {
            move_mode = 0;
         }
         else if(param1.currentTarget.name == "mode_1")
         {
            move_mode = 1;
         }
         else if(param1.currentTarget.name == "mode_2")
         {
            move_mode = 2;
         }
      }
      
      public function get move_up_btn() : SimpleButton
      {
         return ui.move_up_btn;
      }
      
      private function btn_out(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name != "mode_" + _move_mode)
         {
            param1.currentTarget.gotoAndStop(1);
         }
      }
      
      private function displayName(param1:String) : void
      {
         if(param1 == "")
         {
            nameFloat.visible = false;
         }
         else
         {
            nameFloat.setText(param1);
            nameFloat.visible = true;
         }
      }
      
      public function get move_down_btn() : SimpleButton
      {
         return ui.move_down_btn;
      }
      
      public function get removePanel_btn() : SimpleButton
      {
         return ui.panel_controls.removePanel_btn;
      }
   }
}
