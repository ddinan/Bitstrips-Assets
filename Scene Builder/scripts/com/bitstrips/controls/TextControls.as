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
       
      
      private var _enabled:Boolean = true;
      
      public const normal_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("Regular\nSpeech"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"normal",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public var bubble_type:String = "normal";
      
      public var textGradientBox:GradientBox3;
      
      private var myComic:Comic;
      
      private var ui:TextControlsUI;
      
      public const thought_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("Thought\nBubble"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"thought",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      public var myGradientBox:GradientBox3;
      
      public const whisper_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("Whisper"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"whisper",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      private var _underline:Boolean = false;
      
      private var _italic:Boolean = false;
      
      public const shout_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("Shout!\nBubble"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"shout",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      private var debug:Boolean = false;
      
      private var font_cb:ComboBox;
      
      private var cb:ComboBox;
      
      private var font_index:Object;
      
      public const caption_data:Object = {
         "version":4,
         "id":"xx",
         "name":"textbubble",
         "type":"text bubble",
         "bmpURL":"givemetextbubble",
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("Caption\nBox"),
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
         "lockedGround":false,
         "lockedEditing":false,
         "position":{
            "x":100,
            "z":0,
            "float":130
         },
         "textData":{
            "content":_("No\nBorder"),
            "textColor":0,
            "bkgrColor":16777215,
            "style":"borderless",
            "bold":false,
            "italic":false,
            "size":13,
            "cornerRound":100
         }
      };
      
      private var bubbles:Array;
      
      private var _bold:Boolean = false;
      
      public var myText:TextBubble;
      
      private var bubble_data:Object;
      
      public function TextControls(param1:Comic = null)
      {
         bubbles = [];
         super();
         myComic = param1;
         ui = new TextControlsUI();
         addChild(ui);
         init();
         ui.no_bubble.visible = false;
         cb = new ComboBox();
         addChild(cb);
         var _loc2_:TextFormat = new TextFormat(BSConstants.VERDANA,null,null,true);
         cb.prompt = " ";
         cb.textField.setStyle("embedFonts",true);
         cb.textField.setStyle("textFormat",_loc2_);
         cb.dropdown.setRendererStyle("embedFonts",true);
         cb.dropdown.setRendererStyle("textFormat",_loc2_);
         var _loc3_:int = 4;
         while(_loc3_ <= 96)
         {
            cb.addItem({
               "label":_loc3_,
               "data":_loc3_
            });
            _loc3_ = _loc3_ + 2;
         }
         cb.x = 25;
         cb.y = 72;
         cb.width = 50;
         cb.addEventListener(Event.CHANGE,size_change);
         cb.selectedIndex = 5;
         var _loc4_:Array = Font.enumerateFonts(true);
         _loc4_.sortOn("fontName",Array.CASEINSENSITIVE);
         font_cb = new ComboBox();
         addChild(font_cb);
         font_cb.x = 13;
         font_cb.y = 36;
         font_cb.width = 150;
         cb.x = font_cb.x + 150 + 8;
         cb.y = font_cb.y;
         font_cb.prompt = " ";
         font_cb.textField.setStyle("embedFonts",true);
         font_cb.textField.setStyle("textFormat",_loc2_);
         font_cb.dropdown.setRendererStyle("embedFonts",true);
         font_cb.dropdown.setRendererStyle("textFormat",_loc2_);
         var _loc5_:int = 0;
         font_cb.addItem({
            "label":_("Default Font"),
            "data":BSConstants.CREATIVEBLOCK
         });
         font_index = {};
         font_index[BSConstants.CREATIVEBLOCK] = _loc5_;
         _loc5_ = _loc5_ + 1;
         this.enabled = false;
      }
      
      private function enable() : void
      {
         this.transform.colorTransform = new ColorTransform();
         ui.mouseEnabled = ui.mouseChildren = true;
      }
      
      private function set bold(param1:Boolean) : void
      {
         if(param1)
         {
            ui.bold_btn.gotoAndStop(2);
         }
         else
         {
            ui.bold_btn.gotoAndStop(1);
         }
         _bold = param1;
         if(myText && myText.bold != param1)
         {
            myText.bold = param1;
         }
      }
      
      private function init() : void
      {
         var type:String = null;
         var bubble:TextBubble = null;
         ui.bold_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            bold = !_bold;
         });
         ui.i_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            italic = !_italic;
         });
         ui.u_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
            underline = !_underline;
         });
         ui.bold_btn.buttonMode = ui.i_btn.buttonMode = ui.u_btn.buttonMode = true;
         bubble_data = {
            "normal":normal_data,
            "whisper":whisper_data,
            "caption":caption_data,
            "borderless":borderless_data,
            "thought":thought_data,
            "shout":shout_data
         };
         var bubble_width:Number = (ui.bubbleMenu_area_mc.width - 10) / 6;
         var offset:Number = ui.bubbleMenu_area_mc.x + 50;
         var i:int = 0;
         while(i < bubble_order.length)
         {
            type = bubble_order[i];
            bubble = new TextBubble(TextBubbleType.LIBRARY);
            bubble.load_state(bubble_data[type]);
            bubble.buttonMode = true;
            bubble.name = type;
            bubble.addEventListener(MouseEvent.MOUSE_DOWN,bubble_down);
            addChild(bubble);
            Utils.scale_me(bubble,bubble_width - 5,ui.bubbleMenu_area_mc.height - 10);
            if(bubble.scaleX > 1)
            {
               bubble.scaleX = bubble.scaleY = 1;
            }
            Utils.center_piece(bubble,this,offset + bubble_width * i,ui.bubbleMenu_area_mc.y + ui.bubbleMenu_area_mc.height / 2);
            bubble.y = ui.bubbleMenu_area_mc.y + ui.bubbleMenu_area_mc.height / 2;
            bubbles[type] = bubble;
            Utils.over_out(bubble);
            i++;
         }
         ui.no_bubble.addEventListener(MouseEvent.MOUSE_DOWN,click_no_bubble);
         ui.no_bubble.buttonMode = true;
         textGradientBox = new GradientBox3(0);
         textGradientBox.x = ui.fg_colourBox.x;
         textGradientBox.y = ui.fg_colourBox.y;
         addChild(textGradientBox);
         textGradientBox.addEventListener("COLOUR_OVER",text_setColour);
         textGradientBox.addEventListener("SELECTED",text_setColour);
         myGradientBox = new GradientBox3(0);
         myGradientBox.x = ui.colourBox_area_mc.x;
         myGradientBox.y = ui.colourBox_area_mc.y;
         addChild(myGradientBox);
         myGradientBox.addEventListener("COLOUR_OVER",setColour);
         myGradientBox.addEventListener("SELECTED",setColour);
         myGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            textGradientBox.selected = false;
         });
         textGradientBox.addEventListener("SELECTED",function(param1:Event):void
         {
            myGradientBox.selected = false;
         });
         ui.multi_tail.tail_minus.addEventListener(MouseEvent.CLICK,remove_tail);
         ui.multi_tail.tail_plus.addEventListener(MouseEvent.CLICK,add_tail);
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         _enabled = param1;
         var _loc2_:Array = [this.ui.bold_btn,this.ui.i_btn,this.ui.u_btn,this.cb,this.textGradientBox,this.myGradientBox,this.font_cb,this.ui.bg_icon,this.ui.multi_tail];
         if(_enabled)
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
         Utils.enable_shade_btn(ui.multi_tail.tail_minus);
         Utils.enable_shade_btn(ui.multi_tail.tail_plus);
      }
      
      private function set underline(param1:Boolean) : void
      {
         if(param1)
         {
            ui.u_btn.gotoAndStop(2);
         }
         else
         {
            ui.u_btn.gotoAndStop(1);
         }
         _underline = param1;
         if(myText && myText.underline != param1)
         {
            myText.underline = param1;
         }
      }
      
      public function register(param1:TextBubble) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         trace("--text_controls.register()--");
         if(myText)
         {
            removeEventListener("SELECTION_UPDATE",selection_update);
         }
         if(param1 == null)
         {
            this.enabled = false;
            myText = null;
         }
         else
         {
            this.enabled = true;
            myText = param1;
            myText.addEventListener("SELECTION_UPDATE",selection_update,false,0,true);
            selection_update(new Event("SELECTION_UPDATE"));
            this.myGradientBox.set_colour(myText.background_colour);
            this.textGradientBox.selected = false;
            this.myGradientBox.selected = false;
            _loc2_ = myText.bubble_type;
            if(_loc2_ == "caption" || _loc2_ == "borderless")
            {
               Utils.disable_shade(ui.multi_tail);
            }
            else
            {
               _loc3_ = myText.pointer_count;
               Utils.enable_shade_btn(ui.multi_tail.tail_minus);
               Utils.enable_shade_btn(ui.multi_tail.tail_plus);
               if(_loc3_ == 1)
               {
                  Utils.disable_shade_btn(ui.multi_tail.tail_minus);
               }
               else if(_loc3_ == 8)
               {
                  Utils.disable_shade_btn(ui.multi_tail.tail_plus);
               }
            }
         }
      }
      
      private function bubble_click(param1:MouseEvent) : void
      {
         bubble_type = param1.currentTarget.name;
         dispatchEvent(new Event("BUBBLE_TYPE"));
         if(this.myText)
         {
            this.myText.bubble_type = bubble_type;
            update_selected_hilight();
         }
         else
         {
            dragAsset(bubble_data[bubble_type]);
         }
      }
      
      private function remove_tail(param1:Event) : void
      {
         if(this.myText)
         {
            if(this.myText.remove_pointer() == 1)
            {
               Utils.disable_shade_btn(ui.multi_tail.tail_minus);
            }
            Utils.enable_shade_btn(ui.multi_tail.tail_plus);
         }
      }
      
      private function size_change(param1:Event) : void
      {
         if(myText == null)
         {
            return;
         }
         var _loc2_:int = int(param1.currentTarget.value);
         if(_loc2_ >= 4 && myText.font_size != _loc2_)
         {
            myText.font_size = int(param1.currentTarget.value);
            if(myComic)
            {
               myComic.pre_undo();
            }
         }
      }
      
      private function dragAsset(param1:Object) : void
      {
         trace("--text_controls.dragAsset()--");
         param1.position = null;
         param1.dragOffset = new Point(0,0);
         dispatchEvent(new AssetDragEvent(AssetDragEvent.ASSET_DRAG,param1));
      }
      
      private function add_tail(param1:Event) : void
      {
         if(this.myText)
         {
            if(this.myText.add_pointer() >= TextBubble.MAX_TAILS)
            {
               Utils.disable_shade_btn(ui.multi_tail.tail_plus);
            }
            Utils.enable_shade_btn(ui.multi_tail.tail_minus);
         }
      }
      
      private function font_change(param1:Event) : void
      {
         if(myText == null)
         {
            return;
         }
         myText.font = param1.currentTarget.value;
      }
      
      private function text_setColour(param1:Event) : void
      {
         if(myText == null)
         {
            return;
         }
         if(param1.type == "COLOUR_OVER")
         {
            if(stage && stage.focus != null)
            {
               stage.focus = null;
               myText.myField.alwaysShowSelection = false;
            }
         }
         else if(param1.type == "SELECTED")
         {
            trace("Put focus back on the textfield");
            stage.focus = myText.myField;
            myText.myField.alwaysShowSelection = true;
         }
         if(myGradientBox.phase != 1)
         {
            if(myComic && myText)
            {
               myComic.pre_undo();
            }
         }
         myText.text_colour = textGradientBox.colour;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      private function setColour(param1:Event) : void
      {
         trace("--text_controls.setColour(" + myGradientBox.colour + ")--");
         dispatchEvent(new Event("NEW_COLOUR"));
         if(myText)
         {
            if(myGradientBox.phase != 1)
            {
               if(myComic && myText)
               {
                  myComic.pre_undo();
               }
            }
            myText.setColour(myGradientBox.colour);
         }
      }
      
      private function click_no_bubble(param1:MouseEvent) : void
      {
         bubble_type = "none";
         dispatchEvent(new Event("BUBBLE_TYPE"));
      }
      
      private function selection_update(param1:Event) : void
      {
         if(debug)
         {
            trace("TextControls - selection update");
         }
         if(myText == null)
         {
            trace("How\'d I get here?");
            return;
         }
         this.bold = myText.bold;
         this.italic = myText.italic;
         this.underline = myText.underline;
         var _loc2_:int = myText.font_size;
         if(_loc2_ == -1)
         {
            this.cb.selectedIndex = -1;
         }
         else
         {
            this.cb.selectedIndex = (_loc2_ - 4) / 2;
         }
         if(debug)
         {
            trace("Current Font:" + myText.font);
         }
         if(myText.font == "")
         {
            this.font_cb.selectedIndex = -1;
         }
         else
         {
            this.font_cb.selectedIndex = this.font_index[myText.font];
         }
         this.textGradientBox.set_colour(myText.text_colour);
         this.myGradientBox.set_colour(myText.background_colour);
      }
      
      private function set italic(param1:Boolean) : void
      {
         if(param1)
         {
            ui.i_btn.gotoAndStop(2);
         }
         else
         {
            ui.i_btn.gotoAndStop(1);
         }
         _italic = param1;
         if(myText && myText.italic != param1)
         {
            myText.italic = param1;
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function disable() : void
      {
         this.transform.colorTransform = new ColorTransform(0.5,0.5,0.5);
         ui.mouseEnabled = ui.mouseChildren = false;
      }
      
      private function update_selected_hilight() : void
      {
         var _loc2_:* = null;
         var _loc1_:String = "";
         if(this.myText)
         {
            _loc1_ = this.myText.bubble_type;
         }
         for(_loc2_ in bubbles)
         {
            if(_loc2_ == _loc1_)
            {
               bubbles[_loc2_].selected = true;
               bubbles[_loc2_].filters = [Utils.selected_filter];
            }
            else
            {
               bubbles[_loc2_].selected = false;
               bubbles[_loc2_].filters = [];
            }
         }
      }
      
      public function hide_bubbles() : void
      {
         bubbles["thought"].visible = false;
         bubbles["shout"].visible = false;
         ui.no_bubble.visible = true;
      }
      
      private function bubble_down(param1:MouseEvent) : void
      {
         bubble_type = param1.currentTarget.name;
         dragAsset(bubble_data[bubble_type]);
      }
   }
}
