package com.bitstrips.comicbuilder.library
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.core.ImageLoader;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.ContextMenuEvent;
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public final class ImageUploader extends Sprite implements IAssetItem
   {
       
      
      private var file:FileReference;
      
      private var code:String;
      
      private var user_id:int;
      
      private var upload:ImageUpload;
      
      public var tags:Array;
      
      public var order:String = "0002";
      
      public var type:String = "image";
      
      public var assetData:Object;
      
      private var image:DisplayObject;
      
      public function ImageUploader(param1:String, param2:int)
      {
         this.tags = ["MyImage"];
         this.assetData = {};
         super();
         this.code = param1;
         this.user_id = param2;
         this.file = new FileReference();
         this.file.addEventListener(Event.CANCEL,this.cancelHandler);
         this.file.addEventListener(Event.COMPLETE,this.completeHandler);
         this.file.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler);
         this.file.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.file.addEventListener(Event.OPEN,this.openHandler);
         this.file.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         this.file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.file.addEventListener(Event.SELECT,this.selectHandler);
         this.file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,this.uploadCompleteDataHandler);
         this.file.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)","*.jpg;*.jpeg;*.gif;*.png")]);
         name = "";
      }
      
      private function cancelHandler(param1:Event) : void
      {
         trace("cancelHandler: " + param1);
         name = "Cancelled";
         dispatchEvent(param1);
      }
      
      private function completeHandler(param1:Event) : void
      {
         trace("completeHandler: " + param1);
      }
      
      private function uploadCompleteDataHandler(param1:DataEvent) : void
      {
         var data:Object = null;
         var im:ImageLoader = null;
         var event:DataEvent = param1;
         trace("uploadCompleteData: " + event);
         try
         {
            data = com.adobe.serialization.json.JSON.decode(event.data);
         }
         catch(error:Error)
         {
            data = {
               "error":1,
               "reason":"Failed to decode data"
            };
         }
         if(data.error)
         {
            trace("Error: " + data.reason);
            this.upload.gotoAndStop(2);
            name = data.reason;
            return;
         }
         this.assetData = data;
         this.assetData["type"] = "image";
         this.assetData["tags"] = "MyImage";
         im = ImageLoader.getInstance();
         this.image = im.get_image(data["bmpURL"],this.image_done);
         addChild(this.image);
         if(this.image is Bitmap)
         {
            this.image_done();
         }
      }
      
      private function image_done(param1:Event = null) : void
      {
         var menu:ContextMenu = null;
         var msg:String = null;
         var item:ContextMenuItem = null;
         var e:Event = param1;
         this.buttonMode = true;
         name = this.assetData["title"];
         removeChild(this.upload);
         addEventListener(MouseEvent.MOUSE_DOWN,this.doSelect);
         addEventListener(MouseEvent.MOUSE_UP,this.doDeselect);
         addEventListener(MouseEvent.MOUSE_OVER,this.reportName);
         addEventListener(MouseEvent.MOUSE_OUT,this.clearName);
         Utils.scale_me(this.image,AssetItem.a_width - 4,73 - 4);
         Utils.center_piece(this.image,this,AssetItem.a_width / 2,73 / 2);
         if(this.assetData["can_delete"])
         {
            menu = new ContextMenu();
            menu.hideBuiltInItems();
            msg = "Delete this image";
            item = new ContextMenuItem(msg);
            menu.customItems.push(item);
            this.contextMenu = menu;
            item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function(param1:ContextMenuEvent):void
            {
               dispatchEvent(new Event(Event.CANCEL));
            });
         }
      }
      
      private function httpStatusHandler(param1:HTTPStatusEvent) : void
      {
         trace("httpStatusHandler: " + param1);
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + param1);
         name = "IO Error";
         this.upload.gotoAndStop(2);
      }
      
      private function openHandler(param1:Event) : void
      {
         trace("openHandler: " + param1);
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         var _loc2_:FileReference = FileReference(param1.target);
         var _loc3_:String = int(param1.bytesLoaded / param1.bytesTotal * 100).toString();
         this.upload.percent_txt.text = _loc3_ + "%";
         name = "Uploading: " + _loc3_ + "% complete";
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + param1);
      }
      
      private function selectHandler(param1:Event) : void
      {
         var _loc2_:FileReference = FileReference(param1.target);
         this.upload = new ImageUpload();
         addChild(this.upload);
         this.upload.percent_txt.text = "";
         BSConstants.tf_fix(this.upload.percent_txt);
         Utils.scale_me(this.upload,AssetItem.a_width - 4,73 - 4);
         Utils.center_piece(this.upload,this,AssetItem.a_width / 2,73 / 2);
         if(_loc2_.size >= 1024 * 1024 * 3)
         {
            this.upload.gotoAndStop(2);
            name = "Image too large - can\'t upload images > 3MB (image was " + int(_loc2_.size / 1024 / 1024).toString + "MB)";
            return;
         }
         var _loc3_:URLRequest = new URLRequest();
         _loc3_.url = "http://" + BSConstants.URL + "/image_upload.php";
         var _loc4_:URLVariables = new URLVariables();
         _loc4_.code = this.code;
         _loc4_["id"] = this.user_id;
         _loc4_["title"] = _loc2_.name;
         _loc3_.data = _loc4_;
         _loc2_.upload(_loc3_);
      }
      
      public function loadMe() : void
      {
      }
      
      public function tagged(param1:String) : Boolean
      {
         if(param1 == "MyImage")
         {
            return true;
         }
         return false;
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
         this.assetData.dragOffset = new Point(this.mouseX,this.mouseY);
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
   }
}
