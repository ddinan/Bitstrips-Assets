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
       
      
      private var bkgr:Sprite;
      
      private var bkgrOver:Sprite;
      
      private var shapeClipOver:BubbleShape;
      
      private var shapeClipUnder:BubbleShape;
      
      private var pointer:BubblePointer;
      
      private var pointers:Vector.<BubblePointer>;
      
      public var myField:TextField;
      
      private var pad:Number = 10;
      
      private var mode:TextBubbleType;
      
      private var textData:Object;
      
      private var virgin:Boolean = true;
      
      private var lightText:Boolean = false;
      
      private var _max_width:Number = 300;
      
      private var formerLines:int = 2;
      
      public var mini:Boolean = false;
      
      private var _version:int = 1;
      
      private var sh:SpellingHighlighter;
      
      private var dirty:Boolean = false;
      
      private var c_font:String;
      
      private var c_bold:Boolean = false;
      
      private var c_italic:Boolean = false;
      
      private var c_underline:Boolean = false;
      
      private var c_font_size:Number = 14;
      
      private var c_text_colour:int = 0;
      
      public function TextBubble(param1:TextBubbleType)
      {
         this.c_font = BSConstants.CREATIVEBLOCK;
         debug = false;
         if(debug)
         {
            trace("--TextBubble()--");
         }
         super();
         this.mode = param1;
         this.init();
      }
      
      private function init() : void
      {
         asset_type = "TextBubble";
         mouseChildren = true;
         this.bkgr = new Sprite();
         this.bkgrOver = new Sprite();
         this.bkgrOver.doubleClickEnabled = true;
         this.bkgrOver.mouseChildren = false;
         this.bkgrOver.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClick);
         this.pointer = new BubblePointer();
         this.pointer.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent);
         this.myField = new TextField();
         this.myField.defaultTextFormat = new TextFormat(BSConstants.CREATIVEBLOCK,13,null,null,null,null,null,null,TextFormatAlign.CENTER);
         this.myField.condenseWhite = false;
         this.myField.autoSize = TextFieldAutoSize.LEFT;
         this.myField.width = this._max_width;
         this.myField.height = 16;
         this.myField.selectable = true;
         this.myField.type = TextFieldType.DYNAMIC;
         this.myField.embedFonts = true;
         this.myField.multiline = true;
         this.myField.alwaysShowSelection = true;
         this.myField.useRichTextClipboard = true;
         this.myField.wordWrap = false;
         this.myField.x = -(this.myField.width / 2);
         this.shapeClipOver = new BubbleShape();
         this.shapeClipUnder = new BubbleShape();
         this.shapeClipOver.visible = false;
         this.shapeClipUnder.visible = false;
         this.shapeClipOver.lines = false;
         this.shapeClipOver.doubleClickEnabled = true;
         this.shapeClipOver.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClick);
         super.artwork.addChild(this.bkgr);
         super.artwork.addChild(this.shapeClipUnder);
         super.artwork.addChild(this.pointer);
         super.artwork.addChild(this.bkgrOver);
         super.artwork.addChild(this.shapeClipOver);
         super.artwork.addChild(this.myField);
         if(this.mode == TextBubbleType.PANEL || this.mode == TextBubbleType.PLAIN)
         {
            this.myField.addEventListener(MouseEvent.MOUSE_DOWN,this.editText_click,false,13);
            this.myField.addEventListener(MouseEvent.MOUSE_OVER,this.field_over);
            this.myField.addEventListener(MouseEvent.MOUSE_OUT,this.field_out);
            if(this.mode == TextBubbleType.PLAIN)
            {
               this.buttonMode = true;
            }
         }
         else if(this.mode == TextBubbleType.LIBRARY)
         {
            this.myField.mouseEnabled = false;
            super.artwork.filters = new Array();
         }
         this.sh = new SpellingHighlighter(this.myField);
         if(BSConstants.EDU == false)
         {
            this.sh.enabled = false;
         }
         this.pointers = new Vector.<BubblePointer>();
         loaded();
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
            this.myField.setSelection(0,this.myField.text.length);
         }
         super.doSelect(param1);
         if(param1 && hilightable)
         {
            if(debug)
            {
               trace("selecting text bubble");
            }
            if(this.virgin && (this.mode == TextBubbleType.PANEL || this.mode == TextBubbleType.PLAIN))
            {
               if(assetData["locked"] == false)
               {
                  this.myField.setSelection(0,this.myField.text.length);
                  this.editText();
               }
            }
         }
         else
         {
            if(debug)
            {
               trace("deselecting text bubble");
            }
            this.myField.type = TextFieldType.DYNAMIC;
            this.myField.setSelection(0,0);
            if(stage)
            {
               stage.focus = null;
            }
            if(this.virgin)
            {
               this.staticText();
            }
         }
         if(BSConstants.EDU == false)
         {
            this.sh.enabled = param1;
         }
         this.pointer.doSelect(param1);
         for each(_loc2_ in this.pointers)
         {
            _loc2_.doSelect(param1);
         }
         return false;
      }
      
      public function add_pointer(param1:Object = null) : uint
      {
         var _loc4_:Object = null;
         var _loc5_:Point = null;
         var _loc6_:Matrix = null;
         var _loc7_:Point = null;
         if(this.pointers.length >= TextBubble.MAX_TAILS)
         {
            return this.pointers.length;
         }
         var _loc2_:BubblePointer = new BubblePointer();
         _loc2_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         var _loc3_:int = this.artwork.getChildIndex(this.pointer);
         this.artwork.addChildAt(_loc2_,_loc3_ + 1);
         _loc2_.setBubble(this);
         if(param1 == null)
         {
            if(this.pointers.length >= 1)
            {
               _loc4_ = Utils.clone(this.pointers[this.pointers.length - 1].getData());
            }
            else
            {
               _loc4_ = Utils.clone(this.pointer.getData());
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
         this.pointers.push(_loc2_);
         _loc2_.drawMe();
         _loc2_.doSelect(this._selected);
         return this.pointers.length + 1;
      }
      
      public function remove_pointer() : uint
      {
         var _loc1_:BubblePointer = this.pointers.pop();
         this.artwork.removeChild(_loc1_);
         return this.pointers.length + 1;
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
      
      private function load_old_text() : void
      {
         if(debug)
         {
            trace("--TextBubble.drawText(" + this.textData["content"] + ")--");
         }
         var _loc1_:TextFormat = new TextFormat(null,null,null,false,false,false);
         if(this.textData["bold"])
         {
            _loc1_.bold = true;
         }
         if(this.textData["italic"])
         {
            _loc1_.italic = true;
         }
         if(this.textData["underline"])
         {
            _loc1_.underline = true;
         }
         _loc1_.size = this.textData["size"];
         if(this.textData["textColor"] == undefined)
         {
            if(this.lightText)
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
            _loc1_.color = this.textData["textColor"];
         }
         var _loc2_:String = this.textData["content"];
         this.myField.text = _loc2_;
         if(BSConstants.EDU == false && this.textData["italic"])
         {
            this.myField.text = _loc2_.toUpperCase();
         }
         this.myField.setTextFormat(_loc1_);
         if(this.myField.width > this._max_width)
         {
            this.myField.width = this._max_width;
            this.myField.wordWrap = true;
            this.myField.text = this.textData["content"];
            this.myField.setTextFormat(_loc1_);
         }
         this.myField.x = -this.myField.width / 2;
      }
      
      private function onTextInput() : void
      {
         var _loc1_:TextFormat = this.myField.getTextFormat();
         if(this.myField.embedFonts == true)
         {
            if(_loc1_.font != BSConstants.CREATIVEBLOCK)
            {
               this.myField.embedFonts = false;
               this.myField.setTextFormat(new TextFormat(this.c_font));
            }
         }
         else if(_loc1_.font == BSConstants.CREATIVEBLOCK)
         {
            this.myField.embedFonts = true;
         }
         if(this.textData["textColor"] == undefined)
         {
            if(_loc1_.color == null)
            {
               this.textData["textColor"] = true;
            }
         }
         this.update_stuff();
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
            trace("--TextBubble.drawBubble(" + this.textData.style + ")--");
         }
         this.myField.y = -this.myField.height / 2;
         var _loc1_:Number = this.bkgr.height;
         this.pointer.visible = true;
         if(debug)
         {
            trace("myField.x: " + this.myField.x);
         }
         this.shapeClipOver.visible = this.shapeClipUnder.visible = false;
         this.bkgr.graphics.clear();
         this.bkgrOver.graphics.clear();
         var _loc2_:Rectangle = this.myField.getBounds(this);
         var _loc3_:Rectangle = new Rectangle(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2);
         switch(this.textData["style"])
         {
            case "normal":
               this.bkgr.graphics.beginFill(this.textData.bkgrColor);
               this.bkgr.graphics.lineStyle(4,0,1);
               this.bkgr.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,this.textData["cornerRound"],this.textData["cornerRound"]);
               this.bkgrOver.graphics.beginFill(this.textData.bkgrColor);
               this.bkgrOver.graphics.drawRoundRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height,this.textData["cornerRound"],this.textData["cornerRound"]);
               break;
            case "whisper":
               if(debug)
               {
                  trace("whisper");
               }
               _loc8_ = new DashedLine(this.bkgr,6,6);
               _loc9_ = this.myField.y - this.pad;
               _loc10_ = this.myField.y - this.pad + (this.myField.height + this.pad * 2);
               _loc11_ = this.myField.x - this.pad + (this.myField.width + this.pad * 2);
               _loc12_ = this.myField.x - this.pad;
               _loc8_.beginFill(this.textData.bkgrColor);
               _loc8_.lineStyle(4,0,1);
               _loc8_.moveTo(_loc12_,_loc9_);
               _loc8_.lineTo(_loc11_,_loc9_);
               _loc8_.lineTo(_loc11_,_loc10_);
               _loc8_.lineTo(_loc12_,_loc10_);
               _loc8_.lineTo(_loc12_,_loc9_);
               this.bkgrOver.graphics.beginFill(this.textData.bkgrColor);
               this.bkgrOver.graphics.drawRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2);
               break;
            case "caption":
               this.pointer.visible = false;
               this.bkgr.graphics.beginFill(this.textData.bkgrColor);
               this.bkgr.graphics.lineStyle(4,0,1);
               this.bkgr.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
               this.bkgrOver.graphics.clear();
               this.bkgrOver.graphics.beginFill(this.textData.bkgrColor);
               this.bkgrOver.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
               break;
            case "borderless":
               this.pointer.visible = false;
               this.bkgr.graphics.beginFill(16777215,0.01);
               this.bkgr.graphics.lineStyle(4,0,0);
               this.bkgr.graphics.drawRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2);
               this.bkgrOver.graphics.beginFill(16777215,0.01);
               this.bkgrOver.graphics.drawRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2);
               break;
            case "message":
               this.myField.width = 190;
               this.myField.x = 0 - this.myField.width / 2;
               this.bkgr.graphics.clear();
               this.bkgr.graphics.beginFill(this.textData.bkgrColor);
               this.bkgr.graphics.lineStyle(4,0,1);
               this.bkgr.graphics.drawRoundRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2,this.textData["cornerRound"],this.textData["cornerRound"]);
               this.bkgrOver.graphics.clear();
               this.bkgrOver.graphics.beginFill(this.textData.bkgrColor);
               this.bkgrOver.graphics.drawRoundRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2,this.textData["cornerRound"],this.textData["cornerRound"]);
               break;
            case "quick":
               this.myField.x = 0 - this.myField.width / 2;
               this.bkgr.graphics.clear();
               this.bkgr.graphics.beginFill(this.textData.bkgrColor);
               this.bkgr.graphics.lineStyle(4,0,1);
               this.bkgr.graphics.drawRoundRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2,this.textData["cornerRound"],this.textData["cornerRound"]);
               this.bkgrOver.graphics.clear();
               this.bkgrOver.graphics.beginFill(this.textData.bkgrColor);
               this.bkgrOver.graphics.drawRoundRect(this.myField.x - this.pad,this.myField.y - this.pad,this.myField.width + this.pad * 2,this.myField.height + this.pad * 2,this.textData["cornerRound"],this.textData["cornerRound"]);
               break;
            case "thought":
               this.shapeClipOver.visible = true;
               this.shapeClipOver.style = "thought";
               this.shapeClipOver.graphics.lineStyle(2,0,1,false,"none");
               this.shapeClipOver.size(this.myField.width,this.myField.height);
               this.shapeClipUnder.visible = true;
               this.shapeClipUnder.style = "thought";
               this.shapeClipUnder.size(this.myField.width,this.myField.height);
               this.shapeClipUnder.graphics.lineStyle(2,0,1,false,"none");
               break;
            case "shout":
               this.shapeClipOver.visible = true;
               this.shapeClipOver.style = "shout";
               this.shapeClipOver.graphics.lineStyle(2,0,1,false,"none");
               this.shapeClipOver.size(this.myField.width,this.myField.height);
               this.shapeClipUnder.visible = true;
               this.shapeClipUnder.style = "shout";
               this.shapeClipUnder.graphics.lineStyle(2,0,1,false,"none");
               this.shapeClipUnder.size(this.myField.width,this.myField.height);
         }
         _loc1_ = this.bkgr.height - _loc1_;
         var _loc4_:Point = new Point(this.pointer.getData().controlX,this.pointer.getData().controlY);
         var _loc5_:Point = this.pointer.localToGlobal(_loc4_);
         var _loc6_:Number = 15;
         if(this.textData.style == "message")
         {
            this.pointer.load_state({"controlY":_loc4_.y - _loc1_ / 2});
         }
         this.sh.update();
         for each(_loc7_ in this.pointers)
         {
            _loc7_.visible = this.pointer.visible;
         }
         this.drawPointer();
         this.dirty = false;
      }
      
      public function get max_width() : Number
      {
         return this._max_width;
      }
      
      public function set max_width(param1:Number) : void
      {
         if(this._version == 1)
         {
            return;
         }
         if(param1 == this._max_width)
         {
            return;
         }
         this._max_width = param1;
         this.inputText();
         if(debug)
         {
            trace("Max Width: " + this._max_width);
         }
      }
      
      public function drawPointer() : void
      {
         var _loc1_:BubblePointer = null;
         this.pointer.load_state({"style":this.textData.style});
         this.pointer.drawMe();
         for each(_loc1_ in this.pointers)
         {
            _loc1_.drawMe();
         }
      }
      
      public function startMoving(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.startMoving(" + param1.target + ")--");
         }
      }
      
      public function editText_click(param1:MouseEvent) : void
      {
         if(assetData == null || !assetData["locked"])
         {
            param1.stopPropagation();
            this.editText();
         }
      }
      
      public function editText() : void
      {
         if(debug)
         {
            trace("--TextBubble.editText()--");
         }
         if(!this.mini && myPanel != null)
         {
            if(!_selected && myPanel.getComic().getEditable())
            {
               myPanel.getComic().selectAsset(this);
            }
         }
         if(stage && stage.focus != this.myField)
         {
            stage.focus = this.myField;
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.checkEnter);
            this.sh.enabled = true;
         }
         if(this.myField.type != TextFieldType.INPUT)
         {
            this.myField.type = TextFieldType.INPUT;
            this.myField.addEventListener(Event.CHANGE,this.text_change,false,100,true);
            this.bkgrOver.addEventListener(MouseEvent.MOUSE_DOWN,this.staticText_click);
            this.myField.addEventListener(MouseEvent.MOUSE_UP,this.update_selection);
            this.myField.addEventListener(KeyboardEvent.KEY_UP,this.update_selection);
         }
      }
      
      public function staticText_click(param1:MouseEvent) : void
      {
         this.staticText();
      }
      
      public function staticText() : void
      {
         if(debug)
         {
            trace("--TextBubble.staticText()--");
         }
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.checkEnter);
            stage.focus = null;
            if(BSConstants.EDU == false)
            {
               this.sh.enabled = false;
            }
         }
         this.myField.type = TextFieldType.DYNAMIC;
         this.myField.removeEventListener(Event.CHANGE,this.text_change);
         this.bkgrOver.removeEventListener(MouseEvent.MOUSE_DOWN,this.staticText_click);
      }
      
      public function text_change(param1:Event) : void
      {
         if(debug)
         {
            trace("text_change EVENT");
         }
         this.virgin = false;
         this.onTextInput();
         this.inputText();
      }
      
      private function update_wrap() : void
      {
         if(this.myField.width <= this._max_width)
         {
            this.myField.wordWrap = false;
         }
         else
         {
            this.myField.width = this._max_width;
            this.myField.wordWrap = true;
         }
      }
      
      public function inputText(param1:Boolean = false) : void
      {
         if(this.myField.wordWrap == false && this.myField.width <= this._max_width)
         {
            this.myField.x = 0 - this.myField.width / 2;
            this.drawBubble();
            return;
         }
         var _loc2_:int = this.myField.numLines - this.formerLines;
         if(this.textData.style != "message")
         {
            this.pointer.bump({
               "x":0,
               "y":(Number(this.myField.getTextFormat().size) - 6) * _loc2_
            });
         }
         this.formerLines = this.myField.numLines;
         this.myField.wordWrap = false;
         if(this.myField.width > this._max_width)
         {
            this.myField.width = this._max_width;
            this.myField.wordWrap = true;
         }
         if(debug)
         {
            trace("myField.width: " + this.myField.width);
         }
         this.myField.x = -(this.myField.width / 2);
         var _loc3_:Number = this.getBounds(this).y;
         this.drawBubble();
         var _loc4_:Number = this.getBounds(this).y;
         this.y = this.y - (_loc4_ - _loc3_);
         this.sh.updateNow();
      }
      
      private function apply_format(param1:TextFormat) : void
      {
         var _loc2_:int = this.myField.selectionBeginIndex;
         var _loc3_:int = this.myField.selectionEndIndex;
         if(_loc2_ == _loc3_)
         {
            this.myField.defaultTextFormat = param1;
         }
         else
         {
            this.myField.setTextFormat(param1,_loc2_,_loc3_);
            this.update_format();
         }
      }
      
      private function update_stuff() : void
      {
         var _loc3_:TextFormat = null;
         var _loc1_:int = this.myField.selectionBeginIndex;
         var _loc2_:int = this.myField.selectionEndIndex;
         if(_loc1_ != _loc2_ && _loc2_ <= this.myField.text.length)
         {
            _loc3_ = this.myField.getTextFormat(_loc1_,_loc2_);
         }
         else
         {
            _loc3_ = this.myField.defaultTextFormat;
         }
         this.c_bold = this.c_italic = this.c_underline = false;
         if(_loc3_.bold)
         {
            this.c_bold = true;
         }
         if(_loc3_.italic)
         {
            this.c_italic = true;
         }
         if(_loc3_.underline)
         {
            this.c_underline = true;
         }
         this.c_text_colour = -1;
         if(_loc3_.color != null)
         {
            this.c_text_colour = Number(_loc3_.color);
         }
         this.c_font_size = -1;
         if(_loc3_.size != null)
         {
            this.c_font_size = Number(_loc3_.size);
         }
         this.c_font = "";
         if(_loc3_.font != null)
         {
            this.c_font = _loc3_.font;
         }
         dispatchEvent(new Event("SELECTION_UPDATE"));
      }
      
      private function update_selection(param1:Event) : void
      {
         this.update_stuff();
      }
      
      private function update_format() : void
      {
         this.update_stuff();
         if(this.dirty)
         {
            this.inputText();
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
         this.textData["content"] = this.myField.text;
         this.textData["htmlContent"] = this.myField.htmlText;
         this.textData["lines"] = this.myField.numLines;
         if(debug)
         {
            trace("saving lightText: " + this.lightText);
         }
         this.textData["lightText"] = this.lightText;
         _loc1_["textData"] = this.textData;
         _loc1_["pointer"] = this.pointer.save_state();
         _loc1_["pointers"] = [];
         for each(_loc2_ in this.pointers)
         {
            _loc1_["pointers"].push(_loc2_.save_state());
         }
         _loc1_["y"] = this.y;
         _loc1_["version"] = Math.min(2,this._version);
         return _loc1_;
      }
      
      override function move3D() : void
      {
         this.x = parent.mouseX - assetData["dragOffset"].x * this.scaleX;
         var _loc1_:Number = originPoint.y - stage.mouseY;
         this.font_size = this.font_size - _loc1_ / 2;
         originPoint = new Point(stage.mouseX,stage.mouseY);
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
            this._version = param1["version"];
         }
         this.textData = assetData["textData"];
         if(!this.textData["cornerRound"])
         {
            this.textData["cornerRound"] = 20;
         }
         if(this.textData["maxWidth"])
         {
            this._max_width = this.textData["maxWidth"];
         }
         this.myField.width = this._max_width;
         this.myField.x = -this.myField.width / 2;
         if(this.textData["lines"])
         {
            this.formerLines = this.textData["lines"];
         }
         this.pointer.setBubble(this);
         this.setColour(this.textData["bkgrColor"]);
         if(param1.pointer)
         {
            this.pointer.load_state(param1.pointer);
         }
         else
         {
            this.pointer.load_state({
               "bkgrColor":16777215,
               "controlX":0,
               "controlY":40
            });
         }
         if(param1.pointers)
         {
            for each(_loc2_ in param1.pointers)
            {
               this.add_pointer(_loc2_);
            }
         }
         if(this._version >= 4 && (this.textData["style"] == "borderless" || this.textData["style"] == "caption"))
         {
            this.pad = 5;
            _loc3_ = this.myField.defaultTextFormat;
            _loc3_.align = TextFormatAlign.LEFT;
            this.myField.defaultTextFormat = _loc3_;
         }
         if(this.textData["htmlContent"])
         {
            if(this._version == 1)
            {
               this._version = 2;
            }
            this.myField.htmlText = this.textData["htmlContent"];
            _loc4_ = this.myField.text.charAt(this.myField.text.length - 1);
            if(_loc4_ == "\r" || _loc4_ == "\n")
            {
               this.myField.replaceText(this.myField.text.length - 1,this.myField.text.length,"");
            }
            _loc5_ = this.myField.getTextFormat();
            if(_loc5_.font != BSConstants.CREATIVEBLOCK)
            {
               this.myField.embedFonts = false;
            }
            this.update_stuff();
         }
         else
         {
            this.load_old_text();
         }
         this.update_wrap();
         this.drawBubble();
         this.inputText();
         this.myField.getCharBoundaries(0);
      }
      
      public function get text_colour() : Number
      {
         if(this.textData["textColor"] == undefined)
         {
            return -1;
         }
         return this.c_text_colour;
      }
      
      public function set text_colour(param1:Number) : void
      {
         if(param1 == -1)
         {
            this.textData["textColor"] = undefined;
            this.setTextTint();
         }
         else
         {
            this.textData["textColor"] = true;
            this.apply_format(new TextFormat(null,null,param1));
         }
      }
      
      public function set background_colour(param1:Number) : void
      {
         this.setColour(param1);
      }
      
      public function get background_colour() : Number
      {
         return this.textData["bkgrColor"];
      }
      
      public function get bubble_width() : Number
      {
         return this.myField.width;
      }
      
      public function get bubble_height() : Number
      {
         return this.myField.height;
      }
      
      override public function setColour(param1:Number) : void
      {
         var _loc2_:BubblePointer = null;
         var _loc3_:ColorTransform = null;
         var _loc4_:Object = null;
         this.textData["bkgrColor"] = param1;
         this.drawBubble();
         this.pointer.setColour(param1);
         for each(_loc2_ in this.pointers)
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
         this.shapeClipOver.transform.colorTransform = _loc3_;
         _loc4_ = ColorTools.RGBtoHSB(param1);
         if(_loc4_.b > 60)
         {
            if(this.lightText)
            {
               this.lightText = false;
               this.setTextTint();
            }
         }
         else if(!this.lightText)
         {
            this.lightText = true;
            this.setTextTint();
         }
      }
      
      public function setTextTint() : void
      {
         var _loc1_:TextFormat = new TextFormat();
         if(this.textData["textColor"] == undefined)
         {
            _loc1_.color = 0;
            if(this.lightText)
            {
               _loc1_.color = 16777215;
            }
            this.myField.setTextFormat(_loc1_);
         }
      }
      
      override protected function nudgeMe(param1:KeyboardEvent) : void
      {
         if(this.myField && this.myField.type == TextFieldType.DYNAMIC)
         {
            super.nudgeMe(param1);
         }
      }
      
      override public function doubleClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.doubleClick()--");
         }
         this.editText();
         this.myField.setSelection(0,this.myField.text.length);
         if(myPanel)
         {
            myPanel.getComic().getComicBuilder().focusTab("bubble");
         }
      }
      
      private function field_over(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.field_over()--");
         }
         if(assetData != null && !assetData["locked"] && myPanel != null && this.myField.selectable)
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
            param1.stopPropagation();
         }
      }
      
      private function field_out(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--TextBubble.field_out()--");
         }
      }
      
      override public function setLock(param1:Boolean) : void
      {
         super.setLock(param1);
         this.myField.selectable = !param1;
      }
      
      public function getContent() : String
      {
         return this.textData["content"];
      }
      
      public function setContent(param1:String) : void
      {
         this.textData["content"] = param1;
         this.myField.text = param1;
         if(this.myField.wordWrap == false && this.myField.width <= this._max_width)
         {
            this.myField.x = 0 - this.myField.width / 2;
            this.drawBubble();
         }
      }
      
      public function activate() : void
      {
         this.myField.setSelection(0,this.myField.text.length);
         this.editText();
      }
      
      public function focusField() : void
      {
         if(debug)
         {
            trace("--TextBubble.focusField(" + stage + ")--");
         }
         if(stage)
         {
            if(stage.focus != this.myField)
            {
               this.activate();
               stage.focus = this.myField;
               if(debug)
               {
                  trace("Focus: " + stage.focus);
               }
            }
         }
      }
      
      public function getSize() : Object
      {
         var _loc1_:Object = {
            "width":this.bkgr.width,
            "height":this.bkgr.height
         };
         return _loc1_;
      }
      
      public function getPointer() : BubblePointer
      {
         return this.pointer;
      }
      
      public function get bubble_type() : String
      {
         return this.textData["style"];
      }
      
      public function set bubble_type(param1:String) : void
      {
         var _loc2_:TextFormat = null;
         if(param1 != this.textData["style"])
         {
            if(param1 == "caption" && this.background_colour == 16777215)
            {
               this.background_colour = 16776960;
            }
            else if(this.textData["style"] == "caption" && this.background_colour == 16776960)
            {
               this.background_colour = 16777215;
            }
            _loc2_ = new TextFormat(null,null,null,null,null,null,null,null,TextFormatAlign.CENTER);
            if(param1 == "borderless" || param1 == "caption")
            {
               _loc2_.align = TextFormatAlign.LEFT;
               this.pad = 5;
            }
            else
            {
               this.pad = 10;
            }
            this.myField.setTextFormat(_loc2_);
            this.textData["style"] = param1;
            this.drawBubble();
            this.pointer.drawMe();
         }
      }
      
      public function get font_size() : int
      {
         return this.c_font_size;
      }
      
      public function set font_size(param1:int) : void
      {
         var _loc2_:Number = Math.min(96,Math.max(4,param1));
         if(_loc2_ >= 48)
         {
            this.myField.antiAliasType = AntiAliasType.NORMAL;
         }
         else
         {
            this.myField.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.dirty = true;
         this.apply_format(new TextFormat(null,_loc2_));
      }
      
      public function get font() : String
      {
         return this.c_font;
      }
      
      public function set font(param1:String) : void
      {
         if(param1.substr(0,1) == "_" && this.myField.embedFonts == false)
         {
            this.myField.embedFonts = true;
            this.myField.setTextFormat(new TextFormat(param1));
         }
         else if(this.myField.embedFonts == true)
         {
            this.myField.embedFonts = false;
            this.myField.setTextFormat(new TextFormat(param1));
         }
         else
         {
            this.apply_format(new TextFormat(param1));
         }
         this.inputText();
      }
      
      public function get bold() : Boolean
      {
         return this.c_bold;
      }
      
      public function set bold(param1:Boolean) : void
      {
         this.dirty = true;
         this.apply_format(new TextFormat(null,null,null,param1));
      }
      
      public function get italic() : Boolean
      {
         return this.c_italic;
      }
      
      public function set italic(param1:Boolean) : void
      {
         this.dirty = true;
         this.apply_format(new TextFormat(null,null,null,null,param1));
      }
      
      public function get underline() : Boolean
      {
         return this.c_underline;
      }
      
      public function set underline(param1:Boolean) : void
      {
         this.apply_format(new TextFormat(null,null,null,null,null,param1));
      }
      
      public function get spelling() : Boolean
      {
         if(this.sh && this.sh.enabled)
         {
            return true;
         }
         return false;
      }
      
      public function set spelling(param1:Boolean) : void
      {
         if(this.sh)
         {
            this.sh.enabled = param1;
            if(param1 == false)
            {
               this.sh.clear();
            }
         }
      }
      
      public function get pointer_count() : uint
      {
         return this.pointers.length + 1;
      }
   }
}
