package com.bitstrips.comicbuilder
{
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.adobe.images.PNGEnc;
   import com.adobe.images.PNGEncoder;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.BitStrips;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.character.ComicCharAsset;
   import com.bitstrips.character.ComicPropAsset;
   import com.bitstrips.comicbuilder.library.AssetDragEvent;
   import com.bitstrips.comicbuilder.library.LibraryManager;
   import com.bitstrips.controls.CharControls;
   import com.bitstrips.controls.ComicControl;
   import com.bitstrips.controls.ComicControls;
   import com.bitstrips.controls.LayoutControls;
   import com.bitstrips.controls.ObjectControls;
   import com.bitstrips.controls.TextControls;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColorTools;
   import com.bitstrips.core.ImageLoader;
   import com.bitstrips.core.Remote;
   import com.bitstrips.ui.AlertBox;
   import com.bitstrips.ui.CustomCursor;
   import com.bitstrips.ui.ErrorBlocker;
   import com.bitstrips.ui.ProgressBlocker;
   import com.bitstrips.ui.Signup;
   import com.bitstrips.ui.TabDisplay;
   import fl.controls.ScrollBar;
   import fl.events.ScrollEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class ComicBuilder extends MovieClip
   {
       
      
      var charName:String;
      
      private var loaded:Boolean = false;
      
      var user_signup:Signup;
      
      var myComic:Comic;
      
      var prop_controls:ObjectControls;
      
      var comic_controls:ComicControls;
      
      var instance_controls:Sprite;
      
      var il:ImageLoader;
      
      private var scrollbar:ScrollBar;
      
      var layout_controls:LayoutControls;
      
      var al:ArtLoader;
      
      var myTabDisplay:TabDisplay;
      
      private var newPanelCount:uint;
      
      var myLibraryManager:LibraryManager;
      
      public const standardPanelHeight:Number = 178;
      
      public var bs:BitStrips;
      
      public const debug:Boolean = false;
      
      var remote:Remote;
      
      var myAuthor:ComicAuthor;
      
      var cursor:CustomCursor;
      
      var myTitleBar:TitleBar;
      
      var cl:CharLoader;
      
      var initLoadConditions:Object;
      
      var myDisplay:Sprite;
      
      public const standardRescale:Number = 1;
      
      private var _drawMeCustom_once:Boolean = false;
      
      public var move_move:uint = 0;
      
      var draggedAsset:DraggedAsset;
      
      var text_controls:TextControls;
      
      var char_controls:CharControls;
      
      var save_btn:SimpleButton;
      
      var comicData:Object;
      
      var builder_name:String;
      
      private var cur_selected:ComicAsset;
      
      public const standardPanelWidth:Number = 176;
      
      var exportPanels:Array;
      
      var cursorClip:CursorClip;
      
      var alertBox:AlertBox;
      
      public var libraryTypeList:Array;
      
      var thumb:Object;
      
      var bkgrColor:Number = 16777215;
      
      var draggingAsset:Boolean;
      
      var comicDisplay:Sprite;
      
      var authorData:Object;
      
      var pb:ProgressBlocker;
      
      var myOutline:Sprite;
      
      var blocker:Sprite;
      
      public function ComicBuilder(param1:BitStrips = null)
      {
         var new_bs:BitStrips = param1;
         initLoadConditions = {};
         builder_name = _("COMIC BUILDER");
         libraryTypeList = ["characters","scenes","props","furniture","effects"];
         super();
         if(debug)
         {
            trace("--ComicBuilder()--");
         }
         if(new_bs == null)
         {
            bs = new BitStrips();
         }
         else
         {
            bs = new_bs;
         }
         bs.addEventListener(BitStrips.ERROR,bs_error);
         if(new_bs == null)
         {
            if(BSConstants.TESTING)
            {
               bs.init("file://",BSConstants.params);
            }
            else
            {
               bs.init(loaderInfo.url,loaderInfo.parameters);
            }
         }
         if(bs.ready == false)
         {
            return;
         }
         this.builder_name = _("COMIC BUILDER");
         remote = bs.remote;
         il = bs.image_loader;
         cl = bs.char_loader;
         al = ArtLoader.getInstance();
         pb = new ProgressBlocker(750,564,_("Loading"));
         addChild(pb);
         if(BSConstants.EDU && bs.user_id <= 0)
         {
            pb.show("Error");
            pb.message = "Please log in to use tool";
            return;
         }
         cl.addEventListener("LOADED",function(param1:Event):void
         {
            loaded = true;
            componentLoaded("CharLoader");
         });
         bs.char_loader.addEventListener(BulkProgressEvent.PROGRESS,function(param1:BulkProgressEvent):void
         {
            pb.progress = param1.weightPercent;
            pb.message = _("Loading Artwork:") + " " + param1.itemsLoaded + " " + _("of") + " " + param1.itemsTotal;
         });
         pb.show(_("Loading"),true);
         init();
         this.contextMenu = bs.contextMenu;
      }
      
      public function pre_undo() : void
      {
         myComic.pre_undo();
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--ComicBuilder.drawMe()--");
         }
         drawMeCustom();
         this.tabChildren = this.tabEnabled = false;
         myDisplay.visible = true;
         bs.spellcheck();
         pb.hide();
         drawMePost();
      }
      
      public function generateFinalBA(param1:Bitmap, param2:Object, param3:Boolean, param4:Comic = null) : ByteArray
      {
         var _loc5_:ByteArray = null;
         var _loc6_:BitmapData = generateFinalBitmap(param1,param2,param3,param4);
         thumb["comic_width"] = _loc6_.width;
         thumb["comic_height"] = _loc6_.height;
         _loc5_ = PNGEncoder.encode(_loc6_);
         return _loc5_;
      }
      
      public function updateComicData(param1:Object) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("--ComicBuilder.updateComicData()--");
         }
         if(debug)
         {
            trace("<<");
         }
         for(_loc2_ in param1)
         {
            if(debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
            comicData[_loc2_] = param1[_loc2_];
         }
         if(debug)
         {
            trace(">>");
         }
      }
      
      public function centerDisplayObj(param1:Sprite, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Rectangle = param1.getBounds(this);
         if(param2)
         {
            param1.x = 750 / 2 - _loc4_.width / 2;
         }
         if(param3)
         {
            param1.y = 550 / 2 - _loc4_.height / 2;
         }
      }
      
      public function save_confirm(param1:MouseEvent) : void
      {
         myTitleBar.setTitle("");
         if(bs.user_id == 0 && BSConstants.EDU == false)
         {
            showSignup();
         }
         else
         {
            saveComic_request();
         }
      }
      
      public function init() : void
      {
         common_init();
         myTitleBar = new TitleBar(this);
         initLoadConditions = {
            "author":false,
            "comic":false
         };
         if(cl.loaded_done == false)
         {
            initLoadConditions["CharLoader"] = false;
         }
         addChild(myDisplay);
         myDisplay.addChild(myOutline);
         myDisplay.addChild(myTitleBar);
         myDisplay.addChild(comicDisplay);
         myDisplay.addChild(myTabDisplay);
         addChild(init_title_field());
         addChild(cursor);
         initDraw();
         comic_controls = new ComicControls(myComic);
         comic_controls.tabChildren = comic_controls.tabEnabled = false;
         myComic.controls = comic_controls;
         myDisplay.addChild(comic_controls);
         myDisplay.addChild(scrollbar);
         scrollbar.x = 750 - scrollbar.width;
         loadData({
            "user_id":bs.user_id,
            "comic_id":bs.comic_id
         });
      }
      
      public function addBlocker() : void
      {
         if(debug)
         {
            trace("--ComicBuilder.addBlocker()--");
         }
         blocker.x = 0;
         blocker.y = 0;
         blocker.graphics.clear();
         blocker.graphics.beginFill(0,0.2);
         blocker.graphics.drawRect(0,-50,stage.width,stage.height + 100);
         addChild(blocker);
         centerDisplayObj(blocker,true,false);
      }
      
      public function dragAsset(param1:AssetDragEvent) : void
      {
         var _loc2_:Object = param1.assetData;
         if(debug)
         {
            trace("dragging asset: " + _loc2_.name);
         }
         if(debug)
         {
            trace("--ComicBuilder.dragAsset()--");
         }
         if(!draggingAsset)
         {
            draggingAsset = true;
            draggedAsset = new DraggedAsset(this,_loc2_,il,cl);
            myDisplay.addChild(draggedAsset);
            draggedAsset.onComplete();
            draggedAsset.relocate();
         }
      }
      
      public function getComic_controls() : ComicControl
      {
         return comic_controls;
      }
      
      public function registerPanel(param1:ComicPanel) : void
      {
         char_controls.register(null);
         prop_controls.register(null);
         text_controls.register(null);
      }
      
      public function hideSignup() : void
      {
         removeChild(user_signup);
      }
      
      function loadUser_request(param1:int) : void
      {
         var _loc2_:Object = {
            "user_id":bs.user_id,
            "userName":bs.user_name,
            "series":bs.series
         };
         loadUser_response(_loc2_);
      }
      
      private function loadScene_response(param1:Object) : void
      {
         if(param1 == null)
         {
            loadComic_response(DataDump.getDefaultComic_complex());
         }
         else
         {
            param1["bkgrColor"] = 16777215;
            param1["comicTitle"] = "";
            loadComic_response(param1);
         }
      }
      
      public function dump_obj(param1:Object, param2:String = "\t") : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param1)
         {
            trace(param2 + _loc3_ + " : " + param1[_loc3_]);
            if(param1[_loc3_] is Object)
            {
               dump_obj(param1[_loc3_],param2 + "\t");
            }
         }
      }
      
      public function get_bkgrColor() : Number
      {
         return bkgrColor;
      }
      
      public function saveComic_request() : void
      {
         if(BSConstants.EDU)
         {
            save_small();
         }
         else
         {
            save_full_panels();
         }
      }
      
      public function set_cameraStyle(param1:String) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.set_cameraStyle(" + param1 + ")--");
         }
         myComic.set_cameraStyle(param1);
      }
      
      public function releaseAsset(param1:ComicPanel, param2:Object) : void
      {
         draggingAsset = false;
         myDisplay.removeChild(draggedAsset);
         if(param1)
         {
            myComic.pre_undo();
            myComic.releaseAsset(param1,param2);
         }
      }
      
      public function locatePanelAtPoint(param1:Point) : ComicPanel
      {
         return myComic.locatePanelAtPoint(param1);
      }
      
      public function repositionComicControls() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(comic_controls)
         {
            _loc1_ = this.stage_height;
            _loc2_ = comicDisplay.y + myComic.height;
            if(_loc2_ > _loc1_ - 41)
            {
               comic_controls.y = _loc1_ - 41;
               scrollbar.height = _loc1_ - 41 - scrollbar.y;
               scrollbar.minScrollPosition = 0;
               trace("Comic Height: " + myComic.height + " " + comicDisplay.y + ", " + comicDisplay.scrollRect);
               scrollbar.maxScrollPosition = myComic.strips.length;
               scrollbar.visible = true;
            }
            else
            {
               scrollbar.visible = false;
               myComic.scroll_v = 0;
               comic_controls.y = _loc2_;
            }
            myOutline.height = myComic.height + myTitleBar.height;
         }
      }
      
      public function removeAlert() : void
      {
         blockInteraction(false);
      }
      
      public function setAssetColour(param1:Number) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.setAssetColour(" + param1 + ")--");
         }
         myComic.setAssetColour(param1);
      }
      
      function loadComic_response(param1:Object) : void
      {
         var _loc2_:* = null;
         BSConstants.RESCALE = 0.45;
         if(param1["rescale"])
         {
            BSConstants.RESCALE = param1["rescale"];
         }
         comicData["rescale"] = BSConstants.RESCALE;
         if(debug)
         {
            trace("--ComicBuilder.loadComic_response(" + param1["bkgrColor"] + ")--");
         }
         if(debug)
         {
            trace("<<");
         }
         if(bs.comic_id)
         {
            pb.message = _("Comic Data Loaded");
         }
         if(param1.hasOwnProperty("version") == false || param1["version"] < 3)
         {
            param1 = DataDump.update_comic_data(param1);
         }
         for(_loc2_ in param1)
         {
            if(debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
            comicData[_loc2_] = param1[_loc2_];
         }
         if(debug)
         {
            trace(">>");
         }
         if(param1["bkgrColor"] != undefined)
         {
            setBackgroundColour(param1.bkgrColor);
         }
         else
         {
            bkgrColor = 16777215;
         }
         componentLoaded("comic");
      }
      
      private function new_tab_selected(param1:Event) : void
      {
         if(comic.selectedAsset)
         {
            comic.selectedAsset.editing = false;
         }
      }
      
      public function blockInteraction(param1:Boolean) : void
      {
         if(param1)
         {
            addChild(blocker);
         }
         else if(this.contains(blocker))
         {
            removeChild(blocker);
         }
      }
      
      public function setBackgroundColour(param1:Number) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.setBackgroundColour(" + param1 + ")--");
         }
         myComic.comicData["bkgrColor"] = bkgrColor;
         bkgrColor = param1;
         myOutline.graphics.clear();
         if(BSConstants.TRANSPARENT == false)
         {
            if(debug)
            {
               trace("OUTLINE BEGINFILL-------------------------");
            }
            myOutline.graphics.beginFill(bkgrColor,1);
            myOutline.graphics.drawRect(0,0,comicData.comicWidth,comicData.comicHeight + myTitleBar.height);
         }
         var _loc2_:Object = ColorTools.RGBtoHSB(param1);
         if(debug)
         {
            trace("b: " + _loc2_.b);
         }
         if(myTitleBar)
         {
            myTitleBar.setBrightness(_loc2_.b);
         }
      }
      
      public function getRemote() : Remote
      {
         return remote;
      }
      
      function init_tabs() : TabDisplay
      {
         var tabs:TabDisplay = new TabDisplay(!BSConstants.EDU);
         instance_controls = new Sprite();
         char_controls = new CharControls();
         char_controls.x = 10;
         char_controls.y = 30;
         instance_controls.addChild(char_controls);
         char_controls.visible = true;
         prop_controls = new ObjectControls(this.myComic);
         instance_controls.addChild(prop_controls);
         prop_controls.visible = false;
         myLibraryManager = new LibraryManager(bs);
         myLibraryManager.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         var libraryDisplay:Sprite = myLibraryManager.getDisplay();
         text_controls = new TextControls(this.myComic);
         text_controls.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         layout_controls = new LayoutControls(BSConstants.EDU);
         layout_controls.setComicBuilder(this);
         tabs.setData({"tabDataList":[{
            "name":"instance",
            "label":_("CONTROLS"),
            "colour":16750899,
            "clip":instance_controls
         },{
            "name":"bubble",
            "label":_("TEXT BUBBLES"),
            "colour":16777062,
            "clip":text_controls
         },{
            "name":"library",
            "label":_("ART LIBRARY"),
            "colour":16711680,
            "clip":libraryDisplay
         },{
            "name":"layout",
            "label":_("LAYOUT"),
            "colour":52326,
            "clip":layout_controls
         }]});
         tabs.focusTab("layout");
         tabs.addEventListener("NEW_TAB",new_tab_selected);
         tabs.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         });
         return tabs;
      }
      
      public function signup_userID(param1:String) : void
      {
         hideSignup();
         if(debug)
         {
            trace("--ComicBuilder.signup_userID(" + param1 + ")--");
         }
         trace(user_signup.username.text);
         bs.user_id = int(Number(param1));
         myAuthor.setData({
            "userName":user_signup.username.text,
            "userID":bs.user_id,
            "series":[]
         });
         setAuthorName();
         saveComic_request();
      }
      
      public function newSeries_response(param1:Object) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("--ComicBuilder.newSeries_response()--");
         }
         for(_loc2_ in param1)
         {
            if(debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
         }
         myComic.get_comicData()["comicTitle"] = myTitleBar.getTitle();
         myAuthor.addSeries(param1);
         myComic.setSeries(param1["series_id"]);
      }
      
      public function goEasy_request() : void
      {
         doAlert(_("WARNING:  switching to EASY mode will start a new strip and close the one you are currently working on."),[{
            "txt":_("Go Easy"),
            "f":goEasy_confirm
         },{
            "txt":_("Cancel"),
            "f":function(param1:Event):void
            {
               if(debug)
               {
                  trace("Cancel");
               }
            }
         }]);
      }
      
      public function get comic() : Comic
      {
         return myComic;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      function square_thumb(param1:ComicPanel, param2:int) : BitmapData
      {
         var _loc3_:Number = (param2 + 6) / Math.min(param1.panel_width - 2,param1.panel_height - 2);
         var _loc4_:BitmapData = param1.panelBitmap(_loc3_,false);
         var _loc5_:BitmapData = new BitmapData(param2,param2,false);
         var _loc6_:Rectangle = new Rectangle(0,0,param2,param2);
         _loc6_.x = (_loc4_.width - param2) / 2;
         _loc6_.y = (_loc4_.height - param2) / 2;
         _loc5_.copyPixels(_loc4_,_loc6_,new Point(0,0));
         return _loc5_;
      }
      
      protected function componentLoaded(param1:String) : void
      {
         var _loc3_:* = null;
         if(debug)
         {
            trace("--ComicBuilder.componentLoaded(" + param1 + ")--");
         }
         initLoadConditions[param1] = true;
         var _loc2_:Boolean = true;
         trace("componentLoaded " + initLoadConditions[param1]);
         for(_loc3_ in initLoadConditions)
         {
            if(!initLoadConditions[_loc3_])
            {
               trace("Failed: " + initLoadConditions[_loc3_] + " " + _loc3_);
               _loc2_ = false;
               return;
            }
         }
         if(_loc2_)
         {
            drawMe();
         }
      }
      
      function loadCursorClip() : void
      {
         cursorClip = new CursorClip();
         cursor.setCursorClip(cursorClip);
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.color = 0;
         _loc1_.distance = 0;
         _loc1_.strength = 4;
         _loc1_.blurX = 2;
         _loc1_.blurY = 2;
         _loc1_.alpha = 0.7;
         var _loc2_:GlowFilter = new GlowFilter();
         _loc2_.strength = 2;
         _loc2_.quality = 1;
         _loc2_.blurX = 2;
         _loc2_.blurY = 2;
         _loc2_.color = 0;
         var _loc3_:Array = new Array(_loc1_);
         cursor.filters = _loc3_;
      }
      
      public function save_click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(myTitleBar.titleChanged())
         {
            if(bs.user_id == 0 && BSConstants.EDU == false)
            {
               showSignup();
            }
            else
            {
               saveComic_request();
            }
         }
         else
         {
            doAlert(_("Your strip doesn\'t have a title. Click Cancel to go back and give it a title."),[{
               "txt":_("Save Anyway"),
               "f":save_confirm
            },{
               "txt":_("Cancel"),
               "f":function(param1:Event):void
               {
                  if(debug)
                  {
                     trace("Cancel");
                  }
               }
            }]);
         }
      }
      
      public function setPanelNum() : void
      {
         var _loc2_:ComicPanel = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:* = null;
         myComic.pre_undo();
         if(debug)
         {
            trace("--ComicBuilder.setPanelNum()--");
         }
         layout_controls.field.text = String(newPanelCount);
         var _loc1_:Object = DataDump.getComicLayout(newPanelCount);
         var _loc3_:int = 0;
         var _loc6_:Array = new Array();
         var _loc7_:Object = myComic.save_state();
         _loc4_ = 0;
         while(_loc4_ < _loc7_.strips.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc7_.strips[_loc4_].panels.length)
            {
               _loc6_.push(_loc7_.strips[_loc4_].panels[_loc5_]);
               _loc5_++;
            }
            _loc4_++;
         }
         var _loc8_:Array = new Array();
         _loc4_ = 0;
         while(_loc4_ < _loc1_.strips.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc1_.strips[_loc4_].panels.length)
            {
               _loc8_.push(_loc1_.strips[_loc4_].panels[_loc5_]);
               _loc5_++;
            }
            _loc4_++;
         }
         if(debug)
         {
            trace("origPanelList.length: " + _loc6_.length);
         }
         if(debug)
         {
            trace("newPanelList.length: " + _loc8_.length);
         }
         _loc4_ = 0;
         while(_loc4_ < _loc8_.length)
         {
            for(_loc9_ in _loc6_[_loc4_])
            {
               if(_loc9_ != "width")
               {
                  _loc8_[_loc4_][_loc9_] = _loc6_[_loc4_][_loc9_];
               }
            }
            _loc4_++;
         }
         _loc1_["comicTitle"] = myTitleBar.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         loadComic_response(_loc1_);
      }
      
      function loadComic_request(param1:String) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.loadComic_request(" + param1 + ")--");
         }
         if(param1 != "")
         {
            pb.message = _("Loading Comic Data");
            remote.load_comic_data(bs.user_id,bs.comic_id,loadComic_response);
         }
         else
         {
            loadComic_response(DataDump.getDefaultComic_complex());
         }
      }
      
      function cursor_event(param1:CursorEvent) : void
      {
         if(param1.cursorType == "visible")
         {
            cursor.enabled = param1.button_down;
         }
         else if(param1.button_down == false)
         {
            cursor.setCursor(param1.cursorType);
         }
         else
         {
            cursor.last_cursor = param1.cursorType;
         }
      }
      
      private function onSaveError(param1:Object) : void
      {
         pb.hide();
         save_btn.enabled = true;
         trace("Error saving: " + param1);
         dump_obj(param1);
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,_("An error has occured"),true);
         this.addChild(_loc2_);
         _loc2_.show(_("An error has occured"));
         _loc2_.on_top();
         var _loc3_:String = _("Sorry, an error occured while saving. You will need to click \'Save\' again.");
         _loc3_ = _loc3_ + ("\n\n" + _("If the problem persists, please email us at support@") + BSConstants.DOMAIN);
         _loc3_ = _loc3_ + ("\n\n" + _("Error: "));
         if(param1.hasOwnProperty("faultString"))
         {
            _loc3_ = _loc3_ + param1.faultString;
         }
         else
         {
            _loc3_ = _loc3_ + param1.toString();
         }
         _loc2_.message = _loc3_;
      }
      
      function initDraw() : void
      {
         if(debug)
         {
            trace("--ComicBuilder.initDraw()--");
         }
         pb.on_top();
      }
      
      public function showSignup() : void
      {
         user_signup = new Signup(bs.remote);
         user_signup.x = 122;
         user_signup.y = 143;
         addChild(user_signup);
         user_signup.set_id = signup_userID;
         user_signup.cancel_call = hideSignup;
      }
      
      public function getCursor() : CustomCursor
      {
         return cursor;
      }
      
      private function spriteBMP(param1:Sprite) : BitmapData
      {
         var _loc2_:Rectangle = param1.getBounds(param1);
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-_loc2_.x,-_loc2_.y);
         var _loc4_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,false,0);
         _loc4_.draw(param1,_loc3_,null,null,null,true);
         return _loc4_;
      }
      
      public function getAuthor() : ComicAuthor
      {
         return myAuthor;
      }
      
      public function saveComic_response(param1:*) : void
      {
         trace("--ComicBuilder.saveComic_response(" + param1 + ")--");
         if(param1 <= 0)
         {
            pb.hide();
            save_btn.enabled = true;
            return;
         }
         pb.message = _("Save Complete!\nLoading saved comic:");
         if(BSConstants.EDU)
         {
            if(bs.assign_id == "-1")
            {
               ExternalInterface.call("update_opener",param1,myTitleBar.getFullTitle());
            }
            else if(bs.assign_id)
            {
               navigateToURL(new URLRequest(remote.base_url + "activity/" + bs.assign_id + "/" + param1 + "/#saved"),"_self");
            }
            else
            {
               navigateToURL(new URLRequest(remote.base_url + "comics/" + param1 + "/"),"_self");
            }
         }
         else
         {
            navigateToURL(new URLRequest(remote.base_url + "read.php?comic_id=" + param1),"_self");
         }
      }
      
      public function updateTitleBar() : void
      {
         if(myTitleBar == null)
         {
            return;
         }
         var _loc1_:ComicSeries = myAuthor.getSeries(myComic.get_comicData().series);
         var _loc2_:Number = 0;
         if(_loc1_)
         {
            _loc2_ = _loc1_.addCount();
         }
         var _loc3_:String = myAuthor.getAuthorName();
         if(bs.user_name)
         {
            _loc3_ = bs.user_name;
         }
         myTitleBar.setData({
            "comicTitle":myComic.get_comicData().comicTitle,
            "authorName":_loc3_,
            "seriesList":myAuthor.get_seriesList(),
            "series":myComic.get_comicData().series,
            "episode":_loc2_
         });
         myTitleBar.drawMe();
      }
      
      public function newSeries_request(param1:String) : void
      {
         remote.new_series(bs.user_id,param1,newSeries_response);
      }
      
      public function goEasy_confirm(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(remote.base_url + "/create/comic/?quick=1"),"_self");
      }
      
      function drawMeCustom() : void
      {
         if(_drawMeCustom_once == false)
         {
            myAuthor.setData(authorData);
            myLibraryManager.get_user_libs(bs);
            myLibraryManager.drawMe();
         }
         myComic.setData(comicData);
         myComic.drawMe();
         updateTitleBar();
         if(_drawMeCustom_once == false)
         {
            save_btn = comic_controls.save_btn;
            save_btn.addEventListener(MouseEvent.CLICK,save_click);
         }
         setBackgroundColour(bkgrColor);
         myDisplay.y = 3;
         myTabDisplay.y = 0;
         myOutline.y = 120;
         myOutline.x = 0;
         myTitleBar.y = 126;
         comicDisplay.y = 143;
         scrollbar.y = 150;
         repositionComicControls();
         focusTab("layout");
         _drawMeCustom_once = true;
      }
      
      public function get stage_height() : Number
      {
         return 650;
      }
      
      public function generateFinalBitmap(param1:Bitmap, param2:Object, param3:Boolean, param4:Comic = null) : BitmapData
      {
         var _loc9_:Number = NaN;
         var _loc21_:uint = 0;
         var _loc22_:Object = null;
         trace("Don\'t use me anymore!");
         if(!param4)
         {
            param4 = myComic;
         }
         var _loc5_:Sprite = new Sprite();
         var _loc6_:Number = 3;
         var _loc7_:Number = 8;
         var _loc8_:Number = get_bkgrColor();
         if(param3)
         {
            _loc9_ = 16777215;
         }
         else
         {
            _loc9_ = 0;
         }
         if(debug)
         {
            trace("comicBMP.width: " + param1.width);
         }
         var _loc10_:TextFormat = new TextFormat();
         _loc10_.font = BSConstants.CREATIVEBLOCK;
         _loc10_.size = 16;
         _loc10_.color = _loc9_;
         _loc10_.bold = true;
         var _loc11_:TextFormat = new TextFormat();
         _loc11_.font = BSConstants.CREATIVEBLOCK;
         _loc11_.size = 12;
         _loc11_.color = _loc9_;
         _loc11_.bold = false;
         var _loc12_:TextField = new TextField();
         _loc12_.autoSize = TextFieldAutoSize.LEFT;
         _loc12_.wordWrap = false;
         _loc12_.defaultTextFormat = _loc10_;
         _loc12_.embedFonts = true;
         _loc12_.text = param2.comicTitle;
         var _loc13_:TextField = new TextField();
         _loc13_.autoSize = TextFieldAutoSize.LEFT;
         _loc13_.wordWrap = false;
         _loc13_.defaultTextFormat = _loc10_;
         _loc13_.embedFonts = true;
         if(param2.authorName)
         {
            _loc13_.text = param2.authorName;
         }
         var _loc14_:TextField = new TextField();
         _loc14_.autoSize = TextFieldAutoSize.LEFT;
         _loc14_.wordWrap = false;
         _loc14_.defaultTextFormat = _loc11_;
         _loc14_.embedFonts = true;
         _loc14_.text = BSConstants.URL;
         _loc5_.addChild(_loc13_);
         _loc5_.addChild(_loc12_);
         _loc5_.addChild(param1);
         _loc5_.addChild(_loc14_);
         var _loc15_:Number = Comic.BORDER_SIZE;
         _loc12_.x = _loc15_;
         _loc12_.y = _loc6_;
         _loc13_.x = param1.width - _loc13_.width - 7;
         var _loc16_:Number = Math.max(_loc13_.x,_loc12_.x + _loc12_.width + 50);
         if(_loc16_ > _loc13_.x)
         {
            _loc13_.x = _loc16_;
            _loc7_ = -8;
         }
         _loc13_.x = Math.max(_loc13_.x,_loc12_.x + _loc12_.width + 50);
         _loc13_.y = _loc6_;
         param1.x = _loc5_.width / 2 - param1.width / 2;
         param1.y = _loc13_.height;
         _loc14_.x = param1.x + param1.width - _loc14_.width - 7;
         _loc14_.y = param1.y + param1.height - 8;
         thumb = new Object();
         thumb.panels = new Array();
         var _loc17_:Number = 0;
         var _loc18_:uint = 0;
         while(_loc18_ < param4.get_stripList().length)
         {
            if(_loc18_ > 0)
            {
               _loc17_ = _loc17_ + (param4.get_stripList()[_loc18_ - 1].getSize().height + _loc15_);
            }
            _loc21_ = 0;
            while(_loc21_ < param4.get_stripList()[_loc18_].getPanelList().length)
            {
               if(debug)
               {
                  trace("PANEL<<<<<");
               }
               _loc22_ = new Object();
               _loc22_.width = param4.get_stripList()[_loc18_].getPanelList()[_loc21_].panel_width - 2;
               _loc22_.height = param4.get_stripList()[_loc18_].getPanelList()[_loc21_].panel_height - 2;
               _loc22_.x = Math.ceil(param1.x) + param4.get_stripList()[_loc18_].getPanelList()[_loc21_].x + 7;
               _loc22_.y = Math.ceil(param1.y) + 3 + _loc17_;
               thumb.panels.push(_loc22_);
               if(debug)
               {
                  trace("width: " + _loc22_.width);
               }
               if(debug)
               {
                  trace("height: " + _loc22_.height);
               }
               if(debug)
               {
                  trace("x: " + _loc22_.x);
               }
               if(debug)
               {
                  trace("y: " + _loc22_.y);
               }
               if(debug)
               {
                  trace(">>>>>>>>>");
               }
               _loc21_++;
            }
            _loc18_++;
         }
         var _loc19_:Object = thumb.panels[0];
         thumb.x = _loc19_.x;
         thumb.y = _loc19_.y;
         thumb.width = _loc19_.width;
         thumb.height = _loc19_.height;
         _loc12_.x = _loc12_.x - 4;
         _loc13_.x = _loc13_.x - 4;
         param1.x = param1.x - 4;
         _loc14_.x = _loc14_.x - 4;
         thumb.x = thumb.x - 4;
         var _loc20_:BitmapData = new BitmapData(_loc5_.width - _loc7_,_loc5_.height + _loc6_ * 2,false,_loc8_);
         if(BSConstants.TRANSPARENT)
         {
            _loc20_ = new BitmapData(_loc5_.width - _loc7_,_loc5_.height + _loc6_ * 2,true,16777215);
         }
         _loc20_.draw(_loc5_);
         return _loc20_;
      }
      
      function doAlert(param1:String, param2:Array) : void
      {
         addBlocker();
         alertBox = new AlertBox(param1,param2,myDisplay);
         alertBox.set_closeFunc(removeBlocker);
         centerDisplayObj(alertBox,true,true);
         blocker.x = 0 - blocker.width / 2 + alertBox.width / 2;
         blocker.y = 0 - blocker.height / 2 + alertBox.height / 2;
         alertBox.addChildAt(blocker,0);
      }
      
      public function registerControlType(param1:String, param2:ComicAsset) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.registerControlType(" + param1 + ")--");
         }
         if(cur_selected == param2)
         {
            return;
         }
         cur_selected = param2;
         char_controls.register(null);
         prop_controls.register(null);
         text_controls.register(null);
         prop_controls.visible = char_controls.visible = false;
         var _loc3_:String = "";
         switch(param1)
         {
            case "characters":
               if(debug)
               {
                  trace("YOU HAVE SELECTED A CHARACTER");
               }
               if(ComicCharAsset(param2).body)
               {
                  char_controls.register(ComicCharAsset(param2).body);
               }
               else
               {
                  param2.setController(char_controls);
                  char_controls.register(null);
               }
               char_controls.visible = true;
               _loc3_ = "instance";
               break;
            case "text bubble":
               if(debug)
               {
                  trace("YOU HAVE SELECTED A TEXT BUBBLE");
               }
               text_controls.register(TextBubble(param2));
               _loc3_ = "bubble";
               break;
            case "walls":
            case "props":
               if(debug)
               {
                  trace("YOU HAVE SELECTED A PROP");
               }
               prop_controls.register(ComicPropAsset(param2));
               param2.setController(prop_controls);
               prop_controls.visible = true;
               _loc3_ = "instance";
               break;
            case null:
               if(debug)
               {
                  trace("YOU HAVE SELECTED NULL");
               }
         }
         if(prop_controls.visible == false && char_controls.visible == false)
         {
            char_controls.visible = true;
         }
         if(_loc3_ != "" && this.myTabDisplay.focusedTab != "library" && this.myTabDisplay.focusedTab != "filters")
         {
            myTabDisplay.focusTab(_loc3_);
         }
      }
      
      private function loadScene_request(param1:String) : void
      {
         remote.load_scene_data(bs.user_id,bs.scene_id,0,loadScene_response);
      }
      
      public function focusTab(param1:String) : void
      {
         myTabDisplay.focusTab(param1);
      }
      
      private function bs_error(param1:ErrorEvent) : void
      {
         if(save_btn && save_btn.enabled == false)
         {
            this.onSaveError(param1.text);
            return;
         }
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,_("An error has occured"),loaded);
         this.addChild(_loc2_);
         _loc2_.show(_("An error has occured"));
         _loc2_.on_top();
         var _loc3_:String = _("Uh-oh... something didn\'t work like we expected.");
         if(loaded == false)
         {
            _loc3_ = _("Try refreshing the page and re-starting the comic builder to see if it fixes the issue.");
         }
         _loc3_ = _loc3_ + ("\n\n" + _("If the problem persists, please contact us at support@") + BSConstants.DOMAIN);
         _loc3_ = _loc3_ + ("\n\n" + param1.text);
         var _loc4_:String = param1.text;
         if(_loc4_.search("Error #2036: Load Never Completed. URL: ") >= 0)
         {
            _loc3_ = _loc3_ + ("\n" + _("Can\'t Load: ") + _loc4_.substr(40));
         }
         _loc2_.message = _loc3_;
      }
      
      function init_title_field() : TextField
      {
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.font = BSConstants.VERDANA;
         _loc1_.color = 0;
         _loc1_.bold = true;
         _loc1_.size = 14;
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = _loc1_;
         _loc2_.embedFonts = true;
         _loc2_.x = 1;
         _loc2_.y = -2;
         _loc2_.text = _(this.builder_name);
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         return _loc2_;
      }
      
      private function scroll_event(param1:ScrollEvent) : void
      {
         trace("Scroll: " + param1.position);
         myComic.scroll_v = param1.position;
      }
      
      public function loadData(param1:Object) : void
      {
         if(debug)
         {
            if(debug)
            {
               trace("--ComicBuilder.loadData(" + param1.user_id + ")--");
            }
         }
         loadUser_request(bs.user_id);
         if(bs.scene_id)
         {
            loadScene_request(bs.scene_id);
         }
         else if(bs.char_id)
         {
            loadCharComic_request(bs.char_id);
         }
         else
         {
            loadComic_request(bs.comic_id);
         }
      }
      
      public function setPanelNum_request(param1:uint) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.setPanelNum_request(" + param1 + ")--");
         }
         var _loc2_:int = myComic.getPanelCount();
         newPanelCount = param1;
         setPanelNum();
      }
      
      public function returnCall(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("returnCall");
         }
      }
      
      public function setAuthorName() : void
      {
         myTitleBar.setData({"authorName":myAuthor.getAuthorName()});
      }
      
      function drawMePost() : void
      {
      }
      
      public function getComic() : Comic
      {
         return myComic;
      }
      
      private function loadCharComic_request(param1:String) : void
      {
         trace("Load a comic with a character in it...");
         loadComic_response(DataDump.getDefaultComic_char(param1));
      }
      
      public function setBackdropColour(param1:Number, param2:Boolean = false) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.setBackdropColour(" + param2 + ")--");
         }
         myComic.setBackdropColour(param1,param2);
      }
      
      private function save_small() : void
      {
         pb.show(_("Saving"));
         pb.message = _("Generating Bitmap");
         save_btn.enabled = false;
         var _loc1_:Object = myComic.save_state();
         _loc1_["comicTitle"] = myTitleBar.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         var _loc2_:Object = {
            "authorName":"BY " + myAuthor.getAuthorName(),
            "comicTitle":myTitleBar.getFullTitle()
         };
         if(BSConstants.EDU)
         {
            _loc2_["authorName"] = myTitleBar.authorField.text;
            _loc1_["comicAuthorName"] = bs.user_name;
            if(bs.assign_id)
            {
               _loc1_["assign_id"] = bs.assign_id;
            }
         }
         var _loc3_:Bitmap = myComic.getBitmap();
         var _loc4_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],120));
         var _loc5_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],50));
         var _loc6_:ByteArray = generateFinalBA(_loc3_,_loc2_,myTitleBar.get_lightText());
         thumb["rgb"] = ("000000" + bkgrColor.toString(16)).substr(-6);
         pb.message = _("Uploading Comic Data");
         remote.save_comic(bs.user_id,bs.assign_id,myTitleBar.getFullTitle(),_loc1_,thumb,_loc6_,_loc4_,_loc5_,bs.comic_id,saveComic_response,onSaveError);
      }
      
      public function setGroundColour(param1:Number, param2:Boolean = false) : void
      {
         myComic.setGroundColour(param1,param2);
      }
      
      private function save_full_panels() : void
      {
         var _loc7_:uint = 0;
         if(debug)
         {
            trace("--ComicBuilder.saveComic_request()--");
         }
         pb.show(_("Saving"));
         pb.message = _("Generating Bitmap");
         trace("Start save state: " + new Date());
         var _loc1_:Object = myComic.save_state();
         trace("Done save state: " + new Date());
         _loc1_["comicTitle"] = myTitleBar.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         var _loc2_:Object = {
            "authorName":"BY " + myAuthor.getAuthorName(),
            "comicTitle":myTitleBar.getFullTitle()
         };
         if(BSConstants.EDU)
         {
            _loc2_["authorName"] = myTitleBar.authorField.text;
            _loc1_["comicAuthorName"] = bs.user_name;
            if(bs.assign_id)
            {
               _loc1_["assign_id"] = bs.assign_id;
            }
         }
         var _loc3_:Array = this.BitmapBits(_loc2_,myTitleBar.get_lightText());
         thumb = new Object();
         thumb["rows"] = myComic.get_stripList().length;
         thumb["rgb"] = ("000000" + bkgrColor.toString(16)).substr(-6);
         save_btn.enabled = false;
         var _loc4_:Array = myComic.getBitmapPanels();
         var _loc5_:Array = new Array();
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_[_loc6_].length)
            {
               _loc4_[_loc6_][_loc7_] = PNGEnc.encode(_loc4_[_loc6_][_loc7_]);
               _loc7_ = _loc7_ + 1;
            }
            _loc6_ = _loc6_ + 1;
         }
         _loc1_["version"] = 3;
         pb.message = _("Uploading Comic Data");
         if(BSConstants.EDU)
         {
            remote.save_comic_panels_edu(bs.user_id,bs.assign_id,myTitleBar.getFullTitle(),_loc1_,thumb,_loc4_,_loc3_,bs.comic_id,saveComic_response,onSaveError);
         }
         else
         {
            remote.save_comic_panels(bs.user_id,Number(myComic.getSeriesID()),myTitleBar.getFullTitle(),_loc1_,thumb,_loc4_,_loc3_,bs.comic_id,saveComic_response,onSaveError);
         }
      }
      
      public function blocker_all(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function setPanelNum_confirm(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicBuilder.setPanelNum_confirm()--");
         }
         setPanelNum();
      }
      
      function common_init() : void
      {
         comicData = new Object();
         draggingAsset = false;
         myOutline = new Sprite();
         myDisplay = new Sprite();
         myDisplay.visible = false;
         blocker = new Sprite();
         blocker.mouseChildren = blocker.mouseEnabled = false;
         myAuthor = new ComicAuthor(this);
         myComic = new Comic(this,il,cl);
         myComic.addEventListener(CursorEvent.CURSOR_EVENT,cursor_event);
         comicDisplay = myComic.getDisplay();
         myTabDisplay = init_tabs();
         cursor = new CustomCursor();
         loadCursorClip();
         scrollbar = new ScrollBar();
         scrollbar.addEventListener(ScrollEvent.SCROLL,scroll_event);
      }
      
      public function removeBlocker() : void
      {
         if(debug)
         {
            trace("--ComicBuilder.removeBlocker()--");
         }
         if(this.contains(blocker))
         {
            removeChild(blocker);
         }
      }
      
      function loadUser_response(param1:Object) : void
      {
         authorData = param1;
         if(myLibraryManager)
         {
            myLibraryManager.setLibraryData(authorData.library);
         }
         pb.message = _("User Data Loaded");
         componentLoaded("author");
      }
      
      public function setComicSeries(param1:Number) : void
      {
         myComic.get_comicData()["comicTitle"] = myTitleBar.getTitle();
         myComic.setSeries(param1);
      }
      
      public function BitmapBits(param1:Object, param2:Boolean, param3:Comic = null) : Array
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:uint = 0;
         if(param2)
         {
            _loc5_ = 16777215;
         }
         var _loc6_:TextFormat = new TextFormat();
         _loc6_.font = BSConstants.CREATIVEBLOCK;
         _loc6_.size = 16;
         _loc6_.color = _loc5_;
         _loc6_.bold = true;
         var _loc7_:TextField = new TextField();
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         _loc7_.wordWrap = false;
         _loc7_.defaultTextFormat = _loc6_;
         _loc7_.embedFonts = true;
         _loc7_.text = param1.comicTitle;
         _loc7_.background = true;
         _loc7_.backgroundColor = get_bkgrColor();
         _loc4_.addChild(_loc7_);
         var _loc8_:BitmapData = spriteBMP(_loc4_);
         _loc7_.text = "";
         if(param1.authorName)
         {
            _loc7_.text = param1.authorName;
         }
         var _loc9_:BitmapData = spriteBMP(_loc4_);
         _loc6_.size = 12;
         _loc6_.bold = false;
         _loc7_.text = BSConstants.URL;
         _loc7_.setTextFormat(_loc6_);
         var _loc10_:BitmapData = spriteBMP(_loc4_);
         return [PNGEnc.encode(_loc8_),PNGEnc.encode(_loc9_),PNGEnc.encode(_loc10_)];
      }
   }
}
