package com.bitstrips.controls
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.comicbuilder.Comic;
   import com.bitstrips.comicbuilder.TextBubble;
   import com.bitstrips.comicbuilder.TextBubbleType;
   import com.bitstrips.comicbuilder.library.AssetDragEvent;
   import com.bitstrips.ui.GradientBox3;
   import fl.controls.ComboBox;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.Font;
   import flash.text.TextFormat;
   
   public class TextControls extends Sprite
   {
      
      private static const bubble_order:Array = ["normal","whisper","caption","borderless","thought","shout"];
       
      
      private var myComic:Comic;
      
      private var ui:TextControlsUI;
      
      private var _enabled:Boolean = true;
      
      public var myText:TextBubble;
      
      public var myGradientBox:GradientBox3;
      
      public var textGradientBox:GradientBox3;
      
      public var bubble_type:String = "normal";
      
      public const normal_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("Regular\nSpeech"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"normal",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public const whisper_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("Whisper"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"whisper",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public const caption_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("Caption\nBox"),
            "textColor":0,
            "bkgrColor":16776960,
            "style":"caption",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public const borderless_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("No\nBorder"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"borderless",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public const thought_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("Thought\nBubble"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"thought",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public const shout_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":this._("Shout!\nBubble"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"shout",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      private var bubble_data:Object;
      
      private var bubbles:Array;
      
      private var _bold:Boolean = false;
      
      private var _italic:Boolean = false;
      
      private var _underline:Boolean = false;
      
      private var cb:ComboBox;
      
      private var font_cb:ComboBox;
      
      private var font_index:Object;
      
      private var debug:Boolean = false;
      
      public function TextControls(param1:Comic = null)
      {
         this.bubbles = [];
         super();
         this.myComic = param1;
         this.ui = new TextControlsUI();
         addChild(this.ui);
         this.init();
         this.ui.no_bubble.visible = false;
         this.cb = new ComboBox();
         addChild(this.cb);
         var _loc2_:TextFormat = new TextFormat(BSConstants.VERDANA,null,null,true);
         this.cb.prompt = " ";
         this.cb.textField.setStyle("embedFonts",true);
         this.cb.textField.setStyle("textFormat",_loc2_);
         this.cb.dropdown.setRendererStyle("embedFonts",true);
         this.cb.dropdown.setRendererStyle("textFormat",_loc2_);
         var _loc3_:int = 4;
         while(_loc3_ <= 96)
         {
            this.cb.addItem({
               "label":_loc3_,
               "data":_loc3_
            });
            _loc3_ = _loc3_ + 2;
         }
         this.cb.x = 25;
         this.cb.y = 72;
         this.cb.width = 50;
         this.cb.addEventListener(Event.CHANGE,this.size_change);
         this.cb.selectedIndex = 5;
         var _loc4_:Array = Font.enumerateFonts(true);
         _loc4_.sortOn("fontName",Array.CASEINSENSITIVE);
         this.font_cb = new ComboBox();
         addChild(this.font_cb);
         this.font_cb.x = 13;
         this.font_cb.y = 36;
         this.font_cb.width = 150;
         this.cb.x = this.font_cb.x + 150 + 8;
         this.cb.y = this.font_cb.y;
         this.font_cb.prompt = " ";
         this.font_cb.textField.setStyle("embedFonts",true);
         this.font_cb.textField.setStyle("textFormat",_loc2_);
         this.font_cb.dropdown.setRendererStyle("embedFonts",true);
         this.font_cb.dropdown.setRendererStyle("textFormat",_loc2_);
         var _loc5_:int = 0;
         this.font_cb.addItem({
            "label":this._("Default Font"),
            "data":BSConstants.CREATIVEBLOCK
         });
         this.font_index = {};
         this.font_index[BSConstants.CREATIVEBLOCK] = _loc5_;
         _loc5_ = _loc5_ + 1;
         this.enabled = false;
      }
      
      private function size_change(param1:Event) : void
      {
         if(this.myText == null)
         {
            return;
         }
         var _loc2_:int = int(param1.currentTarget.value);
         if(_loc2_ >= 4 && this.myText.font_size != _loc2_)
         {
            this.myText.font_size = int(param1.currentTarget.value);
            if(this.myComic)
            {
               this.myComic.pre_undo();
            }
         }
      }
      
      private function font_change(param1:Event) : void
      {
         if(this.myText == null)
         {
            return;
         }
         this.myText.font = param1.currentTarget.value;
      }
      
      private function disable() : void
      {
         this.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         this.ui.mouseEnabled = this.ui.mouseChildren = false;
      }
      
      private function enable() : void
      {
         this.transform.colorTransform = new ColorTransform();
         this.ui.mouseEnabled = this.ui.mouseChildren = true;
      }
      
      private function init() : void
      {
         var type:String = null;
         var bubble:TextBubble = null;
         this.ui.bold_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            bold = !_bold;
         });
         this.ui.i_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            italic = !_italic;
         });
         this.ui.u_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            underline = !_underline;
         });
         this.ui.bold_btn.buttonMode = this.ui.i_btn.buttonMode = this.ui.u_btn.buttonMode = true;
         this.bubble_data = {
            "normal":this.normal_data,
            "whisper":this.whisper_data,
            "caption":this.caption_data,
            "borderless":this.borderless_data,
            "thought":this.thought_data,
            "shout":this.shout_data
         };
         var bubble_width:Number = (this.ui.bubbleMenu_area_mc.width - 10) / 6;
         var offset:Number = this.ui.bubbleMenu_area_mc.x + 50;
         var i:int = 0;
         while(i < bubble_order.length)
         {
            type = bubble_order[i];
            bubble = new TextBubble(TextBubbleType.LIBRARY);
            bubble.load_state(this.bubble_data[type]);
            bubble.buttonMode = true;
            bubble.name = type;
            bubble.addEventListener(MouseEvent.MOUSE_DOWN,this.bubble_down);
            bubble.addEventListener(MouseEvent.CLICK,this.bubble_click);
            addChild(bubble);
            Utils.scale_me(bubble,bubble_width - 5,this.ui.bubbleMenu_area_mc.height - 10);
            if(bubble.scaleX > 1)
            {
               bubble.scaleX = bubble.scaleY = 1;
            }
            Utils.center_piece(bubble,this,offset + bubble_width * i,this.ui.bubbleMenu_area_mc.y + this.ui.bubbleMenu_area_mc.height / 2);
            bubble.y = this.ui.bubbleMenu_area_mc.y + this.ui.bubbleMenu_area_mc.height / 2;
            this.bubbles[type] = bubble;
            Utils.over_out(bubble);
            i++;
         }
         this.ui.no_bubble.addEventListener(MouseEvent.MOUSE_DOWN,this.click_no_bubble);
         this.ui.no_bubble.buttonMode = true;
         this.textGradientBox = new GradientBox3(0);
         this.textGradientBox.x = this.ui.fg_colourBox.x;
         this.textGradientBox.y = this.ui.fg_colourBox.y;
         addChild(this.textGradientBox);
         this.textGradientBox.addEventListener("COLOUR_OVER",this.text_setColour);
         this.textGradientBox.addEventListener("SELECTED",this.text_setColour);
         this.myGradientBox = new GradientBox3(0);
         this.myGradientBox.x = this.ui.colourBox_area_mc.x;
         this.myGradientBox.y = this.ui.colourBox_area_mc.y;
         addChild(this.myGradientBox);
         this.myGradientBox.addEventListener("COLOUR_OVER",this.setColour);
         this.myGradientBox.addEventListener("SELECTED",this.setColour);
         this.myGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            textGradientBox.selected = false;
         });
         this.textGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            myGradientBox.selected = false;
         });
         this.ui.multi_tail.tail_minus.addEventListener(MouseEvent.CLICK,this.remove_tail);
         this.ui.multi_tail.tail_plus.addEventListener(MouseEvent.CLICK,this.add_tail);
      }
      
      private function remove_tail(param1:Event) : void
      {
         if(this.myText)
         {
            if(this.myText.remove_pointer() == 1)
            {
               Utils.disable_shade_btn(this.ui.multi_tail.tail_minus);
            }
            Utils.enable_shade_btn(this.ui.multi_tail.tail_plus);
         }
      }
      
      private function add_tail(param1:Event) : void
      {
         if(this.myText)
         {
            if(this.myText.add_pointer() >= TextBubble.MAX_TAILS)
            {
               Utils.disable_shade_btn(this.ui.multi_tail.tail_plus);
            }
            Utils.enable_shade_btn(this.ui.multi_tail.tail_minus);
         }
      }
      
      public function hide_bubbles() : void
      {
         this.bubbles["thought"].visible = false;
         this.bubbles["shout"].visible = false;
         this.ui.no_bubble.visible = true;
      }
      
      private function setColour(param1:Event) : void
      {
         trace("--text_controls.setColour(" + this.myGradientBox.colour + ")--");
         dispatchEvent(new Event("NEW_COLOUR"));
         if(this.myText)
         {
            if(this.myGradientBox.phase != 1)
            {
               if(this.myComic && this.myText)
               {
                  this.myComic.pre_undo();
               }
            }
            this.myText.setColour(this.myGradientBox.colour);
         }
      }
      
      private function text_setColour(param1:Event) : void
      {
         if(this.myText == null)
         {
            return;
         }
         if(param1.type == "COLOUR_OVER")
         {
            if(stage && stage.focus != null)
            {
               stage.focus = null;
               this.myText.myField.alwaysShowSelection = false;
            }
         }
         else if(param1.type == "SELECTED")
         {
            trace("Put focus back on the textfield");
            stage.focus = this.myText.myField;
            this.myText.myField.alwaysShowSelection = true;
         }
         if(this.myGradientBox.phase != 1)
         {
            if(this.myComic && this.myText)
            {
               this.myComic.pre_undo();
            }
         }
         this.myText.text_colour = this.textGradientBox.colour;
      }
      
      private function update_selected_hilight() : void
      {
         var _loc2_:* = null;
         var _loc1_:String = "";
         if(this.myText)
         {
            _loc1_ = this.myText.bubble_type;
         }
         for(_loc2_ in this.bubbles)
         {
            if(_loc2_ == _loc1_)
            {
               this.bubbles[_loc2_].selected = true;
               this.bubbles[_loc2_].filters = [Utils.selected_filter];
            }
            else
            {
               this.bubbles[_loc2_].selected = false;
               this.bubbles[_loc2_].filters = [];
            }
         }
      }
      
      public function register(param1:TextBubble) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         trace("--text_controls.register()--");
         if(this.myText)
         {
            removeEventListener("SELECTION_UPDATE",this.selection_update);
         }
         if(param1 == null)
         {
            this.enabled = false;
            this.myText = null;
         }
         else
         {
            this.enabled = true;
            this.myText = param1;
            this.myText.addEventListener("SELECTION_UPDATE",this.selection_update,false,0,true);
            this.selection_update(new Event("SELECTION_UPDATE"));
            this.myGradientBox.set_colour(this.myText.background_colour);
            this.textGradientBox.selected = false;
            this.myGradientBox.selected = false;
            _loc2_ = this.myText.bubble_type;
            if(_loc2_ == "caption" || _loc2_ == "borderless")
            {
               Utils.disable_shade(this.ui.multi_tail);
            }
            else
            {
               _loc3_ = this.myText.pointer_count;
               Utils.enable_shade_btn(this.ui.multi_tail.tail_minus);
               Utils.enable_shade_btn(this.ui.multi_tail.tail_plus);
               if(_loc3_ == 1)
               {
                  Utils.disable_shade_btn(this.ui.multi_tail.tail_minus);
               }
               else if(_loc3_ == 8)
               {
                  Utils.disable_shade_btn(this.ui.multi_tail.tail_plus);
               }
            }
         }
      }
      
      private function selection_update(param1:Event) : void
      {
         if(this.debug)
         {
            trace("TextControls - selection update");
         }
         if(this.myText == null)
         {
            trace("How\'d I get here?");
            return;
         }
         this.bold = this.myText.bold;
         this.italic = this.myText.italic;
         this.underline = this.myText.underline;
         var _loc2_:int = this.myText.font_size;
         if(_loc2_ == -1)
         {
            this.cb.selectedIndex = -1;
         }
         else
         {
            this.cb.selectedIndex = (_loc2_ - 4) / 2;
         }
         if(this.debug)
         {
            trace("Current Font:" + this.myText.font);
         }
         if(this.myText.font == "")
         {
            this.font_cb.selectedIndex = -1;
         }
         else
         {
            this.font_cb.selectedIndex = this.font_index[this.myText.font];
         }
         this.textGradientBox.set_colour(this.myText.text_colour);
         this.myGradientBox.set_colour(this.myText.background_colour);
      }
      
      private function dragAsset(param1:Object) : void
      {
         trace("--text_controls.dragAsset()--");
         param1.position = null;
         param1.dragOffset = new Point(0,0);
         dispatchEvent(new AssetDragEvent(AssetDragEvent.ASSET_DRAG,param1));
      }
      
      private function click_no_bubble(param1:MouseEvent) : void
      {
         this.bubble_type = "none";
         dispatchEvent(new Event("BUBBLE_TYPE"));
      }
      
      private function bubble_down(param1:MouseEvent) : void
      {
         this.bubble_type = param1.currentTarget.name;
         this.dragAsset(this.bubble_data[this.bubble_type]);
      }
      
      private function bubble_click(param1:MouseEvent) : void
      {
         this.bubble_type = param1.currentTarget.name;
         dispatchEvent(new Event("BUBBLE_TYPE"));
      }
      
      private function set bold(param1:Boolean) : void
      {
         if(param1)
         {
            this.ui.bold_btn.gotoAndStop(2);
         }
         else
         {
            this.ui.bold_btn.gotoAndStop(1);
         }
         this._bold = param1;
         if(this.myText && this.myText.bold != param1)
         {
            this.myText.bold = param1;
         }
      }
      
      private function set italic(param1:Boolean) : void
      {
         if(param1)
         {
            this.ui.i_btn.gotoAndStop(2);
         }
         else
         {
            this.ui.i_btn.gotoAndStop(1);
         }
         this._italic = param1;
         if(this.myText && this.myText.italic != param1)
         {
            this.myText.italic = param1;
         }
      }
      
      private function set underline(param1:Boolean) : void
      {
         if(param1)
         {
            this.ui.u_btn.gotoAndStop(2);
         }
         else
         {
            this.ui.u_btn.gotoAndStop(1);
         }
         this._underline = param1;
         if(this.myText && this.myText.underline != param1)
         {
            this.myText.underline = param1;
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         this._enabled = param1;
         var _loc2_:Array = [this.ui.bold_btn,this.ui.i_btn,this.ui.u_btn,this.cb,this.textGradientBox,this.myGradientBox,this.font_cb,this.ui.bg_icon,this.ui.multi_tail];
         if(this._enabled)
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.enable_shade(_loc3_);
            }
         }
         else
         {
            for each(_loc3_ in _loc2_)
            {
               Utils.disable_shade(_loc3_);
            }
         }
         Utils.enable_shade_btn(this.ui.multi_tail.tail_minus);
         Utils.enable_shade_btn(this.ui.multi_tail.tail_plus);
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
