package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.character.ComicCharAsset;
   import com.bitstrips.character.ComicImageAsset;
   import com.bitstrips.character.ComicPropAsset;
   import com.bitstrips.character.IBody;
   import com.bitstrips.controls.ComicControls;
   import com.bitstrips.core.ImageLoader;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class Comic extends EventDispatcher
   {
      
      public static const BORDER_SIZE:Number = 8;
      
      public static const STRIP_MAX:uint = 7;
      
      public static const STRIP_MIN:uint = 1;
      
      public static const WIDTH_MAX:uint = 740 - Comic.BORDER_SIZE * 2;
      
      public static const PANEL_HEIGHT_MIN:uint = 100;
      
      public static const PANEL_HEIGHT_MAX:uint = 360;
      
      public static const PANEL_WIDTH_MIN:uint = 100;
      
      public static const PANEL_MAX:uint = Comic.WIDTH_MAX / (Comic.PANEL_WIDTH_MIN + Comic.BORDER_SIZE);
       
      
      private var myComicBuilder:ComicBuilder;
      
      private var stripList:Vector.<ComicStrip>;
      
      public var comicData:Object;
      
      private var comicInterface:Sprite;
      
      private var comicDisplay:Sprite;
      
      private var comicArea:Sprite;
      
      private var myTitleInterface:TitleInterface;
      
      private var editableSaved:Boolean;
      
      private var currentStrip:ComicStrip;
      
      private var currentPanel:ComicPanel;
      
      private var borderH_L:Sprite;
      
      private var borderH_R:Sprite;
      
      private var borderV:Sprite;
      
      public var selectedStrip:ComicStrip;
      
      public var selectedPanel:ComicPanel;
      
      public var selectedAsset:ComicAsset;
      
      private var il:ImageLoader;
      
      private var cl:CharLoader;
      
      private var clipboard:Object;
      
      private var borderOffset:Point;
      
      private var currentBorder:Sprite;
      
      private var thumb:Object;
      
      private var editable:Boolean = true;
      
      public const debug:Boolean = false;
      
      private var _move_mode:uint = 0;
      
      private var shared_clipboard:SharedObject;
      
      private var undo_offset:int = 0;
      
      private var undo:Array;
      
      public var _popped_asset:ComicAsset;
      
      private var _loading:Boolean = false;
      
      private var _controls:ComicControls;
      
      private var _scroll_v:Number = 0;
      
      public function Comic(param1:ComicBuilder, param2:ImageLoader, param3:CharLoader)
      {
         var new_myComicBuilder:ComicBuilder = param1;
         var new_il:ImageLoader = param2;
         var new_cl:CharLoader = param3;
         this.undo = [];
         super();
         if(this.debug)
         {
            trace("--Comic()--");
         }
         this.myComicBuilder = new_myComicBuilder;
         this.il = new_il;
         this.cl = new_cl;
         this.comicData = new Object();
         this.thumb = {
            "x":0,
            "y":0,
            "width":0,
            "height":0
         };
         this.myTitleInterface = new TitleInterface(this);
         this.comicInterface = new Sprite();
         this.comicDisplay = new Sprite();
         this.comicArea = new Sprite();
         this.borderH_L = new Sprite();
         this.borderH_R = new Sprite();
         this.borderV = new Sprite();
         this.comicInterface.addChild(this.comicDisplay);
         this.comicInterface.addChild(this.myTitleInterface);
         this.comicDisplay.addChild(this.borderV);
         this.comicDisplay.addChild(this.borderH_R);
         this.comicDisplay.addChild(this.borderH_L);
         this.stripList = new Vector.<ComicStrip>();
         this.clipboard = new Object();
         if(BSConstants.SHARED_CLIPBOARD)
         {
            this.shared_clipboard = SharedObject.getLocal("clipboard","/",false);
         }
         this.comicDisplay.addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            comicDisplay.stage.addEventListener(KeyboardEvent.KEY_UP,check_key);
         });
      }
      
      public function get move_mode() : uint
      {
         return this._move_mode;
      }
      
      public function stop_editing_asset() : void
      {
         if(this.selectedAsset && this.selectedAsset.editing)
         {
            this.selectedAsset.editing = false;
         }
      }
      
      public function set move_mode(param1:uint) : void
      {
         if(this._move_mode == 3)
         {
            return;
         }
         trace(" Comic Move Mode: " + param1);
         this.stop_editing_asset();
         this._move_mode = param1;
      }
      
      public function get bkgrColor() : int
      {
         return this.comicData["bkgrColor"];
      }
      
      public function set bkgrColor(param1:int) : void
      {
         this.comicData["bkgrColor"] = param1;
      }
      
      function setData(param1:Object) : void
      {
         var _loc3_:ComicStrip = null;
         var _loc5_:int = 0;
         var _loc6_:ComicPanel = null;
         if(this.debug)
         {
            trace("--Comic.setData()--");
         }
         this._loading = true;
         this.comicData = Utils.clone(param1);
         if(!this.comicData["series"])
         {
            this.comicData["series"] = 0;
         }
         if(!this.comicData["episode"])
         {
            this.comicData["episode"] = 0;
         }
         this.clearComic();
         this.stripList = new Vector.<ComicStrip>();
         var _loc2_:Boolean = false;
         if(this.debug)
         {
            trace("so far so good");
         }
         if(this.debug)
         {
            trace("comicData.strips: " + this.comicData.strips);
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.comicData.strips.length)
         {
            if(_loc4_ > 0)
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
            _loc3_ = this.addStrip(this.comicData.strips[_loc4_],_loc2_,_loc4_);
            _loc5_ = 0;
            while(_loc5_ < this.comicData.strips[_loc4_].panels.length)
            {
               _loc2_ = true;
               if(_loc5_ < 1)
               {
                  _loc2_ = false;
               }
               _loc6_ = this.addPanel(_loc3_,this.comicData.strips[_loc4_].panels[_loc5_],_loc2_);
               _loc5_++;
            }
            if(_loc3_.strip_width > Comic.WIDTH_MAX)
            {
               _loc3_.strip_width = Comic.WIDTH_MAX;
            }
            _loc4_++;
         }
         trace("Comic Width: " + this.comic_width);
         if(this.selectedPanel)
         {
            this.selectPanel(null);
         }
         this.initialDraw();
         this.drawMe();
         if(this.comicData.hasOwnProperty("bkgrColor"))
         {
            this.myComicBuilder.setBackgroundColour(this.comicData["bkgrColor"]);
         }
         this.myComicBuilder.repositionComicControls();
         this._loading = false;
      }
      
      public function set controls(param1:ComicControls) : void
      {
         this._controls = param1;
         this._controls.addPanel_btn.addEventListener(MouseEvent.CLICK,this.addPanel_click);
         this._controls.removePanel_btn.addEventListener(MouseEvent.CLICK,this.removePanel_click);
         this._controls.addStrip_btn.addEventListener(MouseEvent.CLICK,this.addStrip_click);
         this._controls.delete_btn.addEventListener(MouseEvent.CLICK,this.delete_click);
         this._controls.copy_btn.addEventListener(MouseEvent.CLICK,this.copy_click);
         this._controls.paste_btn.addEventListener(MouseEvent.CLICK,this.paste_click);
         this._controls.lock_btn.addEventListener(MouseEvent.CLICK,this.toggle_lock);
         this._controls.move_down_btn.addEventListener(MouseEvent.CLICK,this.move_down);
         this._controls.move_up_btn.addEventListener(MouseEvent.CLICK,this.move_up);
      }
      
      public function initialDraw() : void
      {
         if(this.debug)
         {
            trace("--Comic.initialDraw()--");
         }
         this.borderH_L.addEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart_H);
         this.borderH_L.addEventListener(MouseEvent.MOUSE_OVER,this.borderH_over);
         this.borderH_L.addEventListener(MouseEvent.MOUSE_OUT,this.stripCursor);
         this.borderH_R.addEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart_H);
         this.borderH_R.addEventListener(MouseEvent.MOUSE_OVER,this.borderH_over);
         this.borderH_R.addEventListener(MouseEvent.MOUSE_OUT,this.stripCursor);
         this.borderV.addEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart_V);
         this.borderV.addEventListener(MouseEvent.MOUSE_OVER,this.borderV_over);
         this.borderV.addEventListener(MouseEvent.MOUSE_OUT,this.stripCursor);
         this.comicArea.addEventListener(MouseEvent.ROLL_OUT,this.stripCursor);
      }
      
      public function killBorders() : void
      {
         this.comicDisplay.removeChild(this.borderH_L);
         this.comicDisplay.removeChild(this.borderH_R);
         this.comicDisplay.removeChild(this.borderV);
      }
      
      public function drawMe() : void
      {
         var _loc2_:int = 0;
         if(this.debug)
         {
            trace("--Comic.drawMe()--");
         }
         var _loc1_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < this.stripList.length)
         {
            if(_loc2_ > 0)
            {
               _loc1_ = this.stripList[_loc2_ - 1].y + this.stripList[_loc2_ - 1].getHeight() + Comic.BORDER_SIZE;
            }
            this.stripList[_loc2_].y = _loc1_;
            _loc3_ = _loc3_ + this.stripList[_loc2_].getSize().height;
            _loc2_++;
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(this.stripList[0] != null)
         {
            _loc6_ = this.stripList[0].y;
            _loc5_ = this.stripList[0].x + this.stripList[0].getSize().width;
            _loc5_ = _loc5_ - Comic.BORDER_SIZE * 2;
            if(this.debug)
            {
               trace("edgeX: " + _loc5_);
            }
         }
         this.borderH_L.graphics.clear();
         this.borderH_L.graphics.beginFill(255,0);
         this.borderH_L.graphics.drawRect(0,0,Comic.BORDER_SIZE,_loc3_);
         this.borderH_L.graphics.endFill();
         this.borderH_L.x = _loc5_;
         this.borderH_L.y = _loc6_;
         this.borderH_R.graphics.clear();
         this.borderH_R.graphics.beginFill(16711935,0);
         this.borderH_R.graphics.drawRect(0,0,Comic.BORDER_SIZE,_loc3_);
         this.borderH_R.graphics.endFill();
         this.borderH_R.x = 0;
         this.borderH_R.y = _loc6_;
         var _loc7_:Number = 0;
         if(this.stripList[this.stripList.length - 1] != null)
         {
            _loc7_ = this.stripList[this.stripList.length - 1].y + this.stripList[this.stripList.length - 1].getSize().height;
            _loc4_ = this.stripList[this.stripList.length - 1].getSize().width;
         }
         this.borderV.graphics.clear();
         this.borderV.graphics.beginFill(13369599,0);
         this.borderV.graphics.drawRect(0,0,_loc4_,Comic.BORDER_SIZE);
         this.borderV.graphics.endFill();
         this.borderV.y = _loc7_;
         this.myComicBuilder.centerDisplayObj(this.comicArea,true,false);
         this.comicInterface.x = this.comicArea.x;
         this.comicArea.x = 0;
         this.centerComic(this.comicDisplay);
         this.comicDisplay.y = Comic.BORDER_SIZE;
      }
      
      public function addPanel(param1:ComicStrip, param2:Object, param3:Boolean) : ComicPanel
      {
         if(this.debug)
         {
            trace("--Comic.addPanel()--");
         }
         param2["height"] = param1.strip_height;
         var _loc4_:ComicPanel = new ComicPanel(this,param1,param2,param3);
         _loc4_.set_editable(this.editable);
         _loc4_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         param1.addPanel(_loc4_);
         this.selectPanel(_loc4_);
         _loc4_.blank = true;
         return _loc4_;
      }
      
      public function addPanelAt(param1:ComicStrip, param2:Object, param3:Boolean, param4:int) : ComicPanel
      {
         if(this.debug)
         {
            trace("--Comic.addPanelAt(" + param4 + ")--");
         }
         var _loc5_:ComicPanel = new ComicPanel(this,param1,param2,param3);
         param1.addPanelAt(_loc5_,param4);
         _loc5_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         param2["height"] = param1.strip_height;
         _loc5_.load_state(param2);
         _loc5_.blank = true;
         param1.drawMe();
         this.drawMe();
         return _loc5_;
      }
      
      public function removePanel(param1:ComicPanel) : void
      {
         var _loc2_:Vector.<ComicPanel> = null;
         var _loc3_:int = 0;
         if(this.debug)
         {
            trace("--Comic.removePanel()--");
         }
         if(this.selectedStrip != null)
         {
            _loc2_ = this.selectedStrip.panels;
            _loc3_ = _loc2_.indexOf(param1);
            if(_loc3_ > 0)
            {
               _loc2_[_loc3_ - 1].panel_width = _loc2_[_loc3_ - 1].panel_width + (param1.panel_width + Comic.BORDER_SIZE);
            }
            else
            {
               _loc2_[_loc3_ + 1].panel_width = _loc2_[_loc3_ + 1].panel_width + (param1.panel_width + Comic.BORDER_SIZE);
            }
            this.selectedStrip.removePanel(param1);
            if(this.debug)
            {
               trace("panelList.length: " + _loc2_.length);
            }
            this.selectedStrip = null;
            this.selectPanel(null);
            this.drawMe();
         }
      }
      
      public function addStrip(param1:Object, param2:Boolean, param3:uint) : ComicStrip
      {
         if(this.debug)
         {
            trace("--Comic.addStrip()--");
         }
         var _loc4_:ComicStrip = new ComicStrip(this,param1.height,param2);
         _loc4_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         _loc4_.set_editable(this.editable);
         this.comicDisplay.addChild(_loc4_);
         this.stripList.splice(param3,0,_loc4_);
         _loc4_.x = Comic.BORDER_SIZE;
         return _loc4_;
      }
      
      public function removeStrip(param1:ComicStrip) : Boolean
      {
         if(this.debug)
         {
            trace("--Comic.removeStrip()--");
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.stripList.length)
         {
            if(this.stripList[_loc2_] == param1)
            {
               if(this.debug)
               {
                  trace("MATCH");
               }
               this.stripList.splice(_loc2_,1);
               if(this.debug)
               {
                  trace("stripList.length: " + this.stripList.length);
               }
               param1.clearStrip();
               this.comicDisplay.removeChild(param1);
               this.selectedStrip = null;
               this.selectPanel(null);
               this.drawMe();
               this.myComicBuilder.repositionComicControls();
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function selectPanel(param1:ComicPanel) : void
      {
         if(this.debug)
         {
            trace("--Comic.selectPanel(" + param1 + ")--");
         }
         if(param1 == this.selectedPanel)
         {
            if(this.selectedAsset == null)
            {
               this.myComicBuilder.registerPanel(this.selectedPanel);
            }
            return;
         }
         if(this.selectedPanel)
         {
            this.selectedPanel.selected = false;
         }
         this.selectedPanel = param1;
         if(this.selectedPanel)
         {
            this.selectedPanel.selected = true;
            this.selectedStrip = this.selectedPanel.getStrip();
            if(!this.selectedAsset)
            {
               this.myComicBuilder.registerPanel(this.selectedPanel);
            }
         }
         else
         {
            this.selectAsset(null);
         }
         dispatchEvent(new Event("PANEL_SELECT"));
      }
      
      public function selectAsset(param1:ComicAsset) : void
      {
         if(this.debug)
         {
            trace("--Comic.selectAsset(" + param1 + ")--");
         }
         if(this.selectedAsset == param1)
         {
            return;
         }
         this.stop_editing_asset();
         if(this.selectedAsset)
         {
            if(this.debug)
            {
               trace("getting rid of an existing selection");
            }
            this.selectedAsset.doSelect(false);
            this.myComicBuilder.registerControlType(null,null);
         }
         this.selectedAsset = param1;
         if(this.selectedAsset)
         {
            if(this.debug)
            {
               trace("setting a new selection");
            }
            this.selectedAsset.doSelect(true);
            this.selectPanel(ComicPanel(this.selectedAsset.getPanel()));
            if(this.selectedAsset is ComicCharAsset)
            {
               this.myComicBuilder.registerControlType("characters",this.selectedAsset);
            }
            else if(this.selectedAsset is TextBubble)
            {
               this.myComicBuilder.registerControlType("text bubble",this.selectedAsset);
            }
            else if(this.selectedAsset is ComicPropAsset)
            {
               if(this.selectedAsset.getData()["type"] == "walls")
               {
                  this.myComicBuilder.registerControlType("walls",this.selectedAsset);
               }
               else
               {
                  this.myComicBuilder.registerControlType("props",this.selectedAsset);
               }
            }
         }
         dispatchEvent(new Event("ASSET_SELECT"));
      }
      
      function centerComic(param1:Sprite) : void
      {
         param1.x = this.comicArea.width / 2 - this.stripList[0].getSize().width / 2;
         this.update_scrollRect();
      }
      
      function borderMoveStart_V(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         this.borderOffset = new Point(param1.currentTarget.mouseX,param1.currentTarget.mouseY);
         if(this.comicData.editable)
         {
            this.pre_undo();
            this.comicDisplay.stage.addEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop_V);
            this.comicDisplay.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.borderMove_V);
         }
      }
      
      function borderMoveStop_V(param1:MouseEvent) : void
      {
         if(this.comicData.editable)
         {
            this.comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop_V);
            this.comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.borderMove_V);
         }
         dispatchEvent(new CursorEvent("reset"));
      }
      
      function borderMove_V(param1:MouseEvent) : void
      {
         this.borderResizeComicHeight();
      }
      
      function borderMoveStart_H(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         this.borderOffset = new Point(param1.currentTarget.mouseX,param1.currentTarget.mouseY);
         this.currentBorder = Sprite(param1.currentTarget);
         if(this.comicData.editable)
         {
            this.pre_undo();
            this.comicDisplay.stage.addEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop_H);
            this.comicDisplay.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.borderMove_H);
         }
      }
      
      function borderMoveStop_H(param1:MouseEvent) : void
      {
         if(this.comicData.editable)
         {
            this.comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop_H);
            this.comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.borderMove_H);
         }
         dispatchEvent(new CursorEvent("reset"));
      }
      
      function borderMove_H(param1:MouseEvent) : void
      {
         this.borderResizeComicWidth();
      }
      
      function borderH_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         param1.stopPropagation();
         dispatchEvent(new CursorEvent("border_h"));
      }
      
      function borderV_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         param1.stopPropagation();
         dispatchEvent(new CursorEvent("border_v"));
      }
      
      public function panelFollower(param1:ComicPanel) : ComicPanel
      {
         var _loc2_:ComicStrip = param1.strip;
         var _loc3_:int = _loc2_.panels.indexOf(param1);
         if(_loc3_ > 0)
         {
            return _loc2_.panels[_loc3_ - 1];
         }
         return null;
      }
      
      public function stripFollower(param1:ComicStrip) : ComicStrip
      {
         var _loc2_:int = this.stripList.indexOf(param1);
         if(_loc2_ > 0)
         {
            return this.stripList[_loc2_ - 1];
         }
         return null;
      }
      
      public function borderResizePanel(param1:ComicPanel, param2:ComicPanel, param3:ComicPanel, param4:Point) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc5_:Boolean = true;
         if(this.debug)
         {
            trace("borderOffset.x: " + param4.x);
         }
         var _loc6_:Number = this.comicDisplay.mouseX - param4.x;
         var _loc7_:Number = _loc6_ - param1.x;
         if(param2 == null)
         {
            return;
         }
         _loc9_ = param2.panel_width + _loc7_;
         if(_loc9_ < PANEL_WIDTH_MIN || _loc9_ > Comic.WIDTH_MAX)
         {
            if(_loc9_ < PANEL_WIDTH_MIN)
            {
               _loc7_ = PANEL_WIDTH_MIN - param2.panel_width;
            }
            else
            {
               _loc7_ = Comic.WIDTH_MAX - param2.panel_width;
            }
         }
         if(_loc7_ == 0)
         {
            return;
         }
         if(param3 != null)
         {
            _loc9_ = param3.panel_width - _loc7_;
            if(_loc9_ < PANEL_WIDTH_MIN || _loc9_ > Comic.WIDTH_MAX)
            {
               _loc5_ = false;
            }
         }
         if(_loc5_ && _loc7_)
         {
            param2.panel_width = param2.panel_width + _loc7_;
            if(param3 != null)
            {
               param3.panel_width = param3.panel_width - _loc7_;
            }
            param2.strip.drawMe();
         }
      }
      
      private function resizeStrip(param1:ComicStrip, param2:Number) : void
      {
         var _loc3_:Number = param1.strip_height + param2;
         if(_loc3_ < Comic.PANEL_HEIGHT_MIN)
         {
            param2 = Comic.PANEL_HEIGHT_MIN - param1.strip_height;
         }
         else if(_loc3_ > Comic.PANEL_HEIGHT_MAX)
         {
            param2 = Comic.PANEL_HEIGHT_MAX - param1.strip_height;
         }
         if(param2 == 0)
         {
            return;
         }
         param1.adjustSize({
            "width":null,
            "height":param2
         });
         this.myComicBuilder.repositionComicControls();
         this.drawMe();
      }
      
      public function borderResizeStrip(param1:ComicStrip, param2:ComicStrip, param3:ComicStrip, param4:Point) : void
      {
         var _loc5_:Number = this.comicDisplay.mouseY + param4.y;
         var _loc6_:Number = _loc5_ - param1.y;
         this.resizeStrip(param2,_loc6_);
      }
      
      public function set comic_width(param1:int) : void
      {
         var _loc3_:ComicStrip = null;
         if(param1 < this.min_width())
         {
            param1 = this.min_width();
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.stripList.length)
         {
            _loc3_ = this.stripList[_loc2_];
            _loc3_.strip_width = param1;
            if(_loc3_.strip_width != param1)
            {
               trace("Failed to set the size... " + _loc3_.strip_width + " - " + param1);
            }
            _loc2_++;
         }
         this.drawMe();
      }
      
      public function get comic_width() : int
      {
         var _loc3_:ComicStrip = null;
         var _loc1_:Number = ComicStrip(this.stripList[0]).strip_width;
         var _loc2_:int = 1;
         while(_loc2_ < this.stripList.length)
         {
            _loc3_ = this.stripList[_loc2_];
            if(_loc3_.strip_width != _loc1_)
            {
               trace("Trying to fix a broken comic - sub-strips don\'t match");
               _loc3_.strip_width = _loc1_;
               if(_loc3_.strip_width != _loc1_)
               {
                  trace("Big Errors");
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function max_current_panels() : int
      {
         var _loc3_:ComicStrip = null;
         var _loc1_:int = 1;
         var _loc2_:int = 0;
         while(_loc2_ < this.stripList.length)
         {
            _loc3_ = this.stripList[_loc2_];
            _loc1_ = Math.max(_loc1_,_loc3_.panels.length);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function min_width() : int
      {
         return this.max_current_panels() * (PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE;
      }
      
      public function borderResizeComicWidth() : void
      {
         var _loc4_:Number = NaN;
         if(this.debug)
         {
            trace("--Comic.borderResizeComicWidth()--");
         }
         var _loc1_:Number = this.currentBorder.mouseX - this.borderOffset.x;
         var _loc2_:Number = this.comic_width;
         var _loc3_:Number = _loc2_ + _loc1_;
         if(_loc3_ > Comic.WIDTH_MAX)
         {
            _loc1_ = Comic.WIDTH_MAX - _loc2_;
         }
         else
         {
            _loc4_ = this.min_width();
            if(_loc3_ < _loc4_)
            {
               _loc1_ = _loc4_ - _loc2_;
            }
         }
         _loc3_ = _loc2_ + _loc1_;
         this.comic_width = _loc3_;
      }
      
      public function borderResizeComicHeight() : void
      {
         var _loc1_:Number = this.borderV.mouseY - this.borderV.height / 2;
         var _loc2_:ComicStrip = this.stripList[this.stripList.length - 1];
         this.scroll_v = this.stripList.length;
         this.resizeStrip(_loc2_,_loc1_);
      }
      
      public function locatePanelAtPoint(param1:Point) : ComicPanel
      {
         var _loc2_:Vector.<ComicPanel> = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.stripList.length)
         {
            _loc2_ = this.stripList[_loc3_].getPanelList();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               if(_loc2_[_loc4_].getArea().hitTestPoint(param1.x,param1.y,true))
               {
                  return _loc2_[_loc4_];
               }
               _loc4_++;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function releaseAsset(param1:ComicPanel, param2:Object) : void
      {
         var _loc3_:* = null;
         if(this.debug)
         {
            trace("--Comic.releaseAsset(" + param2.type + ")--");
         }
         this.selectPanel(param1);
         if(param2.type == "scenes")
         {
            param1.absorbScene(param2["asset_data"].strips[0].panels[0]);
            for(_loc3_ in param2["asset_data"])
            {
               if(this.debug)
               {
                  trace(_loc3_ + ": " + param2["asset_data"][_loc3_]);
               }
            }
            if(this.debug)
            {
               trace("---------------------");
            }
         }
         else
         {
            this.addAssetToPanel(param2,param1,true);
         }
      }
      
      public function addAssetToPanel(param1:Object, param2:ComicPanel, param3:Boolean) : ComicAsset
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:DisplayObject = null;
         if(this.debug)
         {
            trace("--Comic.addAssetToPanel(" + param1.type + ")--");
         }
         var _loc4_:ComicAsset = null;
         if(param1["position"] == null && param1["stage_x"])
         {
            _loc5_ = new Point(param1["stage_x"],param1["stage_y"]);
            if(param1.type == "promoted text")
            {
               _loc6_ = param2.text_content.globalToLocal(_loc5_);
            }
            else
            {
               _loc6_ = param2.content.globalToLocal(_loc5_);
            }
            param1["position"] = _loc6_;
         }
         switch(param1.type)
         {
            case "characters":
               if(this.debug)
               {
                  trace("A CHARACTER ASSET");
               }
               if(this._loading == false)
               {
                  _loc7_ = this.il.get_image(param1["bmpURL"]);
               }
               _loc4_ = this.cl.get_char_asset(param1["id"],_loc7_,param1["version"]);
               _loc4_.setPanel(param2);
               _loc4_.load_state(param1);
               param2.addAsset(_loc4_,param3);
               break;
            case "text bubble":
               _loc4_ = new TextBubble(TextBubbleType.PANEL);
               _loc4_.setPanel(param2);
               param1["textData"]["maxWidth"] = param2.panel_width / param2.content.scaleX - 5;
               if(param1["version"] && param1["version"] < 4)
               {
                  param1["textData"]["maxWidth"] = Math.max(300,param1["textData"]["maxWidth"] / param1["scale"]);
               }
               _loc4_.load_state(param1);
               param2.addAsset(_loc4_,param3);
               break;
            case "promoted text":
               _loc4_ = new TextBubble(TextBubbleType.PANEL);
               _loc4_.setPanel(param2);
               param1["textData"]["maxWidth"] = param2.panel_width / param2.text_content.scaleX - 5;
               _loc4_.load_state(param1);
               param2.addTextAsset(_loc4_,param3);
               break;
            case "walls":
            case "wall stuff":
            case "props":
            case "effects":
            case "furniture":
            case "shapes":
               _loc4_ = this.cl.get_prop_asset(param1["id"]);
               _loc4_.setPanel(param2);
               _loc4_.load_state(param1);
               param2.addAsset(_loc4_,param3);
               break;
            case "image":
               _loc4_ = new ComicImageAsset(param1["url"]);
               _loc4_.setPanel(param2);
               _loc4_.load_state(param1);
               param2.addAsset(_loc4_,param3);
               break;
            case "floors":
               param2.panel_contents.setFloor(param1["id"]);
               return null;
            case "backdrops":
               param2.panel_contents.setBackdrop(param1["id"]);
               return null;
            default:
               _loc4_ = new ComicAsset();
               _loc4_.setPanel(param2);
               _loc4_.load_state(param1);
               param2.addAsset(_loc4_,param3);
         }
         _loc4_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent);
         if(_loc4_ && !_loc4_.getLock() && param3 != false)
         {
            this.selectAsset(_loc4_);
         }
         return _loc4_;
      }
      
      public function setAssetColour(param1:Number) : void
      {
         if(this.selectedAsset)
         {
            this.selectedAsset.setColour(param1);
         }
      }
      
      public function addPanel_click(param1:MouseEvent) : void
      {
         var _loc2_:Vector.<ComicPanel> = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:ComicPanel = null;
         this.stop_editing_asset();
         if(this.comicData.editable)
         {
            if(this.selectedStrip != null && this.selectedPanel != null)
            {
               _loc2_ = this.selectedStrip.panels;
               if(_loc2_.length < Comic.PANEL_MAX)
               {
                  this.pre_undo();
                  _loc3_ = _loc2_.indexOf(this.selectedPanel);
                  _loc4_ = this.selectedPanel.panel_width / 2;
                  if(_loc4_ >= PANEL_WIDTH_MIN)
                  {
                     this.selectedPanel.panel_width = this.selectedPanel.panel_width - (_loc4_ + Comic.BORDER_SIZE / 2);
                  }
                  else
                  {
                     _loc6_ = Comic.PANEL_WIDTH_MIN * 2 + Comic.BORDER_SIZE / 2 - this.selectedPanel.panel_width;
                     _loc7_ = 0;
                     this.selectedPanel.panel_width = Comic.PANEL_WIDTH_MIN;
                     _loc4_ = Comic.PANEL_WIDTH_MIN;
                     _loc8_ = _loc3_ + 1;
                     while(_loc8_ < _loc2_.length)
                     {
                        _loc9_ = _loc2_[_loc8_];
                        if(_loc9_ != null)
                        {
                           _loc7_ = _loc9_.panel_width - Comic.PANEL_WIDTH_MIN;
                           if(_loc7_ > _loc6_)
                           {
                              _loc7_ = _loc6_;
                           }
                           _loc9_.panel_width = _loc9_.panel_width - _loc7_;
                           _loc6_ = _loc6_ - _loc7_;
                        }
                        _loc8_++;
                     }
                     if(_loc6_ > 0)
                     {
                        _loc8_ = _loc3_ - 1;
                        while(_loc8_ >= 0)
                        {
                           _loc9_ = _loc2_[_loc8_];
                           if(_loc9_ != null)
                           {
                              _loc7_ = _loc9_.panel_width - Comic.PANEL_WIDTH_MIN;
                              if(_loc7_ > _loc6_)
                              {
                                 _loc7_ = _loc6_;
                              }
                              _loc9_.panel_width = _loc9_.panel_width - _loc7_;
                              _loc6_ = _loc6_ - _loc7_;
                           }
                           _loc8_--;
                        }
                     }
                  }
                  _loc5_ = new Object();
                  _loc5_.width = _loc4_ - Comic.BORDER_SIZE / 2;
                  _loc5_.bkgrColor = 16777215;
                  _loc5_.contentList = new Array();
                  _loc5_.content_scale = this.selectedPanel.scale;
                  this.selectPanel(this.addPanelAt(this.selectedStrip,_loc5_,true,_loc3_ + 1));
                  this.comic_width = this.selectedStrip.strip_width;
               }
            }
         }
      }
      
      public function removePanel_click(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         if(this.comicData.editable)
         {
            if(this.selectedStrip != null && this.selectedPanel != null)
            {
               if(this.selectedStrip.panels.length > Comic.STRIP_MIN)
               {
                  this.pre_undo();
                  this.removePanel_confirm(param1);
               }
               else if(this.stripList.length > 1)
               {
                  this.removeStrip(this.selectedStrip);
               }
            }
         }
      }
      
      public function removePanel_confirm(param1:MouseEvent) : void
      {
         this.removePanel(this.selectedPanel);
         this.drawMe();
      }
      
      public function addStrip_click(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ComicStrip = null;
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:ComicStrip = null;
         var _loc9_:Boolean = false;
         this.stop_editing_asset();
         if(this.comicData.editable)
         {
            if(this.stripList.length < STRIP_MAX)
            {
               this.pre_undo();
               _loc2_ = this.stripList.length;
               if(this.selectedStrip)
               {
                  _loc2_ = this.stripList.indexOf(this.selectedStrip) + 1;
               }
               _loc3_ = this.stripList[_loc2_ - 1];
               _loc4_ = new Object();
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < this.stripList.length)
               {
                  _loc5_ = _loc5_ + this.stripList[_loc6_].getSize().height;
                  _loc6_++;
               }
               _loc4_.height = _loc3_.strip_height;
               _loc7_ = _loc3_.getPanelList().length;
               _loc4_.panels = new Array(_loc7_);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.panels.length)
               {
                  _loc4_.panels[_loc6_] = new Object();
                  _loc4_.panels[_loc6_].width = _loc3_.getPanelList()[_loc6_].panel_width;
                  _loc4_.panels[_loc6_].content_scale = _loc3_.getPanelList()[_loc6_].scale;
                  _loc4_.panels[_loc6_].bkgrColor = 16777215;
                  _loc4_.panels[_loc6_].contentList = new Array();
                  _loc6_++;
               }
               _loc8_ = this.addStrip(_loc4_,true,_loc2_);
               _loc6_ = 0;
               while(_loc6_ < _loc4_.panels.length)
               {
                  if(_loc6_ > 0)
                  {
                     _loc9_ = true;
                  }
                  else
                  {
                     _loc9_ = false;
                  }
                  this.addPanel(_loc8_,_loc4_.panels[_loc6_],_loc9_);
                  _loc6_++;
               }
               this.drawMe();
               this.myComicBuilder.repositionComicControls();
            }
         }
      }
      
      public function removeStrip_click(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         if(this.comicData.editable)
         {
            if(this.stripList.length > Comic.STRIP_MIN && this.selectedStrip != null)
            {
               if(this.selectedStrip != null)
               {
                  this.pre_undo();
                  this.removeStrip_confirm(param1);
               }
            }
         }
      }
      
      public function removeStrip_confirm(param1:MouseEvent) : void
      {
         if(!this.removeStrip(this.selectedStrip))
         {
         }
      }
      
      public function delete_click(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         if(this.debug)
         {
            trace("delete_click");
         }
         this.pre_undo();
         this.do_delete();
      }
      
      public function do_delete() : void
      {
         var _loc1_:ComicAsset = null;
         if(this.debug)
         {
            trace("do_delete");
         }
         if(this._move_mode == 3)
         {
            return;
         }
         if(this.selectedAsset || this.selectedPanel)
         {
            if(this.selectedAsset)
            {
               _loc1_ = this.selectedAsset;
               this.selectAsset(null);
               _loc1_.getPanel().removeAsset(_loc1_);
            }
            else if(this.selectedPanel)
            {
               this.selectedPanel.clearPanel();
            }
         }
      }
      
      public function pre_undo() : void
      {
         trace("Saving data in: " + this.undo_offset);
         this.add_undo(this.setData,this.save_state());
      }
      
      public function add_undo(param1:Function, param2:Object) : void
      {
         if(param1 == null)
         {
            this.pre_undo();
            return;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(param2);
         _loc3_.position = 0;
         this.undo[this.undo_offset] = [param1,_loc3_];
         this.undo_offset = this.undo_offset + 1;
         if(this.undo_offset != this.undo.length)
         {
            trace("Breaking the chain");
            this.undo = this.undo.slice(0,this.undo_offset);
         }
         dispatchEvent(new Event("UNDO_READY"));
      }
      
      public function do_undo() : void
      {
         var _loc1_:Function = null;
         var _loc2_:ByteArray = null;
         var _loc3_:Object = null;
         if(this.undo_offset > 0)
         {
            if(this.undo_offset == this.undo.length)
            {
               trace("First undo from the top");
               this.pre_undo();
               this.undo_offset = this.undo_offset - 1;
            }
            this.undo_offset = this.undo_offset - 1;
            this.undo_offset = Math.max(this.undo_offset,0);
            trace("Loading data: " + this.undo_offset);
            _loc1_ = this.undo[this.undo_offset][0];
            _loc2_ = this.undo[this.undo_offset][1];
            _loc3_ = _loc2_.readObject();
            _loc2_.position = 0;
            _loc1_(_loc3_);
            if(this.undo_offset == 0)
            {
               dispatchEvent(new Event("NO_UNDO"));
            }
            else
            {
               dispatchEvent(new Event("UNDO_READY"));
            }
            if(this.undo_offset < this.undo.length)
            {
               dispatchEvent(new Event("REDO_READY"));
            }
            else
            {
               dispatchEvent(new Event("NO_REDO"));
            }
         }
      }
      
      public function do_redo() : void
      {
         var _loc1_:Function = null;
         var _loc2_:ByteArray = null;
         var _loc3_:Object = null;
         trace("undo_offset: " + this.undo_offset + " undo.length: " + this.undo.length);
         if(this.undo_offset < this.undo.length - 1)
         {
            this.undo_offset = this.undo_offset + 1;
            trace("Loading data: " + this.undo_offset);
            _loc1_ = this.undo[this.undo_offset][0];
            _loc2_ = this.undo[this.undo_offset][1];
            _loc3_ = _loc2_.readObject();
            _loc2_.position = 0;
            _loc1_(_loc3_);
            if(this.undo_offset >= this.undo.length - 1)
            {
               dispatchEvent(new Event("NO_REDO"));
            }
         }
         else
         {
            dispatchEvent(new Event("NO_REDO"));
         }
         if(this.undo_offset > 0)
         {
            dispatchEvent(new Event("UNDO_READY"));
         }
      }
      
      public function deletePanel_confirm(param1:MouseEvent) : void
      {
         if(this.selectedPanel)
         {
            this.selectedPanel.clearPanel();
         }
      }
      
      public function copy_click(param1:MouseEvent) : void
      {
         this.do_copy();
      }
      
      public function do_copy() : void
      {
         this.stop_editing_asset();
         if(this.debug)
         {
            trace("do_copy");
         }
         if(this.selectedAsset && this.selectedAsset.locked == false)
         {
            this.clipboard.type = "asset";
            this.clipboard.content = this.selectedAsset.save_state();
         }
         else if(this.selectedPanel)
         {
            this.clipboard.type = "panel";
            this.clipboard.content = this.selectedPanel.save_state();
         }
         if(BSConstants.SHARED_CLIPBOARD)
         {
            this.shared_clipboard.setProperty("content",Utils.clone(this.clipboard));
            this.shared_clipboard.flush();
         }
         this.clipboard["currentPanel"] = this.selectedPanel;
      }
      
      public function toggle_lock(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         if(this.debug)
         {
            trace("toggle_lock()");
         }
         if(this.selectedAsset)
         {
            this.selectedAsset.setLock(!this.selectedAsset.getLock());
            dispatchEvent(new Event("ASSET_SELECT"));
         }
      }
      
      public function paste_click(param1:MouseEvent) : void
      {
         this.stop_editing_asset();
         this.pre_undo();
         this.paste(this.clipboard);
      }
      
      public function paste(param1:Object) : void
      {
         var _loc2_:ComicAsset = null;
         if(BSConstants.SHARED_CLIPBOARD)
         {
            this.shared_clipboard = null;
            this.shared_clipboard = SharedObject.getLocal("clipboard","/",false);
            this.shared_clipboard.flush();
            if(this.shared_clipboard.data.content)
            {
               param1 = this.shared_clipboard.data.content;
            }
         }
         if(this.selectedPanel == null)
         {
            return;
         }
         if(param1.type == "panel")
         {
            if(param1["currentPanel"] != this.selectedPanel)
            {
               this.pastePanel(param1.content);
            }
         }
         else if(param1 && param1.content)
         {
            _loc2_ = this.pasteAsset(param1.content,null,true);
            if(param1["currentPanel"] != this.selectedPanel)
            {
               _loc2_.centerInPanel();
            }
            else
            {
               _loc2_.x = _loc2_.x + (Math.random() * 5 + 4) * Utils.random_i();
            }
         }
         else
         {
            trace("Error pasting...");
         }
      }
      
      public function pasteAsset(param1:Object, param2:ComicPanel = null, param3:Boolean = false) : ComicAsset
      {
         if(this.debug)
         {
            trace("--Comic.pasteAsset()--");
         }
         if(param2 == null)
         {
            param2 = this.selectedPanel;
         }
         var _loc4_:ComicAsset = this.addAssetToPanel(param1,param2,param3);
         return _loc4_;
      }
      
      public function pastePanel(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--Comic.pastePanel(" + param1 + ")--");
         }
         param1["height"] = null;
         param1["width"] = null;
         this.selectedPanel.load_state(param1);
      }
      
      public function save_state() : Object
      {
         if(this.debug)
         {
            trace("--Comic.save_state()--");
         }
         var _loc1_:Object = this.comicData;
         _loc1_.strips = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.stripList.length)
         {
            _loc1_.strips[_loc2_] = this.stripList[_loc2_].save_state();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function resized(param1:Number = 0) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.stripList.length)
         {
            this.stripList[_loc2_].resized(param1);
            _loc2_++;
         }
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this.stripList.length)
         {
            this.stripList[_loc2_].spelling(param1);
            _loc2_++;
         }
      }
      
      public function getBitmapPanels() : Array
      {
         var _loc3_:Vector.<ComicPanel> = null;
         var _loc4_:uint = 0;
         var _loc5_:ComicPanel = null;
         this.stop_editing_asset();
         this.selectAsset(null);
         this.selectPanel(null);
         var _loc1_:Array = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < this.stripList.length)
         {
            _loc3_ = this.stripList[_loc2_].getPanelList();
            _loc1_.push([]);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc1_[_loc2_].push(_loc5_.panelBitmap());
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getBitmap(param1:Boolean = false) : Bitmap
      {
         return new Bitmap(this.getBitmapData(param1));
      }
      
      public function getBitmapData(param1:Boolean) : BitmapData
      {
         var _loc8_:ComicStrip = null;
         this.stop_editing_asset();
         this.selectAsset(null);
         this.selectPanel(null);
         this.spelling(false);
         var _loc2_:Matrix = new Matrix();
         var _loc3_:Rectangle = this.getComicSize();
         var _loc4_:Number = 1;
         if(param1 || BSConstants.HQ)
         {
            _loc4_ = 3.8;
            this.comicDisplay.scaleX = this.comicDisplay.scaleY = _loc4_;
            this.resized();
            _loc2_.scale(_loc4_,_loc4_);
         }
         else if(this.comicDisplay.stage == null)
         {
            this.resized(1);
         }
         _loc2_.translate(2 * _loc4_,2 * _loc4_);
         var _loc5_:BitmapData = new BitmapData(_loc3_.width * _loc4_,_loc3_.height * _loc4_,true,16777215);
         var _loc6_:int = Comic.BORDER_SIZE;
         var _loc7_:int = 0;
         while(_loc7_ < this.stripList.length)
         {
            _loc8_ = this.stripList[_loc7_];
            _loc2_ = new Matrix();
            _loc2_.scale(_loc4_,_loc4_);
            _loc2_.translate(Comic.BORDER_SIZE * _loc4_,_loc6_ * _loc4_);
            _loc5_.draw(_loc8_,_loc2_);
            _loc6_ = _loc6_ + (_loc8_.strip_height + Comic.BORDER_SIZE);
            _loc7_++;
         }
         this.comicDisplay.scaleX = this.comicDisplay.scaleY = 1;
         if(param1 || BSConstants.HQ)
         {
            this.resized();
         }
         this.spelling(true);
         return _loc5_;
      }
      
      public function getThumb() : Object
      {
         return this.thumb;
      }
      
      public function pullTestBMP(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("pullTestBMP()");
         }
         this.comicInterface.removeChildAt(this.comicInterface.numChildren - 1);
         this.comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.pullTestBMP);
      }
      
      public function move_down(param1:MouseEvent) : void
      {
         var _loc2_:IBody = null;
         if(this.popped_asset)
         {
            if(this.popped_asset is ComicCharAsset)
            {
               _loc2_ = (this.popped_asset as ComicCharAsset).body;
               trace(_loc2_.skin.selected_skin_piece.stack_group);
               _loc2_.simple_bone_down(_loc2_.skin.selected_skin_piece.stack_group);
            }
         }
         else if(this.selectedAsset && this.selectedAsset.parent)
         {
            this.selectedAsset.move_up();
            this.myComicBuilder.getComic_controls().update_stacking();
         }
      }
      
      public function move_up(param1:MouseEvent) : void
      {
         var _loc2_:IBody = null;
         if(this.popped_asset)
         {
            if(this.popped_asset is ComicCharAsset)
            {
               _loc2_ = (this.popped_asset as ComicCharAsset).body;
               trace(_loc2_.skin.selected_skin_piece.stack_group);
               _loc2_.simple_bone_up(_loc2_.skin.selected_skin_piece.stack_group);
            }
         }
         else if(this.selectedAsset && this.selectedAsset.parent)
         {
            this.selectedAsset.move_down();
            this.myComicBuilder.getComic_controls().update_stacking();
         }
      }
      
      public function getDisplay() : Sprite
      {
         return this.comicInterface;
      }
      
      public function getEditable() : Boolean
      {
         return this.comicData.editable;
      }
      
      public function getComicArea() : Sprite
      {
         return this.comicArea;
      }
      
      public function getComicBuilder() : ComicBuilder
      {
         return this.myComicBuilder;
      }
      
      public function get_comicData() : Object
      {
         return this.comicData;
      }
      
      public function get height() : Number
      {
         var _loc1_:Number = Comic.BORDER_SIZE;
         var _loc2_:int = 0;
         while(_loc2_ < this.stripList.length)
         {
            _loc1_ = _loc1_ + (this.stripList[_loc2_].getHeight() + Comic.BORDER_SIZE);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getComicSize() : Rectangle
      {
         var _loc2_:Vector.<ComicPanel> = null;
         var _loc5_:ComicPanel = null;
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.width = Comic.BORDER_SIZE;
         _loc1_.height = Comic.BORDER_SIZE;
         var _loc3_:int = 0;
         while(_loc3_ < this.stripList.length)
         {
            _loc1_.height = _loc1_.height + (this.stripList[_loc3_].getHeight() + Comic.BORDER_SIZE);
            _loc3_++;
         }
         _loc2_ = this.stripList[0].getPanelList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc1_.width = _loc1_.width + (_loc5_.panel_width + Comic.BORDER_SIZE);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function getAssetByName(param1:String) : ComicAsset
      {
         var _loc3_:Vector.<ComicPanel> = null;
         var _loc5_:int = 0;
         if(this.debug)
         {
            trace("--Comic.getAssetByName()--");
         }
         var _loc2_:ComicAsset = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.stripList.length)
         {
            _loc3_ = this.stripList[_loc4_].getPanelList();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc2_ = _loc3_[_loc5_].getAssetByName(param1);
               if(_loc2_)
               {
                  return _loc2_;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function get series_id() : int
      {
         if(this.comicData && this.comicData.hasOwnProperty("series"))
         {
            return this.comicData.series;
         }
         return 0;
      }
      
      public function getTitle() : String
      {
         return this.comicData.comicTitle;
      }
      
      public function clearComic() : void
      {
         if(this.selectedAsset)
         {
            this.selectAsset(null);
         }
         if(this.selectedPanel)
         {
            this.selectPanel(null);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.stripList.length)
         {
            this.stripList[_loc1_].clearStrip();
            this.comicDisplay.removeChild(this.stripList[_loc1_]);
            _loc1_++;
         }
         this.stripList = new Vector.<ComicStrip>();
      }
      
      public function getPanelCount() : int
      {
         var _loc2_:Vector.<ComicPanel> = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this.stripList.length)
         {
            _loc2_ = this.stripList[_loc3_].getPanelList();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc1_++;
               _loc4_++;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get_stripList() : Vector.<ComicStrip>
      {
         return this.stripList;
      }
      
      public function setSeries(param1:Number) : void
      {
         if(this.debug)
         {
            trace("--Comic.setSeries(" + param1 + ")--");
         }
         var _loc2_:ComicSeries = this.myComicBuilder.getAuthor().getSeries(param1);
         this.comicData.series = param1;
         this.comicData.episode = _loc2_.addCount();
         this.myComicBuilder.updateComicData(this.comicData);
         this.myComicBuilder.updateTitleBar();
      }
      
      public function set_editable(param1:Boolean) : void
      {
         this.editable = param1;
      }
      
      public function getSelectedAsset() : ComicAsset
      {
         return this.selectedAsset;
      }
      
      public function get_cl() : CharLoader
      {
         return this.cl;
      }
      
      public function setBackdropColour(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < this.stripList.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this.stripList[_loc3_].getPanelList().length)
               {
                  this.stripList[_loc3_].getPanelList()[_loc4_].panel_contents.sky_colour = param1;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         else if(this.selectedPanel)
         {
            this.selectedPanel.panel_contents.sky_colour = param1;
         }
      }
      
      public function setGroundColour(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < this.stripList.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this.stripList[_loc3_].getPanelList().length)
               {
                  this.stripList[_loc3_].getPanelList()[_loc4_].panel_contents.ground_colour = param1;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         else if(this.selectedPanel)
         {
            this.selectedPanel.panel_contents.ground_colour = param1;
         }
      }
      
      public function stripCursor(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
      }
      
      public function check_key(param1:KeyboardEvent) : void
      {
         trace("Comic Key " + param1.keyCode + " " + param1.charCode);
         if(this.myComicBuilder && this.myComicBuilder.stage && this.myComicBuilder.stage.focus is TextField)
         {
            return;
         }
         if(param1.charCode == 127)
         {
            this.pre_undo();
            this.do_delete();
         }
         else if(param1.ctrlKey && param1.charCode == 3)
         {
            this.do_copy();
         }
         else if(param1.ctrlKey && param1.charCode == 24)
         {
            this.pre_undo();
            this.do_copy();
            this.do_delete();
         }
         else if(param1.ctrlKey && param1.charCode == 22)
         {
            this.pre_undo();
            this.paste(this.clipboard);
         }
         else if(param1.ctrlKey && param1.charCode == 26)
         {
            this.do_undo();
         }
         else if(param1.ctrlKey && param1.charCode == 25)
         {
            this.do_redo();
         }
      }
      
      private function check_mouse_up(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = this.comicDisplay.stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_ is ComicAsset)
            {
               if(ComicAsset(_loc3_).update_cursor())
               {
                  return;
               }
            }
         }
         trace("Do we need to update the cursor?" + _loc2_);
      }
      
      public function get blank() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.stripList.length)
         {
            if(this.stripList[_loc1_].blank == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function set scroll_v(param1:Number) : void
      {
         this._scroll_v = param1;
         this.update_scrollRect();
      }
      
      private function update_scrollRect() : void
      {
         var _loc1_:Number = this.height;
         var _loc2_:Number = this._scroll_v / this.stripList.length;
         var _loc3_:Number = this.myComicBuilder.stage_height - 143 - 41;
         if(_loc1_ <= _loc3_)
         {
            this._scroll_v = 0;
            _loc2_ = 0;
         }
         this.comicDisplay.scrollRect = new Rectangle(0,-2 + (_loc1_ - _loc3_) * _loc2_,Comic.WIDTH_MAX,_loc3_);
      }
      
      public function get strips() : Vector.<ComicStrip>
      {
         return this.stripList;
      }
      
      public function get popped_asset() : ComicAsset
      {
         return this._popped_asset;
      }
      
      public function set popped_asset(param1:ComicAsset) : void
      {
         this._popped_asset = param1;
         if(this._popped_asset != null)
         {
            dispatchEvent(new Event("POSE_BEGIN"));
         }
         else
         {
            dispatchEvent(new Event("POSE_END"));
         }
      }
   }
}
