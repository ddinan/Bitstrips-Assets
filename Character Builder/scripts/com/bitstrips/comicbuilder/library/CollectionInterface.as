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
       
      
      private var titleField:TextField;
      
      public var flickr_item:FlickrSearch;
      
      private var areaRect:Rectangle;
      
      private var debug:Boolean = false;
      
      private var itemList:Array;
      
      private var _type:String;
      
      private var shape:Sprite;
      
      private var current_tree:Tree;
      
      private var contentClip:Sprite;
      
      private var frame:Sprite;
      
      private var titleFormat:TextFormat;
      
      private var maskRect:Sprite;
      
      private var typeInterfaces:Object;
      
      private var pane:ScrollPane;
      
      private var bkgr:Sprite;
      
      private var myLibraryManager:LibraryManager;
      
      public function CollectionInterface(param1:LibraryManager, param2:Rectangle)
      {
         typeInterfaces = {};
         super();
         myLibraryManager = param1;
         areaRect = param2;
         pane = new ScrollPane();
         frame = new Sprite();
         bkgr = new Sprite();
         shape = new Sprite();
         maskRect = new Sprite();
         contentClip = new Sprite();
         contentClip.graphics.clear();
         contentClip.graphics.lineStyle(1,0);
         contentClip.graphics.lineTo(20,0);
         itemList = new Array();
         flickr_item = new FlickrSearch();
         flickr_item.addEventListener(FlickrSearch.FLICKR_SEARCH,dispatchEvent);
      }
      
      public function set type(param1:String) : void
      {
         if(param1 == _type && current_tree != null)
         {
            return;
         }
         _type = param1;
         if(current_tree)
         {
            if(contentClip.contains(current_tree))
            {
               contentClip.removeChild(current_tree);
            }
         }
         current_tree = typeInterfaces[_type];
         if(current_tree)
         {
            contentClip.addChild(current_tree);
            if(current_tree.id == "")
            {
               current_tree.select_first_node();
            }
         }
      }
      
      public function get tag() : String
      {
         var _loc1_:String = "";
         if(current_tree)
         {
            _loc1_ = current_tree.id;
         }
         return _loc1_;
      }
      
      public function update_tags(param1:String, param2:Object) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         if(typeInterfaces.hasOwnProperty(param1) == false)
         {
            addTypeItem(param1);
         }
         if(param1 == "image")
         {
            _loc4_ = param2["children"];
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_].id == "Flickr")
               {
                  _loc4_[_loc5_]["extraDisplay"] = flickr_item;
               }
               _loc5_++;
            }
            trace("FLickr?");
         }
         var _loc3_:Tree = typeInterfaces[param1];
         _loc3_.dataProvider = param2;
         if(_type == param1 && current_tree == null)
         {
            type = _type;
         }
      }
      
      public function drawMe() : void
      {
         if(debug)
         {
            trace("--LibraryInterface.drawMe()--");
         }
         bkgr.graphics.clear();
         bkgr.graphics.beginFill(16777215,1);
         bkgr.graphics.drawRect(areaRect.x,areaRect.y,areaRect.width,areaRect.height);
         bkgr.graphics.endFill();
         maskRect.graphics.clear();
         maskRect.graphics.beginFill(16777215,1);
         maskRect.graphics.drawRect(areaRect.x,areaRect.y,areaRect.width,areaRect.height);
         maskRect.graphics.endFill();
         frame.graphics.clear();
         frame.graphics.lineStyle(2,0);
         frame.graphics.drawRect(areaRect.x,areaRect.y,areaRect.width,areaRect.height);
         frame.graphics.endFill();
         titleFormat = new TextFormat();
         titleFormat.font = BSConstants.VERDANA;
         titleFormat.bold = true;
         titleFormat.size = 9;
         titleFormat.color = 0;
         titleField = new TextField();
         titleField.autoSize = TextFieldAutoSize.LEFT;
         titleField.selectable = false;
         titleField.embedFonts = true;
         titleField.defaultTextFormat = titleFormat;
         titleField.text = _("Collections");
         titleField.y = areaRect.y - titleField.height;
         titleField.x = areaRect.x + 5;
         drawShape();
         shape.x = areaRect.x;
         shape.y = titleField.y;
         addChild(bkgr);
         addChild(contentClip);
         addChild(frame);
         addChild(shape);
         addChild(titleField);
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
         _loc3_.x = areaRect.x;
         _loc3_.y = areaRect.y;
         _loc3_.setSize(areaRect.width,areaRect.height);
         _loc3_.addEventListener(Event.SELECT,dispatchEvent);
         typeInterfaces[param1] = _loc3_;
      }
      
      private function drawShape() : void
      {
         var _loc1_:Number = 4;
         shape.graphics.clear();
         shape.graphics.beginFill(16777215,1);
         shape.graphics.lineStyle(2,16777215,1);
         shape.graphics.moveTo(titleField.width + 10,titleField.height);
         shape.graphics.lineTo(0,titleField.height);
         shape.graphics.lineStyle(2,0,1);
         shape.graphics.lineTo(0,0 + _loc1_);
         shape.graphics.curveTo(0,0,_loc1_,0);
         shape.graphics.lineTo(titleField.width + 10 - _loc1_,0);
         shape.graphics.curveTo(titleField.width + 10,0,titleField.width + 10,0 + _loc1_);
         shape.graphics.lineTo(titleField.width + 10,titleField.height);
      }
   }
}
