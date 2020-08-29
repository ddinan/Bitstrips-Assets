package com.bitstrips.character
{
   import com.bitstrips.comicbuilder.ComicAsset;
   import com.bitstrips.core.ImageLoader;
   import com.nitoyon.potras.ClosedPathList;
   import com.nitoyon.potras.PotrAs;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.geom.Point;
   
   public final class ComicImageAsset extends ComicAsset
   {
       
      
      private var url:String;
      
      private var loader:DisplayObject;
      
      private var thumb:DisplayObject;
      
      private var png_mask:Shape;
      
      private var _loaded:Boolean = false;
      
      public function ComicImageAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicPropAsset()--");
         }
         super();
         this.url = param1;
         var _loc2_:ImageLoader = ImageLoader.getInstance();
         this.loader = _loc2_.get_image(param1,this.image_loaded);
         artwork.addChild(this.loader);
         if(this.loader is Bitmap)
         {
            this.image_loaded();
         }
      }
      
      private function get_mask_shape(param1:BitmapData) : Shape
      {
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,false,4278190080);
         _loc2_.threshold(param1,param1.rect,new Point(0,0),"==",0,4294967295,4278190080);
         _loc2_.threshold(param1,param1.rect,new Point(0,0),"==",4278190080,4278190080,4278190080);
         var _loc3_:ClosedPathList = PotrAs.traceBitmap(_loc2_);
         _loc2_.dispose();
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(26367,0.5);
         _loc3_.draw(_loc4_.graphics);
         _loc4_.graphics.endFill();
         return _loc4_;
      }
      
      private function image_loaded(param1:Event = null) : void
      {
         var _loc2_:BitmapData = null;
         this._loaded = true;
         if(this.thumb)
         {
            artwork.removeChild(this.thumb);
            this.thumb = null;
         }
         if(this.loader is Bitmap)
         {
            _loc2_ = Bitmap(this.loader).bitmapData;
         }
         else
         {
            _loc2_ = Bitmap(Loader(this.loader).content).bitmapData;
         }
         if(_loc2_.transparent)
         {
            this.png_mask = this.get_mask_shape(_loc2_);
            artwork.addChild(this.png_mask);
            this.loader.mask = this.png_mask;
            this.png_mask.scaleX = this.png_mask.scaleY = this.loader.scaleX;
            this.png_mask.x = this.loader.x;
            this.png_mask.y = this.loader.y;
         }
         trace("Loaded");
         loaded();
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         _loc1_["url"] = this.url;
         return _loc1_;
      }
      
      override public function load_state(param1:Object) : void
      {
         var _loc3_:ImageLoader = null;
         var _loc4_:Number = NaN;
         if(debug)
         {
            trace("--ComicPropAsset.load_state()--");
         }
         super.load_state(param1);
         var _loc2_:Number = Math.min(1,300 / Math.max(param1["width"],param1["height"]));
         this.loader.scaleX = this.loader.scaleY = _loc2_;
         this.loader.x = this.loader.x - param1["width"] / 2 * _loc2_;
         this.loader.y = this.loader.y - param1["height"] / 2 * _loc2_;
         if(this.png_mask)
         {
            this.png_mask.scaleX = this.png_mask.scaleY = _loc2_;
            this.png_mask.x = this.loader.x;
            this.png_mask.y = this.loader.y;
         }
         if(this._loaded == false)
         {
            _loc3_ = ImageLoader.getInstance();
            this.thumb = _loc3_.get_image(param1["bmpURL"],null);
            if(param1["tags"].indexOf("Flickr") != -1)
            {
               _loc4_ = Math.min(param1["width"],param1["height"]);
               this.thumb.width = _loc4_ * _loc2_;
               this.thumb.height = _loc4_ * _loc2_;
            }
            else
            {
               this.thumb.width = param1["width"] * _loc2_;
               this.thumb.height = param1["height"] * _loc2_;
            }
            this.thumb.x = -this.thumb.width / 2;
            this.thumb.y = -this.thumb.height / 2;
            artwork.addChild(this.thumb);
         }
      }
   }
}
