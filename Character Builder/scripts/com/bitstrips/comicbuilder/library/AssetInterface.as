package com.bitstrips.comicbuilder.library
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.core.ImageLoader;
   import com.bitstrips.ui.AlertBox;
   import com.bitstrips.ui.SlidePane;
   import com.bitstrips.ui.TextFloat;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class AssetInterface extends Sprite
   {
      
      private static var debug:Boolean = false;
       
      
      private var _prev_tag:String = "";
      
      private var _name_float:Boolean = true;
      
      private var activeAssetList:Array;
      
      private var itemList:Array;
      
      private var tag_page:Object;
      
      private var nameFloat:TextFloat;
      
      private var _no_results:TextField;
      
      private var areaRect:Rectangle;
      
      private var il:ImageLoader;
      
      private var testy:AlertBox;
      
      private var cl:CharLoader;
      
      private var frame:Sprite;
      
      private var pane:SlidePane;
      
      private var contentClip:Sprite;
      
      private var bkgr:Sprite;
      
      private var stacker:AssetStacker;
      
      private var myLibraryManager:LibraryManager;
      
      public function AssetInterface(param1:LibraryManager, param2:Rectangle, param3:ImageLoader, param4:CharLoader)
      {
         tag_page = {};
         super();
         if(debug)
         {
            trace("--AssetInterface()--");
         }
         myLibraryManager = param1;
         areaRect = param2;
         il = param3;
         cl = param4;
         stacker = new AssetStacker();
         stacker.addEventListener(Event.CHANGE,this.displayName);
         bkgr = new Sprite();
         frame = new Sprite();
         contentClip = new Sprite();
         itemList = new Array();
         activeAssetList = new Array();
         nameFloat = new TextFloat();
         nameFloat.mouseEnabled = false;
         nameFloat.visible = false;
         this.addEventListener(MouseEvent.MOUSE_MOVE,move_nameFloat);
         _no_results = new TextField();
         _no_results.visible = false;
         _no_results.selectable = false;
         BSConstants.tf_fix(_no_results);
      }
      
      public function displayAssetType(param1:Array, param2:String) : void
      {
         _no_results.visible = false;
         stacker.visible = true;
         var _loc3_:uint = 0;
         if(param2 && tag_page.hasOwnProperty(param2))
         {
            _loc3_ = tag_page[param2];
         }
         _loc3_ = stacker.set_assets_list(param1,_loc3_);
         if(_prev_tag)
         {
            tag_page[_prev_tag] = _loc3_;
         }
         _prev_tag = param2;
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--AssetInterface.drawMe()--");
         }
         bkgr.graphics.clear();
         bkgr.graphics.beginFill(16777215,1);
         bkgr.graphics.drawRect(areaRect.x,areaRect.y,areaRect.width,areaRect.height);
         bkgr.graphics.endFill();
         frame.graphics.clear();
         frame.graphics.lineStyle(2,0);
         frame.graphics.drawRect(areaRect.x,areaRect.y,areaRect.width,areaRect.height);
         frame.graphics.endFill();
         stacker.set_size(areaRect.width,areaRect.height);
         stacker.x = areaRect.x;
         stacker.y = areaRect.y;
         addChild(bkgr);
         addChild(stacker);
         addChild(frame);
         addChild(nameFloat);
         addChild(_no_results);
         _no_results.x = areaRect.x + 20;
         _no_results.y = areaRect.y + 25;
         _no_results.width = areaRect.width;
         _no_results.height = areaRect.height;
      }
      
      public function clearAllAssets() : void
      {
         if(debug)
         {
            trace("--AssetInterface.clearAllAssets()--");
         }
         itemList = new Array();
      }
      
      public function set name_floats(param1:Boolean) : void
      {
         _name_float = param1;
      }
      
      public function getHeight() : Number
      {
         return areaRect.height;
      }
      
      public function displayName(param1:Event) : void
      {
         if(_name_float == false)
         {
            return;
         }
         var _loc2_:String = stacker.over_name;
         if(_loc2_ == "")
         {
            nameFloat.visible = false;
         }
         else
         {
            nameFloat.setText(_loc2_);
            nameFloat.visible = true;
         }
      }
      
      private function move_nameFloat(param1:MouseEvent) : void
      {
         nameFloat.x = this.mouseX + nameFloat.width / 2 + 10;
         nameFloat.y = this.mouseY + nameFloat.height / 2;
      }
      
      public function text_prompt(param1:String) : void
      {
         _no_results.visible = true;
         _no_results.text = param1;
         stacker.visible = false;
      }
   }
}
