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
       
      
      public var order:int = 1000;
      
      private var assetID:String;
      
      public var assetData:Object;
      
      public var type:String;
      
      private var bmpURL:String;
      
      private var thumb:DisplayObject;
      
      private var loaded:Boolean = false;
      
      private var il:ImageLoader;
      
      private var cl:CharLoader;
      
      public var failed:Boolean = false;
      
      private var blinker:Blinker;
      
      public function AssetItem(param1:Object, param2:CharLoader)
      {
         var menu:ContextMenu = null;
         var msg:String = null;
         var item:ContextMenuItem = null;
         var new_assetData:Object = param1;
         var new_cl:CharLoader = param2;
         super();
         this.assetData = new_assetData;
         name = this.assetData.name;
         this.il = ImageLoader.getInstance();
         this.cl = new_cl;
         if(this.assetData.order)
         {
            this.order = this.assetData.order;
         }
         this.assetID = this.assetData.id;
         this.type = this.assetData.asset_type;
         this.bmpURL = this.assetData.bmpURL;
         this.loaded = false;
         if(this.assetData["can_delete"])
         {
            menu = new ContextMenu();
            menu.hideBuiltInItems();
            msg = "Delete this ";
            if(this.assetData["type"] == "image")
            {
               msg = msg + "image";
            }
            else if(this.assetData["type"] == "characters")
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
      
      public function get tags() : String
      {
         var _loc1_:Array = this.assetData.tags;
         _loc1_.sort();
         return _loc1_.toString();
      }
      
      public function tagged(param1:String) : Boolean
      {
         if(this.assetData.tags.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public function loadMe() : void
      {
         var _loc1_:BackDrop = null;
         if(!this.loaded)
         {
            this.graphics.beginFill(0,0);
            this.graphics.drawRect(0,0,AssetItem.a_width,80);
            this.graphics.endFill();
            this.buttonMode = true;
            this.addEventListener(Event.COMPLETE,this.onComplete,false,0,true);
            if(this.bmpURL)
            {
               if(this.thumb == null)
               {
                  this.thumb = this.il.get_image(this.bmpURL,this.onComplete,this.onError);
                  if(this.thumb is Bitmap)
                  {
                     this.onComplete();
                  }
                  else if(this.blinker == null)
                  {
                     this.blinker = new Blinker();
                     addChild(this.blinker);
                     Utils.center_piece(this.blinker,this,AssetItem.a_width / 2,73 / 2);
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
               if(this.assetData["id"] == -2)
               {
                  this.thumb = new NewImageUpload();
               }
               else if(this.assetData["type"] == "backdrops")
               {
                  _loc1_ = new BackDrop();
                  _loc1_.setBackdrop(this.assetData["id"]);
                  this.thumb = DisplayObject(_loc1_);
               }
               else
               {
                  this.thumb = this.cl.get_prop_asset(this.assetData["id"]);
               }
               this.onComplete();
            }
         }
      }
      
      public function onError(param1:ErrorEvent) : void
      {
         this.failed = true;
         if(this.blinker)
         {
            this.blinker.stop();
            removeChild(this.blinker);
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
      
      public function onComplete(param1:Event = null) : void
      {
         var bounds:Rectangle = null;
         var e:Event = param1;
         if(this.blinker != null)
         {
            removeChild(this.blinker);
            this.blinker = null;
         }
         addChild(this.thumb);
         switch(this.type)
         {
            case "backdrops":
               this.thumb.scrollRect = new Rectangle(-150,-300,300,300);
               Utils.scale_me(this.thumb,AssetItem.a_width - 4,73 - 4);
               this.thumb.y = (73 - AssetItem.a_width) / 2;
               break;
            case "walls":
            case "floors":
               bounds = this.thumb.getBounds(this);
               this.thumb.scrollRect = new Rectangle(bounds.x + bounds.width / 2,bounds.y,bounds.height,bounds.height);
               Utils.scale_me(this.thumb,AssetItem.a_width - 4,73 - 4);
               this.thumb.y = (73 - AssetItem.a_width) / 2;
               break;
            default:
               Utils.scale_me(this.thumb,AssetItem.a_width - 4,73 - 4);
               Utils.center_piece(this.thumb,this,AssetItem.a_width / 2,73 / 2);
         }
         this.loaded = true;
         if(this.assetID == "-1")
         {
            addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               dispatchEvent(new Event("CHAR_BUILDER"));
            });
         }
         else if(this.assetID == "-2")
         {
            addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               dispatchEvent(new Event("UPLOAD_IMAGE"));
            });
         }
         else
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.doSelect);
            addEventListener(MouseEvent.MOUSE_UP,this.doDeselect);
         }
         addEventListener(MouseEvent.MOUSE_OVER,this.reportName);
         addEventListener(MouseEvent.MOUSE_OUT,this.clearName);
      }
      
      protected function doSelect(param1:MouseEvent) : void
      {
         trace("selecting asset id: " + name);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.doDrag);
      }
      
      protected function doDeselect(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.doDrag);
      }
      
      function doDrag(param1:MouseEvent) : void
      {
         this.assetData.dragOffset = new Point(this.thumb.mouseX,this.thumb.mouseY);
         trace("AssetItem.dragOffset.x: " + this.assetData.dragOffset.x);
         trace("AssetItem.dragOffset.y: " + this.assetData.dragOffset.y);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.doDrag);
         dispatchEvent(new AssetDragEvent(AssetDragEvent.ASSET_DRAG,this.assetData));
      }
      
      private function reportName(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         this.filters = [new GlowFilter(65280,1,4,4,4)];
      }
      
      private function clearName(param1:MouseEvent) : void
      {
         this.filters = [];
      }
      
      public function getType() : String
      {
         return this.type;
      }
      
      public function getID() : String
      {
         return this.assetID;
      }
      
      public function getBmpURL() : String
      {
         return this.bmpURL;
      }
      
      public function getName() : String
      {
         return name;
      }
      
      public function getLoaded() : Boolean
      {
         return this.loaded;
      }
      
      public function getThumb() : DisplayObject
      {
         return this.thumb;
      }
      
      public function getData() : Object
      {
         return this.assetData;
      }
   }
}
