package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.core.ImageLoader;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   public class DraggedAsset extends Sprite
   {
       
      
      private var type:String;
      
      private var loaded:Boolean;
      
      private var assetID:String;
      
      private var myComicBuilder:ComicBuilder;
      
      private var debug:Boolean;
      
      private var image:DisplayObject;
      
      private var assetName:String;
      
      private var il:ImageLoader;
      
      private var dragOffset:Point;
      
      private var cl:CharLoader;
      
      private var assetData:Object;
      
      public function DraggedAsset(param1:ComicBuilder, param2:Object, param3:ImageLoader, param4:CharLoader)
      {
         super();
         if(debug)
         {
            trace("--DraggedAsset()--");
         }
         myComicBuilder = param1;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeObject(param2);
         _loc5_.position = 0;
         assetData = _loc5_.readObject();
         il = param3;
         cl = param4;
         assetName = assetData.name;
         assetID = assetData.id;
         type = assetData.type;
         dragOffset = new Point(assetData.dragOffset.x,assetData.dragOffset.y);
         loaded = false;
         if(assetData.type != "text bubble")
         {
            if(assetData.bmpURL)
            {
               image = il.get_image(assetData.bmpURL,onImageLoad);
            }
            else
            {
               image = cl.get_prop_asset(assetData["id"]);
            }
         }
         else
         {
            assetData.type = "promoted text";
            image = new TextBubble(TextBubbleType.DRAG);
            TextBubble(image).load_state(assetData);
         }
      }
      
      public function onImageLoad(param1:Event) : void
      {
         onComplete();
      }
      
      public function mouseRelocate(param1:MouseEvent) : void
      {
         relocate();
      }
      
      public function relocate() : void
      {
         var _loc1_:ComicPanel = myComicBuilder.locatePanelAtPoint(new Point(stage.mouseX,stage.mouseY));
         var _loc2_:Number = 1;
         if(_loc1_)
         {
            _loc2_ = _loc1_.scale;
            if(debug)
            {
               trace("SCALE  " + _loc2_);
            }
            this.rotation = _loc1_.content.rotation;
         }
         if(image is TextBubble)
         {
            _loc2_ = 1;
            this.rotation = 0;
         }
         this.scaleX = this.scaleY = _loc2_;
         this.x = stage.mouseX - dragOffset.x * _loc2_;
         this.y = stage.mouseY - dragOffset.y * _loc2_;
      }
      
      public function getData() : Object
      {
         return assetData;
      }
      
      public function onComplete() : void
      {
         loaded = true;
         addChild(image);
         this.cacheAsBitmap = true;
         trace("--DraggedAsset.onComplete(" + this.width + ")--");
         if(assetData.type != "text bubble" && assetData.type != "promoted text")
         {
            if(assetData.bmpURL)
            {
               image.scaleX = image.scaleY = image.scaleY * (BSConstants.RESCALE / 0.45);
               dragOffset.x = dragOffset.x * myComicBuilder.standardRescale;
               dragOffset.y = dragOffset.y * myComicBuilder.standardRescale;
            }
            this.x = stage.mouseX - dragOffset.x * myComicBuilder.standardRescale;
            this.y = stage.mouseY - dragOffset.y * myComicBuilder.standardRescale;
         }
         this.alpha = 0.6;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseRelocate);
         stage.addEventListener(MouseEvent.MOUSE_UP,insert);
      }
      
      function insert(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = null;
         trace("Insert!");
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseRelocate);
         stage.removeEventListener(MouseEvent.MOUSE_UP,insert);
         assetData["stage_x"] = this.x;
         assetData["stage_y"] = this.y;
         if(assetData["type"] == "characters")
         {
            _loc2_ = image.getBounds(stage);
            assetData["stage_x"] = assetData["stage_x"] + _loc2_.width / 2;
            assetData["stage_y"] = assetData["stage_y"] + _loc2_.height;
            trace(image.width);
            trace(image.height);
         }
         assetData["scale"] = 1;
         if(assetData["image_scale"])
         {
            assetData["scale"] = assetData["image_scale"];
         }
         myComicBuilder.releaseAsset(myComicBuilder.locatePanelAtPoint(new Point(stage.mouseX,stage.mouseY)),assetData);
      }
   }
}
