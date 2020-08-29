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
       
      
      private var myComicBuilder:ComicBuilder;
      
      private var assetID:String;
      
      private var assetData:Object;
      
      private var assetName:String;
      
      private var type:String;
      
      private var loaded:Boolean;
      
      private var dragOffset:Point;
      
      private var il:ImageLoader;
      
      private var cl:CharLoader;
      
      private var image:DisplayObject;
      
      private var debug:Boolean;
      
      public function DraggedAsset(param1:ComicBuilder, param2:Object, param3:ImageLoader, param4:CharLoader)
      {
         super();
         if(this.debug)
         {
            trace("--DraggedAsset()--");
         }
         this.myComicBuilder = param1;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeObject(param2);
         _loc5_.position = 0;
         this.assetData = _loc5_.readObject();
         this.il = param3;
         this.cl = param4;
         this.assetName = this.assetData.name;
         this.assetID = this.assetData.id;
         this.type = this.assetData.type;
         this.dragOffset = new Point(this.assetData.dragOffset.x,this.assetData.dragOffset.y);
         this.loaded = false;
         if(this.assetData.type != "text bubble")
         {
            if(this.assetData.bmpURL)
            {
               this.image = this.il.get_image(this.assetData.bmpURL,this.onImageLoad);
            }
            else
            {
               this.image = this.cl.get_prop_asset(this.assetData["id"]);
            }
         }
         else
         {
            this.assetData.type = "promoted text";
            this.image = new TextBubble(TextBubbleType.DRAG);
            TextBubble(this.image).load_state(this.assetData);
         }
      }
      
      public function onImageLoad(param1:Event) : void
      {
         this.onComplete();
      }
      
      public function onComplete() : void
      {
         this.loaded = true;
         addChild(this.image);
         this.cacheAsBitmap = true;
         trace("--DraggedAsset.onComplete(" + this.width + ")--");
         if(this.assetData.type != "text bubble" && this.assetData.type != "promoted text")
         {
            if(this.assetData.bmpURL)
            {
               this.image.scaleX = this.image.scaleY = this.image.scaleY * (BSConstants.RESCALE / 0.45);
               this.dragOffset.x = this.dragOffset.x * this.myComicBuilder.standardRescale;
               this.dragOffset.y = this.dragOffset.y * this.myComicBuilder.standardRescale;
            }
            this.x = stage.mouseX - this.dragOffset.x * this.myComicBuilder.standardRescale;
            this.y = stage.mouseY - this.dragOffset.y * this.myComicBuilder.standardRescale;
         }
         this.alpha = 0.6;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseRelocate);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.insert);
      }
      
      public function mouseRelocate(param1:MouseEvent) : void
      {
         this.relocate();
      }
      
      public function relocate() : void
      {
         var _loc1_:ComicPanel = this.myComicBuilder.locatePanelAtPoint(new Point(stage.mouseX,stage.mouseY));
         var _loc2_:Number = 1;
         if(_loc1_)
         {
            _loc2_ = _loc1_.scale;
            if(this.debug)
            {
               trace("SCALE  " + _loc2_);
            }
            this.rotation = _loc1_.content.rotation;
         }
         if(this.image is TextBubble)
         {
            _loc2_ = 1;
            this.rotation = 0;
         }
         this.scaleX = this.scaleY = _loc2_;
         this.x = stage.mouseX - this.dragOffset.x * _loc2_;
         this.y = stage.mouseY - this.dragOffset.y * _loc2_;
      }
      
      function insert(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = null;
         trace("Insert!");
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseRelocate);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.insert);
         this.assetData["stage_x"] = this.x;
         this.assetData["stage_y"] = this.y;
         if(this.assetData["type"] == "characters")
         {
            _loc2_ = this.image.getBounds(stage);
            this.assetData["stage_x"] = this.assetData["stage_x"] + _loc2_.width / 2;
            this.assetData["stage_y"] = this.assetData["stage_y"] + _loc2_.height;
            trace(this.image.width);
            trace(this.image.height);
         }
         this.assetData["scale"] = 1;
         if(this.assetData["image_scale"])
         {
            this.assetData["scale"] = this.assetData["image_scale"];
         }
         this.myComicBuilder.releaseAsset(this.myComicBuilder.locatePanelAtPoint(new Point(stage.mouseX,stage.mouseY)),this.assetData);
      }
      
      public function getData() : Object
      {
         return this.assetData;
      }
   }
}
