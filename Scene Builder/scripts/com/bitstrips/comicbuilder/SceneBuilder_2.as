package com.bitstrips.comicbuilder
{
   import com.adobe.images.PNGEncoder;
   import com.bitstrips.BSConstants;
   import com.bitstrips.comicbuilder.library.AssetDragEvent;
   import com.bitstrips.comicbuilder.library.LibraryManager;
   import com.bitstrips.controls.CharControls;
   import com.bitstrips.controls.ComicControls;
   import com.bitstrips.controls.ObjectControls;
   import com.bitstrips.controls.TextControls;
   import com.bitstrips.core.ColorTools;
   import com.bitstrips.ui.TabDisplay;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   
   public class SceneBuilder extends ComicBuilder
   {
       
      
      var myTitleBarScene:TitleBarScene;
      
      var backgroundTypeList:Array;
      
      var scene_id:String;
      
      var myBackgroundManager:LibraryManager;
      
      var sceneData:Object;
      
      private var myPanel:ComicPanel;
      
      public function SceneBuilder()
      {
         backgroundTypeList = ["backdrops","walls","wall stuff","floors"];
         trace("--SceneBuilder()--");
         super();
      }
      
      override public function save_confirm(param1:MouseEvent) : void
      {
         myTitleBarScene.setTitle("");
         if(bs.user_id == 0)
         {
            showSignup();
         }
         else
         {
            saveComic_request();
         }
      }
      
      override public function saveComic_response(param1:*) : void
      {
         if(debug)
         {
            trace("--SceneBuilder.saveComic_response(" + param1 + ")--");
         }
         if(param1 > 0)
         {
            if(BSConstants.EDU)
            {
               navigateToURL(new URLRequest(remote.base_url + "scene_list.php?user_id=" + bs.user_id),"_self");
            }
            else
            {
               navigateToURL(new URLRequest(remote.base_url + "user/" + bs.user_id + "?sc=3"),"_self");
            }
         }
         else
         {
            removeBlocker();
            save_btn.enabled = true;
         }
      }
      
      override public function drawMe() : void
      {
         pb.hide();
         trace("--SceneBuilder.drawMe()--");
         myDisplay.visible = true;
         myAuthor.setData(authorData);
         myLibraryManager.get_user_libs(bs);
         myLibraryManager.drawMe();
         myBackgroundManager.drawMe();
         myComic.setData(comicData);
         myComic.drawMe();
         myPanel = myComic.get_stripList()[0].getPanelList()[0];
         myPanel.killHilight();
         myComic.selectPanel(myPanel);
         updateTitleBar();
         save_btn = comic_controls.save_btn;
         save_btn.addEventListener(MouseEvent.CLICK,save_click);
         myOutline.graphics.lineStyle(2,0,1);
         myOutline.graphics.drawRect(0,0,comicData.comicWidth - 2,145 - 120 + comicData.comicHeight);
         setBackgroundColour(6710886);
         myDisplay.y = 3;
         myTabDisplay.y = 0;
         myOutline.y = 120;
         myOutline.x = 1;
         myTitleBarScene.y = 126;
         comicDisplay.y = 143;
         repositionComicControls();
         if(bs.user_id == 0)
         {
         }
         bs.spellcheck();
         var _loc1_:ComicStrip = this.myComic.strips[0];
         var _loc2_:ComicPanel = _loc1_.panels[0];
      }
      
      override public function updateTitleBar() : void
      {
         myTitleBarScene.setData({
            "comicTitle":myComic.get_comicData().comicTitle,
            "authorName":myAuthor.getAuthorName(),
            "seriesList":myAuthor.get_seriesList(),
            "series":myComic.get_comicData().series,
            "episode":myComic.get_comicData().episode
         });
         myTitleBarScene.drawMe();
      }
      
      override public function saveComic_request() : void
      {
         if(debug)
         {
            trace("--ComicBuilder.saveComic_request()--");
         }
         pb.show(_("Saving"));
         pb.message = _("Generating Bitmap");
         trace("Start save state: " + new Date());
         var _loc1_:Object = myComic.save_state();
         trace("Done save state: " + new Date());
         _loc1_["comicTitle"] = myTitleBarScene.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         var _loc2_:Object = {
            "authorName":"BY " + myAuthor.getAuthorName(),
            "comicTitle":myTitleBarScene.getFullTitle()
         };
         if(BSConstants.EDU)
         {
            _loc2_["authorName"] = myTitleBarScene.authorField.text;
            _loc1_["comicAuthorName"] = bs.user_name;
            if(bs.assign_id)
            {
               _loc1_["assign_id"] = bs.assign_id;
            }
         }
         var _loc3_:Array = this.BitmapBits(_loc2_,false);
         thumb = new Object();
         thumb["rows"] = myComic.get_stripList().length;
         thumb["rgb"] = ("000000" + bkgrColor.toString(16)).substr(-6);
         save_btn.enabled = false;
         var _loc4_:ComicPanel = myComic.strips[0].panels[0];
         var _loc5_:ByteArray = PNGEncoder.encode(_loc4_.panelBitmap(1,false));
         var _loc6_:ByteArray = PNGEncoder.encode(this.square_thumb(_loc4_,120));
         _loc1_["version"] = 4;
         pb.message = _("Uploading Scene Data");
         remote.save_scene(bs.user_id,_loc1_["comicTitle"],_loc1_,_loc5_,_loc6_,saveComic_response);
      }
      
      override public function setBackgroundColour(param1:Number) : void
      {
         if(debug)
         {
            trace("--SceneBuilder.setBackgroundColour(" + param1 + ")--");
         }
         bkgrColor = param1;
         var _loc2_:Number = comicData.comicWidth - 2;
         var _loc3_:Number = 145 - 120 + comicData.comicHeight + 34;
         myOutline.graphics.clear();
         myOutline.graphics.beginFill(param1,1);
         myOutline.graphics.lineStyle(2,0,1);
         myOutline.graphics.moveTo(0,0);
         myOutline.graphics.lineTo(_loc2_,0);
         myOutline.graphics.lineTo(_loc2_,_loc3_);
         myOutline.graphics.lineTo(0,_loc3_);
         myOutline.graphics.lineTo(0,0);
         var _loc4_:Object = ColorTools.RGBtoHSB(param1);
         if(debug)
         {
            trace("b: " + _loc4_.b);
         }
      }
      
      override function init_tabs() : TabDisplay
      {
         var _loc1_:TabDisplay = new TabDisplay(!BSConstants.EDU);
         instance_controls = new Sprite();
         char_controls = new CharControls();
         char_controls.x = 10;
         char_controls.y = 30;
         instance_controls.addChild(char_controls);
         char_controls.visible = true;
         prop_controls = new ObjectControls(myComic);
         instance_controls.addChild(prop_controls);
         prop_controls.visible = false;
         myLibraryManager = new LibraryManager(bs);
         myLibraryManager.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         var _loc2_:Sprite = myLibraryManager.getDisplay();
         myBackgroundManager = new LibraryManager(bs,this.backgroundTypeList);
         myBackgroundManager.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         var _loc3_:Sprite = myBackgroundManager.getDisplay();
         text_controls = new TextControls(myComic);
         text_controls.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         _loc1_.setData({"tabDataList":[{
            "name":"library",
            "label":"ART LIBRARY",
            "colour":16711680,
            "clip":_loc2_
         },{
            "name":"background",
            "label":"BACKGROUND",
            "colour":16777062,
            "clip":_loc3_
         },{
            "name":"bubble",
            "label":"TEXT BUBBLES",
            "colour":16777062,
            "clip":text_controls
         },{
            "name":"instance",
            "label":"CONTROLS",
            "colour":16750899,
            "clip":instance_controls
         }]});
         _loc1_.focusTab("library");
         return _loc1_;
      }
      
      override public function repositionComicControls() : void
      {
         comic_controls.y = comicDisplay.y + myComic.getComicSize().height;
         myOutline.height = comic_controls.y + 36 - 120;
      }
      
      override public function init() : void
      {
         builder_name = "SCENE BUILDER";
         common_init();
         myComic.killBorders();
         myTitleBarScene = new TitleBarScene(this);
         initLoadConditions = {
            "author":false,
            "comic":false,
            "CharLoader":false
         };
         addChild(myDisplay);
         myDisplay.addChild(myOutline);
         myDisplay.addChild(myTitleBarScene);
         myDisplay.addChild(comicDisplay);
         myDisplay.addChild(myTabDisplay);
         comic_controls = new ComicControls(this.myComic,"scene");
         myComic.controls = comic_controls;
         myDisplay.addChild(comic_controls);
         addChild(init_title_field());
         addChild(cursor);
         initDraw();
         loadData({
            "user_id":bs.user_id,
            "comic_id":bs.scene_id
         });
      }
      
      override function loadComic_request(param1:String) : void
      {
         var _loc2_:Object = null;
         trace("--SceneBuilder.loadComic_request(" + param1 + ")--");
         if(param1 != "" && param1 != "0")
         {
            trace("valid series_id: " + param1);
            trace("Shouldn\'t this load a scene?");
         }
         else
         {
            _loc2_ = DataDump.getEmptyScene();
            loadComic_response(_loc2_);
         }
      }
      
      override public function save_click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(myTitleBarScene.titleChanged())
         {
            if(bs.user_id == 0)
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
            doAlert("Your scene doesn\'t have a name. Click Cancel to go back and give it a name.",[{
               "txt":"Save Anyway",
               "f":save_confirm
            },{
               "txt":"Cancel",
               "f":function(param1:Event):void
               {
                  trace("Cancel");
               }
            }]);
         }
      }
      
      override public function setAuthorName() : void
      {
         myTitleBarScene.setData({"authorName":myAuthor.getAuthorName()});
      }
   }
}
