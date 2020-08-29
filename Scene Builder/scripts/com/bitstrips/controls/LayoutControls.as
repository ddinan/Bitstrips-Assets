package com.bitstrips.controls
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.comicbuilder.ComicBuilder;
   import com.bitstrips.ui.GradientBox3;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public final class LayoutControls extends Sprite
   {
       
      
      private var myComicBuilder:ComicBuilder;
      
      private var ui:LayoutControlsUI;
      
      private var groundGradientBox:GradientBox3;
      
      private var linked:Boolean = true;
      
      private var skyGradientBox:GradientBox3;
      
      private var borderGradientBox:GradientBox3;
      
      private var format:TextFormat;
      
      public var field:TextField;
      
      private var colorAll:Boolean = true;
      
      public function LayoutControls(param1:Boolean = false)
      {
         super();
         ui = new LayoutControlsUI();
         addChild(ui);
         ui.easy_btn.visible = false;
         init();
      }
      
      public function setComicBuilder(param1:ComicBuilder) : void
      {
         trace("--layout_controls.setComicBuilder()--");
         myComicBuilder = param1;
      }
      
      private function goEasy(param1:MouseEvent) : void
      {
         trace("--layout_controls.goEasy()--");
         if(myComicBuilder)
         {
            myComicBuilder.goEasy_request();
         }
      }
      
      private function init() : void
      {
         var i:* = undefined;
         trace("init()");
         field = ui.field;
         ui.panel1_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(1);
         });
         ui.panel3_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(3);
         });
         ui.panel8_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(8);
         });
         ui.panel1_mc.buttonMode = ui.panel3_mc.buttonMode = ui.panel8_mc.buttonMode = true;
         format = new TextFormat();
         field.restrict = "1-8";
         field.maxChars = 1;
         field.text = "3";
         field.addEventListener(TextEvent.TEXT_INPUT,px_enter);
         ui.easy_btn.addEventListener(MouseEvent.CLICK,goEasy);
         borderGradientBox = new GradientBox3(2);
         borderGradientBox.x = ui.border_colourBox_area_mc.x;
         borderGradientBox.y = ui.border_colourBox_area_mc.y;
         addChild(borderGradientBox);
         skyGradientBox = new GradientBox3(2);
         skyGradientBox.x = ui.sky_colourBox_area_mc.x;
         skyGradientBox.y = ui.sky_colourBox_area_mc.y;
         addChild(skyGradientBox);
         groundGradientBox = new GradientBox3(2);
         groundGradientBox.x = ui.ground_colourBox_area_mc.x;
         groundGradientBox.y = ui.ground_colourBox_area_mc.y;
         addChild(groundGradientBox);
         borderGradientBox.addEventListener("COLOUR_OVER",border_setColour);
         skyGradientBox.addEventListener("COLOUR_OVER",sky_setColour);
         groundGradientBox.addEventListener("COLOUR_OVER",ground_setColour);
         borderGradientBox.addEventListener("SELECTED",border_setColour);
         skyGradientBox.addEventListener("SELECTED",sky_setColour);
         groundGradientBox.addEventListener("SELECTED",ground_setColour);
         borderGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            skyGradientBox.selected = groundGradientBox.selected = false;
         });
         skyGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            borderGradientBox.selected = groundGradientBox.selected = false;
         });
         groundGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            borderGradientBox.selected = skyGradientBox.selected = false;
         });
         ui.color_all_mc.addEventListener(MouseEvent.CLICK,click_colorAll);
         ui.link_mc.addEventListener(MouseEvent.CLICK,click_link);
         ui.color_all_mc.buttonMode = ui.link_mc.buttonMode = true;
         var tf:TextFormat = new TextFormat(BSConstants.VERDANA);
         for each(i in [ui.lbl_14b,ui.lbl_10b,ui.lbl_10b2,ui.lbl_10b3,ui.lbl_10b4,ui.lbl_10b5,ui.lbl_10b6,ui.cap])
         {
            BSConstants.tf_fix(i);
         }
         ui.cap.text = _("color all panels");
         ui.lbl_14b.text = _("How Many Panels Do You Want?");
         ui.lbl_10b.text = _("The \'New Yorker\'");
         ui.lbl_10b2.text = _("The \'Gag Strip\'");
         ui.lbl_10b3.text = _("The \'Story Strip\'");
         ui.lbl_10b4.text = _("Border");
         ui.lbl_10b5.text = _("Sky");
         ui.lbl_10b6.text = _("Ground");
         ui.color_all_mc.gotoAndStop(2);
      }
      
      private function click_link(param1:MouseEvent) : void
      {
         linked = !linked;
         if(linked)
         {
            ui.link_mc.gotoAndStop(1);
         }
         else
         {
            ui.link_mc.gotoAndStop(2);
         }
      }
      
      private function click_colorAll(param1:MouseEvent) : void
      {
         colorAll = !colorAll;
         if(colorAll)
         {
            ui.color_all_mc.gotoAndStop(2);
         }
         else
         {
            ui.color_all_mc.gotoAndStop(1);
         }
      }
      
      private function ground_setColour(param1:Event) : void
      {
         trace("--layout_controls.ground_setColour(" + groundGradientBox.colour + ")--");
         if(myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               myComicBuilder.pre_undo();
            }
            myComicBuilder.setGroundColour(groundGradientBox.colour,colorAll);
            if(linked)
            {
               myComicBuilder.setBackdropColour(groundGradientBox.colour,colorAll);
               skyGradientBox.set_colour(groundGradientBox.colour);
            }
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function px_enter(param1:TextEvent) : void
      {
         var _loc2_:int = int(param1.text);
         if(_loc2_ >= 1 && _loc2_ <= 8)
         {
            setPanelNum(_loc2_);
         }
      }
      
      private function setPanelNum(param1:int) : void
      {
         trace("--layout_controls.setPanelNum(" + param1 + ")--");
         if(myComicBuilder)
         {
            if(param1 > 0 && param1 <= 8)
            {
               myComicBuilder.setPanelNum_request(param1);
            }
         }
      }
      
      private function sky_setColour(param1:Event) : void
      {
         trace("--layout_controls.sky_setColour(" + skyGradientBox.colour + ")--");
         if(myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               myComicBuilder.pre_undo();
            }
            myComicBuilder.setBackdropColour(skyGradientBox.colour,colorAll);
            if(linked)
            {
               myComicBuilder.setGroundColour(skyGradientBox.colour,colorAll);
               groundGradientBox.set_colour(skyGradientBox.colour);
            }
         }
      }
      
      private function border_setColour(param1:Event) : void
      {
         trace("--layout_controls.border_setColour(" + borderGradientBox.colour + ")--");
         if(myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               myComicBuilder.pre_undo();
            }
            myComicBuilder.setBackgroundColour(borderGradientBox.colour);
         }
      }
   }
}
