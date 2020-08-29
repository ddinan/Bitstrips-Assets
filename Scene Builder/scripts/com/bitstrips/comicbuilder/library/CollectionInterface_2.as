package com.bitstrips.comicbuilder.library
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import fl.containers.ScrollPane;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class CollectionInterface extends Sprite
   {
       
      
      private var library_items:Object;
      
      private var _prev_tag:Object;
      
      private var titleField:TextField;
      
      public var flickr_item:CollectionItem;
      
      private var areaRect:Rectangle;
      
      private var debug:Boolean = false;
      
      private var itemList:Array;
      
      private var _type:String = "";
      
      private var _tag:String = "";
      
      private var shape:Sprite;
      
      private var _prev_offset:Object;
      
      private var contentClip:Sprite;
      
      private var frame:Sprite;
      
      private var titleFormat:TextFormat;
      
      private var maskRect:Sprite;
      
      private var bkgr:Sprite;
      
      private var pane:ScrollPane;
      
      private var myLibraryManager:LibraryManager;
      
      public function CollectionInterface(param1:LibraryManager, param2:Rectangle)
      {
         _prev_tag = {};
         _prev_offset = {};
         library_items = [];
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
         pane.source = contentClip;
         pane.setSize(areaRect.width,areaRect.height);
         pane.move(areaRect.x,areaRect.y);
         pane.verticalLineScrollSize = 4;
         pane.verticalPageScrollSize = 4;
      }
      
      private function item_select(param1:Event) : void
      {
         var _loc2_:CollectionItem = param1.currentTarget as CollectionItem;
         if(debug)
         {
            trace("--CollectionItem:item_select(" + _loc2_.getLibraryID() + ")--");
         }
         var _loc3_:int = 0;
         while(_loc3_ < itemList.length)
         {
            if(itemList[_loc3_] != _loc2_)
            {
               itemList[_loc3_].selected = false;
            }
            _loc3_++;
         }
         _tag = _loc2_.getLibraryID();
         dispatchEvent(new Event(Event.SELECT));
      }
      
      private function addLibraryItem(param1:String, param2:String) : void
      {
         var _loc3_:CollectionItem = null;
         if(param2 == null || param2 == "")
         {
            param2 = param1;
         }
         if(library_items[param1])
         {
            _loc3_ = library_items[param1];
            _loc3_.selected = false;
         }
         else
         {
            _loc3_ = new CollectionItem(param1,param2);
            _loc3_.addEventListener(Event.SELECT,item_select);
            library_items[param1] = _loc3_;
            if(param1 == "Flickr")
            {
               flickr_item = _loc3_;
            }
         }
         if(debug)
         {
            trace("newLibraryItem.height: " + _loc3_.height);
         }
         _loc3_.y = itemList.length * 16 + 5;
         contentClip.addChild(_loc3_);
         itemList.push(_loc3_);
         if(param1 == "Flickr")
         {
            _loc3_.addEventListener(CollectionItem.FLICKR_SEARCH,dispatchEvent);
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
         addChild(maskRect);
         addChild(bkgr);
         addChild(pane);
         addChild(frame);
         addChild(shape);
         addChild(titleField);
         pane.mask = maskRect;
      }
      
      public function set_tags(param1:Array, param2:Object, param3:String) : void
      {
         var tag:String = null;
         var i:CollectionItem = null;
         var tags:Array = param1;
         var names:Object = param2;
         var type:String = param3;
         if(_type != "" && _tag != "")
         {
            _prev_tag[_type] = _tag;
            _prev_offset[_type] = pane.verticalScrollPosition;
         }
         _type = type;
         while(contentClip.numChildren != 0)
         {
            contentClip.removeChildAt(0);
         }
         itemList = new Array();
         for each(tag in tags)
         {
            addLibraryItem(tag,names[tag]);
         }
         pane.update();
         if(tags.length > 0)
         {
            if(_prev_tag.hasOwnProperty(type))
            {
               _tag = _prev_tag[_type];
            }
            else
            {
               _tag = tags[0];
               _prev_tag[_type] = _tag;
            }
            for each(i in itemList)
            {
               if(i.getLibraryID() == _tag)
               {
                  i.selected = true;
                  try
                  {
                     if(_prev_offset.hasOwnProperty(_type))
                     {
                        pane.verticalScrollPosition = _prev_offset[_type];
                     }
                  }
                  catch(e:Error)
                  {
                     trace("Pane error");
                  }
                  break;
               }
            }
            try
            {
               if(_prev_offset.hasOwnProperty(_type) == false && pane.verticalScrollPosition != 0)
               {
                  pane.verticalScrollPosition = 0;
               }
               return;
            }
            catch(e:Error)
            {
               trace("Pane error");
               return;
            }
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function selectLibraryItem(param1:String) : void
      {
         var _loc2_:CollectionItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < itemList.length)
         {
            itemList[_loc3_].selected = false;
            if(itemList[_loc3_].getLibraryID() == param1)
            {
               _loc2_ = itemList[_loc3_];
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc2_.selected = true;
         }
      }
      
      public function get tag() : String
      {
         return _tag;
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
