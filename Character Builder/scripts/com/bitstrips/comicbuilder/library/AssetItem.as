package com.bitstrips.comicbuilder.library
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.comicbuilder.BackDrop;
   import com.bitstrips.core.ImageLoader;
   import com.bitstrips.core.Remote;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class AssetItem extends Sprite implements IAssetItem
   {
      
      public static const a_width:Number = 58.5;
      
      public static var _error_count:int = 0;
       
      
      private var loaded:Boolean = false;
      
      private var blinker:Blinker;
      
      private var assetID:String;
      
      public var order:int = 1000;
      
      private var thumb:DisplayObject;
      
      public var type:String;
      
      private var il:ImageLoader;
      
      private var cl:CharLoader;
      
      private var bmpURL:String;
      
      public var assetData:Object;
      
      public var failed:Boolean = false;
      
      public function AssetItem(param1:Object, param2:CharLoader)
      {
         var menu:ContextMenu = null;
         var msg:String = null;
         var item:ContextMenuItem = null;
         var new_assetData:Object = param1;
         var new_cl:CharLoader = param2;
         super();
         assetData = new_assetData;
         name = assetData.name;
         il = ImageLoader.getInstance();
         cl = new_cl;
         if(assetData.order)
         {
            order = assetData.order;
         }
         assetID = assetData.id;
         type = assetData.asset_type;
         bmpURL = assetData.bmpURL;
         loaded = false;
         if(assetData["can_delete"])
         {
            menu = new ContextMenu();
            menu.hideBuiltInItems();
            msg = "Delete this ";
            if(assetData["type"] == "image")
            {
               msg = msg + "image";
            }
            else if(assetData["type"] == "characters")
            {
               msg = msg + "character";
            }
            item = new ContextMenuItem(msg);
            menu.customItems.push(item);
            this.contextMenu = menu;
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(param1:ContextMenuEvent):void
            {
               dispatchEvent(new Event(Event.CANCEL));
            });
         }
      }
      
      public function getName() : String
      {
         return name;
      }
      
      public function getData() : Object
      {
         return assetData;
      }
      
      public function getLoaded() : Boolean
      {
         return loaded;
      }
      
      public function get tags() : String
      {
         var _loc1_:Array = assetData.tags;
         _loc1_.sort();
         return _loc1_.toString();
      }
      
      public function loadMe() : void
      {
         var _loc1_:BackDrop = null;
         if(!loaded)
         {
            this.graphics.beginFill(0,0);
            this.graphics.drawRect(0,0,AssetItem.a_width,80);
            this.graphics.endFill();
            this.buttonMode = true;
            this.addEventListener(Event.COMPLETE,onComplete,false,0,true);
            if(bmpURL)
            {
               if(thumb == null)
               {
                  thumb = il.get_image(bmpURL,onComplete,onError);
                  if(thumb is Bitmap)
                  {
                     onComplete();
                  }
                  else if(blinker == null)
                  {
                     blinker = new Blinker();
                     addChild(blinker);
                     Utils.center_piece(blinker,this,AssetItem.a_width / 2,73 / 2);
                  }
               }
               else
               {
                  return;
               }
            }
            else
            {
               trace("AssetItem - prop type");
               if(assetData["id"] == -2)
               {
                  thumb = new NewImageUpload();
               }
               else if(assetData["type"] == "backdrops")
               {
                  _loc1_ = new BackDrop();
                  _loc1_.setBackdrop(assetData["id"]);
                  thumb = DisplayObject(_loc1_);
               }
               else
               {
                  thumb = cl.get_prop_asset(assetData["id"]);
               }
               onComplete();
            }
         }
      }
      
      function doDrag(param1:MouseEvent) : void
      {
         assetData.dragOffset = new Point(thumb.mouseX,thumb.mouseY);
         trace("AssetItem.dragOffset.x: " + assetData.dragOffset.x);
         trace("AssetItem.dragOffset.y: " + assetData.dragOffset.y);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
         dispatchEvent(new AssetDragEvent(AssetDragEvent.ASSET_DRAG,assetData));
      }
      
      public function getBmpURL() : String
      {
         return bmpURL;
      }
      
      private function reportName(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         this.filters = [new GlowFilter(65280,1,4,4,4)];
      }
      
      protected function doSelect(param1:MouseEvent) : void
      {
         trace("selecting asset id: " + name);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,doDrag);
      }
      
      protected function doDeselect(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,doDrag);
      }
      
      public function getThumb() : DisplayObject
      {
         return thumb;
      }
      
      public function onError(param1:ErrorEvent) : void
      {
         failed = true;
         if(blinker)
         {
            blinker.stop();
            removeChild(blinker);
         }
         var _loc2_:ImageUpload = new ImageUpload();
         addChild(_loc2_);
         _loc2_.gotoAndStop(2);
         Utils.scale_me(_loc2_,AssetItem.a_width - 4,73 - 4);
         Utils.center_piece(_loc2_,this,AssetItem.a_width / 2,73 / 2);
         name = param1.text;
         param1.stopPropagation();
         if(AssetItem._error_count == 0)
         {
            Remote.log_error_post("AssetItem Image Error " + param1.text,this.bmpURL);
         }
         AssetItem._error_count = AssetItem._error_count + 1;
      }
      
      public function getID() : String
      {
         return assetID;
      }
      
      public function tagged(param1:String) : Boolean
      {
         if(assetData.tags.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function getType() : String
      {
         return type;
      }
      
      public function onComplete(param1:Event = null) : void
      {
         var bounds:Rectangle = null;
         var e:Event = param1;
         if(blinker != null)
         {
            removeChild(blinker);
            blinker = null;
         }
         addChild(thumb);
         switch(type)
         {
            case "backdrops":
               thumb.scrollRect = new Rectangle(-150,-300,300,300);
               Utils.scale_me(thumb,AssetItem.a_width - 4,73 - 4);
               thumb.y = (73 - AssetItem.a_width) / 2;
               break;
            case "walls":
            case "floors":
               bounds = thumb.getBounds(this);
               thumb.scrollRect = new Rectangle(bounds.x + bounds.width / 2,bounds.y,bounds.height,bounds.height);
               Utils.scale_me(thumb,AssetItem.a_width - 4,73 - 4);
               thumb.y = (73 - AssetItem.a_width) / 2;
               break;
            default:
               Utils.scale_me(thumb,AssetItem.a_width - 4,73 - 4);
               Utils.center_piece(thumb,this,AssetItem.a_width / 2,73 / 2);
         }
         loaded = true;
         if(assetID == "-1")
         {
            addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               dispatchEvent(new Event("CHAR_BUILDER"));
            });
         }
         else if(assetID == "-2")
         {
            addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               dispatchEvent(new Event("UPLOAD_IMAGE"));
            });
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_DOWN,doSelect);
            addEventListener(MouseEvent.MOUSE_UP,doDeselect);
         }
         addEventListener(MouseEvent.MOUSE_OVER,reportName);
         addEventListener(MouseEvent.MOUSE_OUT,clearName);
      }
      
      private function clearName(param1:MouseEvent) : void
      {
         this.filters = [];
      }
   }
}
