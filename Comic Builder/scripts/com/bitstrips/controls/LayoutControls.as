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
      
      private var format:TextFormat;
      
      private var borderGradientBox:GradientBox3;
      
      private var skyGradientBox:GradientBox3;
      
      private var groundGradientBox:GradientBox3;
      
      private var colorAll:Boolean = true;
      
      private var linked:Boolean = true;
      
      private var ui:LayoutControlsUI;
      
      public var field:TextField;
      
      public function LayoutControls(param1:Boolean = false)
      {
         super();
         this.ui = new LayoutControlsUI();
         addChild(this.ui);
         this.ui.easy_btn.visible = false;
         this.init();
      }
      
      private function init() : void
      {
         var i:* = undefined;
         trace("init()");
         this.field = this.ui.field;
         this.ui.panel1_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(1);
         });
         this.ui.panel3_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(3);
         });
         this.ui.panel8_mc.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            setPanelNum(8);
         });
         this.ui.panel1_mc.buttonMode = this.ui.panel3_mc.buttonMode = this.ui.panel8_mc.buttonMode = true;
         this.format = new TextFormat();
         this.field.restrict = "1-8";
         this.field.maxChars = 1;
         this.field.text = "3";
         this.field.addEventListener(TextEvent.TEXT_INPUT,this.px_enter);
         this.ui.easy_btn.addEventListener(MouseEvent.CLICK,this.goEasy);
         this.borderGradientBox = new GradientBox3(2);
         this.borderGradientBox.x = this.ui.border_colourBox_area_mc.x;
         this.borderGradientBox.y = this.ui.border_colourBox_area_mc.y;
         addChild(this.borderGradientBox);
         this.skyGradientBox = new GradientBox3(2);
         this.skyGradientBox.x = this.ui.sky_colourBox_area_mc.x;
         this.skyGradientBox.y = this.ui.sky_colourBox_area_mc.y;
         addChild(this.skyGradientBox);
         this.groundGradientBox = new GradientBox3(2);
         this.groundGradientBox.x = this.ui.ground_colourBox_area_mc.x;
         this.groundGradientBox.y = this.ui.ground_colourBox_area_mc.y;
         addChild(this.groundGradientBox);
         this.borderGradientBox.addEventListener("COLOUR_OVER",this.border_setColour);
         this.skyGradientBox.addEventListener("COLOUR_OVER",this.sky_setColour);
         this.groundGradientBox.addEventListener("COLOUR_OVER",this.ground_setColour);
         this.borderGradientBox.addEventListener("SELECTED",this.border_setColour);
         this.skyGradientBox.addEventListener("SELECTED",this.sky_setColour);
         this.groundGradientBox.addEventListener("SELECTED",this.ground_setColour);
         this.borderGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            skyGradientBox.selected = groundGradientBox.selected = false;
         });
         this.skyGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            borderGradientBox.selected = groundGradientBox.selected = false;
         });
         this.groundGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            borderGradientBox.selected = skyGradientBox.selected = false;
         });
         this.ui.color_all_mc.addEventListener(MouseEvent.CLICK,this.click_colorAll);
         this.ui.link_mc.addEventListener(MouseEvent.CLICK,this.click_link);
         this.ui.color_all_mc.buttonMode = this.ui.link_mc.buttonMode = true;
         var tf:TextFormat = new TextFormat(BSConstants.VERDANA);
         for each(i in [this.ui.lbl_14b,this.ui.lbl_10b,this.ui.lbl_10b2,this.ui.lbl_10b3,this.ui.lbl_10b4,this.ui.lbl_10b5,this.ui.lbl_10b6,this.ui.cap])
         {
            BSConstants.tf_fix(i);
         }
         this.ui.cap.text = this._("color all panels");
         this.ui.lbl_14b.text = this._("How Many Panels Do You Want?");
         this.ui.lbl_10b.text = this._("The \'New Yorker\'");
         this.ui.lbl_10b2.text = this._("The \'Gag Strip\'");
         this.ui.lbl_10b3.text = this._("The \'Story Strip\'");
         this.ui.lbl_10b4.text = this._("Border");
         this.ui.lbl_10b5.text = this._("Sky");
         this.ui.lbl_10b6.text = this._("Ground");
         this.ui.color_all_mc.gotoAndStop(2);
      }
      
      public function setComicBuilder(param1:ComicBuilder) : void
      {
         trace("--layout_controls.setComicBuilder()--");
         this.myComicBuilder = param1;
      }
      
      private function px_enter(param1:TextEvent) : void
      {
         var _loc2_:int = int(param1.text);
         if(_loc2_ >= 1 && _loc2_ <= 8)
         {
            this.setPanelNum(_loc2_);
         }
      }
      
      private function setPanelNum(param1:int) : void
      {
         trace("--layout_controls.setPanelNum(" + param1 + ")--");
         if(this.myComicBuilder)
         {
            if(param1 > 0 && param1 <= 8)
            {
               this.myComicBuilder.setPanelNum_request(param1);
            }
         }
      }
      
      private function border_setColour(param1:Event) : void
      {
         trace("--layout_controls.border_setColour(" + this.borderGradientBox.colour + ")--");
         if(this.myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               this.myComicBuilder.pre_undo();
            }
            this.myComicBuilder.setBackgroundColour(this.borderGradientBox.colour);
         }
      }
      
      private function sky_setColour(param1:Event) : void
      {
         trace("--layout_controls.sky_setColour(" + this.skyGradientBox.colour + ")--");
         if(this.myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               this.myComicBuilder.pre_undo();
            }
            this.myComicBuilder.setBackdropColour(this.skyGradientBox.colour,this.colorAll);
            if(this.linked)
            {
               this.myComicBuilder.setGroundColour(this.skyGradientBox.colour,this.colorAll);
               this.groundGradientBox.set_colour(this.skyGradientBox.colour);
            }
         }
      }
      
      private function ground_setColour(param1:Event) : void
      {
         trace("--layout_controls.ground_setColour(" + this.groundGradientBox.colour + ")--");
         if(this.myComicBuilder)
         {
            if(param1.currentTarget.phase == 2)
            {
               this.myComicBuilder.pre_undo();
            }
            this.myComicBuilder.setGroundColour(this.groundGradientBox.colour,this.colorAll);
            if(this.linked)
            {
               this.myComicBuilder.setBackdropColour(this.groundGradientBox.colour,this.colorAll);
               this.skyGradientBox.set_colour(this.groundGradientBox.colour);
            }
         }
      }
      
      private function goEasy(param1:MouseEvent) : void
      {
         trace("--layout_controls.goEasy()--");
         if(this.myComicBuilder)
         {
            this.myComicBuilder.goEasy_request();
         }
      }
      
      private function click_link(param1:MouseEvent) : void
      {
         this.linked = !this.linked;
         if(this.linked)
         {
            this.ui.link_mc.gotoAndStop(1);
         }
         else
         {
            this.ui.link_mc.gotoAndStop(2);
         }
      }
      
      private function click_colorAll(param1:MouseEvent) : void
      {
         this.colorAll = !this.colorAll;
         if(this.colorAll)
         {
            this.ui.color_all_mc.gotoAndStop(2);
         }
         else
         {
            this.ui.color_all_mc.gotoAndStop(1);
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
