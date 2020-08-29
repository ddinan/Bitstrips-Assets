package com.bitstrips.comicbuilder.library
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.ui.Tree;
   import fl.containers.ScrollPane;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class CollectionInterface extends Sprite
   {
       
      
      private var myLibraryManager:LibraryManager;
      
      private var frame:Sprite;
      
      private var bkgr:Sprite;
      
      private var maskRect:Sprite;
      
      private var contentClip:Sprite;
      
      private var shape:Sprite;
      
      private var pane:ScrollPane;
      
      private var areaRect:Rectangle;
      
      private var itemList:Array;
      
      private var titleField:TextField;
      
      private var titleFormat:TextFormat;
      
      private var _type:String;
      
      private var typeInterfaces:Object;
      
      private var current_tree:Tree;
      
      private var debug:Boolean = false;
      
      public var flickr_item:FlickrSearch;
      
      public function CollectionInterface(param1:LibraryManager, param2:Rectangle)
      {
         this.typeInterfaces = {};
         super();
         this.myLibraryManager = param1;
         this.areaRect = param2;
         this.pane = new ScrollPane();
         this.frame = new Sprite();
         this.bkgr = new Sprite();
         this.shape = new Sprite();
         this.maskRect = new Sprite();
         this.contentClip = new Sprite();
         this.contentClip.graphics.clear();
         this.contentClip.graphics.lineStyle(1,0);
         this.contentClip.graphics.lineTo(20,0);
         this.itemList = new Array();
         this.flickr_item = new FlickrSearch();
         this.flickr_item.addEventListener(FlickrSearch.FLICKR_SEARCH,dispatchEvent);
      }
      
      public function set type(param1:String) : void
      {
         if(param1 == this._type && this.current_tree != null)
         {
            return;
         }
         this._type = param1;
         if(this.current_tree)
         {
            if(this.contentClip.contains(this.current_tree))
            {
               this.contentClip.removeChild(this.current_tree);
            }
         }
         this.current_tree = this.typeInterfaces[this._type];
         if(this.current_tree)
         {
            this.contentClip.addChild(this.current_tree);
            if(this.current_tree.id == "")
            {
               this.current_tree.select_first_node();
            }
         }
      }
      
      public function update_tags(param1:String, param2:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(this.typeInterfaces.hasOwnProperty(param1) == false)
         {
            this.addTypeItem(param1);
         }
         if(param1 == "image")
         {
            _loc4_ = param2["children"];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].id == "Flickr")
               {
                  _loc4_[_loc5_]["extraDisplay"] = this.flickr_item;
               }
               _loc5_++;
            }
            trace("FLickr?");
         }
         var _loc3_:Tree = this.typeInterfaces[param1];
         _loc3_.dataProvider = param2;
         if(this._type == param1 && this.current_tree == null)
         {
            this.type = this._type;
         }
      }
      
      public function get tag() : String
      {
         var _loc1_:String = "";
         if(this.current_tree)
         {
            _loc1_ = this.current_tree.id;
         }
         return _loc1_;
      }
      
      public function drawMe() : void
      {
         if(this.debug)
         {
            trace("--LibraryInterface.drawMe()--");
         }
         this.bkgr.graphics.clear();
         this.bkgr.graphics.beginFill(16777215,1);
         this.bkgr.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         this.bkgr.graphics.endFill();
         this.maskRect.graphics.clear();
         this.maskRect.graphics.beginFill(16777215,1);
         this.maskRect.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         this.maskRect.graphics.endFill();
         this.frame.graphics.clear();
         this.frame.graphics.lineStyle(2,0);
         this.frame.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         this.frame.graphics.endFill();
         this.titleFormat = new TextFormat();
         this.titleFormat.font = BSConstants.VERDANA;
         this.titleFormat.bold = true;
         this.titleFormat.size = 9;
         this.titleFormat.color = 0;
         this.titleField = new TextField();
         this.titleField.autoSize = TextFieldAutoSize.LEFT;
         this.titleField.selectable = false;
         this.titleField.embedFonts = true;
         this.titleField.defaultTextFormat = this.titleFormat;
         this.titleField.text = this._("Collections");
         this.titleField.y = this.areaRect.y - this.titleField.height;
         this.titleField.x = this.areaRect.x + 5;
         this.drawShape();
         this.shape.x = this.areaRect.x;
         this.shape.y = this.titleField.y;
         addChild(this.bkgr);
         addChild(this.contentClip);
         addChild(this.frame);
         addChild(this.shape);
         addChild(this.titleField);
      }
      
      private function drawShape() : void
      {
         var _loc1_:Number = 4;
         this.shape.graphics.clear();
         this.shape.graphics.beginFill(16777215,1);
         this.shape.graphics.lineStyle(2,16777215,1);
         this.shape.graphics.moveTo(this.titleField.width + 10,this.titleField.height);
         this.shape.graphics.lineTo(0,this.titleField.height);
         this.shape.graphics.lineStyle(2,0,1);
         this.shape.graphics.lineTo(0,0 + _loc1_);
         this.shape.graphics.curveTo(0,0,_loc1_,0);
         this.shape.graphics.lineTo(this.titleField.width + 10 - _loc1_,0);
         this.shape.graphics.curveTo(this.titleField.width + 10,0,this.titleField.width + 10,0 + _loc1_);
         this.shape.graphics.lineTo(this.titleField.width + 10,this.titleField.height);
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function addTypeItem(param1:String) : void
      {
         var _loc2_:Object = {
            "id":"top",
            "label":"top",
            "order":0,
            "children":[]
         };
         var _loc3_:Tree = new Tree();
         _loc3_.dataProvider = _loc2_;
         _loc3_.x = this.areaRect.x;
         _loc3_.y = this.areaRect.y;
         _loc3_.setSize(this.areaRect.width,this.areaRect.height);
         _loc3_.addEventListener(Event.SELECT,dispatchEvent);
         this.typeInterfaces[param1] = _loc3_;
      }
   }
}
