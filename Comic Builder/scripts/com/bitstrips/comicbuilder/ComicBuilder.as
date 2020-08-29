package com.bitstrips.comicbuilder
{
   import br.com.stimuli.loading.BulkProgressEvent;
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
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ComicBuilder extends MovieClip
   {
       
      
      var myDisplay:Sprite;
      
      var myOutline:Sprite;
      
      var comicDisplay:Sprite;
      
      var blocker:Sprite;
      
      var pb:ProgressBlocker;
      
      var draggedAsset:DraggedAsset;
      
      var charName:String;
      
      var initLoadConditions:Object;
      
      var myAuthor:ComicAuthor;
      
      var myComic:Comic;
      
      var myLibraryManager:LibraryManager;
      
      var myTitleBar:TitleBar;
      
      var myTabDisplay:TabDisplay;
      
      var alertBox:AlertBox;
      
      var draggingAsset:Boolean;
      
      var instance_controls:Sprite;
      
      var char_controls:CharControls;
      
      var prop_controls:ObjectControls;
      
      var text_controls:TextControls;
      
      var layout_controls:LayoutControls;
      
      var comic_controls:ComicControls;
      
      var cursorClip:CursorClip;
      
      var il:ImageLoader;
      
      var save_btn:SimpleButton;
      
      var comicData:Object;
      
      var authorData:Object;
      
      var remote:Remote;
      
      var cl:CharLoader;
      
      var al:ArtLoader;
      
      var cursor:CustomCursor;
      
      private var newPanelCount:uint;
      
      var bkgrColor:Number = 16777215;
      
      var thumb:Object;
      
      var exportPanels:Array;
      
      public const standardPanelWidth:Number = 176;
      
      public const standardPanelHeight:Number = 178;
      
      public const standardRescale:Number = 1;
      
      public const debug:Boolean = false;
      
      protected var builder_name:String;
      
      public var libraryTypeList:Array;
      
      var user_signup:Signup;
      
      public var bs:BitStrips;
      
      public var move_move:uint = 0;
      
      private var scrollbar:ScrollBar;
      
      private var loaded:Boolean = false;
      
      private var _drawMeCustom_once:Boolean = false;
      
      private var cur_selected:ComicAsset;
      
      private var cs:ComicSaver;
      
      public function ComicBuilder(param1:BitStrips = null)
      {
         var new_bs:BitStrips = param1;
         this.initLoadConditions = {};
         this.builder_name = this._("COMIC BUILDER");
         this.libraryTypeList = ["characters","scenes","props","furniture","effects"];
         super();
         if(this.debug)
         {
            trace("--ComicBuilder()--");
         }
         if(new_bs == null)
         {
            this.bs = new BitStrips();
         }
         else
         {
            this.bs = new_bs;
         }
         this.bs.addEventListener(BitStrips.ERROR,this.bs_error);
         if(new_bs == null)
         {
            if(BSConstants.TESTING)
            {
               this.bs.init("file://",BSConstants.params);
               this.bs.char_id = null;
            }
            else
            {
               this.bs.init(loaderInfo.url,loaderInfo.parameters);
            }
         }
         if(this.bs.ready == false)
         {
            return;
         }
         this.builder_name = this._("COMIC BUILDER");
         this.remote = this.bs.remote;
         this.il = this.bs.image_loader;
         this.cl = this.bs.char_loader;
         this.al = ArtLoader.getInstance();
         this.pb = new ProgressBlocker(750,564,this._("Loading"));
         addChild(this.pb);
         if(BSConstants.EDU && this.bs.user_id <= 0)
         {
            this.pb.show("Error");
            this.pb.message = "Please log in to use tool";
            return;
         }
         this.cl.addEventListener("LOADED",function(param1:Event):void
         {
            loaded = true;
            componentLoaded("CharLoader");
         });
         this.bs.char_loader.addEventListener(BulkProgressEvent.PROGRESS,function(param1:BulkProgressEvent):void
         {
            pb.progress = param1.weightPercent;
            pb.message = _("Loading Artwork:") + " " + param1.itemsLoaded + " " + _("of") + " " + param1.itemsTotal;
         });
         this.pb.show(this._("Loading"),true);
         this.init();
         this.contextMenu = this.bs.contextMenu;
      }
      
      public function get comic() : Comic
      {
         return this.myComic;
      }
      
      function common_init() : void
      {
         this.comicData = new Object();
         this.draggingAsset = false;
         this.myOutline = new Sprite();
         this.myDisplay = new Sprite();
         this.myDisplay.visible = false;
         this.blocker = new Sprite();
         this.blocker.mouseChildren = this.blocker.mouseEnabled = false;
         this.myAuthor = new ComicAuthor(this);
         this.myComic = new Comic(this,this.il,this.cl);
         this.myComic.addEventListener(CursorEvent.CURSOR_EVENT,this.cursor_event);
         this.comicDisplay = this.myComic.getDisplay();
         this.myTabDisplay = this.init_tabs();
         this.cursor = new CustomCursor();
         this.loadCursorClip();
         this.scrollbar = new ScrollBar();
         this.scrollbar.addEventListener(ScrollEvent.SCROLL,this.scroll_event);
      }
      
      private function scroll_event(param1:ScrollEvent) : void
      {
         trace("Scroll: " + param1.position);
         this.myComic.scroll_v = param1.position;
      }
      
      function cursor_event(param1:CursorEvent) : void
      {
         if(param1.cursorType == "visible")
         {
            this.cursor.enabled = param1.button_down;
         }
         else if(param1.button_down == false)
         {
            this.cursor.setCursor(param1.cursorType);
         }
         else
         {
            this.cursor.last_cursor = param1.cursorType;
         }
      }
      
      public function init() : void
      {
         this.common_init();
         this.myTitleBar = new TitleBar(this);
         this.initLoadConditions = {
            "author":false,
            "comic":false
         };
         if(this.cl.loaded_done == false)
         {
            this.initLoadConditions["CharLoader"] = false;
         }
         addChild(this.myDisplay);
         this.myDisplay.addChild(this.myOutline);
         this.myDisplay.addChild(this.myTitleBar);
         this.myDisplay.addChild(this.comicDisplay);
         this.myDisplay.addChild(this.myTabDisplay);
         addChild(this.init_title_field());
         addChild(this.cursor);
         this.initDraw();
         this.comic_controls = new ComicControls(this.myComic);
         this.comic_controls.tabChildren = this.comic_controls.tabEnabled = false;
         this.myComic.controls = this.comic_controls;
         this.myDisplay.addChild(this.comic_controls);
         this.myDisplay.addChild(this.scrollbar);
         this.scrollbar.x = 750 - this.scrollbar.width;
         this.loadData({
            "user_id":this.bs.user_id,
            "comic_id":this.bs.comic_id
         });
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
         _loc2_.text = this._(this.builder_name);
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         return _loc2_;
      }
      
      function init_tabs() : TabDisplay
      {
         var tabs:TabDisplay = new TabDisplay(!BSConstants.EDU);
         this.instance_controls = new Sprite();
         this.char_controls = new CharControls();
         this.char_controls.x = 10;
         this.char_controls.y = 30;
         this.instance_controls.addChild(this.char_controls);
         this.char_controls.visible = true;
         this.prop_controls = new ObjectControls(this.myComic);
         this.instance_controls.addChild(this.prop_controls);
         this.prop_controls.visible = false;
         this.myLibraryManager = new LibraryManager(this.bs);
         this.myLibraryManager.addEventListener(AssetDragEvent.ASSET_DRAG,this.dragAsset);
         var libraryDisplay:Sprite = this.myLibraryManager.getDisplay();
         this.text_controls = new TextControls(this.myComic);
         this.text_controls.addEventListener(AssetDragEvent.ASSET_DRAG,this.dragAsset);
         this.layout_controls = new LayoutControls(BSConstants.EDU);
         this.layout_controls.setComicBuilder(this);
         tabs.setData({"tabDataList":[{
            "name":"instance",
            "label":this._("CONTROLS"),
            "colour":16750899,
            "clip":this.instance_controls
         },{
            "name":"bubble",
            "label":this._("TEXT BUBBLES"),
            "colour":16777062,
            "clip":this.text_controls
         },{
            "name":"library",
            "label":this._("ART LIBRARY"),
            "colour":16711680,
            "clip":libraryDisplay
         },{
            "name":"layout",
            "label":this._("LAYOUT"),
            "colour":52326,
            "clip":this.layout_controls
         }]});
         tabs.focusTab("layout");
         tabs.addEventListener("NEW_TAB",this.new_tab_selected);
         tabs.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         });
         return tabs;
      }
      
      private function new_tab_selected(param1:Event) : void
      {
         if(this.comic.selectedAsset)
         {
            this.comic.selectedAsset.editing = false;
         }
      }
      
      public function blocker_all(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }
      
      public function loadData(param1:Object) : void
      {
         if(this.debug)
         {
            if(this.debug)
            {
               trace("--ComicBuilder.loadData(" + param1.user_id + ")--");
            }
         }
         this.loadUser_request(this.bs.user_id);
         if(this.bs.scene_id)
         {
            this.loadScene_request(this.bs.scene_id);
         }
         else if(this.bs.char_id)
         {
            this.loadCharComic_request(this.bs.char_id);
         }
         else
         {
            this.loadComic_request(this.bs.comic_id);
         }
      }
      
      protected function componentLoaded(param1:String) : void
      {
         var i:String = null;
         var componentName:String = param1;
         if(this.debug)
         {
            trace("--ComicBuilder.componentLoaded(" + componentName + ")--");
         }
         this.initLoadConditions[componentName] = true;
         var allLoaded:Boolean = true;
         trace("componentLoaded " + this.initLoadConditions[componentName]);
         for(i in this.initLoadConditions)
         {
            if(!this.initLoadConditions[i])
            {
               trace("Failed: " + this.initLoadConditions[i] + " " + i);
               allLoaded = false;
               return;
            }
         }
         if(allLoaded)
         {
            this.drawMe();
            try
            {
               ExternalInterface.call("leave_block");
               return;
            }
            catch(error:Error)
            {
               trace("Uh-oh, we\'re not blocked from leaving...");
               return;
            }
            finally
            {
               trace("Hopefully we\'re blocked from leaving");
            }
         }
      }
      
      function initDraw() : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.initDraw()--");
         }
         this.pb.on_top();
      }
      
      function drawMePost() : void
      {
      }
      
      function drawMeCustom() : void
      {
         if(this._drawMeCustom_once == false)
         {
            this.myAuthor.setData(this.authorData);
            this.myLibraryManager.get_user_libs(this.bs);
            this.myLibraryManager.drawMe();
         }
         this.myComic.setData(this.comicData);
         this.myComic.drawMe();
         this.updateTitleBar();
         if(this._drawMeCustom_once == false)
         {
            this.save_btn = this.comic_controls.save_btn;
            this.save_btn.addEventListener(MouseEvent.CLICK,this.save_click);
         }
         this.setBackgroundColour(this.bkgrColor);
         this.myDisplay.y = 3;
         this.myTabDisplay.y = 0;
         this.myOutline.y = 120;
         this.myOutline.x = 0;
         this.myTitleBar.y = 126;
         this.comicDisplay.y = 143;
         this.scrollbar.y = 150;
         this.repositionComicControls();
         this.focusTab("layout");
         this._drawMeCustom_once = true;
      }
      
      public function drawMe() : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.drawMe()--");
         }
         this.drawMeCustom();
         this.tabChildren = this.tabEnabled = false;
         this.myDisplay.visible = true;
         this.bs.spellcheck();
         this.pb.hide();
         this.drawMePost();
      }
      
      public function updateTitleBar() : void
      {
         if(this.myTitleBar == null)
         {
            return;
         }
         var _loc1_:ComicSeries = this.myAuthor.getSeries(this.myComic.get_comicData().series);
         var _loc2_:Number = 0;
         if(_loc1_)
         {
            _loc2_ = _loc1_.addCount();
         }
         var _loc3_:String = this.myAuthor.getAuthorName();
         if(this.bs.user_name)
         {
            _loc3_ = this.bs.user_name;
         }
         this.myTitleBar.setData({
            "comicTitle":this.myComic.get_comicData().comicTitle,
            "authorName":_loc3_,
            "seriesList":this.myAuthor.get_seriesList(),
            "series":this.myComic.get_comicData().series,
            "episode":_loc2_
         });
         this.myTitleBar.drawMe();
      }
      
      function loadCursorClip() : void
      {
         this.cursorClip = new CursorClip();
         this.cursor.setCursorClip(this.cursorClip);
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
         this.cursor.filters = _loc3_;
      }
      
      public function registerPanel(param1:ComicPanel) : void
      {
         if(this.char_controls)
         {
            this.char_controls.register(null);
         }
         if(this.prop_controls)
         {
            this.prop_controls.register(null);
         }
         if(this.text_controls)
         {
            this.text_controls.register(null);
         }
      }
      
      public function registerControlType(param1:String, param2:ComicAsset) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.registerControlType(" + param1 + ")--");
         }
         if(this.cur_selected == param2)
         {
            return;
         }
         this.cur_selected = param2;
         this.char_controls.register(null);
         this.prop_controls.register(null);
         if(this.text_controls)
         {
            this.text_controls.register(null);
         }
         this.prop_controls.visible = this.char_controls.visible = false;
         var _loc3_:String = "";
         switch(param1)
         {
            case "characters":
               if(this.debug)
               {
                  trace("YOU HAVE SELECTED A CHARACTER");
               }
               if(ComicCharAsset(param2).body)
               {
                  this.char_controls.register(ComicCharAsset(param2).body);
               }
               else
               {
                  param2.setController(this.char_controls);
                  this.char_controls.register(null);
               }
               this.char_controls.visible = true;
               _loc3_ = "instance";
               break;
            case "text bubble":
               if(this.debug)
               {
                  trace("YOU HAVE SELECTED A TEXT BUBBLE");
               }
               if(this.text_controls == null)
               {
                  break;
               }
               this.text_controls.register(TextBubble(param2));
               _loc3_ = "bubble";
               break;
            case "walls":
            case "props":
               if(this.debug)
               {
                  trace("YOU HAVE SELECTED A PROP");
               }
               this.prop_controls.register(ComicPropAsset(param2));
               param2.setController(this.prop_controls);
               this.prop_controls.visible = true;
               _loc3_ = "instance";
               break;
            case null:
               if(this.debug)
               {
                  trace("YOU HAVE SELECTED NULL");
               }
         }
         if(this.prop_controls.visible == false && this.char_controls.visible == false)
         {
            this.char_controls.visible = true;
         }
         if(_loc3_ != "" && this.myTabDisplay.focusedTab != "library" && this.myTabDisplay.focusedTab != "filters")
         {
            this.myTabDisplay.focusTab(_loc3_);
         }
      }
      
      public function focusTab(param1:String) : void
      {
         this.myTabDisplay.focusTab(param1);
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
      
      function loadUser_request(param1:int) : void
      {
         var _loc2_:Object = {
            "user_id":this.bs.user_id,
            "userName":this.bs.user_name,
            "series":this.bs.series
         };
         this.loadUser_response(_loc2_);
      }
      
      function loadUser_response(param1:Object) : void
      {
         this.authorData = param1;
         if(this.myLibraryManager)
         {
            this.myLibraryManager.setLibraryData(this.authorData.library);
         }
         this.pb.message = this._("User Data Loaded");
         this.componentLoaded("author");
      }
      
      function loadComic_request(param1:String) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.loadComic_request(" + param1 + ")--");
         }
         if(param1 != "")
         {
            this.pb.message = this._("Loading Comic Data");
            this.remote.load_comic_data(this.bs.user_id,this.bs.comic_id,this.loadComic_response);
         }
         else
         {
            this.loadComic_response(DataDump.getDefaultComic_complex());
         }
      }
      
      private function loadCharComic_request(param1:String) : void
      {
         trace("Load a comic with a character in it...");
         this.loadComic_response(DataDump.getDefaultComic_char(param1));
      }
      
      private function loadScene_request(param1:String) : void
      {
         this.remote.load_scene_data(this.bs.user_id,this.bs.scene_id,0,this.loadScene_response);
      }
      
      private function loadScene_response(param1:Object) : void
      {
         if(param1 == null)
         {
            this.loadComic_response(DataDump.getDefaultComic_complex());
         }
         else
         {
            param1["bkgrColor"] = 16777215;
            param1["comicTitle"] = "";
            this.loadComic_response(param1);
         }
      }
      
      function loadComic_response(param1:Object) : void
      {
         var _loc2_:* = null;
         BSConstants.RESCALE = 0.45;
         if(param1["rescale"])
         {
            BSConstants.RESCALE = param1["rescale"];
         }
         this.comicData["rescale"] = BSConstants.RESCALE;
         if(this.debug)
         {
            trace("--ComicBuilder.loadComic_response(" + param1["bkgrColor"] + ")--");
         }
         if(this.debug)
         {
            trace("<<");
         }
         if(this.bs.comic_id)
         {
            this.pb.message = this._("Comic Data Loaded");
         }
         if(param1.hasOwnProperty("version") == false || param1["version"] < 3)
         {
            param1 = DataDump.update_comic_data(param1);
         }
         for(_loc2_ in param1)
         {
            if(this.debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
            this.comicData[_loc2_] = param1[_loc2_];
         }
         if(this.debug)
         {
            trace(">>");
         }
         if(param1["bkgrColor"] != undefined)
         {
            this.setBackgroundColour(param1.bkgrColor);
         }
         else
         {
            this.bkgrColor = 16777215;
         }
         this.componentLoaded("comic");
      }
      
      public function updateComicData(param1:Object) : void
      {
         var _loc2_:* = null;
         if(this.debug)
         {
            trace("--ComicBuilder.updateComicData()--");
         }
         if(this.debug)
         {
            trace("<<");
         }
         for(_loc2_ in param1)
         {
            if(this.debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
            this.comicData[_loc2_] = param1[_loc2_];
         }
         if(this.debug)
         {
            trace(">>");
         }
      }
      
      function doAlert(param1:String, param2:Array) : void
      {
         this.addBlocker();
         this.alertBox = new AlertBox(param1,param2,this.myDisplay);
         this.alertBox.set_closeFunc(this.removeBlocker);
         this.centerDisplayObj(this.alertBox,true,true);
         this.blocker.x = 0 - this.blocker.width / 2 + this.alertBox.width / 2;
         this.blocker.y = 0 - this.blocker.height / 2 + this.alertBox.height / 2;
         this.alertBox.addChildAt(this.blocker,0);
      }
      
      public function returnCall(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("returnCall");
         }
      }
      
      public function dragAsset(param1:AssetDragEvent) : void
      {
         var _loc2_:Object = param1.assetData;
         if(this.debug)
         {
            trace("dragging asset: " + _loc2_.name);
         }
         if(this.debug)
         {
            trace("--ComicBuilder.dragAsset()--");
         }
         if(!this.draggingAsset)
         {
            this.draggingAsset = true;
            this.draggedAsset = new DraggedAsset(this,_loc2_,this.il,this.cl);
            this.myDisplay.addChild(this.draggedAsset);
            this.draggedAsset.onComplete();
            this.draggedAsset.relocate();
         }
      }
      
      public function releaseAsset(param1:ComicPanel, param2:Object) : void
      {
         this.draggingAsset = false;
         this.myDisplay.removeChild(this.draggedAsset);
         if(param1)
         {
            this.myComic.pre_undo();
            this.myComic.releaseAsset(param1,param2);
         }
      }
      
      public function locatePanelAtPoint(param1:Point) : ComicPanel
      {
         return this.myComic.locatePanelAtPoint(param1);
      }
      
      public function setAssetColour(param1:Number) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.setAssetColour(" + param1 + ")--");
         }
         this.myComic.setAssetColour(param1);
      }
      
      public function pre_undo() : void
      {
         this.myComic.pre_undo();
      }
      
      public function setBackgroundColour(param1:Number) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.setBackgroundColour(" + param1 + ")--");
         }
         this.bkgrColor = param1;
         this.myComic.bkgrColor = this.bkgrColor;
         this.myOutline.graphics.clear();
         if(BSConstants.TRANSPARENT == false)
         {
            if(this.debug)
            {
               trace("OUTLINE BEGINFILL-------------------------");
            }
            this.myOutline.graphics.beginFill(this.bkgrColor,1);
            this.myOutline.graphics.drawRect(0,0,750,100);
         }
         var _loc2_:Object = ColorTools.RGBtoHSB(param1);
         if(this.debug)
         {
            trace("b: " + _loc2_.b);
         }
         if(this.myTitleBar)
         {
            this.myTitleBar.setBrightness(_loc2_.b);
         }
      }
      
      public function save_click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(this.myTitleBar.titleChanged())
         {
            if(this.bs.user_id == 0 && BSConstants.EDU == false)
            {
               this.showSignup();
            }
            else
            {
               this.saveComic_request();
            }
         }
         else
         {
            this.doAlert(this._("Your strip doesn\'t have a title. Click Cancel to go back and give it a title."),[{
               "txt":this._("Save Anyway"),
               "f":this.save_confirm
            },{
               "txt":this._("Cancel"),
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
      
      public function save_confirm(param1:MouseEvent) : void
      {
         this.myTitleBar.setTitle("");
         if(this.bs.user_id == 0 && BSConstants.EDU == false)
         {
            this.showSignup();
         }
         else
         {
            this.saveComic_request();
         }
      }
      
      public function saveComic_request() : void
      {
         this.cs = new ComicSaver();
         this.save_btn.enabled = false;
         this.cs.save(this.bs,this.myComic,this.myAuthor,this.myTitleBar,this.pb,this.saveComic_response,this.onSaveError);
      }
      
      private function onSaveError(param1:Object) : void
      {
         this.pb.hide();
         this.save_btn.enabled = true;
         trace("Error saving: " + param1);
         this.dump_obj(param1);
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,this._("An error has occured"),true);
         this.addChild(_loc2_);
         _loc2_.show(this._("An error has occured"));
         _loc2_.on_top();
         var _loc3_:String = this._("Sorry, an error occured while saving. You will need to click \'Save\' again.");
         _loc3_ = _loc3_ + ("\n\n" + this._("If the problem persists, please email us at support@") + BSConstants.DOMAIN);
         _loc3_ = _loc3_ + ("\n\n" + this._("Error: "));
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
      
      public function dump_obj(param1:Object, param2:String = "\t") : void
      {
         var _loc3_:* = null;
         for(_loc3_ in param1)
         {
            trace(param2 + _loc3_ + " : " + param1[_loc3_]);
            if(param1[_loc3_] is Object)
            {
               this.dump_obj(param1[_loc3_],param2 + "\t");
            }
         }
      }
      
      public function saveComic_response(param1:*) : void
      {
         var e:* = param1;
         trace("--ComicBuilder.saveComic_response(" + e + ")--");
         try
         {
            ExternalInterface.call("clear_leave_block");
         }
         finally
         {
            trace("Hopefully we\'re blocked from leaving");
         }
         if(e <= 0)
         {
            this.pb.hide();
            this.save_btn.enabled = true;
            return;
         }
         this.pb.message = this._("Save Complete!\nLoading saved comic:");
         if(BSConstants.EDU)
         {
            if(this.bs.assign_id == "-1")
            {
               ExternalInterface.call("update_opener",e,this.myTitleBar.getFullTitle());
            }
            else if(this.bs.assign_id)
            {
               navigateToURL(new URLRequest(this.remote.base_url + "activity/" + this.bs.assign_id + "/" + e + "/#saved"),"_self");
            }
            else
            {
               navigateToURL(new URLRequest(this.remote.base_url + "comics/" + e + "/"),"_self");
            }
         }
         else
         {
            navigateToURL(new URLRequest(this.remote.base_url + "user/" + this.bs.user_id + "/read.php?comic_id=" + e + "&sc=1"),"_self");
         }
      }
      
      public function setPanelNum_request(param1:uint) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.setPanelNum_request(" + param1 + ")--");
         }
         var _loc2_:int = this.myComic.getPanelCount();
         this.newPanelCount = param1;
         this.setPanelNum();
      }
      
      public function setPanelNum_confirm(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.setPanelNum_confirm()--");
         }
         this.setPanelNum();
      }
      
      public function setPanelNum() : void
      {
         var _loc2_:ComicPanel = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc9_:* = null;
         this.myComic.pre_undo();
         if(this.debug)
         {
            trace("--ComicBuilder.setPanelNum()--");
         }
         this.layout_controls.field.text = String(this.newPanelCount);
         var _loc1_:Object = DataDump.getComicLayout(this.newPanelCount);
         var _loc3_:int = 0;
         var _loc6_:Array = new Array();
         var _loc7_:Object = this.myComic.save_state();
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
         if(this.debug)
         {
            trace("origPanelList.length: " + _loc6_.length);
         }
         if(this.debug)
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
         _loc1_["comicTitle"] = this.myTitleBar.getFullTitle();
         _loc1_["comicAuthorName"] = this.myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = this.bkgrColor;
         this.loadComic_response(_loc1_);
      }
      
      public function getRemote() : Remote
      {
         return this.remote;
      }
      
      public function getAuthor() : ComicAuthor
      {
         return this.myAuthor;
      }
      
      public function getCursor() : CustomCursor
      {
         return this.cursor;
      }
      
      public function get_bkgrColor() : Number
      {
         return this.bkgrColor;
      }
      
      public function setComicSeries(param1:Number) : void
      {
         this.myComic.get_comicData()["comicTitle"] = this.myTitleBar.getTitle();
         this.myComic.setSeries(param1);
      }
      
      public function newSeries_request(param1:String) : void
      {
         this.remote.new_series(this.bs.user_id,param1,this.newSeries_response);
      }
      
      public function newSeries_response(param1:Object) : void
      {
         var _loc2_:* = null;
         if(this.debug)
         {
            trace("--ComicBuilder.newSeries_response()--");
         }
         for(_loc2_ in param1)
         {
            if(this.debug)
            {
               trace(_loc2_ + ": " + param1[_loc2_]);
            }
         }
         this.myComic.get_comicData()["comicTitle"] = this.myTitleBar.getTitle();
         this.myAuthor.addSeries(param1);
         this.myComic.setSeries(param1["series_id"]);
      }
      
      public function addBlocker() : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.addBlocker()--");
         }
         this.blocker.x = 0;
         this.blocker.y = 0;
         this.blocker.graphics.clear();
         this.blocker.graphics.beginFill(0,0.2);
         this.blocker.graphics.drawRect(0,-50,stage.width,stage.height + 100);
         addChild(this.blocker);
         this.blocker.mouseEnabled = this.blocker.mouseChildren = false;
         this.centerDisplayObj(this.blocker,true,false);
      }
      
      public function removeBlocker() : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.removeBlocker()--");
         }
         if(this.contains(this.blocker))
         {
            removeChild(this.blocker);
         }
      }
      
      public function blockInteraction(param1:Boolean) : void
      {
         if(param1)
         {
            addChild(this.blocker);
         }
         else if(this.contains(this.blocker))
         {
            removeChild(this.blocker);
         }
      }
      
      public function removeAlert() : void
      {
         this.blockInteraction(false);
      }
      
      public function get stage_height() : Number
      {
         return 650;
      }
      
      public function repositionComicControls() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.comic_controls)
         {
            _loc1_ = this.stage_height;
            _loc2_ = this.comicDisplay.y + this.myComic.height;
            if(_loc2_ > _loc1_ - 41)
            {
               this.comic_controls.y = _loc1_ - 41;
               this.scrollbar.height = _loc1_ - 41 - this.scrollbar.y;
               this.scrollbar.minScrollPosition = 0;
               trace("Comic Height: " + this.myComic.height + " " + this.comicDisplay.y + ", " + this.comicDisplay.scrollRect);
               this.scrollbar.maxScrollPosition = this.myComic.strips.length;
               this.scrollbar.visible = true;
            }
            else
            {
               this.scrollbar.visible = false;
               this.myComic.scroll_v = 0;
               this.comic_controls.y = _loc2_;
            }
            if(!(this is MessageBuilder))
            {
               this.myOutline.height = this.myComic.height + this.myTitleBar.height;
            }
         }
      }
      
      public function setBackdropColour(param1:Number, param2:Boolean = false) : void
      {
         if(this.debug)
         {
            trace("--ComicBuilder.setBackdropColour(" + param2 + ")--");
         }
         this.myComic.setBackdropColour(param1,param2);
      }
      
      public function setGroundColour(param1:Number, param2:Boolean = false) : void
      {
         this.myComic.setGroundColour(param1,param2);
      }
      
      public function goEasy_request() : void
      {
         this.doAlert(this._("WARNING:  switching to EASY mode will start a new strip and close the one you are currently working on."),[{
            "txt":this._("Go Easy"),
            "f":this.goEasy_confirm
         },{
            "txt":this._("Cancel"),
            "f":function(param1:Event):void
            {
               if(debug)
               {
                  trace("Cancel");
               }
            }
         }]);
      }
      
      public function goEasy_confirm(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest(this.remote.base_url + "/create/comic/?quick=1"),"_self");
      }
      
      public function getComic() : Comic
      {
         return this.myComic;
      }
      
      public function showSignup() : void
      {
         this.user_signup = new Signup(this.bs.remote);
         this.user_signup.x = 122;
         this.user_signup.y = 143;
         addChild(this.user_signup);
         this.user_signup.set_id = this.signup_userID;
         this.user_signup.cancel_call = this.hideSignup;
      }
      
      public function hideSignup() : void
      {
         removeChild(this.user_signup);
      }
      
      public function signup_userID(param1:String) : void
      {
         this.hideSignup();
         if(this.debug)
         {
            trace("--ComicBuilder.signup_userID(" + param1 + ")--");
         }
         trace(this.user_signup.username.text);
         this.bs.user_id = int(Number(param1));
         this.myAuthor.setData({
            "userName":this.user_signup.username.text,
            "userID":this.bs.user_id,
            "series":[]
         });
         this.setAuthorName();
         this.saveComic_request();
      }
      
      public function setAuthorName() : void
      {
         this.myTitleBar.setData({"authorName":this.myAuthor.getAuthorName()});
      }
      
      public function getComic_controls() : ComicControl
      {
         return this.comic_controls;
      }
      
      private function bs_error(param1:ErrorEvent) : void
      {
         if(this.save_btn && this.save_btn.enabled == false)
         {
            this.onSaveError(param1.text);
            return;
         }
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,this._("An error has occured"),this.loaded);
         this.addChild(_loc2_);
         _loc2_.show(this._("An error has occured"));
         _loc2_.on_top();
         var _loc3_:String = this._("Uh-oh... something didn\'t work like we expected.");
         if(this.loaded == false)
         {
            _loc3_ = this._("Try refreshing the page and re-starting the comic builder to see if it fixes the issue.");
         }
         _loc3_ = _loc3_ + ("\n\n" + this._("If the problem persists, please contact us at support@") + BSConstants.DOMAIN);
         _loc3_ = _loc3_ + ("\n\n" + param1.text);
         var _loc4_:String = param1.text;
         if(_loc4_.search("Error #2036: Load Never Completed. URL: ") >= 0)
         {
            _loc3_ = _loc3_ + ("\n" + this._("Can\'t Load: ") + _loc4_.substr(40));
         }
         _loc2_.message = _loc3_;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
