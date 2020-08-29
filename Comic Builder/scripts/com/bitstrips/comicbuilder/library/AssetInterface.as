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
       
      
      private var myLibraryManager:LibraryManager;
      
      private var itemList:Array;
      
      private var activeAssetList:Array;
      
      private var contentClip:Sprite;
      
      private var stacker:AssetStacker;
      
      private var pane:SlidePane;
      
      private var testy:AlertBox;
      
      private var bkgr:Sprite;
      
      private var frame:Sprite;
      
      private var areaRect:Rectangle;
      
      private var il:ImageLoader;
      
      private var cl:CharLoader;
      
      private var nameFloat:TextFloat;
      
      private var _no_results:TextField;
      
      private var tag_page:Object;
      
      private var _prev_tag:String = "";
      
      private var _name_float:Boolean = true;
      
      public function AssetInterface(param1:LibraryManager, param2:Rectangle, param3:ImageLoader, param4:CharLoader)
      {
         this.tag_page = {};
         super();
         if(debug)
         {
            trace("--AssetInterface()--");
         }
         this.myLibraryManager = param1;
         this.areaRect = param2;
         this.il = param3;
         this.cl = param4;
         this.stacker = new AssetStacker();
         this.stacker.addEventListener(Event.CHANGE,this.displayName);
         this.bkgr = new Sprite();
         this.frame = new Sprite();
         this.contentClip = new Sprite();
         this.itemList = new Array();
         this.activeAssetList = new Array();
         this.nameFloat = new TextFloat();
         this.nameFloat.mouseEnabled = false;
         this.nameFloat.visible = false;
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.move_nameFloat);
         this._no_results = new TextField();
         this._no_results.visible = false;
         this._no_results.selectable = false;
         BSConstants.tf_fix(this._no_results);
      }
      
      public function text_prompt(param1:String) : void
      {
         this._no_results.visible = true;
         this._no_results.text = param1;
         this.stacker.visible = false;
      }
      
      public function displayAssetType(param1:Array, param2:String) : void
      {
         this._no_results.visible = false;
         this.stacker.visible = true;
         var _loc3_:uint = 0;
         if(param2 && this.tag_page.hasOwnProperty(param2))
         {
            _loc3_ = this.tag_page[param2];
         }
         _loc3_ = this.stacker.set_assets_list(param1,_loc3_);
         if(this._prev_tag)
         {
            this.tag_page[this._prev_tag] = _loc3_;
         }
         this._prev_tag = param2;
      }
      
      public function clearAllAssets() : void
      {
         if(debug)
         {
            trace("--AssetInterface.clearAllAssets()--");
         }
         this.itemList = new Array();
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--AssetInterface.drawMe()--");
         }
         this.bkgr.graphics.clear();
         this.bkgr.graphics.beginFill(16777215,1);
         this.bkgr.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         this.bkgr.graphics.endFill();
         this.frame.graphics.clear();
         this.frame.graphics.lineStyle(2,0);
         this.frame.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         this.frame.graphics.endFill();
         this.stacker.set_size(this.areaRect.width,this.areaRect.height);
         this.stacker.x = this.areaRect.x;
         this.stacker.y = this.areaRect.y;
         addChild(this.bkgr);
         addChild(this.stacker);
         addChild(this.frame);
         addChild(this.nameFloat);
         addChild(this._no_results);
         this._no_results.x = this.areaRect.x + 20;
         this._no_results.y = this.areaRect.y + 25;
         this._no_results.width = this.areaRect.width;
         this._no_results.height = this.areaRect.height;
      }
      
      public function set name_floats(param1:Boolean) : void
      {
         this._name_float = param1;
      }
      
      private function move_nameFloat(param1:MouseEvent) : void
      {
         this.nameFloat.x = this.mouseX + this.nameFloat.width / 2 + 10;
         this.nameFloat.y = this.mouseY + this.nameFloat.height / 2;
      }
      
      public function displayName(param1:Event) : void
      {
         if(this._name_float == false)
         {
            return;
         }
         var _loc2_:String = this.stacker.over_name;
         if(_loc2_ == "")
         {
            this.nameFloat.visible = false;
         }
         else
         {
            this.nameFloat.setText(_loc2_);
            this.nameFloat.visible = true;
         }
      }
      
      public function getHeight() : Number
      {
         return this.areaRect.height;
      }
   }
}
