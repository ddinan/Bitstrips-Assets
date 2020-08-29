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
       
      
      private var png_mask:Shape;
      
      private var _loaded:Boolean = false;
      
      private var url:String;
      
      private var loader:DisplayObject;
      
      private var thumb:DisplayObject;
      
      public function ComicImageAsset(param1:String)
      {
         if(debug)
         {
            trace("--ComicPropAsset()--");
         }
         super();
         this.url = param1;
         var _loc2_:ImageLoader = ImageLoader.getInstance();
         loader = _loc2_.get_image(param1,image_loaded);
         artwork.addChild(loader);
         if(loader is Bitmap)
         {
            image_loaded();
         }
      }
      
      override public function save_state() : Object
      {
         var _loc1_:Object = super.save_state();
         _loc1_["url"] = url;
         return _loc1_;
      }
      
      private function image_loaded(param1:Event = null) : void
      {
         var _loc2_:BitmapData = null;
         _loaded = true;
         if(thumb)
         {
            artwork.removeChild(thumb);
            thumb = null;
         }
         if(loader is Bitmap)
         {
            _loc2_ = Bitmap(loader).bitmapData;
         }
         else
         {
            _loc2_ = Bitmap(Loader(loader).content).bitmapData;
         }
         if(_loc2_.transparent)
         {
            png_mask = get_mask_shape(_loc2_);
            artwork.addChild(png_mask);
            loader.mask = png_mask;
            png_mask.scaleX = png_mask.scaleY = loader.scaleX;
            png_mask.x = loader.x;
            png_mask.y = loader.y;
         }
         trace("Loaded");
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
         loader.scaleX = loader.scaleY = _loc2_;
         loader.x = loader.x - param1["width"] / 2 * _loc2_;
         loader.y = loader.y - param1["height"] / 2 * _loc2_;
         if(png_mask)
         {
            png_mask.scaleX = png_mask.scaleY = _loc2_;
            png_mask.x = loader.x;
            png_mask.y = loader.y;
         }
         if(_loaded == false)
         {
            _loc3_ = ImageLoader.getInstance();
            thumb = _loc3_.get_image(param1["bmpURL"],null);
            if(param1["tags"].indexOf("Flickr") != -1)
            {
               _loc4_ = Math.min(param1["width"],param1["height"]);
               thumb.width = _loc4_ * _loc2_;
               thumb.height = _loc4_ * _loc2_;
            }
            else
            {
               thumb.width = param1["width"] * _loc2_;
               thumb.height = param1["height"] * _loc2_;
            }
            thumb.x = -thumb.width / 2;
            thumb.y = -thumb.height / 2;
            artwork.addChild(thumb);
         }
      }
   }
}
