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
   import fl.controls.CheckBox;
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
      
      public static const PANEL_HEIGHT_MAX:uint = 360;
      
      public static const PANEL_MAX:uint = 6;
      
      public static const WIDTH_MAX:uint = 740;
      
      public static const BORDER_SIZE:Number = 8;
      
      public static const PANEL_HEIGHT_MIN:uint = 100;
      
      public static const STRIP_MAX:uint = 7;
      
      public static const PANEL_WIDTH_MIN:uint = 100;
       
      
      private var currentBorder:Sprite;
      
      private var currentPanel:ComicPanel;
      
      public var selectedAsset:ComicAsset;
      
      private var _controls:ComicControls;
      
      private var comicInterface:Sprite;
      
      private var currentStrip:ComicStrip;
      
      private var il:ImageLoader;
      
      public var selectedPanel:ComicPanel;
      
      public var selectedStrip:ComicStrip;
      
      private var shared_clipboard:SharedObject;
      
      private var undo_offset:int = 0;
      
      public const debug:Boolean = false;
      
      private var editable:Boolean = true;
      
      private var _scroll_v:Number = 0;
      
      private var cl:CharLoader;
      
      public var _popped_asset:ComicAsset;
      
      private var borderH_R:Sprite;
      
      private var borderH_L:Sprite;
      
      private var editableSaved:Boolean;
      
      private var comicArea:Sprite;
      
      private var myComicBuilder:ComicBuilder;
      
      private var myTitleInterface:TitleInterface;
      
      private var groundLock_cbx:CheckBox;
      
      private var clipboard:Object;
      
      public var comicData:Object;
      
      private var borderV:Sprite;
      
      private var thumb:Object;
      
      private var stripList:Array;
      
      private var borderOffset:Point;
      
      private var _move_mode:uint = 0;
      
      private var undo:Array;
      
      private var comicDisplay:Sprite;
      
      private var _loading:Boolean = false;
      
      public function Comic(param1:ComicBuilder, param2:ImageLoader, param3:CharLoader)
      {
         var new_myComicBuilder:ComicBuilder = param1;
         var new_il:ImageLoader = param2;
         var new_cl:CharLoader = param3;
         undo = [];
         super();
         if(debug)
         {
            trace("--Comic()--");
         }
         myComicBuilder = new_myComicBuilder;
         il = new_il;
         cl = new_cl;
         comicData = new Object();
         thumb = {
            "x":0,
            "y":0,
            "width":0,
            "height":0
         };
         myTitleInterface = new TitleInterface(this);
         comicInterface = new Sprite();
         comicDisplay = new Sprite();
         comicArea = new Sprite();
         borderH_L = new Sprite();
         borderH_R = new Sprite();
         borderV = new Sprite();
         comicInterface.addChild(comicDisplay);
         comicInterface.addChild(myTitleInterface);
         comicDisplay.addChild(borderV);
         comicDisplay.addChild(borderH_R);
         comicDisplay.addChild(borderH_L);
         stripList = new Array();
         clipboard = new Object();
         if(BSConstants.SHARED_CLIPBOARD)
         {
            shared_clipboard = SharedObject.getLocal("clipboard","/",false);
         }
         comicDisplay.addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            comicDisplay.stage.addEventListener(KeyboardEvent.KEY_UP,check_key);
         });
      }
      
      public function pre_undo() : void
      {
         trace("Saving data in: " + undo_offset);
         add_undo(setData,this.save_state());
      }
      
      public function get_comicData() : Object
      {
         return comicData;
      }
      
      public function set scroll_v(param1:Number) : void
      {
         _scroll_v = param1;
         update_scrollRect();
      }
      
      public function paste_click(param1:MouseEvent) : void
      {
         stop_editing_asset();
         pre_undo();
         paste(clipboard);
      }
      
      public function stop_editing_asset() : void
      {
         if(selectedAsset && selectedAsset.editing)
         {
            selectedAsset.editing = false;
         }
      }
      
      function centerComic(param1:Sprite) : void
      {
         param1.x = comicArea.width / 2 - stripList[0].getSize().width / 2;
         update_scrollRect();
      }
      
      public function clearComic() : void
      {
         if(selectedAsset)
         {
            selectAsset(null);
         }
         if(selectedPanel)
         {
            selectPanel(null);
         }
         var _loc1_:int = 0;
         while(_loc1_ < stripList.length)
         {
            stripList[_loc1_].clearStrip();
            comicDisplay.removeChild(stripList[_loc1_]);
            _loc1_++;
         }
         stripList = new Array();
      }
      
      public function pasteAsset(param1:Object, param2:ComicPanel = null, param3:Boolean = false) : ComicAsset
      {
         if(debug)
         {
            trace("--Comic.pasteAsset()--");
         }
         if(param2 == null)
         {
            param2 = selectedPanel;
         }
         var _loc4_:ComicAsset = addAssetToPanel(param1,param2,param3);
         return _loc4_;
      }
      
      public function getThumb() : Object
      {
         return thumb;
      }
      
      public function setAssetColour(param1:Number) : void
      {
         if(selectedAsset)
         {
            selectedAsset.setColour(param1);
         }
      }
      
      public function getBitmap(param1:Boolean = false) : Bitmap
      {
         return new Bitmap(getBitmapData(param1));
      }
      
      public function addPanel_click(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:ComicPanel = null;
         stop_editing_asset();
         if(comicData.editable)
         {
            if(selectedStrip != null && selectedPanel != null)
            {
               _loc2_ = selectedStrip.getPanelList();
               if(_loc2_.length < Comic.PANEL_MAX)
               {
                  pre_undo();
                  _loc3_ = _loc2_.indexOf(selectedPanel);
                  _loc4_ = selectedPanel.panel_width / 2;
                  if(_loc4_ >= PANEL_WIDTH_MIN)
                  {
                     selectedPanel.panel_width = selectedPanel.panel_width - (_loc4_ + Comic.BORDER_SIZE / 2);
                  }
                  else
                  {
                     _loc7_ = Comic.PANEL_WIDTH_MIN * 2 + Comic.BORDER_SIZE / 2 - selectedPanel.panel_width;
                     _loc8_ = 0;
                     selectedPanel.panel_width = Comic.PANEL_WIDTH_MIN;
                     _loc4_ = Comic.PANEL_WIDTH_MIN;
                     _loc9_ = _loc3_ + 1;
                     while(_loc9_ < _loc2_.length)
                     {
                        _loc10_ = _loc2_[_loc9_];
                        if(_loc10_ != null)
                        {
                           _loc8_ = _loc10_.panel_width - Comic.PANEL_WIDTH_MIN;
                           if(_loc8_ > _loc7_)
                           {
                              _loc8_ = _loc7_;
                           }
                           _loc10_.panel_width = _loc10_.panel_width - _loc8_;
                           _loc7_ = _loc7_ - _loc8_;
                        }
                        _loc9_++;
                     }
                     if(_loc7_ > 0)
                     {
                        _loc9_ = _loc3_ - 1;
                        while(_loc9_ >= 0)
                        {
                           _loc10_ = _loc2_[_loc9_];
                           if(_loc10_ != null)
                           {
                              _loc8_ = _loc10_.panel_width - Comic.PANEL_WIDTH_MIN;
                              if(_loc8_ > _loc7_)
                              {
                                 _loc8_ = _loc7_;
                              }
                              _loc10_.panel_width = _loc10_.panel_width - _loc8_;
                              _loc7_ = _loc7_ - _loc8_;
                           }
                           _loc9_--;
                        }
                     }
                  }
                  _loc5_ = new Object();
                  _loc5_.width = _loc4_ - Comic.BORDER_SIZE / 2;
                  _loc5_.bkgrColor = 16777215;
                  _loc5_.contentList = new Array();
                  _loc5_.content_scale = selectedPanel.scale;
                  selectPanel(addPanelAt(selectedStrip,_loc5_,true,_loc3_ + 1));
                  _loc6_ = selectedStrip.getSize().width;
                  this.comic_width = _loc6_;
               }
            }
         }
      }
      
      public function get_stripList() : Array
      {
         return stripList;
      }
      
      public function get height() : Number
      {
         var _loc1_:Number = Comic.BORDER_SIZE;
         var _loc2_:int = 0;
         while(_loc2_ < stripList.length)
         {
            _loc1_ = _loc1_ + (stripList[_loc2_].getHeight() + Comic.BORDER_SIZE);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set_cameraStyle(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         if(debug)
         {
            trace("--Comic.set_cameraStyle(" + param1 + ")--");
         }
         var _loc3_:int = 0;
         while(_loc3_ < stripList.length)
         {
            _loc2_ = stripList[_loc3_].getPanelList();
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc2_[_loc4_].set_cameraStyle(param1);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function releaseAsset(param1:ComicPanel, param2:Object) : void
      {
         var _loc3_:* = null;
         if(debug)
         {
            trace("--Comic.releaseAsset(" + param2.type + ")--");
         }
         selectPanel(param1);
         if(param2.type == "scenes")
         {
            param1.absorbScene(param2["asset_data"].strips[0].panels[0]);
            for(_loc3_ in param2["asset_data"])
            {
               if(debug)
               {
                  trace(_loc3_ + ": " + param2["asset_data"][_loc3_]);
               }
            }
            if(debug)
            {
               trace("---------------------");
            }
         }
         else
         {
            addAssetToPanel(param2,param1,true);
         }
      }
      
      public function do_redo() : void
      {
         var _loc1_:Function = null;
         var _loc2_:ByteArray = null;
         var _loc3_:Object = null;
         trace("undo_offset: " + undo_offset + " undo.length: " + undo.length);
         if(undo_offset < undo.length - 1)
         {
            undo_offset = undo_offset + 1;
            trace("Loading data: " + undo_offset);
            _loc1_ = undo[undo_offset][0];
            _loc2_ = undo[undo_offset][1];
            _loc3_ = _loc2_.readObject();
            _loc2_.position = 0;
            _loc1_(_loc3_);
            if(undo_offset >= undo.length - 1)
            {
               dispatchEvent(new Event("NO_REDO"));
            }
         }
         else
         {
            dispatchEvent(new Event("NO_REDO"));
         }
         if(undo_offset > 0)
         {
            dispatchEvent(new Event("UNDO_READY"));
         }
      }
      
      public function toggle_lock(param1:MouseEvent) : void
      {
         stop_editing_asset();
         if(debug)
         {
            trace("toggle_lock()");
         }
         if(selectedAsset)
         {
            selectedAsset.setLock(!selectedAsset.getLock());
            dispatchEvent(new Event("ASSET_SELECT"));
         }
      }
      
      public function resized(param1:Number = 0) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < stripList.length)
         {
            stripList[_loc2_].resized(param1);
            _loc2_++;
         }
      }
      
      public function pastePanel(param1:Object) : void
      {
         if(debug)
         {
            trace("--Comic.pastePanel(" + param1 + ")--");
         }
         param1["height"] = null;
         param1["width"] = null;
         selectedPanel.load_state(param1);
      }
      
      function setData(param1:Object) : void
      {
         var _loc3_:ComicStrip = null;
         var _loc5_:int = 0;
         var _loc6_:ComicPanel = null;
         if(debug)
         {
            trace("--Comic.setData()--");
         }
         _loading = true;
         comicData = Utils.clone(param1);
         if(!comicData["series"])
         {
            comicData["series"] = 0;
         }
         if(!comicData["episode"])
         {
            comicData["episode"] = 0;
         }
         clearComic();
         stripList = new Array();
         var _loc2_:Boolean = false;
         if(debug)
         {
            trace("so far so good");
         }
         if(debug)
         {
            trace("comicData.strips: " + comicData.strips);
         }
         var _loc4_:int = 0;
         while(_loc4_ < comicData.strips.length)
         {
            if(_loc4_ > 0)
            {
               _loc2_ = true;
            }
            else
            {
               _loc2_ = false;
            }
            _loc3_ = addStrip(comicData.strips[_loc4_],_loc2_,_loc4_);
            _loc5_ = 0;
            while(_loc5_ < comicData.strips[_loc4_].panels.length)
            {
               _loc2_ = true;
               if(_loc5_ < 1)
               {
                  _loc2_ = false;
               }
               _loc6_ = addPanel(_loc3_,comicData.strips[_loc4_].panels[_loc5_],_loc2_);
               _loc5_++;
            }
            _loc4_++;
         }
         if(selectedPanel)
         {
            selectPanel(null);
         }
         initialDraw();
         drawMe();
         if(comicData.hasOwnProperty("bkgrColor"))
         {
            myComicBuilder.setBackgroundColour(comicData["bkgrColor"]);
         }
         myComicBuilder.repositionComicControls();
         _loading = false;
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
         stop_editing_asset();
         if(comicData.editable)
         {
            if(stripList.length < STRIP_MAX)
            {
               pre_undo();
               _loc2_ = stripList.length;
               if(this.selectedStrip)
               {
                  _loc2_ = this.stripList.indexOf(this.selectedStrip) + 1;
               }
               _loc3_ = this.stripList[_loc2_ - 1];
               _loc4_ = new Object();
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < stripList.length)
               {
                  _loc5_ = _loc5_ + stripList[_loc6_].getSize().height;
                  _loc6_++;
               }
               _loc4_.height = _loc3_.getSize()["height"];
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
               _loc8_ = addStrip(_loc4_,true,_loc2_);
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
                  addPanel(_loc8_,_loc4_.panels[_loc6_],_loc9_);
                  _loc6_++;
               }
               drawMe();
               myComicBuilder.repositionComicControls();
            }
         }
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
      
      public function do_undo() : void
      {
         var _loc1_:Function = null;
         var _loc2_:ByteArray = null;
         var _loc3_:Object = null;
         if(undo_offset > 0)
         {
            if(undo_offset == undo.length)
            {
               trace("First undo from the top");
               pre_undo();
               undo_offset = undo_offset - 1;
            }
            undo_offset = undo_offset - 1;
            undo_offset = Math.max(undo_offset,0);
            trace("Loading data: " + undo_offset);
            _loc1_ = undo[undo_offset][0];
            _loc2_ = undo[undo_offset][1];
            _loc3_ = _loc2_.readObject();
            _loc2_.position = 0;
            _loc1_(_loc3_);
            if(undo_offset == 0)
            {
               dispatchEvent(new Event("NO_UNDO"));
            }
            else
            {
               dispatchEvent(new Event("UNDO_READY"));
            }
            if(undo_offset < undo.length)
            {
               dispatchEvent(new Event("REDO_READY"));
            }
            else
            {
               dispatchEvent(new Event("NO_REDO"));
            }
         }
      }
      
      public function getSeriesID() : String
      {
         if(comicData && comicData.series)
         {
            return comicData.series;
         }
         return "0";
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
      
      public function borderResizeComicWidth() : void
      {
         var _loc3_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc10_:ComicStrip = null;
         var _loc11_:Number = NaN;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         if(debug)
         {
            trace("--Comic.borderResizeComicWidth()--");
         }
         var _loc1_:Boolean = true;
         var _loc2_:Number = currentBorder.mouseX - borderOffset.x;
         var _loc4_:Array = new Array();
         if(debug)
         {
            trace("Original ChangeX: " + _loc2_);
         }
         var _loc9_:int = 0;
         while(_loc9_ < stripList.length)
         {
            _loc10_ = stripList[_loc9_];
            _loc6_ = _loc10_.getSize();
            _loc7_ = _loc6_.width + _loc2_;
            _loc11_ = _loc10_.panels.length * (PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE;
            if(_loc7_ <= _loc11_)
            {
               _loc8_ = _loc6_.width - _loc11_;
               if(_loc2_ < 0)
               {
                  _loc2_ = Math.min(_loc8_,0);
               }
               else
               {
                  _loc2_ = _loc8_;
               }
            }
            else if(_loc7_ >= WIDTH_MAX)
            {
               _loc8_ = WIDTH_MAX - _loc6_.width;
               if(_loc8_ > 0)
               {
                  _loc2_ = Math.max(_loc8_,0);
               }
               else
               {
                  _loc2_ = _loc8_;
               }
            }
            if(debug)
            {
               trace("Strip: " + _loc9_ + " Width: " + _loc6_.width + " " + " newWidth: " + _loc7_ + " ChangeX: " + _loc2_);
            }
            _loc9_++;
         }
         if(_loc2_ == 0)
         {
            return;
         }
         _loc9_ = 0;
         while(_loc9_ < stripList.length)
         {
            _loc3_ = stripList[_loc9_].getPanelList();
            trace("Strip: " + _loc9_ + ", Panel Checks");
            _loc12_ = false;
            _loc13_ = _loc3_.length - 1;
            while(_loc13_ >= 0)
            {
               _loc7_ = _loc3_[_loc13_].panel_width + _loc2_;
               trace("\t Panel: " + _loc13_ + ", Current: " + _loc3_[_loc13_].panel_width + ", New Width: " + _loc7_);
               if(_loc7_ <= PANEL_WIDTH_MIN || _loc7_ >= WIDTH_MAX)
               {
                  _loc13_--;
                  continue;
               }
               _loc4_.push(_loc3_[_loc13_]);
               _loc12_ = true;
               break;
            }
            if(_loc12_ == false)
            {
               _loc1_ = false;
               break;
            }
            _loc9_++;
         }
         if(debug)
         {
            trace("legalResize: " + _loc1_);
         }
         if(_loc1_)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc4_.length)
            {
               _loc4_[_loc9_].panel_width = _loc4_[_loc9_].panel_width + _loc2_;
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < stripList.length)
            {
               stripList[_loc9_].drawMe();
               _loc9_++;
            }
            drawMe();
         }
      }
      
      public function copy_click(param1:MouseEvent) : void
      {
         do_copy();
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--Comic.save_state()--");
         }
         var _loc1_:Object = comicData;
         _loc1_.strips = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < stripList.length)
         {
            _loc1_.strips[_loc2_] = stripList[_loc2_].save_state();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function move_down(param1:MouseEvent) : void
      {
         var _loc2_:IBody = null;
         if(popped_asset)
         {
            if(popped_asset is ComicCharAsset)
            {
               _loc2_ = (popped_asset as ComicCharAsset).body;
               trace(_loc2_.skin.selected_skin_piece.stack_group);
               _loc2_.simple_bone_down(_loc2_.skin.selected_skin_piece.stack_group);
            }
         }
         else if(selectedAsset && selectedAsset.parent)
         {
            selectedAsset.move_up();
            this.myComicBuilder.getComic_controls().update_stacking();
         }
      }
      
      public function get move_mode() : uint
      {
         return _move_mode;
      }
      
      public function getComicSize() : Rectangle
      {
         var _loc2_:Array = null;
         var _loc5_:ComicPanel = null;
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.width = Comic.BORDER_SIZE;
         _loc1_.height = Comic.BORDER_SIZE;
         var _loc3_:int = 0;
         while(_loc3_ < stripList.length)
         {
            _loc1_.height = _loc1_.height + (stripList[_loc3_].getHeight() + Comic.BORDER_SIZE);
            _loc3_++;
         }
         _loc2_ = stripList[0].getPanelList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc1_.width = _loc1_.width + (_loc5_.panel_width + Comic.BORDER_SIZE);
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function stripFollower(param1:ComicStrip) : ComicStrip
      {
         var _loc2_:int = stripList.indexOf(param1);
         if(_loc2_ > 0)
         {
            return stripList[_loc2_ - 1];
         }
         return null;
      }
      
      public function set popped_asset(param1:ComicAsset) : void
      {
         _popped_asset = param1;
         if(_popped_asset != null)
         {
            dispatchEvent(new Event("POSE_BEGIN"));
         }
         else
         {
            dispatchEvent(new Event("POSE_END"));
         }
      }
      
      public function getComicBuilder() : ComicBuilder
      {
         return myComicBuilder;
      }
      
      public function borderResizeComicHeight() : void
      {
         var _loc1_:Number = borderV.mouseY - borderV.height / 2;
         var _loc2_:ComicStrip = stripList[stripList.length - 1];
         scroll_v = stripList.length;
         resizeStrip(_loc2_,_loc1_);
      }
      
      public function selectAsset(param1:ComicAsset) : void
      {
         if(debug)
         {
            trace("--Comic.selectAsset(" + param1 + ")--");
         }
         if(selectedAsset == param1)
         {
            return;
         }
         stop_editing_asset();
         if(selectedAsset)
         {
            if(debug)
            {
               trace("getting rid of an existing selection");
            }
            selectedAsset.doSelect(false);
            myComicBuilder.registerControlType(null,null);
         }
         selectedAsset = param1;
         if(selectedAsset)
         {
            if(debug)
            {
               trace("setting a new selection");
            }
            selectedAsset.doSelect(true);
            selectPanel(ComicPanel(selectedAsset.getPanel()));
            if(selectedAsset is ComicCharAsset)
            {
               myComicBuilder.registerControlType("characters",selectedAsset);
            }
            else if(selectedAsset is TextBubble)
            {
               myComicBuilder.registerControlType("text bubble",selectedAsset);
            }
            else if(selectedAsset is ComicPropAsset)
            {
               if(selectedAsset.getData()["type"] == "walls")
               {
                  myComicBuilder.registerControlType("walls",selectedAsset);
               }
               else
               {
                  myComicBuilder.registerControlType("props",selectedAsset);
               }
            }
         }
         dispatchEvent(new Event("ASSET_SELECT"));
      }
      
      public function getAssetByName(param1:String) : ComicAsset
      {
         var _loc3_:Array = null;
         var _loc5_:int = 0;
         if(debug)
         {
            trace("--Comic.getAssetByName()--");
         }
         var _loc2_:ComicAsset = null;
         var _loc4_:int = 0;
         while(_loc4_ < stripList.length)
         {
            _loc3_ = stripList[_loc4_].getPanelList();
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
      
      public function getSelectedAsset() : ComicAsset
      {
         return selectedAsset;
      }
      
      public function removePanel_confirm(param1:MouseEvent) : void
      {
         removePanel(selectedPanel);
         drawMe();
      }
      
      public function get strips() : Array
      {
         return stripList;
      }
      
      public function get blank() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < stripList.length)
         {
            if(stripList[_loc1_].blank == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function selectPanel(param1:ComicPanel) : void
      {
         if(debug)
         {
            trace("--Comic.selectPanel(" + param1 + ")--");
         }
         if(param1 == selectedPanel)
         {
            if(selectedAsset == null)
            {
               myComicBuilder.registerPanel(selectedPanel);
            }
            return;
         }
         if(selectedPanel)
         {
            selectedPanel.selected = false;
         }
         selectedPanel = param1;
         if(selectedPanel)
         {
            selectedPanel.selected = true;
            selectedStrip = selectedPanel.getStrip();
            if(!selectedAsset)
            {
               myComicBuilder.registerPanel(selectedPanel);
            }
         }
         else
         {
            selectAsset(null);
         }
         dispatchEvent(new Event("PANEL_SELECT"));
      }
      
      public function set controls(param1:ComicControls) : void
      {
         _controls = param1;
         _controls.addPanel_btn.addEventListener(MouseEvent.CLICK,addPanel_click);
         _controls.removePanel_btn.addEventListener(MouseEvent.CLICK,removePanel_click);
         _controls.addStrip_btn.addEventListener(MouseEvent.CLICK,addStrip_click);
         _controls.delete_btn.addEventListener(MouseEvent.CLICK,delete_click);
         _controls.copy_btn.addEventListener(MouseEvent.CLICK,copy_click);
         _controls.paste_btn.addEventListener(MouseEvent.CLICK,paste_click);
         _controls.lock_btn.addEventListener(MouseEvent.CLICK,toggle_lock);
         _controls.move_down_btn.addEventListener(MouseEvent.CLICK,move_down);
         _controls.move_up_btn.addEventListener(MouseEvent.CLICK,move_up);
      }
      
      public function getBitmapPanels() : Array
      {
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:ComicPanel = null;
         stop_editing_asset();
         selectAsset(null);
         selectPanel(null);
         var _loc1_:Array = new Array();
         var _loc2_:uint = 0;
         while(_loc2_ < stripList.length)
         {
            _loc3_ = stripList[_loc2_].getPanelList();
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
      
      public function removeStrip_confirm(param1:MouseEvent) : void
      {
         if(!removeStrip(selectedStrip))
         {
         }
      }
      
      public function addPanelAt(param1:ComicStrip, param2:Object, param3:Boolean, param4:int) : ComicPanel
      {
         if(debug)
         {
            trace("--Comic.addPanelAt(" + param4 + ")--");
         }
         var _loc5_:ComicPanel = new ComicPanel(this,param1,param2,param3);
         param1.addPanelAt(_loc5_,param4);
         _loc5_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         param2["height"] = param1.getHeight();
         _loc5_.load_state(param2);
         _loc5_.blank = true;
         param1.drawMe();
         drawMe();
         return _loc5_;
      }
      
      public function getPanelCount() : int
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < stripList.length)
         {
            _loc2_ = stripList[_loc3_].getPanelList();
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
      
      public function addAssetToPanel(param1:Object, param2:ComicPanel, param3:Boolean) : ComicAsset
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc7_:DisplayObject = null;
         if(debug)
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
               if(debug)
               {
                  trace("A CHARACTER ASSET");
               }
               if(_loading == false)
               {
                  _loc7_ = il.get_image(param1["bmpURL"]);
               }
               _loc4_ = cl.get_char_asset(param1["id"],_loc7_,param1["version"]);
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
               _loc4_ = cl.get_prop_asset(param1["id"]);
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
            selectAsset(_loc4_);
         }
         return _loc4_;
      }
      
      public function removeStrip_click(param1:MouseEvent) : void
      {
         stop_editing_asset();
         if(comicData.editable)
         {
            if(stripList.length > comicData.strip_min && selectedStrip != null)
            {
               if(selectedStrip != null)
               {
                  pre_undo();
                  removeStrip_confirm(param1);
               }
            }
         }
      }
      
      public function getBitmapData(param1:Boolean) : BitmapData
      {
         var _loc9_:ComicStrip = null;
         stop_editing_asset();
         selectAsset(null);
         selectPanel(null);
         spelling(false);
         var _loc2_:Matrix = new Matrix();
         var _loc3_:Rectangle = getComicSize();
         var _loc4_:Number = 1;
         if(param1 || BSConstants.HQ)
         {
            _loc4_ = 3.8;
            comicDisplay.scaleX = comicDisplay.scaleY = _loc4_;
            this.resized();
            _loc2_.scale(_loc4_,_loc4_);
         }
         else if(comicDisplay.stage == null)
         {
            this.resized(1);
         }
         _loc2_.translate(2 * _loc4_,2 * _loc4_);
         var _loc5_:BitmapData = new BitmapData(_loc3_.width * _loc4_,_loc3_.height * _loc4_,true,16777215);
         var _loc6_:Array = this.stripList;
         var _loc7_:int = Comic.BORDER_SIZE;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc8_];
            _loc2_ = new Matrix();
            _loc2_.scale(_loc4_,_loc4_);
            _loc2_.translate(Comic.BORDER_SIZE * _loc4_,_loc7_ * _loc4_);
            _loc5_.draw(_loc9_,_loc2_);
            _loc7_ = _loc7_ + (_loc9_.strip_height + Comic.BORDER_SIZE);
            _loc8_++;
         }
         comicDisplay.scaleX = comicDisplay.scaleY = 1;
         if(param1 || BSConstants.HQ)
         {
            this.resized();
         }
         spelling(true);
         return _loc5_;
      }
      
      public function setSeries(param1:Number) : void
      {
         if(debug)
         {
            trace("--Comic.setSeries(" + param1 + ")--");
         }
         var _loc2_:ComicSeries = myComicBuilder.getAuthor().getSeries(param1);
         comicData.series = param1;
         comicData.episode = _loc2_.addCount();
         myComicBuilder.updateComicData(comicData);
         myComicBuilder.updateTitleBar();
      }
      
      private function update_scrollRect() : void
      {
         var _loc1_:Number = this.height;
         var _loc2_:Number = _scroll_v / stripList.length;
         var _loc3_:Number = myComicBuilder.stage_height - 143 - 41;
         if(_loc1_ <= _loc3_)
         {
            _scroll_v = 0;
            _loc2_ = 0;
         }
         comicDisplay.scrollRect = new Rectangle(0,-2 + (_loc1_ - _loc3_) * _loc2_,Comic.WIDTH_MAX,_loc3_);
      }
      
      public function killBorders() : void
      {
         comicDisplay.removeChild(borderH_L);
         comicDisplay.removeChild(borderH_R);
         comicDisplay.removeChild(borderV);
      }
      
      public function removePanel_click(param1:MouseEvent) : void
      {
         stop_editing_asset();
         if(comicData.editable)
         {
            if(selectedStrip != null && selectedPanel != null)
            {
               if(selectedStrip.getPanelList().length > comicData.strip_min)
               {
                  pre_undo();
                  removePanel_confirm(param1);
               }
               else if(stripList.length > 1)
               {
                  removeStrip(selectedStrip);
               }
            }
         }
      }
      
      public function pullTestBMP(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("pullTestBMP()");
         }
         comicInterface.removeChildAt(comicInterface.numChildren - 1);
         comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,pullTestBMP);
      }
      
      public function get popped_asset() : ComicAsset
      {
         return _popped_asset;
      }
      
      public function stripCursor(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
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
      
      public function deletePanel_confirm(param1:MouseEvent) : void
      {
         if(selectedPanel)
         {
            selectedPanel.clearPanel();
         }
      }
      
      public function getDisplay() : Sprite
      {
         return comicInterface;
      }
      
      public function set_editable(param1:Boolean) : void
      {
         editable = param1;
      }
      
      public function set move_mode(param1:uint) : void
      {
         trace(" Comic Move Mode: " + param1);
         stop_editing_asset();
         _move_mode = param1;
      }
      
      public function initialDraw() : void
      {
         if(debug)
         {
            trace("--Comic.initialDraw()--");
         }
         borderH_L.addEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart_H);
         borderH_L.addEventListener(MouseEvent.MOUSE_OVER,borderH_over);
         borderH_L.addEventListener(MouseEvent.MOUSE_OUT,stripCursor);
         borderH_R.addEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart_H);
         borderH_R.addEventListener(MouseEvent.MOUSE_OVER,borderH_over);
         borderH_R.addEventListener(MouseEvent.MOUSE_OUT,stripCursor);
         borderV.addEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart_V);
         borderV.addEventListener(MouseEvent.MOUSE_OVER,borderV_over);
         borderV.addEventListener(MouseEvent.MOUSE_OUT,stripCursor);
         comicArea.addEventListener(MouseEvent.ROLL_OUT,stripCursor);
      }
      
      public function do_copy() : void
      {
         stop_editing_asset();
         if(debug)
         {
            trace("do_copy");
         }
         if(selectedAsset && selectedAsset.locked == false)
         {
            clipboard.type = "asset";
            clipboard.content = selectedAsset.save_state();
         }
         else if(selectedPanel)
         {
            clipboard.type = "panel";
            clipboard.content = selectedPanel.save_state();
         }
         if(BSConstants.SHARED_CLIPBOARD)
         {
            shared_clipboard.setProperty("content",Utils.clone(clipboard));
            shared_clipboard.flush();
         }
         clipboard["currentPanel"] = selectedPanel;
      }
      
      public function paste(param1:Object) : void
      {
         var _loc2_:ComicAsset = null;
         if(BSConstants.SHARED_CLIPBOARD)
         {
            shared_clipboard = null;
            shared_clipboard = SharedObject.getLocal("clipboard","/",false);
            shared_clipboard.flush();
            if(shared_clipboard.data.content)
            {
               param1 = shared_clipboard.data.content;
            }
         }
         if(selectedPanel == null)
         {
            return;
         }
         if(param1.type == "panel")
         {
            if(param1["currentPanel"] != selectedPanel)
            {
               pastePanel(param1.content);
            }
         }
         else if(param1 && param1.content)
         {
            _loc2_ = pasteAsset(param1.content,null,true);
            if(param1["currentPanel"] != selectedPanel)
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
      
      function borderMove_H(param1:MouseEvent) : void
      {
         borderResizeComicWidth();
      }
      
      public function check_key(param1:KeyboardEvent) : void
      {
         trace("Comic Key " + param1.keyCode + " " + param1.charCode);
         if(myComicBuilder && myComicBuilder.stage && myComicBuilder.stage.focus is TextField)
         {
            return;
         }
         if(param1.charCode == 127)
         {
            pre_undo();
            do_delete();
         }
         else if(param1.ctrlKey && param1.charCode == 3)
         {
            do_copy();
         }
         else if(param1.ctrlKey && param1.charCode == 24)
         {
            pre_undo();
            do_copy();
            do_delete();
         }
         else if(param1.ctrlKey && param1.charCode == 22)
         {
            pre_undo();
            paste(clipboard);
         }
         else if(param1.ctrlKey && param1.charCode == 26)
         {
            do_undo();
         }
         else if(param1.ctrlKey && param1.charCode == 25)
         {
            do_redo();
         }
      }
      
      public function getTitle() : String
      {
         return comicData.comicTitle;
      }
      
      function borderMove_V(param1:MouseEvent) : void
      {
         borderResizeComicHeight();
      }
      
      public function setGroundColour(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < stripList.length)
            {
               _loc4_ = 0;
               while(_loc4_ < stripList[_loc3_].getPanelList().length)
               {
                  stripList[_loc3_].getPanelList()[_loc4_].panel_contents.ground_colour = param1;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         else if(selectedPanel)
         {
            selectedPanel.panel_contents.ground_colour = param1;
         }
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < stripList.length)
         {
            stripList[_loc2_].spelling(param1);
            _loc2_++;
         }
      }
      
      public function add_undo(param1:Function, param2:Object) : void
      {
         if(param1 == null)
         {
            pre_undo();
            return;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(param2);
         _loc3_.position = 0;
         undo[undo_offset] = [param1,_loc3_];
         undo_offset = undo_offset + 1;
         if(undo_offset != undo.length)
         {
            trace("Breaking the chain");
            undo = undo.slice(0,undo_offset);
         }
         dispatchEvent(new Event("UNDO_READY"));
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
         myComicBuilder.repositionComicControls();
         drawMe();
      }
      
      public function move_up(param1:MouseEvent) : void
      {
         var _loc2_:IBody = null;
         if(popped_asset)
         {
            if(popped_asset is ComicCharAsset)
            {
               _loc2_ = (popped_asset as ComicCharAsset).body;
               trace(_loc2_.skin.selected_skin_piece.stack_group);
               _loc2_.simple_bone_up(_loc2_.skin.selected_skin_piece.stack_group);
            }
         }
         else if(selectedAsset && selectedAsset.parent)
         {
            selectedAsset.move_down();
            this.myComicBuilder.getComic_controls().update_stacking();
         }
      }
      
      public function set comic_width(param1:Number) : void
      {
         var _loc3_:ComicStrip = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:ComicPanel = null;
         var _loc8_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < stripList.length)
         {
            _loc3_ = stripList[_loc2_];
            _loc4_ = _loc3_.getSize().width;
            if(_loc4_ != param1)
            {
               _loc5_ = (param1 - _loc4_) / _loc3_.panels.length;
               _loc6_ = _loc3_.panels.length - 1;
               while(_loc6_ >= 0)
               {
                  _loc7_ = _loc3_.panels[_loc6_];
                  _loc8_ = _loc7_.panel_width;
                  _loc7_.panel_width = _loc8_ + _loc5_;
                  _loc6_--;
               }
               _loc3_.drawMe();
            }
            _loc2_++;
         }
      }
      
      private function check_mouse_up(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = comicDisplay.stage.getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
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
      
      public function setBackdropColour(param1:Number, param2:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2)
         {
            _loc3_ = 0;
            while(_loc3_ < stripList.length)
            {
               _loc4_ = 0;
               while(_loc4_ < stripList[_loc3_].getPanelList().length)
               {
                  stripList[_loc3_].getPanelList()[_loc4_].panel_contents.sky_colour = param1;
                  _loc4_++;
               }
               _loc3_++;
            }
         }
         else if(selectedPanel)
         {
            selectedPanel.panel_contents.sky_colour = param1;
         }
      }
      
      function borderMoveStart_H(param1:MouseEvent) : void
      {
         stop_editing_asset();
         borderOffset = new Point(param1.currentTarget.mouseX,param1.currentTarget.mouseY);
         currentBorder = Sprite(param1.currentTarget);
         if(comicData.editable)
         {
            pre_undo();
            comicDisplay.stage.addEventListener(MouseEvent.MOUSE_UP,borderMoveStop_H);
            comicDisplay.stage.addEventListener(MouseEvent.MOUSE_MOVE,borderMove_H);
         }
      }
      
      function borderMoveStop_H(param1:MouseEvent) : void
      {
         if(comicData.editable)
         {
            comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_UP,borderMoveStop_H);
            comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE,borderMove_H);
         }
         dispatchEvent(new CursorEvent("reset"));
      }
      
      public function getEditable() : Boolean
      {
         return comicData.editable;
      }
      
      public function removePanel(param1:ComicPanel) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(debug)
         {
            trace("--Comic.removePanel()--");
         }
         if(selectedStrip != null)
         {
            _loc2_ = selectedStrip.getPanelList();
            _loc3_ = _loc2_.indexOf(param1);
            if(_loc3_ > 0)
            {
               _loc2_[_loc3_ - 1].panel_width = _loc2_[_loc3_ - 1].panel_width + (param1.panel_width + Comic.BORDER_SIZE);
            }
            else
            {
               _loc2_[_loc3_ + 1].panel_width = _loc2_[_loc3_ + 1].panel_width + (param1.panel_width + Comic.BORDER_SIZE);
            }
            selectedStrip.removePanel(param1);
            if(debug)
            {
               trace("panelList.length: " + _loc2_.length);
            }
            selectedStrip = null;
            selectPanel(null);
            drawMe();
         }
      }
      
      public function addPanel(param1:ComicStrip, param2:Object, param3:Boolean) : ComicPanel
      {
         if(debug)
         {
            trace("--Comic.addPanel()--");
         }
         param2["height"] = param1.getHeight();
         var _loc4_:ComicPanel = new ComicPanel(this,param1,param2,param3);
         _loc4_.set_editable(editable);
         _loc4_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         param1.addPanel(_loc4_);
         selectPanel(_loc4_);
         _loc4_.blank = true;
         return _loc4_;
      }
      
      function borderMoveStop_V(param1:MouseEvent) : void
      {
         if(comicData.editable)
         {
            comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_UP,borderMoveStop_V);
            comicDisplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE,borderMove_V);
         }
         dispatchEvent(new CursorEvent("reset"));
      }
      
      public function do_delete() : void
      {
         var _loc1_:ComicAsset = null;
         if(debug)
         {
            trace("do_delete");
         }
         if(selectedAsset || selectedPanel)
         {
            if(selectedAsset)
            {
               _loc1_ = selectedAsset;
               selectAsset(null);
               _loc1_.getPanel().removeAsset(_loc1_);
            }
            else if(selectedPanel)
            {
               selectedPanel.clearPanel();
            }
         }
      }
      
      public function getComicArea() : Sprite
      {
         return comicArea;
      }
      
      public function locatePanelAtPoint(param1:Point) : ComicPanel
      {
         var _loc2_:Array = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < stripList.length)
         {
            _loc2_ = stripList[_loc3_].getPanelList();
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
      
      public function get_cl() : CharLoader
      {
         return cl;
      }
      
      public function borderResizePanel(param1:ComicPanel, param2:ComicPanel, param3:ComicPanel, param4:Point) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc5_:Boolean = true;
         if(debug)
         {
            trace("borderOffset.x: " + param4.x);
         }
         var _loc6_:Number = comicDisplay.mouseX - param4.x;
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
      
      public function removeStrip(param1:ComicStrip) : Boolean
      {
         if(debug)
         {
            trace("--Comic.removeStrip()--");
         }
         var _loc2_:int = 0;
         while(_loc2_ < stripList.length)
         {
            if(stripList[_loc2_] == param1)
            {
               if(debug)
               {
                  trace("MATCH");
               }
               stripList.splice(_loc2_,1);
               if(debug)
               {
                  trace("stripList.length: " + stripList.length);
               }
               param1.clearStrip();
               comicDisplay.removeChild(param1);
               selectedStrip = null;
               this.selectPanel(null);
               drawMe();
               myComicBuilder.repositionComicControls();
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function addStrip(param1:Object, param2:Boolean, param3:uint) : ComicStrip
      {
         if(debug)
         {
            trace("--Comic.addStrip()--");
         }
         var _loc4_:ComicStrip = new ComicStrip(this,param1.height,param2);
         _loc4_.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         _loc4_.set_editable(editable);
         comicDisplay.addChild(_loc4_);
         stripList.splice(param3,0,_loc4_);
         _loc4_.x = Comic.BORDER_SIZE;
         return _loc4_;
      }
      
      public function borderResizeStrip(param1:ComicStrip, param2:ComicStrip, param3:ComicStrip, param4:Point) : void
      {
         var _loc5_:Number = comicDisplay.mouseY + param4.y;
         var _loc6_:Number = _loc5_ - param1.y;
         resizeStrip(param2,_loc6_);
      }
      
      public function delete_click(param1:MouseEvent) : void
      {
         stop_editing_asset();
         if(debug)
         {
            trace("delete_click");
         }
         pre_undo();
         do_delete();
      }
      
      public function drawMe() : void
      {
         var _loc2_:int = 0;
         if(debug)
         {
            trace("--Comic.drawMe()--");
         }
         var _loc1_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         _loc2_ = 0;
         while(_loc2_ < stripList.length)
         {
            if(_loc2_ > 0)
            {
               _loc1_ = stripList[_loc2_ - 1].y + stripList[_loc2_ - 1].getHeight() + Comic.BORDER_SIZE;
            }
            stripList[_loc2_].y = _loc1_;
            _loc3_ = _loc3_ + stripList[_loc2_].getSize().height;
            _loc2_++;
         }
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         if(stripList[0] != null)
         {
            _loc6_ = stripList[0].y;
            _loc5_ = stripList[0].x + stripList[0].getSize().width;
            _loc5_ = _loc5_ - Comic.BORDER_SIZE * 2;
            if(debug)
            {
               trace("edgeX: " + _loc5_);
            }
         }
         borderH_L.graphics.clear();
         borderH_L.graphics.beginFill(255,0);
         borderH_L.graphics.drawRect(0,0,Comic.BORDER_SIZE,_loc3_);
         borderH_L.graphics.endFill();
         borderH_L.x = _loc5_;
         borderH_L.y = _loc6_;
         borderH_R.graphics.clear();
         borderH_R.graphics.beginFill(16711935,0);
         borderH_R.graphics.drawRect(0,0,Comic.BORDER_SIZE,_loc3_);
         borderH_R.graphics.endFill();
         borderH_R.x = 0;
         borderH_R.y = _loc6_;
         var _loc7_:Number = 0;
         if(stripList[stripList.length - 1] != null)
         {
            _loc7_ = stripList[stripList.length - 1].y + stripList[stripList.length - 1].getSize().height;
            _loc4_ = stripList[stripList.length - 1].getSize().width;
         }
         borderV.graphics.clear();
         borderV.graphics.beginFill(13369599,0);
         borderV.graphics.drawRect(0,0,_loc4_,Comic.BORDER_SIZE);
         borderV.graphics.endFill();
         borderV.y = _loc7_;
         myComicBuilder.centerDisplayObj(comicArea,true,false);
         comicInterface.x = comicArea.x;
         comicArea.x = 0;
         centerComic(comicDisplay);
         comicDisplay.y = Comic.BORDER_SIZE;
      }
      
      function borderMoveStart_V(param1:MouseEvent) : void
      {
         stop_editing_asset();
         borderOffset = new Point(param1.currentTarget.mouseX,param1.currentTarget.mouseY);
         if(comicData.editable)
         {
            pre_undo();
            comicDisplay.stage.addEventListener(MouseEvent.MOUSE_UP,borderMoveStop_V);
            comicDisplay.stage.addEventListener(MouseEvent.MOUSE_MOVE,borderMove_V);
         }
      }
   }
}
