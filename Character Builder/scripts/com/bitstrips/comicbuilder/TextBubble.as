package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.core.BubbleShape;
   import com.bitstrips.core.ColorTools;
   import com.bitstrips.ui.DashedLine;
   import com.gskinner.spelling.SpellingHighlighter;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TextBubble extends ComicAsset
   {
      
      public static const MAX_TAILS:int = 8;
       
      
      private var shapeClipOver:BubbleShape;
      
      private var formerLines:int = 2;
      
      private var c_font_size:Number = 14;
      
      private var pointer:BubblePointer;
      
      private var c_text_colour:int = 0;
      
      private var virgin:Boolean = true;
      
      private var sh:SpellingHighlighter;
      
      public var mini:Boolean = false;
      
      private var lightText:Boolean = false;
      
      private var textData:Object;
      
      private var c_italic:Boolean = false;
      
      private var pad:Number = 10;
      
      private var _version:int = 1;
      
      private var mode:TextBubbleType;
      
      private var c_font:String;
      
      private var _max_width:Number = 300;
      
      public var myField:TextField;
      
      private var shapeClipUnder:BubbleShape;
      
      private var dirty:Boolean = false;
      
      private var pointers:Array;
      
      private var c_bold:Boolean = false;
      
      private var bkgr:Sprite;
      
      private var bkgrOver:Sprite;
      
      private var c_underline:Boolean = false;
      
      public function TextBubble(param1:TextBubbleType)
      {
         c_font = BSConstants.CREATIVEBLOCK;
         debug = false;
         if(debug)
         {
            trace("--TextBubble()--");
         }
         super();
         mode = param1;
         init();
      }
      
      private function update_wrap() : void
      {
         if(myField.width <= _max_width)
         {
            myField.wordWrap = false;
         }
         else
         {
            myField.width = _max_width;
            myField.wordWrap = true;
         }
      }
      
      public function text_change(param1:Event) : void
      {
         if(debug)
         {
            trace("text_change EVENT");
         }
         virgin = false;
         onTextInput();
         inputText();
      }
      
      public function staticText_click(param1:MouseEvent) : void
      {
         staticText();
      }
      
      public function getPointer() : BubblePointer
      {
         return pointer;
      }
      
      override function move3D() : void
      {
         this.x = parent.mouseX - assetData["dragOffset"].x * this.scaleX;
         var _loc1_:Number = originPoint.y - stage.mouseY;
         this.font_size = this.font_size - _loc1_ / 2;
         originPoint = new Point(stage.mouseX,stage.mouseY);
      }
      
      public function get bubble_type() : String
      {
         return textData["style"];
      }
      
      private function init() : void
      {
         asset_type = "TextBubble";
         mouseChildren = true;
         bkgr = new Sprite();
         bkgrOver = new Sprite();
         bkgrOver.doubleClickEnabled = true;
         bkgrOver.mouseChildren = false;
         bkgrOver.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClick);
         pointer = new BubblePointer();
         pointer.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent);
         myField = new TextField();
         myField.defaultTextFormat = new TextFormat(BSConstants.CREATIVEBLOCK,13,null,null,null,null,null,null,TextFormatAlign.CENTER);
         myField.condenseWhite = false;
         myField.autoSize = TextFieldAutoSize.LEFT;
         myField.width = this._max_width;
         myField.height = 16;
         myField.selectable = true;
         myField.type = TextFieldType.DYNAMIC;
         myField.embedFonts = true;
         myField.multiline = true;
         myField.alwaysShowSelection = true;
         myField.useRichTextClipboard = true;
         myField.wordWrap = false;
         myField.x = -(myField.width / 2);
         shapeClipOver = new BubbleShape();
         shapeClipUnder = new BubbleShape();
         shapeClipOver.visible = false;
         shapeClipUnder.visible = false;
         shapeClipOver.lines = false;
         shapeClipOver.doubleClickEnabled = true;
         shapeClipOver.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClick);
         super.artwork.addChild(bkgr);
         super.artwork.addChild(shapeClipUnder);
         super.artwork.addChild(pointer);
         super.artwork.addChild(bkgrOver);
         super.artwork.addChild(shapeClipOver);
         super.artwork.addChild(myField);
         if(mode == TextBubbleType.PANEL || mode == TextBubbleType.PLAIN)
         {
            myField.addEventListener(MouseEvent.MOUSE_DOWN,editText_click,false,13);
            myField.addEventListener(MouseEvent.MOUSE_OVER,field_over);
            myField.addEventListener(MouseEvent.MOUSE_OUT,field_out);
            if(mode == TextBubbleType.PLAIN)
            {
               this.buttonMode = true;
            }
         }
         else if(mode == TextBubbleType.LIBRARY)
         {
            myField.mouseEnabled = false;
            super.artwork.filters = new Array();
         }
         sh = new SpellingHighlighter(myField);
         if(BSConstants.EDU == false)
         {
            sh.enabled = false;
         }
         pointers = [];
         loaded();
      }
      
      public function focusField() : void
      {
         if(debug)
         {
            trace("--TextBubble.focusField(" + stage + ")--");
         }
         if(stage)
         {
            if(stage.focus != myField)
            {
               activate();
               stage.focus = myField;
               if(debug)
               {
                  trace("Focus: " + stage.focus);
               }
            }
         }
      }
      
      override protected function nudgeMe(param1:KeyboardEvent) : void
      {
         if(myField && myField.type == TextFieldType.DYNAMIC)
         {
            super.nudgeMe(param1);
         }
      }
      
      public function inputText(param1:Boolean = false) : void
      {
         if(myField.wordWrap == false && myField.width <= _max_width)
         {
            myField.x = 0 - myField.width / 2;
            drawBubble();
            return;
         }
         var _loc2_:int = myField.numLines - formerLines;
         if(textData.style != "message")
         {
            pointer.bump({
               "x":0,
               "y":(Number(myField.getTextFormat().size) - 6) * _loc2_
            });
         }
         formerLines = myField.numLines;
         myField.wordWrap = false;
         if(myField.width > _max_width)
         {
            myField.width = _max_width;
            myField.wordWrap = true;
         }
         if(debug)
         {
            trace("myField.width: " + myField.width);
         }
         myField.x = -(myField.width / 2);
         var _loc3_:Number = this.getBounds(this).y;
         drawBubble();
         var _loc4_:Number = this.getBounds(this).y;
         this.y = this.y - (_loc4_ - _loc3_);
         sh.updateNow();
      }
      
      public function set bold(param1:Boolean) : void
      {
         dirty = true;
         apply_format(new TextFormat(null,null,null,param1));
      }
      
      public function set bubble_type(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         if(param1 != textData["style"])
         {
            if(param1 == "caption" && this.background_colour == 16777215)
            {
               this.background_colour = 16776960;
            }
            else if(textData["style"] == "caption" && this.background_colour == 16776960)
            {
               this.background_colour = 16777215;
            }
            _loc2_ = new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER);
            if(param1 == "borderless" || param1 == "caption")
            {
               _loc2_.align = TextFormatAlign.LEFT;
               pad = 5;
            }
            else
            {
               pad = 10;
            }
            myField.setTextFormat(_loc2_);
            textData["style"] = param1;
            drawBubble();
            pointer.drawMe();
         }
      }
      
      public function get text_colour() : Number
      {
         if(textData["textColor"] == undefined)
         {
            return -1;
         }
         return c_text_colour;
      }
      
      public function get max_width() : Number
      {
         return _max_width;
      }
      
      private function update_format() : void
      {
         update_stuff();
         if(dirty)
         {
            inputText();
         }
      }
      
      public function get italic() : Boolean
      {
         return c_italic;
      }
      
      override public function doubleClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.doubleClick()--");
         }
         editText();
         myField.setSelection(0,myField.text.length);
         if(myPanel)
         {
            myPanel.getComic().getComicBuilder().focusTab("bubble");
         }
      }
      
      public function get bubble_height() : Number
      {
         return myField.height;
      }
      
      public function set text_colour(param1:Number) : void
      {
         if(param1 == -1)
         {
            textData["textColor"] = undefined;
            setTextTint();
         }
         else
         {
            textData["textColor"] = true;
            apply_format(new TextFormat(null,null,param1));
         }
      }
      
      public function getContent() : String
      {
         return textData["content"];
      }
      
      public function setTextTint() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         if(textData["textColor"] == undefined)
         {
            _loc1_.color = 0;
            if(lightText)
            {
               _loc1_.color = 16777215;
            }
            myField.setTextFormat(_loc1_);
         }
      }
      
      override public function save_state() : Object
      {
         var _loc2_:BubblePointer = null;
         if(debug)
         {
            trace("--TextBubble.save_state()--");
         }
         var _loc1_:Object = super.save_state();
         textData["content"] = myField.text;
         textData["htmlContent"] = myField.htmlText;
         textData["lines"] = myField.numLines;
         if(debug)
         {
            trace("saving lightText: " + lightText);
         }
         textData["lightText"] = lightText;
         _loc1_["textData"] = textData;
         _loc1_["pointer"] = pointer.save_state();
         _loc1_["pointers"] = [];
         for each(_loc2_ in pointers)
         {
            _loc1_["pointers"].push(_loc2_.save_state());
         }
         _loc1_["y"] = this.y;
         _loc1_["version"] = Math.min(2,_version);
         return _loc1_;
      }
      
      public function startMoving(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.startMoving(" + param1.target + ")--");
         }
      }
      
      public function get bubble_width() : Number
      {
         return myField.width;
      }
      
      public function set max_width(param1:Number) : void
      {
         if(_version == 1)
         {
            return;
         }
         if(param1 == _max_width)
         {
            return;
         }
         _max_width = param1;
         inputText();
         if(debug)
         {
            trace("Max Width: " + _max_width);
         }
      }
      
      public function drawPointer() : void
      {
         var _loc1_:BubblePointer = null;
         pointer.load_state({"style":textData.style});
         pointer.drawMe();
         for each(_loc1_ in pointers)
         {
            _loc1_.drawMe();
         }
      }
      
      public function editText() : void
      {
         if(debug)
         {
            trace("--TextBubble.editText()--");
         }
         if(!mini && myPanel != null)
         {
            if(!_selected && myPanel.getComic().getEditable())
            {
               myPanel.getComic().selectAsset(this);
            }
         }
         if(stage && stage.focus != myField)
         {
            stage.focus = myField;
            stage.addEventListener(KeyboardEvent.KEY_DOWN,checkEnter);
            sh.enabled = true;
         }
         if(myField.type != TextFieldType.INPUT)
         {
            myField.type = TextFieldType.INPUT;
            myField.addEventListener(Event.CHANGE,text_change,false,100,true);
            bkgrOver.addEventListener(MouseEvent.MOUSE_DOWN,staticText_click);
            myField.addEventListener(MouseEvent.MOUSE_UP,update_selection);
            myField.addEventListener(KeyboardEvent.KEY_UP,update_selection);
         }
      }
      
      public function set italic(param1:Boolean) : void
      {
         dirty = true;
         apply_format(new TextFormat(null,null,null,null,param1));
      }
      
      override public function doSelect(param1:Boolean) : Boolean
      {
         var _loc2_:BubblePointer = null;
         if(debug)
         {
            trace("--TextBubble.doSelect(b: " + param1 + " hilightable: " + hilightable + ")--");
         }
         if(param1 && _selected == false)
         {
            myField.setSelection(0,myField.text.length);
         }
         super.doSelect(param1);
         if(param1 && hilightable)
         {
            if(debug)
            {
               trace("selecting text bubble");
            }
            if(virgin && (mode == TextBubbleType.PANEL || mode == TextBubbleType.PLAIN))
            {
               if(assetData["locked"] == false)
               {
                  myField.setSelection(0,myField.text.length);
                  editText();
               }
            }
         }
         else
         {
            if(debug)
            {
               trace("deselecting text bubble");
            }
            myField.type = TextFieldType.DYNAMIC;
            myField.setSelection(0,0);
            if(stage)
            {
               stage.focus = null;
            }
            if(virgin)
            {
               staticText();
            }
         }
         if(BSConstants.EDU == false)
         {
            sh.enabled = param1;
         }
         pointer.doSelect(param1);
         for each(_loc2_ in pointers)
         {
            _loc2_.doSelect(param1);
         }
         return false;
      }
      
      public function get font() : String
      {
         return c_font;
      }
      
      public function set spelling(param1:Boolean) : void
      {
         if(sh)
         {
            sh.enabled = param1;
            if(param1 == false)
            {
               sh.clear();
            }
         }
      }
      
      public function getSize() : Object
      {
         var _loc1_:Object = {
            "width":bkgr.width,
            "height":bkgr.height
         };
         return _loc1_;
      }
      
      private function load_old_text() : void
      {
         if(debug)
         {
            trace("--TextBubble.drawText(" + textData["content"] + ")--");
         }
         var _loc1_:TextFormat = new TextFormat(null,null,null,false,false,false);
         if(textData["bold"])
         {
            _loc1_.bold = true;
         }
         if(textData["italic"])
         {
            _loc1_.italic = true;
         }
         if(textData["underline"])
         {
            _loc1_.underline = true;
         }
         _loc1_.size = textData["size"];
         if(textData["textColor"] == undefined)
         {
            if(lightText)
            {
               _loc1_.color = 16777215;
            }
            else
            {
               _loc1_.color = 0;
            }
         }
         else
         {
            _loc1_.color = textData["textColor"];
         }
         var _loc2_:String = textData["content"];
         myField.text = _loc2_;
         if(BSConstants.EDU == false && textData["italic"])
         {
            myField.text = _loc2_.toUpperCase();
         }
         myField.setTextFormat(_loc1_);
         if(myField.width > _max_width)
         {
            myField.width = _max_width;
            myField.wordWrap = true;
            myField.text = textData["content"];
            myField.setTextFormat(_loc1_);
         }
         myField.x = -myField.width / 2;
      }
      
      public function remove_pointer() : uint
      {
         var _loc1_:BubblePointer = pointers.pop();
         this.artwork.removeChild(_loc1_);
         return pointers.length + 1;
      }
      
      public function get bold() : Boolean
      {
         return c_bold;
      }
      
      private function field_out(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.field_out()--");
         }
      }
      
      private function onTextInput() : void
      {
         var _loc1_:TextFormat = myField.getTextFormat();
         if(myField.embedFonts == true)
         {
            if(_loc1_.font != BSConstants.CREATIVEBLOCK)
            {
               myField.embedFonts = false;
               myField.setTextFormat(new TextFormat(c_font));
            }
         }
         else if(_loc1_.font == BSConstants.CREATIVEBLOCK)
         {
            myField.embedFonts = true;
         }
         if(textData["textColor"] == undefined)
         {
            if(_loc1_.color == null)
            {
               textData["textColor"] = true;
            }
         }
         update_stuff();
      }
      
      public function get pointer_count() : uint
      {
         return pointers.length + 1;
      }
      
      private function update_selection(param1:Event) : void
      {
         update_stuff();
      }
      
      public function set underline(param1:Boolean) : void
      {
         apply_format(new TextFormat(null,null,null,null,null,param1));
      }
      
      public function set font(param1:String) : void
      {
         if(param1.substr(0,1) == "_" && myField.embedFonts == false)
         {
            myField.embedFonts = true;
            myField.setTextFormat(new TextFormat(param1));
         }
         else if(myField.embedFonts == true)
         {
            myField.embedFonts = false;
            myField.setTextFormat(new TextFormat(param1));
         }
         else
         {
            apply_format(new TextFormat(param1));
         }
         inputText();
      }
      
      public function add_pointer(param1:Object = null) : uint
      {
         var _loc4_:Object = null;
         var _loc5_:Point = null;
         var _loc6_:Matrix = null;
         var _loc7_:Point = null;
         if(pointers.length >= TextBubble.MAX_TAILS)
         {
            return pointers.length;
         }
         var _loc2_:BubblePointer = new BubblePointer();
         _loc2_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         var _loc3_:int = this.artwork.getChildIndex(pointer);
         this.artwork.addChildAt(_loc2_,_loc3_ + 1);
         _loc2_.setBubble(this);
         if(param1 == null)
         {
            if(pointers.length >= 1)
            {
               _loc4_ = Utils.clone(pointers[pointers.length - 1].getData());
            }
            else
            {
               _loc4_ = Utils.clone(pointer.getData());
            }
            _loc5_ = new Point(_loc4_.controlX,_loc4_.controlY);
            _loc6_ = new Matrix();
            _loc6_.scale(1.01,1.01);
            _loc6_.rotate(57.29);
            _loc5_ = _loc6_.transformPoint(_loc5_);
            _loc7_ = this.localToGlobal(_loc5_);
            if(this.bkgr.hitTestPoint(_loc7_.x,_loc7_.y))
            {
               _loc5_.x = -this.bubble_width;
               _loc5_.y = this.bubble_height;
            }
            _loc4_.controlX = _loc5_.x;
            _loc4_.controlY = _loc5_.y;
            _loc2_.load_state(_loc4_);
         }
         else
         {
            _loc2_.load_state(param1);
         }
         pointers.push(_loc2_);
         _loc2_.drawMe();
         _loc2_.doSelect(this._selected);
         return pointers.length + 1;
      }
      
      public function editText_click(param1:MouseEvent) : void
      {
         if(assetData == null || !assetData["locked"])
         {
            param1.stopPropagation();
            editText();
         }
      }
      
      override public function setLock(param1:Boolean) : void
      {
         super.setLock(param1);
         myField.selectable = !param1;
      }
      
      private function checkEnter(param1:KeyboardEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.checkEnter(" + param1.keyCode + ")--");
         }
         if(param1.keyCode == 13)
         {
         }
      }
      
      public function setContent(param1:String) : void
      {
         textData["content"] = param1;
         myField.text = param1;
         if(myField.wordWrap == false && myField.width <= _max_width)
         {
            myField.x = 0 - myField.width / 2;
            drawBubble();
         }
      }
      
      public function get spelling() : Boolean
      {
         if(sh && sh.enabled)
         {
            return true;
         }
         return false;
      }
      
      public function staticText() : void
      {
         if(debug)
         {
            trace("--TextBubble.staticText()--");
         }
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,checkEnter);
            stage.focus = null;
            if(BSConstants.EDU == false)
            {
               sh.enabled = false;
            }
         }
         myField.type = TextFieldType.DYNAMIC;
         myField.removeEventListener(Event.CHANGE,text_change);
         bkgrOver.removeEventListener(MouseEvent.MOUSE_DOWN,staticText_click);
      }
      
      public function get underline() : Boolean
      {
         return this.c_underline;
      }
      
      override public function setColour(param1:Number) : void
      {
         var _loc2_:BubblePointer = null;
         var _loc3_:ColorTransform = null;
         var _loc4_:Object = null;
         textData["bkgrColor"] = param1;
         drawBubble();
         pointer.setColour(param1);
         for each(_loc2_ in pointers)
         {
            _loc2_.setColour(param1);
         }
         _loc3_ = new ColorTransform();
         _loc3_.color = param1;
         _loc3_.redOffset = _loc3_.redOffset + -255;
         _loc3_.greenOffset = _loc3_.greenOffset + -255;
         _loc3_.blueOffset = _loc3_.blueOffset + -255;
         _loc3_.redMultiplier = 1;
         _loc3_.greenMultiplier = 1;
         _loc3_.blueMultiplier = 1;
         shapeClipOver.transform.colorTransform = _loc3_;
         _loc4_ = ColorTools.RGBtoHSB(param1);
         if(_loc4_.b > 60)
         {
            if(lightText)
            {
               lightText = false;
               setTextTint();
            }
         }
         else if(!lightText)
         {
            lightText = true;
            setTextTint();
         }
      }
      
      public function set font_size(param1:int) : void
      {
         var _loc2_:Number = Math.min(96,Math.max(4,param1));
         if(_loc2_ >= 48)
         {
            myField.antiAliasType = AntiAliasType.NORMAL;
         }
         else
         {
            myField.antiAliasType = AntiAliasType.ADVANCED;
         }
         dirty = true;
         apply_format(new TextFormat(null,_loc2_));
      }
      
      private function apply_format(param1:TextFormat) : void
      {
         var _loc2_:int = myField.selectionBeginIndex;
         var _loc3_:int = myField.selectionEndIndex;
         if(_loc2_ == _loc3_)
         {
            myField.defaultTextFormat = param1;
         }
         else
         {
            myField.setTextFormat(param1,_loc2_,_loc3_);
            update_format();
         }
      }
      
      public function drawBubble() : void
      {
         var _loc7_:BubblePointer = null;
         var _loc8_:DashedLine = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(debug)
         {
            trace("--TextBubble.drawBubble(" + textData.style + ")--");
         }
         myField.y = -myField.height / 2;
         var _loc1_:Number = bkgr.height;
         pointer.visible = true;
         if(debug)
         {
            trace("myField.x: " + myField.x);
         }
         shapeClipOver.visible = this.shapeClipUnder.visible = false;
         bkgr.graphics.clear();
         bkgrOver.graphics.clear();
         var _loc2_:Rectangle = myField.getBounds(this);
         var _loc3_:Rectangle = new Rectangle(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2);
         switch(textData["style"])
         {
            case "normal":
               bkgr.graphics.beginFill(textData.bkgrColor);
               bkgr.graphics.lineStyle(4,0,1);
               bkgr.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,textData["cornerRound"],textData["cornerRound"]);
               bkgrOver.graphics.beginFill(textData.bkgrColor);
               bkgrOver.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,textData["cornerRound"],textData["cornerRound"]);
               break;
            case "whisper":
               if(debug)
               {
                  trace("whisper");
               }
               _loc8_ = new DashedLine(bkgr,6,6);
               _loc9_ = myField.y - pad;
               _loc10_ = myField.y - pad + (myField.height + pad * 2);
               _loc11_ = myField.x - pad + (myField.width + pad * 2);
               _loc12_ = myField.x - pad;
               _loc8_.beginFill(textData.bkgrColor);
               _loc8_.lineStyle(4,0,1);
               _loc8_.moveTo(_loc12_,_loc9_);
               _loc8_.lineTo(_loc11_,_loc9_);
               _loc8_.lineTo(_loc11_,_loc10_);
               _loc8_.lineTo(_loc12_,_loc10_);
               _loc8_.lineTo(_loc12_,_loc9_);
               bkgrOver.graphics.beginFill(textData.bkgrColor);
               bkgrOver.graphics.drawRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2);
               break;
            case "caption":
               pointer.visible = false;
               bkgr.graphics.beginFill(textData.bkgrColor);
               bkgr.graphics.lineStyle(4,0,1);
               bkgr.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
               bkgrOver.graphics.clear();
               bkgrOver.graphics.beginFill(textData.bkgrColor);
               bkgrOver.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
               break;
            case "borderless":
               pointer.visible = false;
               bkgr.graphics.beginFill(16777215,0.01);
               bkgr.graphics.lineStyle(4,0,0);
               bkgr.graphics.drawRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2);
               bkgrOver.graphics.beginFill(16777215,0.01);
               bkgrOver.graphics.drawRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2);
               break;
            case "message":
               myField.width = 190;
               myField.x = 0 - myField.width / 2;
               bkgr.graphics.clear();
               bkgr.graphics.beginFill(textData.bkgrColor);
               bkgr.graphics.lineStyle(4,0,1);
               bkgr.graphics.drawRoundRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2,textData["cornerRound"],textData["cornerRound"]);
               bkgrOver.graphics.clear();
               bkgrOver.graphics.beginFill(textData.bkgrColor);
               bkgrOver.graphics.drawRoundRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2,textData["cornerRound"],textData["cornerRound"]);
               break;
            case "quick":
               myField.x = 0 - myField.width / 2;
               bkgr.graphics.clear();
               bkgr.graphics.beginFill(textData.bkgrColor);
               bkgr.graphics.lineStyle(4,0,1);
               bkgr.graphics.drawRoundRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2,textData["cornerRound"],textData["cornerRound"]);
               bkgrOver.graphics.clear();
               bkgrOver.graphics.beginFill(textData.bkgrColor);
               bkgrOver.graphics.drawRoundRect(myField.x - pad,myField.y - pad,myField.width + pad * 2,myField.height + pad * 2,textData["cornerRound"],textData["cornerRound"]);
               break;
            case "thought":
               shapeClipOver.visible = true;
               shapeClipOver.style = "thought";
               shapeClipOver.graphics.lineStyle(2,0,1,false,"none");
               shapeClipOver.size(myField.width,myField.height);
               shapeClipUnder.visible = true;
               shapeClipUnder.style = "thought";
               shapeClipUnder.size(myField.width,myField.height);
               shapeClipUnder.graphics.lineStyle(2,0,1,false,"none");
               break;
            case "shout":
               shapeClipOver.visible = true;
               shapeClipOver.style = "shout";
               shapeClipOver.graphics.lineStyle(2,0,1,false,"none");
               shapeClipOver.size(myField.width,myField.height);
               shapeClipUnder.visible = true;
               shapeClipUnder.style = "shout";
               shapeClipUnder.graphics.lineStyle(2,0,1,false,"none");
               shapeClipUnder.size(myField.width,myField.height);
         }
         _loc1_ = bkgr.height - _loc1_;
         var _loc4_:Point = new Point(pointer.getData().controlX,pointer.getData().controlY);
         var _loc5_:Point = pointer.localToGlobal(_loc4_);
         var _loc6_:Number = 15;
         if(textData.style == "message")
         {
            pointer.load_state({"controlY":_loc4_.y - _loc1_ / 2});
         }
         sh.update();
         for each(_loc7_ in pointers)
         {
            _loc7_.visible = pointer.visible;
         }
         drawPointer();
         dirty = false;
      }
      
      public function get font_size() : int
      {
         return c_font_size;
      }
      
      public function activate() : void
      {
         myField.setSelection(0,myField.text.length);
         editText();
      }
      
      override public function load_state(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TextFormat = null;
         var _loc4_:String = null;
         var _loc5_:TextFormat = null;
         if(debug)
         {
            trace("--TextBubble.load_state()--");
         }
         super.load_state(param1);
         if(param1["version"])
         {
            _version = param1["version"];
         }
         textData = assetData["textData"];
         if(!textData["cornerRound"])
         {
            textData["cornerRound"] = 20;
         }
         if(textData["maxWidth"])
         {
            _max_width = textData["maxWidth"];
         }
         myField.width = _max_width;
         myField.x = -myField.width / 2;
         if(textData["lines"])
         {
            formerLines = textData["lines"];
         }
         pointer.setBubble(this);
         this.setColour(textData["bkgrColor"]);
         if(param1.pointer)
         {
            pointer.load_state(param1.pointer);
         }
         else
         {
            pointer.load_state({
               "bkgrColor":16777215,
               "controlX":0,
               "controlY":40
            });
         }
         if(param1.pointers)
         {
            for each(_loc2_ in param1.pointers)
            {
               add_pointer(_loc2_);
            }
         }
         if(_version >= 4 && (textData["style"] == "borderless" || textData["style"] == "caption"))
         {
            pad = 5;
            _loc3_ = myField.defaultTextFormat;
            _loc3_.align = TextFormatAlign.LEFT;
            myField.defaultTextFormat = _loc3_;
         }
         if(textData["htmlContent"])
         {
            if(_version == 1)
            {
               _version = 2;
            }
            myField.htmlText = textData["htmlContent"];
            _loc4_ = myField.text.charAt(myField.text.length - 1);
            if(_loc4_ == "\r" || _loc4_ == "\n")
            {
               myField.replaceText(myField.text.length - 1,myField.text.length,"");
            }
            _loc5_ = myField.getTextFormat();
            if(_loc5_.font != BSConstants.CREATIVEBLOCK)
            {
               myField.embedFonts = false;
            }
            this.update_stuff();
         }
         else
         {
            load_old_text();
         }
         this.update_wrap();
         drawBubble();
         inputText();
         myField.getCharBoundaries(0);
      }
      
      private function field_over(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.field_over()--");
         }
         if(assetData != null && !assetData["locked"] && myPanel != null && myField.selectable)
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
            param1.stopPropagation();
         }
      }
      
      public function set background_colour(param1:Number) : void
      {
         this.setColour(param1);
      }
      
      public function get background_colour() : Number
      {
         return textData["bkgrColor"];
      }
      
      private function update_stuff() : void
      {
         var _loc3_:TextFormat = null;
         var _loc1_:int = myField.selectionBeginIndex;
         var _loc2_:int = myField.selectionEndIndex;
         if(_loc1_ != _loc2_ && _loc2_ <= myField.text.length)
         {
            _loc3_ = myField.getTextFormat(_loc1_,_loc2_);
         }
         else
         {
            _loc3_ = myField.defaultTextFormat;
         }
         c_bold = c_italic = c_underline = false;
         if(_loc3_.bold)
         {
            c_bold = true;
         }
         if(_loc3_.italic)
         {
            c_italic = true;
         }
         if(_loc3_.underline)
         {
            c_underline = true;
         }
         c_text_colour = -1;
         if(_loc3_.color != null)
         {
            c_text_colour = Number(_loc3_.color);
         }
         c_font_size = -1;
         if(_loc3_.size != null)
         {
            c_font_size = Number(_loc3_.size);
         }
         c_font = "";
         if(_loc3_.font != null)
         {
            c_font = _loc3_.font;
         }
         dispatchEvent(new Event("SELECTION_UPDATE"));
      }
   }
}
